
import 'package:flutter_clock_helper/model.dart';
import 'package:helg9000_clock/sky/moon.dart';
import 'package:helg9000_clock/sky/sky_painter.dart';
import 'package:helg9000_clock/sky/sun.dart';
import 'package:flutter/material.dart';

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
  double _sunShine =  0.8;

  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _updateColor();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

    var controller = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          _fraction = getSkyOpacity(animation.value);
          _sunShine = widget.mode == 'light' ? animation.value : 1 - animation.value;
        });
      });
      controller.forward();
  }

  getSkyOpacity(double animationValue) {
    var val;

    if (widget.mode == 'light') {
      val = animationValue;
    } else {
      val = 1 - animationValue;
    }

    if (val < 0.2) {
      val = 0.2;
    }
 
    if (val > 0.8) {
      val = 0.8;
    }

    return val;
  }


  @override
  Widget build(BuildContext context) {
    // print('building sky $context');
    Paint haloOuter = Paint()  
      ..strokeCap = StrokeCap.butt  
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0
      ..color = widget.color.withOpacity(1)
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 400)
      ..isAntiAlias = true;

    Paint haloInner = Paint()  
      ..strokeCap = StrokeCap.butt  
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0
      ..color = widget.color.withOpacity(1)
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
      fit: StackFit.expand,
      children: <Widget> [
        CustomPaint(painter: Sun(sun, 20, this._sunShine)),
        CustomPaint(painter: Moon(sun, 20, 1 - this._sunShine)),
        CustomPaint(painter: SkyPainter(this._radius, this._fraction, haloOuter)), 
        CustomPaint(painter: SkyPainter(this._radius, this._fraction, haloInner)),
      ]
    );
  }
}