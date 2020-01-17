

import 'package:flutter_clock_helper/model.dart';
import 'package:helg9000_clock/weather/sky/sky_painter.dart';
import 'package:flutter/material.dart';
import 'package:helg9000_clock/weather/sun.dart';

class Sky extends StatefulWidget {
  
  final ClockModel model;
  final Color color;
  final String mode;

  @override
  State<StatefulWidget> createState() => SkyState();

  const Sky({ this.model, this.color, this.mode });
}

class SkyState extends State<Sky> with TickerProviderStateMixin {

  double _fraction = 0.0;
  double _radius = 90;

  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _updateColor();
  }

  @override
  void didUpdateWidget(Sky oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.mode != oldWidget.mode) {
      _updateColor();
    }

    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateSky());
      widget.model.addListener(_updateSky());
    }
  }

  @override
  void dispose() {
    widget.model.removeListener(_updateSky());
    widget.model.dispose();
    super.dispose();
  }

  _updateSky() {
    // to be implemented
  }

  void _updateColor() {
    var start = widget.mode == 'light' ? 0.2 : 0.8;
    var finish = widget.mode == 'light' ? 0.8 : 0.2;

    var controller = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: start, end: finish).animate(controller)
      ..addListener(() {
        setState(() {
          _fraction = animation.value;
        });
      });
      controller.forward();
  }


  @override
  Widget build(BuildContext context) {
    // print('building sky $context');
    Paint skyHalo = Paint()  
        ..strokeCap = StrokeCap.butt  
        ..style = PaintingStyle.fill
        ..strokeWidth = 4.0
        ..color = widget.color.withOpacity(1)
        ..maskFilter = MaskFilter.blur(BlurStyle.outer, 400)
        ..isAntiAlias = true;

      // print(widget);

    Paint skyHalo2 = Paint()  
      ..strokeCap = StrokeCap.butt  
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0
      ..color = widget.color.withOpacity(0.2)
      ..maskFilter = MaskFilter.blur(BlurStyle.inner, 200)
      ..isAntiAlias = true;

    Paint sun = Paint()  
      ..strokeCap = StrokeCap.butt  
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0
      ..color = Colors.white.withOpacity(1)
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, 20)
      ..isAntiAlias = true;

    return Stack(
      alignment: Alignment.center,
      children: <Widget> [
        CustomPaint(painter: SkyPainter(this._radius, this._fraction, skyHalo)),
        CustomPaint(painter: SkyPainter(this._radius, this._fraction, skyHalo2)),
        CustomPaint(painter: Sun(sun, 20)),
      ]
    );
  }
}