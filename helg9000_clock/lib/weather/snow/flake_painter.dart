import 'package:flutter/material.dart';

class FlakePainter extends CustomPainter {

  double x;
  double y;
  double radius;
  double speed;
  double opacity;

  FlakePainter(
    this.x,
    this.y,
    this.radius,
    this.speed,
    this.opacity,
  );


  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawLine(Offset(this.x, this.y), Offset(this.x, this.y + this.length), Paint()..color = Colors.black.withOpacity(this.opacity)..strokeWidth = 3.0..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}