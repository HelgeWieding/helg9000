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

  const Sky({this.model, this.color, this.mode});
}

class SkyState extends State<Sky> with TickerProviderStateMixin {
  double _brightness = 0.33;
  double _sunShine = 1.0;
  double _moonShine = 0.0;
  double _thunder = 0.0;

  AnimationController sunAnimationController;
  AnimationController moonAnimationController;
  AnimationController skyAnimationController;
  AnimationController thunderAnimationController;

  Animation<double> sunAnimation;
  Animation<double> moonAnimation;
  Animation<double> skyAnimation;
  Animation<double> thunderAnimation;

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

  @override
  void initState() {
    widget.model.addListener(_updateWeather);
    super.initState();
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
    final currentMode = widget.mode;
    final oldMode = oldWidget.mode;

    if (oldMode != currentMode) {
      if (widget.mode == 'light') {
        this.setCloudy(this._brightness, 0.5, 2000);
        this.setSun(this._sunShine, 1, 3000);
        this.setMoon(this._moonShine, 0, 2000);
      } else {
        this.setCloudy(this._brightness, 0.2, 2000);
        this.setMoon(this._moonShine, 1, 2000);
        this.setSun(this._sunShine, 0, 3000);
      }
    }
  }

  _updateWeather() {
    if (this.sunAnimationController != null) {
      if (this.sunAnimationController.isAnimating) {
        this.sunAnimationController.stop();
      }
    }

    if (this.moonAnimationController != null) {
      if (this.moonAnimationController.isAnimating) {
        this.moonAnimationController.stop();
      }
    }

    if (this.skyAnimationController != null) {
      if (this.skyAnimationController.isAnimating) {
        this.skyAnimationController.stop();
      }
    }

    if (this.thunderAnimationController != null) {
      if (this.thunderAnimationController.isAnimating) {
        this.thunderAnimationController.stop();
      }
    }

    switch (widget.model.weatherString) {
      case 'cloudy':
        {
          this.setSun(this._sunShine, 0, 2000);
          this.setMoon(this._moonShine, 0, 2000);
          this.setCloudy(this._brightness, 0.5, 2000);
        }
        break;

      case 'sunny':
        {
          //statements
          if (widget.mode == 'light') {
            this.setCloudy(this._brightness, 0.2, 2000);
            this.setSun(this._sunShine, 1, 2000);
          } else {
            this.setMoon(this._moonShine, 1, 2000);
            this.setCloudy(this._brightness, 0.0, 2000);
          }
        }
        break;

      case 'rainy':
        {
          //statements;
          this.setCloudy(this._brightness, 0.5, 2000);
          this.setMoon(this._moonShine, 0, 2000);
          this.setSun(this._sunShine, 0, 2000);
        }
        break;

      case 'foggy':
        {
          //statements;
          this.setCloudy(this._brightness, 0.5, 2000);
          this.setMoon(this._moonShine, 0, 2000);
          this.setSun(this._sunShine, 0, 2000);
        }
        break;

      case 'snowy':
        {
          //statements;
          this.setCloudy(this._brightness, 0.5, 2000);
          this.setMoon(this._moonShine, 0, 2000);
          this.setSun(this._sunShine, 0, 2000);
        }
        break;

      case 'thunderstorm':
        {
          //statements;
          this.setCloudy(this._brightness, 0.5, 2000);
          this.setMoon(this._moonShine, 0, 2000);
          this.setSun(this._sunShine, 0, 2000);
          this.setThunder();
        }
        break;

      default:
        {
          //statements;
        }
        break;
    }
  }

  @override
  void dispose() {
    widget.model.dispose();
    widget.model.removeListener(_updateWeather);
    this.moonAnimationController.dispose();
    this.sunAnimationController.dispose();
    this.skyAnimationController.dispose();
    this.thunderAnimationController.dispose();
    super.dispose();
  }

  void setSun(double from, double to, int duration) {
    this.sunAnimationController = AnimationController(
        duration: Duration(milliseconds: duration), vsync: this);
    sunAnimation =
        Tween(begin: from, end: to).animate(this.sunAnimationController)
          ..addListener(() {
            setState(() {
              this._sunShine = sunAnimation.value;
            });
          });
    this.sunAnimationController.forward();
  }

  void setMoon(double from, double to, int duration) {
    this.moonAnimationController = AnimationController(
        duration: Duration(milliseconds: duration), vsync: this);
    moonAnimation =
        Tween(begin: from, end: to).animate(this.moonAnimationController)
          ..addListener(() {
            setState(() {
              this._moonShine = moonAnimation.value;
            });
          });
    this.moonAnimationController.forward();
  }

  void setCloudy(double from, double to, int duration) {
    this.skyAnimationController = AnimationController(
        duration: Duration(milliseconds: duration), vsync: this);
    skyAnimation =
        Tween(begin: from, end: to).animate(this.skyAnimationController)
          ..addListener(() {
            setState(() {
              double value = skyAnimation.value;
              this._brightness = value;
            });
          });
    this.skyAnimationController.forward();
  }

  void setThunder() {
    this.thunderAnimationController = AnimationController(
        duration: Duration(milliseconds: 5000), vsync: this);
    thunderAnimation =
        Tween(begin: 0.0, end: 1.0).animate(this.thunderAnimationController)
          ..addListener(() {
            setState(() {
              if ((thunderAnimation.value > 0.9 &&
                      thunderAnimation.value < 0.91) ||
                  (thunderAnimation.value > 0.92 &&
                      thunderAnimation.value < 0.93) ||
                  (thunderAnimation.value > 0.94 &&
                      thunderAnimation.value < 0.95)) {
                this._thunder = thunderAnimation.value - 0.5;
              } else {
                this._thunder = 0.0;
              }
            });
          });
    this.thunderAnimationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    Paint thunder = Paint()
      ..color = Colors.white.withOpacity(1)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20);

    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            CustomPaint(
                painter: Sun(
                    paintSun: sun,
                    radius: constraints.maxHeight / 12,
                    fraction: this._sunShine)),
            CustomPaint(
                painter:
                    Moon(moon, constraints.maxHeight / 14, this._moonShine)),
            CustomPaint(
                painter: SkyPainter(constraints.maxHeight * 0.4,
                    this._brightness, widget.color, haloOuter)),
            CustomPaint(
                painter: SkyPainter(constraints.maxHeight * 0.3, this._thunder,
                    widget.color, thunder)),
            CustomPaint(
                painter: SkyPainter(constraints.maxHeight * 0.4,
                    this._brightness, widget.color, haloInner)),
          ]);
    });
  }
}
