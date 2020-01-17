import 'package:flutter/material.dart';
import 'dart:math';

class ArcPainter extends CustomPainter {

  int _progress;
  Paint _paint;
  int _units;
  double _gap;

  List<Color> _gradient;

  Offset center;
  double _radius;

  ArcPainter(
    this._progress,
    this._paint,
    this._units,
    this._radius,
    this._gap,
    this._gradient,
  );

  @override
  void paint(Canvas canvas, Size size) {

    // final double sweepAngle = 2 * pi * (100 / this._units * this._progress) / 100;
    center = Offset(size.width / 2, size.height / 2);
    var rect = Rect.fromCircle(center: center, radius: this._radius);

    final gradient2 = new SweepGradient(
      startAngle: -pi / 2,
      endAngle: (-pi / 2) + (pi * 2),
      tileMode: TileMode.repeated,
      colors: this._gradient,
    );

    this._paint.shader = gradient2.createShader(rect);

    Paint paintMarkerEmpty = Paint()
      ..color = this._gradient[0].withOpacity(0.2)
      ..strokeCap = StrokeCap.butt  
      ..style = PaintingStyle.stroke
      ..strokeWidth = this._paint.strokeWidth
      ..isAntiAlias = true;

    // draw dial
    // canvas.drawArc(Rect.fromCircle(center: center, radius: this._radius), -pi / 2 + this._startAngle, sweepAngle, this._fill, this._paint);
    // set markers
    for(var i = 0 ; i < this._units; i++) { 
      final double start = ((2 * pi) / this._units * i);
      canvas.drawArc(rect, -pi / 2 + start, this._gap * 2, false, i < this._progress ? this._paint : paintMarkerEmpty);
    } 
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}