import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:weather_app_1/controller/global_controller.dart';
import 'package:weather_app_1/utils/costum_colors.dart';
import 'package:weather_app_1/widgets/hourly_widgets/hourly_body.dart';
import 'package:weather_app_1/widgets/hourly_widgets/hourly_header.dart';

class hourly_screen extends StatelessWidget {
  hourly_screen({Key? key}) : super(key: key);

  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);

  Future<void> _refresh() async {
    await globalController.refreshWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: Obx(
          () => globalController.checkLoading().isTrue
              ? Center(
                  child: Image.asset(
                    "assets/icons/clouds.png",
                    height: 200,
                    width: 200,
                  ),
                )
              : Center(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      // Current location and time
                      hourlyHeader(
                          weatherDataHourly: globalController
                              .getWeatherData()
                              .getHourlyWeather()),
                      // for current temperature ('current')

                      hourlyBody(
                          weatherDataHourly: globalController
                              .getWeatherData()
                              .getHourlyWeather())
                    ],
                  ),
                ),
        ),
      ),
    ));
  }
}
