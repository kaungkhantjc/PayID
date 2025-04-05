import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pay_id/app_utils.dart';
import 'ocr_result.dart';

Future<OcrResult> performOcrTask(String path) async {
  ProcessResult versionResult = await Process.run("tesseract", ["--version"]);

  if (versionResult.exitCode == 0) {
    String ocrVersion =
        versionResult.stdout.toString().split("\n").firstOrNull ?? "";
    List<String> installedLanguages = await _getInstalledLanguages();
    String installedLanguagesStr = installedLanguages.join(", ");

    String ocrLanguages =
        installedLanguages.contains("script\\Myanmar")
            ? "eng+script\\Myanmar"
            : (installedLanguages.contains("mya") ? "eng+mya" : "eng");

    String prefix =
        "$ocrVersion\nInstalled languages: $installedLanguagesStr\n\n";

    if (isUrl(path)) {
      final (imageFile, error) = await downloadImage(path);
      if (imageFile == null) return OcrResult(null, null, "$prefix\n\n$error");

      OcrResult ocrResult = await _runOcr(imageFile.path, ocrLanguages, prefix);
      imageFile.delete();
      return ocrResult;
    } else {
      return await _runOcr(path, ocrLanguages, prefix);
    }
  } else {
    return OcrResult(null, null, versionResult.stderr.toString());
  }
}

Future<(File?, String?)> downloadImage(String url) async {
  final client = http.Client();
  File? imageFile;

  try {
    final headResponse = await client
        .head(Uri.parse(url))
        .timeout(Duration(seconds: 5));

    if (headResponse.statusCode != 200) {
      return (null, "Failed to get image info.");
    }

    final contentType =
        headResponse.headers['content-type']?.split(';').first.trim();
    final extension =
        contentType != null ? supportedMimesToExtensions[contentType] : null;

    if (!isSupportedImage(extension)) {
      return (null, "File is not a supported image.");
    }

    final tempDir = await getTemporaryDirectory();
    final uniqueId = DateTime.now().millisecondsSinceEpoch;
    imageFile = File('${tempDir.path}/temp_$uniqueId.$extension');

    final getResponse = await client
        .get(Uri.parse(url))
        .timeout(Duration(seconds: 30));

    if (getResponse.statusCode != 200) {
      return (null, "Failed to download image.");
    }

    await imageFile.writeAsBytes(getResponse.bodyBytes);

    return (imageFile, null);
  } catch (e) {
    if (imageFile != null) imageFile.delete();
    return (null, e.toString());
  } finally {
    client.close();
  }
}

Future<List<String>> _getInstalledLanguages() async {
  ProcessResult lanResult = await Process.run("tesseract", ["--list-langs"]);
  List<String> lanOutput = lanResult.stdout.toString().trim().split("\n");
  return lanOutput.length > 1
      ? lanOutput.skip(1).toList()
      : [lanOutput.firstOrNull ?? ""];
}

Future<OcrResult> _runOcr(String path, String languages, String prefix) async {
  ProcessResult ocrResult = await Process.run("tesseract", [
    path,
    "-",
    "-l",
    languages,
  ]);

  String ocrOutput = ocrResult.stdout;
  PayData? payData = _extractPayData(ocrOutput);

  return OcrResult(payData, "$prefix$ocrOutput\n\n${ocrResult.stderr}", null);
}

PayData? _extractPayData(String text) {
  final keywordToPayType = {
    "Transaction No.": PayType.kbzPay, // KBZPay English
    "လုပ်ဆောင်မှုအမှတ်": PayType.kbzPay, // KBZPay Burmese
    "Transaction ID": PayType.wavePay, // WavePay English
    "လုပ်ဆောင်ချက်အိုင်ဒီ": PayType.wavePay, // WavePay Burmese
    "လုပဆောင်ချကအုငံဒ": PayType.wavePay, // WavePay Burmese with OCR error
  };

  // regex pattern that captures both the keyword and the number
  final allKeywords = keywordToPayType.keys.toList();
  final keywordPattern = allKeywords.map((k) => RegExp.escape(k)).join('|');
  final pattern = RegExp("($keywordPattern)\\s*(\\d+)");

  // Search for a keyword followed by a number
  final match = pattern.firstMatch(text);
  if (match != null) {
    final keyword = match.group(1)!; // matched keyword
    final transactionId = match.group(2)!; // captured transaction ID
    final payType = keywordToPayType[keyword]!; // corresponding pay type
    return PayData(payType, transactionId);
  }

  // KBZPay Fallback 1: Look for a standalone 20-digit number
  final kbzFallbackPattern = RegExp(r"\b\d{20}\b");
  final kbzFallbackMatch = kbzFallbackPattern.firstMatch(text);
  if (kbzFallbackMatch != null) {
    final transactionId = kbzFallbackMatch.group(0)!;
    return PayData(PayType.kbzPay, transactionId);
  }

  //  WavePay Fallback 1: Look for the last standalone 6+ digit number
  final waveFallbackPattern = RegExp(r"\b\d{6,}\b");
  final waveFallbackMatches = waveFallbackPattern.allMatches(text).toList();
  if (waveFallbackMatches.isNotEmpty) {
    final lastMatch = waveFallbackMatches.last;
    final transactionId = lastMatch.group(0)!;
    return PayData(PayType.wavePay, transactionId);
  }

  return null;
}
