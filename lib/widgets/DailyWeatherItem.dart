import 'package:craft_silicon_weather_app/helper/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:craft_silicon_weather_app/models/dailyWeather.dart';
import 'package:craft_silicon_weather_app/provider/weatherProvider.dart';
import 'package:craft_silicon_weather_app/theme/colors.dart';
import 'package:craft_silicon_weather_app/theme/textStyle.dart';
import '../helper/utils.dart';

class DailyWeatherItem extends StatelessWidget {
  final DailyWeather weather;
  final int index;
  final bool isCelsius;

  const DailyWeatherItem({
    Key? key,
    required this.weather,
    required this.index,
    required this.isCelsius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade100, Colors.blue.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          Navigator.of(context).pushNamed(
            '/fiveDayForecastDetail', // Replace with actual route
            arguments: index,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Day Label
              Expanded(
                flex: 2,
                child: Text(
                  index == 0 ? 'Today' : DateFormat('EEEE').format(weather.date),
                  style: semiboldText.copyWith(
                    fontSize: 18,
                    color: index == 0 ? Colors.black : Colors.blueGrey.shade800,
                  ),
                ),
              ),
              // Weather Icon and Category
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      getWeatherImage(weather.weatherCategory),
                      height: 48.0,
                      width: 48.0,
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      weather.weatherCategory.toTitleCase(),
                      style: lightText.copyWith(
                        fontSize: 14.0,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              // Temperature
              Expanded(
                flex: 1,
                child: Text(
                  isCelsius
                      ? '${weather.tempMax.toStringAsFixed(0)}°/${weather.tempMin.toStringAsFixed(0)}°'
                      : '${weather.tempMax.toFahrenheit().toStringAsFixed(0)}°/${weather.tempMin.toFahrenheit().toStringAsFixed(0)}°',
                  style: semiboldText.copyWith(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
