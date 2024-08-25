import 'dart:math';
import 'package:flutter/material.dart';
import 'package:helg9000_clock/weather/wind/leaf.dart';
import 'package:helg9000_clock/weather/wind/leaf_painter.dart';

class Wind extends StatefulWidget {
  final double width;
  final double height;
  final Orientation orientation;

  @override
  State<StatefulWidget> createState() => WindState();

  const Wind({required this.width, required this.height, required this.orientation});
}

class WindState extends State<Wind> with TickerProviderStateMixin {
  var _leafPainters = <Widget>[];
  var _leafes = <Leaf>[];
  late AnimationController windAnimationController;

  @override
  void initState() {
    _createLeafes();
    _startAnimation();
    super.initState();
  }

  @override
  void didUpdateWidget(Wind oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (this._leafes.length == 0) {
      _createLeafes();
      _startAnimation();
    }

    if (oldWidget.height != widget.height) {
      this.windAnimationController.dispose();
      _createLeafes();
      _startAnimation();
    }
  }

  @override
  void dispose() {
    this.windAnimationController.dispose();
    super.dispose();
  }

  _createLeafes() {
    this._leafes = [];
    var rng = new Random();
    for (var i = 0; i < 200; i += 1) {
      final leaf = Leaf(
          rng.nextDouble() * widget.width,
          rng.nextDouble() * widget.height,
          rng.nextDouble() * (widget.height / 20),
          rng.nextDouble() + (widget.height / 100),
          rng.nextDouble() * 0.6);
      var painter = CustomPaint(
          painter: LeafPainter(leaf.x, leaf.y, 2, leaf.opacity, 0.0));
      this._leafes.add(leaf);
      this._leafPainters.add(painter);
    }
  }

  _startAnimation() {
    this.windAnimationController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
    var rng = new Random();
    Tween(begin: 0.0, end: 1.0).animate(this.windAnimationController)
      ..addListener(() {
        setState(() {
          this._leafPainters = [];
          this._leafes.forEach((leaf) {
            leaf.y = leaf.y += 0;
            leaf.x = leaf.x += 2 * rng.nextDouble() * 2 + 5;

            if (leaf.y > widget.height * 2 || leaf.x > widget.height * 2) {
              leaf.x = rng.nextDouble() * widget.width;
              leaf.y = rng.nextDouble() * widget.height;
            }

            var painter = CustomPaint(
                painter: LeafPainter(
                    leaf.x, leaf.y, leaf.radius, leaf.speed, leaf.opacity));
            this._leafPainters.add(painter);
          });
        });
      });
    this.windAnimationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: this._leafPainters);
  }
}
