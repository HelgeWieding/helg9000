// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:helg9000_clock/clock/arc_painter.dart';

class Clock extends StatefulWidget {
  Clock({this.model, this.mode, this.colors});

  final ClockModel model;
  final String mode;
  final colors;

  final Paint paintSeconds = Paint()
    ..strokeCap = StrokeCap.butt
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4.0
    ..isAntiAlias = true;

  final Paint paintMinutes = Paint()
    ..strokeCap = StrokeCap.butt
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4.0
    ..isAntiAlias = true;

  final Paint paintHours = Paint()
    ..strokeCap = StrokeCap.butt
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4.0
    ..isAntiAlias = true;

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

    final weather = widget.model.weatherString;

    final maskFiler = weather == 'foggy'
        ? MaskFilter.blur(BlurStyle.normal, 2)
        : MaskFilter.blur(BlurStyle.solid, 2);

    widget.paintHours.maskFilter = maskFiler;
    widget.paintMinutes.maskFilter = maskFiler;
    widget.paintSeconds.maskFilter = maskFiler;

    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          CustomPaint(
              painter: ArcPainter(hours, widget.paintHours, 12,
                  constraints.maxHeight * 0.4, 0.24, widget.colors)),
          CustomPaint(
              painter: ArcPainter(minutes, widget.paintMinutes, 60,
                  constraints.maxHeight * 0.36, 0.2, widget.colors)),
          CustomPaint(
              painter: ArcPainter(seconds, widget.paintSeconds, 60,
                  constraints.maxHeight * 0.32, 0.2, widget.colors)),
        ],
      );
    });
  }
}
