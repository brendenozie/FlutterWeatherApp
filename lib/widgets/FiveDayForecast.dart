import 'package:craft_silicon_weather_app/widgets/DailyWeatherItem.dart';
import 'package:flutter/material.dart';
import 'package:craft_silicon_weather_app/Screens/FiveDayForecastDetailScreen.dart';
import 'package:craft_silicon_weather_app/helper/extensions.dart';
import 'package:craft_silicon_weather_app/models/dailyWeather.dart';
import 'package:craft_silicon_weather_app/provider/weatherProvider.dart';
import 'package:craft_silicon_weather_app/theme/colors.dart';
import 'package:craft_silicon_weather_app/theme/textStyle.dart';
import 'package:craft_silicon_weather_app/widgets/customShimmer.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../helper/utils.dart';

class FiveDayForecast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                PhosphorIconsRegular.calendar,
                color: Colors.white,
              ),
              const SizedBox(width: 8.0),
              Text(
                '5-Day Forecast',
                style: semiboldText.copyWith(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Consumer<WeatherProvider>(
                builder: (context, weatherProv, _) {
                  return TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: mediumText.copyWith(fontSize: 14.0),
                    ),
                    child: const Text('More details ▶'),
                    onPressed: weatherProv.isLoading
                        ? null
                        : () {
                      Navigator.of(context).pushNamed(
                          FiveDayForecastDetail.routeName);
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Consumer<WeatherProvider>(
            builder: (context, weatherProv, _) {
              if (weatherProv.isLoading) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) => CustomShimmer(
                    height: 80.0,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: weatherProv.dailyWeather.length,
                itemBuilder: (context, index) {
                  final DailyWeather weather = weatherProv.dailyWeather[index];
                  return DailyWeatherItem(weather: weather, index: index, isCelsius: false);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
