import 'package:flutter/material.dart';

class SkyPainter extends CustomPainter {

  Paint _paint;

  Offset center;
  double _radius;
  double _fraction;

  SkyPainter(
    this._radius,
    this._fraction,
    this._paint,
  );

  @override
  void paint(Canvas canvas, Size size) {
    center = Offset(size.width / 2, (size.height / 2) - 0);

    this._paint.color = this._paint.color.withOpacity(this._fraction);

    canvas.drawCircle(center, this._radius, this._paint);
    
  }

  @override
  bool shouldRepaint(SkyPainter oldDelegate) {
    return oldDelegate._fraction != _fraction;
  }
}