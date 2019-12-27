import 'package:flutter/material.dart';
import 'dart:math';

class ArcPainter extends CustomPainter {

  double _startAngle;
  int _progress;
  Paint _paint;
  int _units;
  bool _fill;
  double _gap;

  Offset center;
  double _radius;

  ArcPainter(
    this._startAngle,
    this._progress,
    this._paint,
    this._units,
    this._fill,
    this._radius,
    this._gap,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final double sweepAngle = 2 * pi * (100 / this._units * this._progress) / 100;
    center = Offset(size.width / 4, size.height / 4);

    Paint paintMarkers = Paint()
        ..color = Colors.blue.withOpacity(0.2)
        ..strokeCap = StrokeCap.square
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7.0;

    // draw dial
    canvas.drawArc(Rect.fromCircle(center: center, radius: this._radius), -pi / 2 + this._startAngle, sweepAngle, this._fill, this._paint);

    // set markers
    for(var i = 0 ; i < this._units; i++) { 
      final double start = ((2 * pi) / this._units * i) - this._gap;
      // print('start $start');
      canvas.drawArc(Rect.fromCircle(center: center, radius: this._radius), start, this._gap * 2, this._fill, paintMarkers);
    } 

    
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}