import 'package:flutter/material.dart';
import 'package:craft_silicon_weather_app/helper/extensions.dart';
import 'package:craft_silicon_weather_app/theme/textStyle.dart';
import 'package:craft_silicon_weather_app/widgets/customShimmer.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import 'package:craft_silicon_weather_app/provider/weatherProvider.dart';
import 'package:craft_silicon_weather_app/theme/colors.dart';

import '../helper/utils.dart';

class MainWeatherDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(builder: (context, weatherProv, _) {
      if (weatherProv.isLoading) {
        return CustomShimmer(
          height: 150.0,
          borderRadius: BorderRadius.circular(16.0),
        );
      }

      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.blue.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            children: [
              _buildDetailRow(
                context,
                tiles: [
                  _buildDetailTile(
                    context,
                    title: 'Feels Like',
                    data: weatherProv.isCelsius
                        ? '${weatherProv.weather.feelsLike.toStringAsFixed(1)}°'
                        : '${weatherProv.weather.feelsLike.toFahrenheit().toStringAsFixed(1)}°',
                    icon: PhosphorIconsRegular.thermometerSimple,
                  ),
                  _buildDetailTile(
                    context,
                    title: 'Precipitation',
                    data: '${weatherProv.additionalWeatherData.precipitation}%',
                    icon: PhosphorIconsRegular.drop,
                  ),
                  _buildDetailTile(
                    context,
                    title: 'UV Index',
                    data: uviValueToString(
                      weatherProv.additionalWeatherData.uvi,
                    ),
                    icon: PhosphorIconsRegular.sun,
                  ),
                ],
              ),
              const Divider(
                color: Colors.white24,
                thickness: 1.0,
                height: 24.0,
              ),
              _buildDetailRow(
                context,
                tiles: [
                  _buildDetailTile(
                    context,
                    title: 'Wind',
                    data: '${weatherProv.weather.windSpeed} m/s',
                    icon: PhosphorIconsRegular.wind,
                  ),
                  _buildDetailTile(
                    context,
                    title: 'Humidity',
                    data: '${weatherProv.weather.humidity}%',
                    icon: PhosphorIconsRegular.dropHalfBottom,
                  ),
                  _buildDetailTile(
                    context,
                    title: 'Cloudiness',
                    data: '${weatherProv.additionalWeatherData.clouds}%',
                    icon: PhosphorIconsRegular.cloud,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDetailRow(BuildContext context, {required List<Widget> tiles}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: tiles,
    );
  }

  Widget _buildDetailTile(BuildContext context,
      {required String title, required String data, required IconData icon}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24.0,
          backgroundColor: Colors.white.withOpacity(0.2),
          child: Icon(icon, color: Colors.white, size: 28.0),
        ),
        const SizedBox(height: 8.0),
        Text(
          title,
          style: lightText.copyWith(color: Colors.white70, fontSize: 14.0),
        ),
        const SizedBox(height: 4.0),
        Text(
          data,
          style: mediumText.copyWith(color: Colors.white, fontSize: 16.0),
        ),
      ],
    );
  }
}
