import 'dart:math';

import 'package:flutter/material.dart';

class Moon extends CustomPainter {
  Paint _paint;

  Offset center;
  double _radius;
  double fraction = 0.0;

  Moon(this._paint, this._radius, this.fraction);

  @override
  void paint(Canvas canvas, Size size) {
    center = Offset(size.width / 2, (size.height / 2) - 0);

    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, 5)
      ..color = Colors.white.withOpacity(this.fraction);

    var rect = Rect.fromCircle(
        center: Offset(center.dx, center.dy), radius: this._radius);

    Path path = Path();
    path.arcTo(rect, pi / 2, pi, false);
    path.cubicTo(center.dx - 18, center.dy - 10, center.dx - 18, center.dy + 12,
        center.dx, center.dy + this._radius);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(Moon oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
