import 'package:flutter/material.dart';
import 'package:craft_silicon_weather_app/helper/extensions.dart';
import 'package:craft_silicon_weather_app/helper/utils.dart';
import 'package:craft_silicon_weather_app/provider/weatherProvider.dart';
import 'package:craft_silicon_weather_app/theme/textStyle.dart';
import 'package:provider/provider.dart';

import 'customShimmer.dart';

class MainWeatherInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(builder: (context, weatherProv, _) {
      if (weatherProv.isLoading) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomShimmer(
                height: 148.0,
                width: 148.0,
                borderRadius: BorderRadius.circular(16.0),
              ),
              CustomShimmer(
                height: 148.0,
                width: 148.0,
                borderRadius: BorderRadius.circular(16.0),
              ),
            ],
          ),
        );
      }

      final String temperature = weatherProv.isCelsius
          ? weatherProv.weather.temp.toStringAsFixed(1)
          : weatherProv.weather.temp.toFahrenheit().toStringAsFixed(1);
      final String unit = weatherProv.measurementUnit;
      final String description = weatherProv.weather.description.toTitleCase();
      final String weatherImage = getWeatherImage(weatherProv.weather.weatherCategory);

      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        temperature,
                        style: boldText.copyWith(
                          fontSize: 72.0,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          unit,
                          style: mediumText.copyWith(
                            fontSize: 24.0,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    description,
                    style: lightText.copyWith(
                      fontSize: 18.0,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 128.0,
              width: 128.0,
              child: Image.asset(
                weatherImage,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      );
    });
  }
}
