import 'dart:io';

const supportedMimesToExtensions = {
  'image/jpeg': 'jpg',
  'image/png': 'png',
  'image/gif': 'gif',
  'image/bmp': 'bmp',
  'image/webp': 'webp',
  'image/tiff': 'tiff',
  'image/jp2': 'jp2',
  'image/x-portable-anymap': 'pnm',
};

bool isSupportedImage(String? extension) => extension != null && supportedMimesToExtensions.values.contains(extension);

bool isUrl(String str) =>
    str.startsWith('http://') || str.startsWith('https://');

bool isFile(String? path) {
  if (path == null || path.isEmpty) return false;
  return File(path).existsSync();
}