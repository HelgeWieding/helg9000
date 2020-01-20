
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:helg9000_clock/weather/rain/rain.dart';
import 'package:helg9000_clock/weather/snow/snow.dart';

class Weather extends StatefulWidget {
  
  final ClockModel model;
  final String mode;

  @override
  State<StatefulWidget> createState() => WeatherState();

  const Weather({ this.model, this.mode });
}

class WeatherState extends State<Weather> with TickerProviderStateMixin {

  Widget weather;

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

            if (widget.model.weatherString =='rainy' || widget.model.weatherString == 'thunderstorm') {
              this.weather = Rain(width: constraints.maxWidth / 2, height: constraints.maxHeight * 0.9);
            } else if (widget.model.weatherString == 'snowy') {
              this.weather = Snow(width: constraints.maxWidth / 2, height: constraints.maxHeight * 0.9);
            } else {
              this.weather = Container();
            }

            return this.weather;
          }
        );
  }
}