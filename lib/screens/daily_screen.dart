import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:weather_app_1/controller/global_controller.dart';
import 'package:weather_app_1/model/weather_data_daily.dart';
import 'package:weather_app_1/model/weather_data_hourly.dart';
import 'package:weather_app_1/utils/costum_colors.dart';
import 'package:weather_app_1/widgets/daily_widgets/daily_body.dart';
import 'package:weather_app_1/widgets/daily_widgets/daily_header.dart';
import 'package:weather_app_1/widgets/hourly_widgets/hourly_header.dart';
import 'package:weather_app_1/widgets/hourly_widgets/hourly_screen_widget.dart';

class daily_screen extends StatelessWidget {
  daily_screen({Key? key}) : super(key: key);

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
                      DailyHeader(
                          weatherDataDaily: globalController
                              .getWeatherData()
                              .getDailyWeather()),
                      // for current temperature ('current')

                      DailyBody(
                        weatherDataDaily:
                            globalController.getWeatherData().getDailyWeather(),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    ));
  }
}
