import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app_1/controller/global_controller.dart';
import 'package:weather_app_1/model/weather_data_current.dart';
import 'package:weather_app_1/screens/hourly_screen.dart';
import 'package:weather_app_1/utils/costum_colors.dart';
import 'package:weather_app_1/widgets/aqi_radial_gauge.dart';
import 'package:weather_app_1/widgets/comfort_level.dart';
import 'package:weather_app_1/widgets/current_weather_widget.dart';
import 'package:weather_app_1/widgets/daily_data_forecast.dart';
import 'package:weather_app_1/widgets/header_widget.dart';
import 'package:weather_app_1/widgets/hourly_data_widget.dart';
import 'package:weather_app_1/widgets/radial_gauge.dart';
import 'package:weather_app_1/widgets/wind_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // call
  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);

  Future<void> _refresh() async {
    await globalController.refreshWeather();
  }

  @override
  Widget build(BuildContext context) {
    double halfScreenWidth = (MediaQuery.of(context).size.width / 2) - 10;
    double containerWidth = 0.5 * MediaQuery.of(context).size.width;
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
                      HeaderWidget(
                        weatherDataCurrent: globalController
                            .getWeatherData()
                            .getCurrentWeather(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      HourlyDataWidget(
                        weatherDataHourly: globalController
                            .getWeatherData()
                            .getHourlyWeather(),
                        weatherDataCurrent: globalController
                            .getWeatherData()
                            .getCurrentWeather(),
                      ),
                      DailyDataForecast(
                        weatherDataDaily:
                            globalController.getWeatherData().getDailyWeather(),
                      ),
                      Container(
                        height: 1,
                        color: CustomColors.dividerLine,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              WindSpeed(
                                weatherDataCurrent: globalController
                                    .getWeatherData()
                                    .getCurrentWeather(),
                                weatherDataHourly: globalController
                                    .getWeatherData()
                                    .getHourlyWeather(),
                              ),
                              ComfortLevel(
                                  weatherDataCurrent: globalController
                                      .getWeatherData()
                                      .getCurrentWeather()),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 200,
                                width: halfScreenWidth,
                                child: RadialGauge(
                                  weatherDataCurrent: globalController
                                      .getWeatherData()
                                      .getCurrentWeather(),
                                ),
                              ),
                              Container(
                                height: 200,
                                width: halfScreenWidth,
                                child: AqiRadialGauge(
                                  weatherDataCurrent: globalController
                                      .getWeatherData()
                                      .getCurrentWeather(),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
        ),
      ),
    ));
  }
}
