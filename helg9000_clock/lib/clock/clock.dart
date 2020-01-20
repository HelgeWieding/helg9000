// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:helg9000_clock/clock/arc_painter.dart';


class Clock extends StatefulWidget {
  const Clock({ this.model, this.mode, this.colors });

  final ClockModel model;
  final String mode;
  final colors;

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {

  DateTime _dateTime = DateTime.now();
  Timer _timer;


  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(Clock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();

      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    final hours = _dateTime.hour % 12;
    final minutes = _dateTime.minute;
    final seconds = _dateTime.second;
    // calculate temperature colors

    // final minTemp = widget.model.temperature - 5;
    // final maxTemp = widget.model.temperature + 5;

    // var startIndex = ((minTemp + 20) / 2).floor() > 0 ? ((minTemp + 20) / 2).floor() : 0;
    // var limit = ((maxTemp + 20) / 2).floor() <= widget.colors.length ? ((maxTemp + 20) / 2).floor() : widget.colors.length;
    
    // List<Color> gradientColors = List();
    
    // // we need at least 2 colors for the gradient
    // if (startIndex > widget.colors.length) {
    //   startIndex = widget.colors.length - 2;
    // }

    // if (limit < 0) {
    //   limit = 2;
    // }
    
    // for (var i = startIndex; i < limit; i += 1) {
    //   gradientColors.add(widget.colors[i]);
    // }
    
    final maskFilter = widget.mode == 'light' ? MaskFilter.blur(BlurStyle.normal, 0) : MaskFilter.blur(BlurStyle.solid, 2);
    

    Paint paintSeconds = Paint()
        ..strokeCap = StrokeCap.butt  
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..maskFilter = maskFilter
        ..isAntiAlias = true;

    Paint paintMinutes = Paint()
        ..strokeCap = StrokeCap.butt  
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..maskFilter = maskFilter
        ..isAntiAlias = true;

    Paint paintHours = Paint()
        ..strokeCap = StrokeCap.butt  
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..maskFilter = maskFilter
        ..isAntiAlias = true;

    return 
    LayoutBuilder(
        builder: (context, constraints) {       
        return Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: <Widget>[
              CustomPaint(
                painter: ArcPainter(hours, paintHours, 12, constraints.maxHeight * 0.45, 0.24, widget.colors)
              ),
              CustomPaint(
                painter: ArcPainter(minutes, paintMinutes, 60, constraints.maxHeight * 0.4, 0.03, widget.colors)
              ),
              CustomPaint(
                painter: ArcPainter(seconds, paintSeconds, 60, constraints.maxHeight * 0.35, 0.015, widget.colors)
              ),
            ],
        );
      }
    );
  }
}
