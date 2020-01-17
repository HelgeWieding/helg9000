// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:helg9000_clock/weather/sky/sky.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'arc_painter.dart';

enum _Element {
  background,
  text,
  shadow,
  blur,
  mode
}



final temperatureColors = [
  const Color(0xFFB50DE2), // -20 Celsius , friggin coold
  const Color(0xFFAE0DE2),
  const Color(0xFF980DE2),
  const Color(0xFF8E0DE2),
  const Color(0xFF810DE2),
  const Color(0xFF7B0DE2),
  const Color(0xFF670DE2),
  const Color(0xFF570DE2),
  const Color(0xFF4A0DE2),
  const Color(0xFF410DE2),
  const Color(0xFF1D0DE2),
  const Color(0xFF0D4AE2),
  const Color(0xFF0D57E2),
  const Color(0xFF0D74E2),
  const Color(0xFF0DB8E2),
  const Color(0xFF0DD8E2),
  const Color(0xFF0DE2BB),
  const Color(0xFF0DE2A1),
  const Color(0xFF0DE284),
  const Color(0xFF0DE25E),
  const Color(0xFF0DE244),
  const Color(0xFF84E20D),
  const Color(0xFFC2E20D),
  const Color(0xFFE2DF0D),
  const Color(0xFFE2A10D),
  const Color(0xFFE2740D),
  const Color(0xFFE2510D),
  const Color(0xFFE22D0D),
  const Color(0xFFE2100D),
  const Color(0xFFE20D17), // 40 Celsius, rather be dead
];

final _lightTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.black,
  _Element.shadow: Colors.black,
  _Element.blur: MaskFilter.blur(BlurStyle.normal, 0),
  _Element.mode: 'light'
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.black,
  _Element.shadow: Colors.black,
  _Element.blur: MaskFilter.blur(BlurStyle.solid, 2),
  _Element.mode: 'dark'
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
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
  void didUpdateWidget(DigitalClock oldWidget) {
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
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    
    final hours = _dateTime.hour % 12;
    final minutes = _dateTime.minute;
    final seconds = _dateTime.second;


    // calculate temperature colors

    final minTemp = widget.model.temperature - 5;
    final maxTemp = widget.model.temperature + 5;

    var startIndex = ((minTemp + 20) / 2).floor() > 0 ? ((minTemp + 20) / 2).floor() : 0;
    var limit = ((maxTemp + 20) / 2).floor() <= temperatureColors.length ? ((maxTemp + 20) / 2).floor() : temperatureColors.length;
    
    List<Color> gradientColors = List();
    
    // we need at least 2 colors for the gradient
    if (startIndex > temperatureColors.length) {
      startIndex = temperatureColors.length - 2;
    }

    if (limit < 0) {
      limit = 2;
    }

    for (var i = startIndex; i < limit; i += 1) {
      gradientColors.add(temperatureColors[i]);
    }
    
    

    Paint paintSeconds = Paint()
        ..strokeCap = StrokeCap.butt  
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..maskFilter = colors[_Element.blur]
        ..isAntiAlias = true;

    Paint paintMinutes = Paint()
        ..strokeCap = StrokeCap.butt  
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..maskFilter = colors[_Element.blur]
        ..isAntiAlias = true;

    Paint paintHours = Paint()
        ..strokeCap = StrokeCap.butt  
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..maskFilter = colors[_Element.blur]
        ..isAntiAlias = true;

    return Container(
      color: colors[_Element.background],
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            painter: ArcPainter(hours, paintHours, 12, 120, 0.24, gradientColors)
            
          ),
          CustomPaint(
            painter: ArcPainter(minutes, paintMinutes, 60, 110, 0.03, gradientColors)
            
          ),
          CustomPaint(
            painter: ArcPainter(seconds, paintSeconds, 60, 100, 0.015, gradientColors)
          ),
          Sky(color: gradientColors[0], model: widget.model, mode: colors[_Element.mode])
        ],
      )
    );
  }
}
