import 'package:flutter/material.dart';

class Sun extends CustomPainter {

  Paint _paint;

  Offset center;
  double _radius;
  double _fraction = 1.0;

  Sun(
    this._paint,
    this._radius,
    this._fraction

  );

  @override
  void paint(Canvas canvas, Size size) {
    
    this._paint.color = this._paint.color.withOpacity(this._fraction);
    center = Offset(size.width / 2, (size.height / 2) - 0);

    canvas.drawCircle(center, this._radius, this._paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}