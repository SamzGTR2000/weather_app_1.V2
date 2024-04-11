import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_1/controller/global_controller.dart';
import 'package:weather_app_1/model/weather_data_current.dart';
import 'package:weather_app_1/utils/costum_colors.dart';

class HeaderWidget extends StatefulWidget {
  final WeatherDataCurrent weatherDataCurrent;

  const HeaderWidget({Key? key, required this.weatherDataCurrent})
      : super(key: key);

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState(weatherDataCurrent);
}

class _HeaderWidgetState extends State<HeaderWidget> {
  String city = "";
  String administrativeArea = "";
  String country = "";
  String date = DateFormat("yMMMMd").format(DateTime.now());

  final WeatherDataCurrent weatherDataCurrent;

  _HeaderWidgetState(this.weatherDataCurrent);

  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);

  @override
  void initState() {
    getAddress(globalController.getLattitude().value,
        globalController.getLongitude().value);
    super.initState();
  }

  getAddress(lat, lon) async {
    List<Placemark> placemark = await placemarkFromCoordinates(lat, lon);
    Placemark place = placemark[0];

    city = place.locality!;
    administrativeArea = place.administrativeArea!;
    country = place.country!;

    setState(() {
      city = place.locality!;
      administrativeArea = place.administrativeArea!;
      country = place.country!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 2, 2, 2),
                  height: 50,
                  width: 200,
                  child: Text(
                    city,
                    style: TextStyle(fontSize: 35),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 2, 2, 2),
                  height: 90,
                  width: 200,
                  child: Text(
                    "${weatherDataCurrent.current.temp!.toInt()}°",
                    style: TextStyle(fontSize: 65),
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 2, 15, 2),
              height: 140,
              width: 180,
              child: WeatherInfoWidget(
                weatherIcon: weatherDataCurrent.current.weather![0].icon!,
                description:
                    weatherDataCurrent.current.weather![0].description!,
              ),
            )
          ],
        )
      ],
    );
  }
}

class WeatherInfoWidget extends StatelessWidget {
  final String weatherIcon;
  final String description;

  const WeatherInfoWidget({
    Key? key,
    required this.weatherIcon,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double halfScreenWidth = (MediaQuery.of(context).size.width / 2) - 10;

    return Container(
      height: 120,
      width: halfScreenWidth,
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: CustomColors.dividerLine.withAlpha(150),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            child: Image.asset(
              "assets/weather/$weatherIcon.png",
              height: 60,
              width: 60,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              description,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
