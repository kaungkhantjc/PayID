String msgTesseractNotInstalled = """Tesseract CLI not installed.

For Windows

- download setup file. Install "additional script data > Myanmar script" and "additional language data > Burmese" while setup.

  https://github.com/tesseract-ocr/tesseract/releases

- Add Tesseract CLI path to Environment variables > PATH.

For Mac
brew install tesseract tesseract-lang

For Ubuntu
sudo apt install tesseract-ocr tesseract-ocr-mya

For others
https://tesseract-ocr.github.io/tessdoc/Installation.html
""";

String repoUrl = "https://github.com/kaungkhantjc/PayID";

