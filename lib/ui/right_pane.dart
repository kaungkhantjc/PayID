import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:pay_id/bloc/ocr_bloc.dart';
import 'package:pay_id/constants.dart';
import 'package:pay_id/icons/github_icon.dart';
import 'package:pay_id/ocr/ocr_result.dart';
import 'package:url_launcher/url_launcher.dart';

class RightPane extends StatelessWidget {
  const RightPane({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "OCR Output",
                style: FluentTheme.of(context).typography.bodyStrong,
              ),
              IconButton(
                icon: SizedBox(
                  width: 24,
                  height: 24,
                  child: CustomPaint(painter: GithubIcon()),
                ),
                onPressed: () async {
                  if (!await launchUrl(Uri.parse(repoUrl))) {
                    throw Exception('Could not launch $repoUrl');
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.topLeft,
              child: BlocBuilder<OcrBloc, OcrState>(
                builder: (context, state) {
                  return _buildSelectableText(context, state);
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

String getOcrResultText(OcrResult? result) =>
    result == null
        ? "Drop a file, select one, or enter a path."
        : result.error ?? result.output ?? "";

Widget _buildSelectableText(BuildContext context, OcrState state) {
  TextStyle? textStyle = FluentTheme.of(context).typography.bodyLarge;
  OcrResult? result = state.result;

  String resultText = getOcrResultText(result);

  return SelectableLinkify(
    onOpen: (link) async {
      if (!await launchUrl(Uri.parse(link.url))) {
        throw Exception('Could not launch ${link.url}');
      }
    },
    text: resultText,
    style: textStyle,
    linkStyle: TextStyle(color: FluentTheme.of(context).accentColor.normal),
  );
}
