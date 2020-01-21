import 'package:flutter/material.dart';

class LeafPainter extends CustomPainter {
  double x;
  double y;
  double radius;
  double speed;
  double opacity;

  Paint leafPainter = Paint()
    ..color = Colors.black
    ..maskFilter = MaskFilter.blur(BlurStyle.solid, 2)
    ..style = PaintingStyle.fill;

  LeafPainter(
    this.x,
    this.y,
    this.radius,
    this.speed,
    this.opacity,
  );

  @override
  void paint(Canvas canvas, Size size) {
    this.leafPainter.color =
        this.leafPainter.color.withOpacity(this.opacity / 2);
    var rect = Rect.fromCenter(
        center: Offset(this.x, this.y),
        width: this.radius / 2,
        height: this.radius);

    canvas.rotate(this.opacity * 10);
    canvas.drawRect(rect, this.leafPainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
