import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../helper/extensions.dart';
import '../helper/utils.dart';
import '../models/dailyWeather.dart';
import '../provider/weatherProvider.dart';
import '../theme/colors.dart';
import '../theme/textStyle.dart';

class FiveDayForecastDetail extends StatefulWidget {
  static const routeName = '/fiveDayForecast';
  final int initialIndex;

  const FiveDayForecastDetail({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<FiveDayForecastDetail> createState() => _FiveDayForecastDetailState();
}

class _FiveDayForecastDetailState extends State<FiveDayForecastDetail> {
  int _selectedIndex = 0;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _scrollController = ScrollController();
    if (_selectedIndex > 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _selectedIndex * 80.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '5-Day Forecast',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProv, _) {
          final _selectedWeather = weatherProv.dailyWeather[_selectedIndex];
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              const SizedBox(height: 16.0),
              // Horizontal Day Selector
              SizedBox(
                height: 120.0,
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: weatherProv.dailyWeather.length,
                  itemBuilder: (context, index) {
                    final weather = weatherProv.dailyWeather[index];
                    final isSelected = index == _selectedIndex;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 80.0,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                            colors: [Color(0xFF6BA4FF), Color(0xFF92CFFF)],
                          )
                              : null,
                          color: isSelected
                              ? null
                              : Colors.blue.shade50.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              blurRadius: 8.0,
                              offset: const Offset(0, 4),
                            ),
                          ]
                              : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              index == 0
                                  ? 'Today'
                                  : DateFormat('EEE').format(weather.date),
                              style: mediumText.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.blueGrey.shade800,
                              ),
                            ),
                            Image.asset(
                              getWeatherImage(weather.weatherCategory),
                              height: 40.0,
                            ),
                            Text(
                              weatherProv.isCelsius
                                  ? '${weather.tempMax.toStringAsFixed(0)}°/${weather.tempMin.toStringAsFixed(0)}°'
                                  : '${weather.tempMax.toFahrenheit().toStringAsFixed(0)}°/${weather.tempMin.toFahrenheit().toStringAsFixed(0)}°',
                              style: regularText.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.blueGrey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24.0),
              // Selected Day Overview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedIndex == 0
                            ? 'Today'
                            : DateFormat('EEEE').format(_selectedWeather.date),
                        style: mediumText.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        weatherProv.isCelsius
                            ? '${_selectedWeather.tempMax.toStringAsFixed(0)}°/${_selectedWeather.tempMin.toStringAsFixed(0)}°'
                            : '${_selectedWeather.tempMax.toFahrenheit().toStringAsFixed(0)}°/${_selectedWeather.tempMin.toFahrenheit().toStringAsFixed(0)}°',
                        style: boldText.copyWith(fontSize: 48.0),
                      ),
                      Text(
                        _selectedWeather.weatherCategory,
                        style: semiboldText.copyWith(
                          color: primaryBlue,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    getWeatherImage(_selectedWeather.weatherCategory),
                    height: 112.0,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Weather Details
              _DetailSection(
                title: 'Weather Details',
                details: [
                  _ForecastDetailInfoTile(
                    title: 'Cloudiness',
                    icon: PhosphorIcon(
                      PhosphorIconsRegular.cloud,
                      color: Colors.white,
                    ),
                    data: '${_selectedWeather.clouds}%',
                  ),
                  _ForecastDetailInfoTile(
                    title: 'UV Index',
                    icon: PhosphorIcon(
                      PhosphorIconsRegular.sun,
                      color: Colors.white,
                    ),
                    data: uviValueToString(_selectedWeather.uvi),
                  ),
                  _ForecastDetailInfoTile(
                    title: 'Precipitation',
                    icon: PhosphorIcon(
                      PhosphorIconsRegular.drop,
                      color: Colors.white,
                    ),
                    data: '${_selectedWeather.precipitation}%',
                  ),
                  _ForecastDetailInfoTile(
                    title: 'Humidity',
                    icon: PhosphorIcon(
                      PhosphorIconsRegular.thermometerSimple,
                      color: Colors.white,
                    ),
                    data: '${_selectedWeather.humidity}%',
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}


class _DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> details;

  const _DetailSection({
    Key? key,
    required this.title,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: semiboldText.copyWith(fontSize: 18.0, color: Colors.black87),
        ),
        const SizedBox(height: 12.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Column(
            children: details,
          ),
        ),
      ],
    );
  }
}

class _ForecastDetailInfoTile extends StatelessWidget {
  final String title;
  final String data;
  final Widget icon;

  const _ForecastDetailInfoTile({
    Key? key,
    required this.title,
    required this.data,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 48.0,
            width: 48.0,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6BA4FF), Color(0xFF92CFFF)],
              ),
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 6.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(child: icon),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: mediumText.copyWith(
                    color: Colors.black54,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  data,
                  style: boldText.copyWith(fontSize: 16.0, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
