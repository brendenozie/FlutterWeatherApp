import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:craft_silicon_weather_app/models/additionalWeatherData.dart';
import 'package:craft_silicon_weather_app/models/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import '../models/dailyWeather.dart';
import '../models/hourlyWeather.dart';
import '../models/weather.dart';
import 'dart:io'; // Used for actual internet check

class WeatherProvider with ChangeNotifier {

  String apiKey = '9a5522b6910088436fe893df1dc9aa9f';
  late Weather weather;
  late AdditionalWeatherData additionalWeatherData;
  LatLng? currentLocation;
  List<HourlyWeather> hourlyWeather = [];
  List<DailyWeather> dailyWeather = [];
  bool isLoading = false;
  bool isRequestError = false;
  bool isSearchError = false;
  bool isLocationserviceEnabled = false;
  LocationPermission? locationPermission;
  bool isCelsius = true;

  String get measurementUnit => isCelsius ? '°C' : '°F';

  Future<Position?> requestLocation(BuildContext context) async {
    isLocationserviceEnabled = await Geolocator.isLocationServiceEnabled();
    notifyListeners();

    if (!isLocationserviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location service disabled')),
      );
      return Future.error('Location services are disabled.');
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      isLoading = false;
      notifyListeners();
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Permission denied'),
        ));
        return Future.error('Location permissions are denied');
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Location permissions are permanently denied, Please enable manually from app settings',
        ),
      ));
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getWeatherData(BuildContext context, {bool notify = false}) async {
    isLoading = true;
    isRequestError = false;
    isSearchError = false;
    if (notify) notifyListeners();

    Position? locData = await requestLocation(context);

    if (locData == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    currentLocation = LatLng(locData.latitude, locData.longitude);
    bool isInternet =await isConnected();
    print('check if there is internet connection $isInternet');
    if (isInternet) {
      // Try fetching live data
      try {
        await getCurrentWeather(currentLocation!);
        await getDailyWeather(currentLocation!);
        cacheWeatherData();  // Save fresh data
      } catch (e) {
        print('Error Fetching Weather Online: $e');

        // Only trigger error if cached data is unavailable
        if (!Hive.box('weatherBox').containsKey('weather')) {
          isRequestError = true;
        } else {
          print("Using cached data due to API failure");
          loadCachedWeatherData();
        }
      }
    } else {
      // Offline Mode: Load cached data
      if (Hive.box('weatherBox').containsKey('weather')) {
        loadCachedWeatherData();
      } else {
        print("No cached data available, triggering request error.");
        isRequestError = true;
      }
    }

    isLoading = false;
    notifyListeners();
  }

  void cacheWeatherData() async {
    var box = Hive.box('weatherBox');
    print('Caching weather data...');
    print(jsonEncode(weather.toJson())); // Debug: Verify the data being cached
    box.put('weather', jsonEncode(weather.toJson()));
    if (dailyWeather.isNotEmpty) {
      box.put('dailyWeather', jsonEncode(dailyWeather.map((e) => e.toJson()).toList()));
    }
    if (hourlyWeather.isNotEmpty) {
      box.put('hourlyWeather', jsonEncode(hourlyWeather.map((e) => e.toJson()).toList()));
    }
    if (additionalWeatherData != null) {
      box.put('additionalWeatherData', jsonEncode(additionalWeatherData.toJson()));
    }
  }

  void loadCachedWeatherData() {
    var box = Hive.box('weatherBox');
    print('Loading cached data...');
    if (box.containsKey('weather')) {
      final cachedWeather = json.decode(box.get('weather')) as Map<String, dynamic>;
      weather = Weather.fromJson(cachedWeather);
      print('Loaded cached weather: ${weather.city}');
    } else {
      print('No cached weather data available.');
    }

    if (box.containsKey('dailyWeather')) {
      final cachedDaily = json.decode(box.get('dailyWeather')) as List;
      dailyWeather = cachedDaily.map((e) => DailyWeather.fromDailyJson(e)).toList();
      print('Loaded ${dailyWeather.length} days of cached weather.');
    } else {
      print('No cached daily weather data available.');
    }

    if (box.containsKey('hourlyWeather')) {
      final hourlWeather = json.decode(box.get('hourlyWeather')) as List;
      print('cached $hourlWeather');
      hourlyWeather = hourlWeather.map((e) => HourlyWeather(temp: e['temp'], weatherCategory: e['weatherCategory'], date:
      DateTime.fromMillisecondsSinceEpoch(e['date'] * 1000)) ).toList();
      print('Loaded ${hourlyWeather.length} days of cached weather.');
    } else {
      print('No cached daily weather data available.');
    }

    if (box.containsKey('additionalWeatherData')) {
      final cachedData = json.decode(box.get('additionalWeatherData')) as Map<String, dynamic>;
      additionalWeatherData = AdditionalWeatherData(
        precipitation: cachedData['precipitation'].toString(), // Ensure it's String
        uvi: (cachedData['uvi'] as num?)?.toDouble() ?? 0.0,
        clouds: cachedData['clouds'] as int? ?? 0,
      );
      print('Loaded cached weather data: $additionalWeatherData');
    } else {
      print('No cached daily weather data available.');
    }
  }

  Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    print('Result: ${connectivityResult.first}');
    if (connectivityResult.first == ConnectivityResult.mobile ||
        connectivityResult.first == ConnectivityResult.wifi) {
      // Verify actual internet access
      return await _hasInternet();
    }

    return false;
  }

  Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      print('Result: $result');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }


  Future<void> getDailyWeatherV1(LatLng location) async {
    isLoading = true;
    notifyListeners();

    Uri dailyUrl = Uri.parse(
       'https://api.openweathermap.org/data/2.5/forecast?lat=${location.latitude}&lon=${location.longitude}&units=metric&exclude=minutely,current&appid=$apiKey',
    );

    try {
      final response = await http.get(dailyUrl);
      final dailyData = json.decode(response.body) as Map<String, dynamic>;

      additionalWeatherData = AdditionalWeatherData.fromJson(dailyData);

      // Limit daily weather to five days
      List dailyList = dailyData['daily'];
      dailyWeather = dailyList
          .take(5) // Take only the first 5 days
          .map((item) => DailyWeather.fromDailyJson(item))
          .toList();

      // Limit hourly data if needed (e.g., first 24 hours)
      List hourlyList = dailyData['hourly'];
      hourlyWeather = hourlyList
          .map((item) => HourlyWeather.fromJson(item))
          .toList()
          .take(24)
          .toList();

    } catch (error) {
      print('Error Fetching number 1234 $error');
      isLoading = false;
      this.isRequestError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDailyWeather(LatLng location) async {
    isLoading = true;
    notifyListeners();

    Uri dailyUrl = Uri.parse(
      'https://api.openweathermap.org/data/3.0/onecall?lat=${location.latitude}&lon=${location.longitude}&units=metric&exclude=minutely,current&appid=$apiKey',
    );

    try {
      final response = await http.get(dailyUrl);
      final dailyData = json.decode(response.body) as Map<String, dynamic>;

      additionalWeatherData = AdditionalWeatherData.fromJson(dailyData);

      // Limit daily weather to five days
      List dailyList = dailyData['daily'];
      dailyWeather = dailyList
          .take(5) // Take only the first 5 days
          .map((item) => DailyWeather.fromDailyJson(item))
          .toList();

      // Limit hourly data if needed (e.g., first 24 hours)
      List hourlyList = dailyData['hourly'];
      hourlyWeather = hourlyList
          .map((item) => HourlyWeather.fromJson(item))
          .toList()
          .take(24)
          .toList();

    } catch (error) {
      print('Error Fetching number 1234 $error');
      isLoading = false;
      this.isRequestError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCurrentWeather(LatLng location) async {
    Uri url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&units=metric&appid=$apiKey',
    );
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      weather = Weather.fromJson(extractedData);
      cacheWeatherData();  // Save fetched data
      print('Fetched Weather for: ${weather.city}/${weather.countryCode}');
    } catch (error) {
      print('Error Fetching Weather: $error');
      isRequestError = true;
    }
  }

  Future<GeocodeData?> locationToLatLng(String location) async {
    try {
      Uri url = Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$location&limit=5&appid=$apiKey',
      );
      final http.Response response = await http.get(url);
      if (response.statusCode != 200) return null;
      return GeocodeData.fromJson(
        jsonDecode(response.body)[0] as Map<String, dynamic>,
      );
    } catch (e) {
      print('Error Fetching number 12345 $e');
      return null;
    }
  }

  Future<void> searchWeather(String location) async {
    isLoading = true;
    notifyListeners();
    isRequestError = false;
    print('search');
    try {
      GeocodeData? geocodeData;
      geocodeData = await locationToLatLng(location);
      if (geocodeData == null) throw Exception('Unable to Find Location');
      await getCurrentWeather(geocodeData.latLng);
      await getDailyWeather(geocodeData.latLng);
      // replace location name with data from geocode
      // because data from certain lat long might return local area name
      weather.city = geocodeData.name;
    } catch (e) {
      print(e);
      isSearchError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void switchTempUnit() {
    isCelsius = !isCelsius;
    notifyListeners();
  }
}
