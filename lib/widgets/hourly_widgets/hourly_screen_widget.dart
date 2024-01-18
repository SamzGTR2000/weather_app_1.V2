import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_1/controller/global_controller.dart';
import 'package:weather_app_1/model/weather_data_hourly.dart';
import 'package:weather_app_1/screens/hourly_screen.dart';
import 'package:weather_app_1/utils/costum_colors.dart';
import 'package:weather_app_1/widgets/hourly_widgets/hourly_header.dart';

class HourlyScreenWidget1 extends StatelessWidget {
  final int index;
  final WeatherDataHourly weatherDataHourly;

  HourlyScreenWidget1(
      {Key? key, required this.weatherDataHourly, required this.index})
      : super(key: key);

  // card index
  RxInt cardIndex = GlobalController().getIndex();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          alignment: Alignment.topCenter,
          child: const Text(
            "Details",
            style: TextStyle(fontSize: 18),
          ),
        ),
        HourlyDetails(
          index: index,
          cardIndex: cardIndex.toInt(),
          temp: weatherDataHourly.hourly[index].temp!,
          timeStamp: weatherDataHourly.hourly[index].dt!,
          weatherIcon: weatherDataHourly.hourly[index].weather![0].icon!,
          feelsLike: weatherDataHourly.hourly[index].feelsLike!,
          pressure: weatherDataHourly.hourly[index].pressure!,
          humidity: weatherDataHourly.hourly[index].humidity!,
          dewPoint: weatherDataHourly.hourly[index].dewPoint!,
          uvi: weatherDataHourly.hourly[index].uvi!,
          clouds: weatherDataHourly.hourly[index].clouds!,
          visibility: weatherDataHourly.hourly[index].visibility!,
          windSpeed: weatherDataHourly.hourly[index].windSpeed!,
          windDeg: weatherDataHourly.hourly[index].windDeg!,
          windGust: weatherDataHourly.hourly[index].windGust!,
          description: weatherDataHourly.hourly[index].weather![0].description!,
          // null value for pop
          pop: 3,
          //
        ),
      ],
    );
  }

  Widget hourlyList() {
    return Container(
      height: 160,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: weatherDataHourly.hourly.length > 12
            ? 14
            : weatherDataHourly.hourly.length,
        itemBuilder: (context, index) {
          return Obx((() => GestureDetector(
              onTap: () {
                cardIndex.value = index;
              },
              child: Container(
                width: 90,
                margin: const EdgeInsets.only(left: 20, right: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0.5, 0),
                          blurRadius: 30,
                          spreadRadius: 1,
                          color: CustomColors.dividerLine.withAlpha(150))
                    ],
                    gradient: cardIndex.value == index
                        ? const LinearGradient(colors: [
                            CustomColors.firstGradientColor,
                            CustomColors.secondGradientColor
                          ])
                        : null),
              ))));
        },
      ),
    );
  }
}

class HourlyDetails extends StatelessWidget {
  int temp;
  int index;
  int cardIndex;
  int timeStamp;
  String weatherIcon;
  double feelsLike;
  int pressure;
  int humidity;
  double dewPoint;
  double uvi;
  int clouds;
  int visibility;
  double windSpeed;
  int windDeg;
  double windGust;
  String description;
  int pop;

  String getTime(final timeStamp) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    String x = DateFormat('jm').format(time);
    return x;
  }

  HourlyDetails({
    Key? key,
    required this.index,
    required this.cardIndex,
    required this.timeStamp,
    required this.temp,
    required this.weatherIcon,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.uvi,
    required this.clouds,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.windGust,
    required this.description,
    required this.pop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            getTime(timeStamp),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(5),
          child: Image.asset(
            "assets/weather/$weatherIcon.png",
            height: 40,
            width: 40,
          ),
        ),
        buildAttributeText("Description", "$description"),
        buildAttributeText("Temperature", "$temp°"),
        buildAttributeText("FeelsLike", "$feelsLike"),
        buildAttributeText("Pressure", "$pressure"),
        buildAttributeText("Humidity", "$humidity"),
        buildAttributeText("DewPoint", "$dewPoint"),
        buildAttributeText("UVIndex", "$uvi"),
        buildAttributeText("Clouds", "$clouds"),
        buildAttributeText("Visibility", "$visibility"),
        buildAttributeText("WindSpeed", "$windSpeed"),
        buildAttributeText("WindDeg", "$windDeg"),
        buildAttributeText("WindGust", "$windGust"),
      ],
    );
  }

  Widget buildAttributeText(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color:
                cardIndex == index ? Colors.black : CustomColors.textColorBlack,
          ),
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: value,
            ),
          ],
        ),
      ),
    );
  }
}
