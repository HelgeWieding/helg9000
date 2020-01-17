import 'package:flutter/material.dart';

class Sun extends CustomPainter {

  Paint _paint;

  Offset center;
  double _radius;

  Sun(
    this._paint,
    this._radius,
  );

  @override
  void paint(Canvas canvas, Size size) {

    center = Offset(size.width / 2, (size.height / 2) - 0);

    canvas.drawCircle(center, this._radius, this._paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}