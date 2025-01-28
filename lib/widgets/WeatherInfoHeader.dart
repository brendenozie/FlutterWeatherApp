import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:craft_silicon_weather_app/provider/weatherProvider.dart';
import 'package:craft_silicon_weather_app/theme/colors.dart';
import 'package:craft_silicon_weather_app/theme/textStyle.dart';
import 'package:craft_silicon_weather_app/widgets/customShimmer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeatherInfoHeader extends StatelessWidget {
  static const double boxWidth = 52.0;
  static const double boxHeight = 40.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProv, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              weatherProv.isLoading
                  ? Expanded(
                child: CustomShimmer(
                  height: 48.0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              )
                  : Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: Colors.blueAccent, size: 18),
                        const SizedBox(width: 4.0),
                        Flexible(
                          child: Text(
                            '${weatherProv.weather?.city}, ${Country.tryParse(weatherProv.weather!.countryCode)?.name ?? ''}',
                            style: semiboldText.copyWith(fontSize: 18.0),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Colors.grey.shade700, size: 16),
                        const SizedBox(width: 4.0),
                        Flexible(
                          child: Text(
                            DateFormat('EEEE MMM dd, y hh:mm a')
                                .format(DateTime.now()),
                            style: regularText.copyWith(
                              color: Colors.grey.shade700,
                              fontSize: 14.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  color: Colors.grey.shade100,
                  child: Stack(
                    children: [
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 200),
                        child: weatherProv.isCelsius
                            ? GestureDetector(
                          key: ValueKey<int>(0),
                          onTap: weatherProv.isLoading
                              ? null
                              : weatherProv.switchTempUnit,
                          child: Row(
                            children: [
                              _buildTemperatureBox(
                                isActive: true,
                                text: '°C',
                                isLoading: weatherProv.isLoading,
                              ),
                              _buildTemperatureBox(
                                isActive: false,
                                text: '°F',
                                isLoading: weatherProv.isLoading,
                              ),
                            ],
                          ),
                        )
                            : GestureDetector(
                          key: ValueKey<int>(1),
                          onTap: weatherProv.isLoading
                              ? null
                              : weatherProv.switchTempUnit,
                          child: Row(
                            children: [
                              _buildTemperatureBox(
                                isActive: false,
                                text: '°C',
                                isLoading: weatherProv.isLoading,
                              ),
                              _buildTemperatureBox(
                                isActive: true,
                                text: '°F',
                                isLoading: weatherProv.isLoading,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTemperatureBox({
    required bool isActive,
    required String text,
    required bool isLoading,
  }) {
    return Container(
      height: boxHeight,
      width: boxWidth,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive
            ? (isLoading ? Colors.grey : primaryBlue)
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: semiboldText.copyWith(
          fontSize: 16,
          color: isActive ? Colors.white : Colors.grey.shade600,
        ),
      ),
    );
  }
}
