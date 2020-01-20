
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

  double _brightness = 0.33;
  double _sunShine =  1.0;
  double _moonShine =  0.0;

  Paint haloOuter = Paint()  
      ..strokeCap = StrokeCap.butt  
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 400)
      ..isAntiAlias = true;

  Paint haloInner = Paint()  
      ..strokeCap = StrokeCap.butt  
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0
      ..maskFilter = MaskFilter.blur(BlurStyle.inner, 200)
      ..isAntiAlias = true;

  Paint sun = Paint()  
      ..strokeCap = StrokeCap.butt  
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, 20)
      ..isAntiAlias = true;

  Paint moon = Paint()  
    ..strokeCap = StrokeCap.butt  
    ..style = PaintingStyle.fill
    ..strokeWidth = 4.0
    ..maskFilter = MaskFilter.blur(BlurStyle.solid, 20)
    ..isAntiAlias = true;

  Animation<double> animation;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Sky oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.mode != oldWidget.mode) {
      // _switchBrightness();
    }

    switch(widget.model.weatherString) { 
        case 'cloudy': {
            this.setCloudy(this._brightness, 1, 2000);
        } 
        break; 
        
        case 'sunny': { 
            //statements; 
            this.setSunny(this._sunShine, 1, 2000);
        } 
        break; 

        case 'rainy': { 
            //statements; 
            this.setCloudy(this._brightness, 1, 2000);
        } 
        break; 
            
        default: { 
            //statements;  
        }
        break; 
      }
  }

  @override
  void dispose() {
    widget.model.dispose();
    super.dispose();
  }

  void setSunny(double from, double to, int duration) {
    var controller = AnimationController(duration: Duration(milliseconds: duration), vsync: this);
    animation = Tween(begin: from, end: to).animate(controller)
      ..addListener(() {
          setState(() {
            this._sunShine = animation.value;
            this._moonShine = 0;
            this._brightness = animation.value / 3;
          });
        });
    controller.forward();
  }

  void setCloudy(double from, double to, int duration) {
    var controller = AnimationController(duration: Duration(milliseconds: duration), vsync: this);
    animation = Tween(begin: from, end: to).animate(controller)
      ..addListener(() {
          setState(() {
            this._sunShine = 1 - animation.value;
            this._moonShine = 0;
            this._brightness = animation.value;
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
 
    if (val > 0.5) {
      val = 0.5;
    }

    return val;
  }


  @override
  Widget build(BuildContext context) {
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return
          Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: <Widget> [
              CustomPaint(painter: Sun(paintSun: sun, radius: constraints.maxHeight / 12, fraction: this._sunShine)),
              CustomPaint(painter: Moon(moon, constraints.maxHeight / 14, this._moonShine)),
              CustomPaint(painter: SkyPainter(constraints.maxHeight * 0.4, this._brightness, widget.color, haloOuter)), 
              CustomPaint(painter: SkyPainter(constraints.maxHeight * 0.4, this._brightness, widget.color, haloInner)),
            ]
          );
      }
    );
  }
}