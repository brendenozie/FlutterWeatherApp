import 'package:flutter/material.dart';
import 'package:craft_silicon_weather_app/helper/extensions.dart';
import 'package:craft_silicon_weather_app/models/hourlyWeather.dart';
import 'package:craft_silicon_weather_app/provider/weatherProvider.dart';
import 'package:craft_silicon_weather_app/theme/colors.dart';
import 'package:craft_silicon_weather_app/theme/textStyle.dart';
import 'package:craft_silicon_weather_app/widgets/customShimmer.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../helper/utils.dart';

class TwentyFourHourForecast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              children: [
                Icon(
                  PhosphorIconsRegular.clock,
                  color: Colors.white,
                ),
                const SizedBox(width: 8.0),
                Text(
                  '24-Hour Forecast',
                  style: semiboldText.copyWith(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Consumer<WeatherProvider>(
            builder: (context, weatherProv, _) {
              if (weatherProv.isLoading) {
                return SizedBox(
                  height: 140.0,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: 10,
                    separatorBuilder: (context, index) =>
                    const SizedBox(width: 12.0),
                    itemBuilder: (context, index) => CustomShimmer(
                      height: 140.0,
                      width: 80.0,
                    ),
                  ),
                );
              }
              return SizedBox(
                height: 140.0,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: weatherProv.hourlyWeather.length,
                  itemBuilder: (context, index) => HourlyWeatherWidget(
                    index: index,
                    data: weatherProv.hourlyWeather[index],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}

class HourlyWeatherWidget extends StatelessWidget {
  final int index;
  final HourlyWeather data;
  const HourlyWeatherWidget({
    Key? key,
    required this.index,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      width: 80.0,
      child: Column(
        children: [
          Consumer<WeatherProvider>(
            builder: (context, weatherProv, _) {
              return Text(
                weatherProv.isCelsius
                    ? '${data.temp.toStringAsFixed(1)}°'
                    : '${data.temp.toFahrenheit().toStringAsFixed(1)}°',
                style: semiboldText.copyWith(color: Colors.white),
              );
            },
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 40.0,
            width: 40.0,
            child: Image.asset(
              getWeatherImage(data.weatherCategory),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 4.0),
          FittedBox(
            child: Text(
              data.condition?.toTitleCase() ?? '',
              style: regularText.copyWith(fontSize: 12.0, color: Colors.white70),
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            index == 0 ? 'Now' : DateFormat('hh:mm a').format(data.date),
            style: regularText.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
