
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:helg9000_clock/weather/rain/rain.dart';

class Weather extends StatefulWidget {
  
  final ClockModel model;
  final String mode;

  @override
  State<StatefulWidget> createState() => WeatherState();

  const Weather({ this.model, this.mode });
}

class WeatherState extends State<Weather> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    _updateWeather();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Weather oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.mode != oldWidget.mode) {
      _updateWeather();
    }

    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateWeather());
      widget.model.addListener(_updateWeather());
    }
  }

  @override
  void dispose() {
    widget.model.removeListener(_updateWeather());
    widget.model.dispose();
    super.dispose();
  }

  _updateWeather() {

  }


  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
            builder: (context, constraints) {       
            return Rain(width: constraints.maxWidth / 2, height: constraints.maxHeight * 0.8);
          }
        );
  }
}