
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
  double _thunder = 0.0;

  AnimationController weatherAnimationController;

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
    widget.model.addListener(_updateWeather);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Sky oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateWeather());
      widget.model.addListener(_updateWeather());
    }

    if (widget.mode != oldWidget.mode) {
      this._updateWeather();
    }
  }

  _updateWeather() {

    if (this.weatherAnimationController != null) {
      this.weatherAnimationController.dispose();
    }

    switch(widget.model.weatherString) { 
        case 'cloudy': {
            this.setCloudy(this._brightness, 1, 2000);
        } 
        break; 
        
        case 'sunny': { 
            //statements
            if (widget.mode == 'light') {
              this.setSunny(this._sunShine, 1, 0.3, 2000);
            } else {
              this.setMoon(0, this._moonShine, 0.1, 2000);
            }
        } 
        break; 

        case 'rainy': { 
            //statements; 
            this.setCloudy(this._brightness, 1, 2000);
        } 
        break;

        case 'foggy': { 
            //statements; 
            this.setCloudy(this._brightness, 1, 2000);
        } 
        break; 

        case 'snowy': { 
            //statements; 
            this.setCloudy(this._brightness, 1, 2000);
        } 
        break; 

        case 'thunderstorm': { 
            //statements; 
            this.setThunder();
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
    widget.model.removeListener(_updateWeather);
    super.dispose();
  }

  void setSunny(double sunTo, double moonTo, double brightnessTo, int duration) {

    bool brightnessDown = brightnessTo < this._brightness;

    this.weatherAnimationController = AnimationController(duration: Duration(milliseconds: duration), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(this.weatherAnimationController)
      ..addListener(() {
          setState(() {
            this._sunShine = animation.value;
            this._moonShine = 0;

            if (this._brightness > brightnessTo && brightnessDown) {
              this._brightness = 1 - animation.value;
            } else if (this._brightness < brightnessTo && !brightnessDown) {
              this._brightness = animation.value;
            }
          });
        });
    this.weatherAnimationController.forward();
  }

  void setMoon(double sunTo, double moonTo, double brightnessTo, int duration) {

    bool brightnessDown = brightnessTo < this._brightness;

    this.weatherAnimationController = AnimationController(duration: Duration(milliseconds: duration), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(this.weatherAnimationController)
      ..addListener(() {
          setState(() {
            this._sunShine = 1 - animation.value;
            this._moonShine = animation.value;

            if (this._brightness > brightnessTo && brightnessDown) {
              this._brightness -= animation.value;
            }
          });
        });
    this.weatherAnimationController.forward();
  }

  void setCloudy(double from, double to, int duration) {
    this.weatherAnimationController = AnimationController(duration: Duration(milliseconds: duration), vsync: this);
    animation = Tween(begin: from, end: to).animate(this.weatherAnimationController)
      ..addListener(() {
          setState(() {
            this._sunShine = 1 - animation.value;
            this._moonShine = 1 - animation.value;
            this._brightness = animation.value;
          });
        });
    this.weatherAnimationController.forward();
  }

  void setThunder() {
    this.weatherAnimationController = AnimationController(duration: Duration(milliseconds: 3000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(this.weatherAnimationController)
      ..addListener(() {

          setState(() {

            if ((animation.value > 0.9 && animation.value < 0.91) || (animation.value > 0.93 && animation.value < 0.94)) {
              this._thunder = animation.value;
            } else {
              this._thunder = 0.0;
            }

            this._brightness = 1.0;
            this._sunShine = 0.0;
            this._moonShine = 0.0;
          });
        });
    this.weatherAnimationController.repeat();
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

    Paint thunder = Paint()
                    ..color = Colors.white.withOpacity(1)
                    ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20);

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
              CustomPaint(painter: SkyPainter(constraints.maxHeight * 0.4, this._thunder, widget.color, thunder)),
            ]
          );
      }
    );
  }
}