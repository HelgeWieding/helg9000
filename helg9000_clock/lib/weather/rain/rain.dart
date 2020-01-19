import 'dart:math';
import 'package:flutter/material.dart';
import 'package:helg9000_clock/weather/rain/drop.dart';
import 'package:helg9000_clock/weather/rain/drop_painter.dart';


class Rain extends StatefulWidget {

  
  final double width;
  final double height;
  final Orientation orientation;

  @override
  State<StatefulWidget> createState() => RainState();

  const Rain({ this.width, this.height, this.orientation });
}

class RainState extends State<Rain> with TickerProviderStateMixin {

  var _dropPainters = <Widget>[];
  var _drops = <Drop>[];
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void didUpdateWidget(Rain oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (this._drops.length == 0) {
      _createDrops();
      _startAnimation();
    }

    if (oldWidget.height != widget.height) {
      _createDrops();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _createDrops() {
    print('creating drops');
    this._drops = [];
    var rng = new Random();
    for (var i = 0; i < 200; i += 1) {
      final drop = Drop(rng.nextDouble() * widget.width + widget.width / 2, rng.nextDouble() * widget.height, rng.nextDouble() * 20, rng.nextDouble() * 2 + 5, 
      rng.nextDouble() * 0.6);
      var painter = CustomPaint(painter: DropPainter(drop.x, drop.y, drop.length, 2, drop.opacity));
      this._drops.add(drop);
      this._dropPainters.add(painter);
    }
  }

  _startAnimation() {
    var controller = AnimationController(duration: Duration(milliseconds: 15000), vsync: this);
    this._animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          this._dropPainters = [];
          this._drops.forEach((drop) {
            drop.y = drop.y += drop.speed;

            if (drop.y > widget.height) {
              drop.y = 0;
            }

            var painter = CustomPaint(painter: DropPainter(drop.x, drop.y, drop.length, 2, drop.opacity));
            this._dropPainters.add(painter);
          }); 
        });
      });
      controller.repeat();
  }


  @override 
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: this._dropPainters
    );
  }
}