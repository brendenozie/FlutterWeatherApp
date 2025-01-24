// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:craft_silicon_weather_app/screens/locationError.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/weatherProvider.dart';
import '../theme/colors.dart';
import '../theme/textStyle.dart';
import '../widgets/WeatherInfoHeader.dart';
import '../widgets/mainWeatherDetail.dart';
import '../widgets/mainWeatherInfo.dart';
import '../widgets/FiveDayForecast.dart';
import '../widgets/twentyFourHourForecast.dart';

import 'requestError.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FloatingSearchBarController fsc = FloatingSearchBarController();

  @override
  void initState() {
    super.initState();
    requestWeather();
  }

  Future<void> requestWeather() async {
    await Provider.of<WeatherProvider>(context, listen: false)
        .getWeatherData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProv, _) {
          if (!weatherProv.isLoading && !weatherProv.isLocationserviceEnabled)
            return LocationServiceErrorDisplay();

          if (!weatherProv.isLoading &&
              weatherProv.locationPermission != LocationPermission.always &&
              weatherProv.locationPermission != LocationPermission.whileInUse) {
            return LocationPermissionErrorDisplay();
          }

          if (weatherProv.isRequestError) return RequestErrorDisplay();

          if (weatherProv.isSearchError) return SearchErrorDisplay(fsc: fsc);

          return Stack(
            children: [
              ListView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(12.0).copyWith(
                  top: kToolbarHeight +
                      MediaQuery.viewPaddingOf(context).top +
                      24.0,
                ),
                children: [
                  WeatherInfoHeader(),
                  const SizedBox(height: 16.0),
                  MainWeatherInfo(),
                  const SizedBox(height: 16.0),
                  MainWeatherDetail(),
                  const SizedBox(height: 16.0),
                  TwentyFourHourForecast(),
                  const SizedBox(height: 18.0),
                  FiveDayForecast(),
                ],
              ),
              CustomSearchBar(fsc: fsc),
            ],
          );
        },
      ),
    );
  }
}

class CustomSearchBar extends StatefulWidget {
  final FloatingSearchBarController fsc;
  const CustomSearchBar({Key? key, required this.fsc}) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  List<String> _citiesSuggestion = [
    'Nairobi',
    'Kisumu',
    'Kericho',
    'Mombasa',
    'Garissa',
    'Eldoret',
    'Turkana'
  ];

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      controller: widget.fsc,
      hint: 'Search for cities...',
      clearQueryOnClose: false,
      scrollPadding: const EdgeInsets.only(top: 16.0, bottom: 56.0),
      transitionDuration: const Duration(milliseconds: 400),
      borderRadius: BorderRadius.circular(16.0),
      transitionCurve: Curves.easeInOut,
      accentColor: primaryBlue,
      hintStyle: regularText.copyWith(color: Colors.grey[600]),
      queryStyle: regularText.copyWith(color: Colors.black87),
      physics: const BouncingScrollPhysics(),
      elevation: 6.0,
      shadowColor: Colors.grey.withOpacity(0.2),
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {},
      onSubmitted: (query) async {
        widget.fsc.close();
        await Provider.of<WeatherProvider>(context, listen: false)
            .searchWeather(query);
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: Icon(
            Icons.search,
            color: primaryBlue,
          ),
        ),
        FloatingSearchBarAction.icon(
          showIfClosed: false,
          showIfOpened: true,
          icon: Icon(
            Icons.close,
            color: primaryBlue,
          ),
          onTap: () {
            if (widget.fsc.query.isEmpty) {
              widget.fsc.close();
            } else {
              widget.fsc.clear();
            }
          },
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  child: Text(
                    'Suggestions',
                    style: mediumText.copyWith(
                        color: Colors.grey[800], fontWeight: FontWeight.w600),
                  ),
                ),
                Divider(height: 1.0, thickness: 1.0),
                // Suggestion List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: _citiesSuggestion.length,
                  itemBuilder: (context, index) {
                    String data = _citiesSuggestion[index];
                    return InkWell(
                      onTap: () async {
                        widget.fsc.query = data;
                        widget.fsc.close();
                        await Provider.of<WeatherProvider>(context,
                            listen: false)
                            .searchWeather(data);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: primaryBlue,
                              size: 20.0,
                            ),
                            const SizedBox(width: 16.0),
                            Text(
                              data,
                              style: mediumText.copyWith(color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                  const Divider(height: 1.0, thickness: 1.0),
                ),
                // Add More Sections Here (e.g., Recent Searches)
              ],
            ),
          ),
        );
      },
    );
  }
}
