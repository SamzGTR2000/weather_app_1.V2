import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:weather_app_1/model/weather_data_current.dart';
import 'package:weather_app_1/model/weather_data_hourly.dart';
import 'package:weather_app_1/utils/costum_colors.dart';

class WindSpeed extends StatelessWidget {
  final WeatherDataCurrent weatherDataCurrent;
  final WeatherDataHourly weatherDataHourly;
  late List<double> hourlyWindSpeeds;
  WindSpeed(
      {Key? key,
      required this.weatherDataCurrent,
      required this.weatherDataHourly})
      : super(key: key) {
    hourlyWindSpeeds = weatherDataHourly.getHourlyWindSpeeds();

    double maxWindSpeed = getMaxWindSpeed(hourlyWindSpeeds);
  }
  double getMaxWindSpeed(List<double> windSpeeds) {
    if (windSpeeds.isEmpty) {
      return 0.0;
    }

    double maxSpeed = windSpeeds.first;

    for (double speed in windSpeeds) {
      if (speed > maxSpeed) {
        maxSpeed = speed;
      }
    }

    return maxSpeed;
  }

  @override
  Widget build(BuildContext context) {
    double halfScreenWidth = (MediaQuery.of(context).size.width / 2) - 10;
    double containerWidth = 0.5 *
        MediaQuery.of(context)
            .size
            .width; // Set the percentage you desire (e.g., 50%)
    return Center(
        child: Container(
      width: halfScreenWidth,
      height: 200,
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: CustomColors.dividerLine.withAlpha(150),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        height: 180,
        child: Column(
          children: [
            const Text(
              "Wind Speed",
              style: TextStyle(
                color: CustomColors.textColorBlack,
                fontSize: 18,
              ),
            ),
            Container(
              height: 1,
              width: 180,
              color: CustomColors.dividerLine,
            ),
            Image.asset(
              'assets/icons/wind.png', // Replace with your image asset path
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 10),
            Text(
              "${weatherDataCurrent.current.windSpeed} km/h", // Replace with your wind speed data
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "Max Speed: ${getMaxWindSpeed(hourlyWindSpeeds)} km/h", // Replace with your max speed data
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    ));
  }
}
