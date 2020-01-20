import 'package:flutter/material.dart';

class Sun extends CustomPainter {

  Sun({
    @required this.fraction,
    @required this.paintSun,
    @required this.radius
  }
    

  );
  Paint paintSun;

  Offset center;
  double radius;
  double fraction;


  @override
  void paint(Canvas canvas, Size size) {
    this.paintSun.color = Colors.white.withOpacity(this.fraction);
    center = Offset(size.width / 2, (size.height / 2) - 0);
    canvas.drawCircle(center, this.radius, this.paintSun);
  }

  @override
  bool shouldRepaint(Sun oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}