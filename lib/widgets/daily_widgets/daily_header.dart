import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_1/controller/global_controller.dart';
import 'package:weather_app_1/model/weather_data_daily.dart';

class DailyHeader extends StatefulWidget {
  final WeatherDataDaily weatherDataDaily;

  const DailyHeader({Key? key, required this.weatherDataDaily})
      : super(key: key);

  @override
  State<DailyHeader> createState() =>
      _DailyHeaderState(weatherDataDaily: weatherDataDaily);
}

class _DailyHeaderState extends State<DailyHeader> {
  final WeatherDataDaily weatherDataDaily;
  _DailyHeaderState({required this.weatherDataDaily});
  String city = "";
  String day = DateFormat("EEEE").format(DateTime.now());
  String date = DateFormat("y MMMM d").format(DateTime.now());
  String time = DateFormat("H:mm").format(DateTime.now());
  DateTime selectedTime = DateTime.now();

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
    setState(() {
      city = place.locality!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                city,
                style: const TextStyle(fontSize: 35),
              ),
              Padding(
                padding: const EdgeInsets.all(5.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      day,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
