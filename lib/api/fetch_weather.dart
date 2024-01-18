import 'dart:convert';

import 'package:weather_app_1/api/api_key.dart';
import 'package:weather_app_1/model/weather_data.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_1/model/weather_data_current.dart';
import 'package:weather_app_1/model/weather_data_daily.dart';
import 'package:weather_app_1/model/weather_data_hourly.dart';

class FetchWeatherApi {
  WeatherData? weatherData;

  // processing the data from response -> to json
  Future<WeatherData> processData(lat, lon) async {
    var response = await http.get(Uri.parse(apiURL(lat, lon)));
    var jsonString = jsonDecode(response.body);
    weatherData = WeatherData(
        WeatherDataCurrent.fromJson(jsonString),
        WeatherDataHourly.fromJson(jsonString),
        WeatherDataDaily.fromJson(jsonString));

    return weatherData!;
  }
}

String apiURL(var lat, var lon) {
  String url;
  url =
      "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&appid=$apiKey&units=metric";
  return url;
}
