import 'package:fluent_ui/fluent_ui.dart';

class GithubIcon extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    paint.color = Colors.black;
    path = Path();
    path.lineTo(size.width / 2, 0);
    path.cubicTo(size.width * 0.22, 0, 0, size.height * 0.23, 0, size.height * 0.51);
    path.cubicTo(0, size.height * 0.74, size.width * 0.14, size.height * 0.93, size.width * 0.34, size.height);
    path.cubicTo(size.width * 0.37, size.height, size.width * 0.38, size.height, size.width * 0.38, size.height * 0.97);
    path.cubicTo(size.width * 0.38, size.height * 0.96, size.width * 0.38, size.height * 0.92, size.width * 0.38, size.height * 0.88);
    path.cubicTo(size.width / 4, size.height * 0.9, size.width * 0.22, size.height * 0.85, size.width / 5, size.height * 0.82);
    path.cubicTo(size.width / 5, size.height * 0.8, size.width * 0.18, size.height * 0.76, size.width * 0.16, size.height * 0.75);
    path.cubicTo(size.width * 0.14, size.height * 0.74, size.width * 0.11, size.height * 0.71, size.width * 0.16, size.height * 0.71);
    path.cubicTo(size.width * 0.19, size.height * 0.71, size.width * 0.22, size.height * 0.75, size.width * 0.23, size.height * 0.77);
    path.cubicTo(size.width * 0.28, size.height * 0.84, size.width * 0.35, size.height * 0.82, size.width * 0.38, size.height * 0.81);
    path.cubicTo(size.width * 0.38, size.height * 0.77, size.width * 0.4, size.height * 0.75, size.width * 0.41, size.height * 0.74);
    path.cubicTo(size.width * 0.3, size.height * 0.73, size.width * 0.18, size.height * 0.68, size.width * 0.18, size.height * 0.49);
    path.cubicTo(size.width * 0.18, size.height * 0.43, size.width / 5, size.height * 0.38, size.width * 0.23, size.height * 0.35);
    path.cubicTo(size.width * 0.23, size.height * 0.34, size.width / 5, size.height * 0.28, size.width * 0.24, size.height / 5);
    path.cubicTo(size.width * 0.24, size.height / 5, size.width * 0.28, size.height / 5, size.width * 0.38, size.height * 0.26);
    path.cubicTo(size.width * 0.42, size.height / 4, size.width * 0.46, size.height / 4, size.width / 2, size.height / 4);
    path.cubicTo(size.width * 0.54, size.height / 4, size.width * 0.59, size.height / 4, size.width * 0.63, size.height * 0.26);
    path.cubicTo(size.width * 0.72, size.height / 5, size.width * 0.76, size.height / 5, size.width * 0.76, size.height / 5);
    path.cubicTo(size.width * 0.79, size.height * 0.28, size.width * 0.77, size.height * 0.34, size.width * 0.77, size.height * 0.35);
    path.cubicTo(size.width * 0.8, size.height * 0.38, size.width * 0.82, size.height * 0.43, size.width * 0.82, size.height * 0.49);
    path.cubicTo(size.width * 0.82, size.height * 0.68, size.width * 0.7, size.height * 0.73, size.width * 0.59, size.height * 0.74);
    path.cubicTo(size.width * 0.61, size.height * 0.75, size.width * 0.63, size.height * 0.79, size.width * 0.63, size.height * 0.83);
    path.cubicTo(size.width * 0.63, size.height * 0.9, size.width * 0.62, size.height * 0.96, size.width * 0.62, size.height * 0.97);
    path.cubicTo(size.width * 0.62, size.height, size.width * 0.63, size.height, size.width * 0.66, size.height);
    path.cubicTo(size.width * 0.86, size.height * 0.93, size.width, size.height * 0.73, size.width, size.height * 0.51);
    path.cubicTo(size.width, size.height * 0.23, size.width * 0.78, 0, size.width / 2, 0);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
