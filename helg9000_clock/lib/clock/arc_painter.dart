import 'package:flutter/material.dart';
import 'dart:math';

class ArcPainter extends CustomPainter {
  int _progress;
  Paint _paint;
  int _units;
  double _gap;

  List<Color> _gradient;

  late Offset center;
  double _radius;

  late Paint paintMarkerEmpty;

  ArcPainter(
    this._progress,
    this._paint,
    this._units,
    this._radius,
    this._gap,
    this._gradient,
  ) {
    this.paintMarkerEmpty = Paint()
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = this._paint.strokeWidth
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    center = Offset(size.width / 2, size.height / 2);
    var rect = Rect.fromCircle(center: center, radius: this._radius);

    final gradient2 = new SweepGradient(
      startAngle: -pi / 2,
      endAngle: (-pi / 2) + (pi * 2),
      tileMode: TileMode.repeated,
      colors: this._gradient,
    );

    this._paint.shader = gradient2.createShader(rect);

    this.paintMarkerEmpty.color = this._gradient[0].withOpacity(0.2);

    for (var i = 0; i < this._units; i++) {
      final double unit = 2 * pi / this._units;
      double start = unit * i;
      double to = (((2 * pi) / this._units) + unit);

      canvas.drawArc(rect, (-pi / 2 + start), to * 2 * this._gap, false,
          i < this._progress ? this._paint : this.paintMarkerEmpty);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
