import 'package:flutter/material.dart';

class CloudPainter extends CustomPainter {

  double x;
  double y;
  double radius;
  double speed;
  double opacity;

  Paint cloudPainter = Paint()
                        ..color = Colors.black
                        ..maskFilter = MaskFilter.blur(BlurStyle.solid, 2)
                        ..style = PaintingStyle.fill;

  CloudPainter(
    this.x,
    this.y,
    this.radius,
    this.speed,
    this.opacity,
  ) {
    
  }

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawLine(Offset(this.x, this.y), Offset(this.x, this.y + this.length), Paint()..color = Colors.black.withOpacity(this.opacity)..strokeWidth = 3.0..strokeCap = StrokeCap.round);
    this.cloudPainter.color = this.cloudPainter.color.withOpacity(this.opacity / 2);
    var rect = Rect.fromCircle(center: Offset(this.x, this.y), radius: this.radius / 2);
    canvas.drawOval(rect, this.cloudPainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}