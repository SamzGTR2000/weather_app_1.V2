import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:weather_app_1/controller/global_controller.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:weather_app_1/model/weather_data_daily.dart';
import 'package:weather_app_1/model/weather_data_hourly.dart';
import 'package:weather_app_1/utils/costum_colors.dart';

class hourlyHeader extends StatefulWidget {
  final WeatherDataHourly weatherDataHourly;

  const hourlyHeader({Key? key, required this.weatherDataHourly})
      : super(key: key);

  @override
  State<hourlyHeader> createState() =>
      _hourlyHeaderState(weatherDataHourly: weatherDataHourly);
}

class _hourlyHeaderState extends State<hourlyHeader> {
  final WeatherDataHourly weatherDataHourly;
  _hourlyHeaderState({required this.weatherDataHourly});
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
    if (day == null) {
      print(day);
    }
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
        // Row(
        //   children: [
        //     Container(
        //       width: 200,
        //       child: TimePicker(weatherDataHourly: weatherDataHourly),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class TimePicker extends StatefulWidget {
  final WeatherDataHourly weatherDataHourly;
  const TimePicker({super.key, required this.weatherDataHourly});

  @override
  State<TimePicker> createState() =>
      _TimePickerState(weatherDataHourly: weatherDataHourly);
}

class _TimePickerState extends State<TimePicker> {
  final WeatherDataHourly weatherDataHourly;
  _TimePickerState({required this.weatherDataHourly});

  var hour = 0;
  var minute = 0;
  var timeFormat = "";
  late int timeStamp = 0;
  late String time = '';

  int getTimeStamp() {
    DateTime dateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      hour + (timeFormat == "PM" ? 12 : 0), // Adjust hour for PM
      minute,
    );

    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }

  @override
  void initState() {
    super.initState();
    timeStamp = getTimeStamp();
    time = getTime(timeStamp);
  }

  String getTime(final timeStamp) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    String x = DateFormat('jm').format(time);
    return x;
  }

  int getClosestSmallerTimestamp(List<int> timestampList, int targetTimestamp) {
    int? closestTimestamp;
    for (int timestamp in timestampList) {
      if (timestamp <= targetTimestamp &&
          (closestTimestamp == null || timestamp > closestTimestamp)) {
        closestTimestamp = timestamp;
      }
    }
    return closestTimestamp ??
        1705385400; // Return the default value if closestTimestamp is null.
  }

  @override
  Widget build(BuildContext context) {
    int timeStamp1 = 1705385400;
    List<int> dts = weatherDataHourly.getHourlyDts();
    int? desiredTimestamp = getClosestSmallerTimestamp(dts, timeStamp);
    Hourly? hourlyData = weatherDataHourly.getHourlyByDt(desiredTimestamp!);

    if (dts != null) {
      // print(dts);
    }

    if (timeStamp != null) {
      // print("Time TS is $timeStamp");
    }

    if (desiredTimestamp != null) {
      // print("Desired timestamp is $desiredTimestamp");
    }

    if (hourlyData != null) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              // "$timeStamp",
              // "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, "0")} ${timeFormat}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 150,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  NumberPicker(
                    minValue: 0,
                    maxValue: 12,
                    value: hour,
                    zeroPad: true,
                    infiniteLoop: true,
                    itemWidth: 50,
                    itemHeight: 50,
                    onChanged: (value) {
                      setState(() {
                        hour = value;
                        timeStamp = getTimeStamp();
                        time = getTime(timeStamp);
                      });
                    },
                    textStyle:
                        const TextStyle(color: Colors.grey, fontSize: 20),
                    selectedTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 30),
                    decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(
                            color: Colors.white,
                          ),
                          bottom: BorderSide(color: Colors.white)),
                    ),
                  ),
                  NumberPicker(
                    minValue: 0,
                    maxValue: 59,
                    value: minute,
                    zeroPad: true,
                    infiniteLoop: true,
                    itemWidth: 50,
                    itemHeight: 50,
                    onChanged: (value) {
                      setState(() {
                        minute = value;
                        timeStamp = getTimeStamp();
                        time = getTime(timeStamp);
                      });
                    },
                    textStyle:
                        const TextStyle(color: Colors.grey, fontSize: 20),
                    selectedTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 30),
                    decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(
                            color: Colors.white,
                          ),
                          bottom: BorderSide(color: Colors.white)),
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            timeFormat = "AM";
                            timeStamp = getTimeStamp();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: timeFormat == "AM"
                                ? Colors.grey.shade800
                                : Colors.grey.shade700,
                            border: Border.all(
                              color: timeFormat == "AM"
                                  ? Colors.grey
                                  : Colors.grey.shade700,
                            ),
                          ),
                          child: const Text(
                            "AM",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            timeFormat = "PM";
                            timeStamp = getTimeStamp();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: timeFormat == "PM"
                                ? Colors.grey.shade800
                                : Colors.grey.shade700,
                            border: Border.all(
                              color: timeFormat == "PM"
                                  ? Colors.grey
                                  : Colors.grey.shade700,
                            ),
                          ),
                          child: const Text(
                            "PM",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            HourlyDetails(
              timeStamp: timeStamp,
              temp: weatherDataHourly.getHourlyByDt(desiredTimestamp)!.temp!,
              weatherIcon: weatherDataHourly
                  .getHourlyByDt(desiredTimestamp)!
                  .weather![0]
                  .icon!,
              feelsLike:
                  weatherDataHourly.getHourlyByDt(desiredTimestamp)!.feelsLike!,
              pressure:
                  weatherDataHourly.getHourlyByDt(desiredTimestamp)!.pressure!,
              humidity:
                  weatherDataHourly.getHourlyByDt(desiredTimestamp)!.humidity!,
              dewPoint:
                  weatherDataHourly.getHourlyByDt(desiredTimestamp)!.dewPoint!,
              uvi: weatherDataHourly.getHourlyByDt(desiredTimestamp)!.uvi!,
              clouds:
                  weatherDataHourly.getHourlyByDt(desiredTimestamp)!.clouds!,
              visibility: weatherDataHourly
                  .getHourlyByDt(desiredTimestamp)!
                  .visibility!,
              windSpeed:
                  weatherDataHourly.getHourlyByDt(desiredTimestamp)!.windSpeed!,
              windDeg:
                  weatherDataHourly.getHourlyByDt(desiredTimestamp)!.windDeg!,
              windGust:
                  weatherDataHourly.getHourlyByDt(desiredTimestamp)!.windGust!,
              description: weatherDataHourly
                  .getHourlyByDt(desiredTimestamp)!
                  .weather![0]
                  .description!,
              // null value for pop
              pop: 3,
              //
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              // "$timeStamp",
              // "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, "0")} ${timeFormat}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 150,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  NumberPicker(
                    minValue: 0,
                    maxValue: 12,
                    value: hour,
                    zeroPad: true,
                    infiniteLoop: true,
                    itemWidth: 50,
                    itemHeight: 50,
                    onChanged: (value) {
                      setState(() {
                        hour = value;
                        timeStamp = getTimeStamp();
                        time = getTime(timeStamp);
                      });
                    },
                    textStyle:
                        const TextStyle(color: Colors.grey, fontSize: 20),
                    selectedTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 30),
                    decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(
                            color: Colors.white,
                          ),
                          bottom: BorderSide(color: Colors.white)),
                    ),
                  ),
                  NumberPicker(
                    minValue: 0,
                    maxValue: 59,
                    value: minute,
                    zeroPad: true,
                    infiniteLoop: true,
                    itemWidth: 50,
                    itemHeight: 50,
                    onChanged: (value) {
                      setState(() {
                        minute = value;
                        timeStamp = getTimeStamp();
                        time = getTime(timeStamp);
                      });
                    },
                    textStyle:
                        const TextStyle(color: Colors.grey, fontSize: 20),
                    selectedTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 30),
                    decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(
                            color: Colors.white,
                          ),
                          bottom: BorderSide(color: Colors.white)),
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            timeFormat = "AM";
                            timeStamp = getTimeStamp();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: timeFormat == "AM"
                                ? Colors.grey.shade800
                                : Colors.grey.shade700,
                            border: Border.all(
                              color: timeFormat == "AM"
                                  ? Colors.grey
                                  : Colors.grey.shade700,
                            ),
                          ),
                          child: const Text(
                            "AM",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            timeFormat = "PM";
                            timeStamp = getTimeStamp();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: timeFormat == "PM"
                                ? Colors.grey.shade800
                                : Colors.grey.shade700,
                            border: Border.all(
                              color: timeFormat == "PM"
                                  ? Colors.grey
                                  : Colors.grey.shade700,
                            ),
                          ),
                          child: const Text(
                            "PM",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Text("Damn thing is null and timeStamp: $timeStamp"),
          ],
        ),
      );
    }
  }
}

class HourlyDetails extends StatelessWidget {
  int timeStamp;
  int temp;
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
        Row(
          children: [
            WeatherInfoWidget(
                weatherIcon: weatherIcon, description: description),
            TemperatureGauge(temp: temp, feelsLike: feelsLike),
          ],
        ),
        Row(
          children: [
            UVIRadialGauge(uvi: uvi),
            UVIRadialGauge(uvi: uvi),
          ],
        ),
        Row(
          children: [
            WindSpeed(windSpeed: windSpeed),
            HumidityMeter(humidity: humidity),
          ],
        )

        // this is for AQI
      ],
    );
  }

  Widget buildAttributeText(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: RichText(
        text: TextSpan(
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

class TemperatureGauge extends StatelessWidget {
  final int temp;
  final double feelsLike;

  TemperatureGauge({required this.temp, required this.feelsLike});

  @override
  Widget build(BuildContext context) {
    double halfScreenWidth = (MediaQuery.of(context).size.width / 2) - 10;
    return Container(
      height: 225,
      width: halfScreenWidth,
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: CustomColors.dividerLine.withAlpha(150),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildTemperatureLinearGauge('Temperature', temp.toDouble()),
          ),
          Expanded(
            child: _buildTemperatureLinearGauge('Feels Like', feelsLike),
          )
        ],
      ),
    );
  }

  Widget _buildTemperatureLinearGauge(String title, double value) {
    return Column(
      children: [
        Text(
          '$value °C',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 150,
          width: 150,
          child: FittedBox(
            child: SfLinearGauge(
              minimum: -25,
              maximum: 50,
              orientation: LinearGaugeOrientation.vertical,
              ranges: const [
                LinearGaugeRange(
                  startValue: -25,
                  endValue: 50,
                  color: Colors.blue,
                ),
              ],
              barPointers: [
                LinearBarPointer(
                  value: value,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        ),
      ],
    );
  }
}

class UVIRadialGauge extends StatelessWidget {
  final double uvi;
  const UVIRadialGauge({Key? key, required this.uvi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double halfScreenWidth = (MediaQuery.of(context).size.width / 2) - 10;
    return Container(
      height: 200,
      width: halfScreenWidth,
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: CustomColors.dividerLine.withAlpha(150),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          _UVIRadialGauge(uvi),
          const Positioned(
            top: 5, // Adjust the top value as needed
            left: 50, // Adjust the left value as needed
            child: Text(
              'UV Index',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _UVIRadialGauge(double uvi) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          radiusFactor: 0.8,
          startAngle: 150,
          endAngle: 30,
          minimum: 0,
          maximum: 14,
          canScaleToFit: true,
          axisLineStyle: const AxisLineStyle(
              thickness: 10, thicknessUnit: GaugeSizeUnit.logicalPixel),
          pointers: <GaugePointer>[
            NeedlePointer(
              value: uvi,
              // Set the UV index value here
              needleColor: Colors.black,
              needleLength: 0.8,
              needleStartWidth: 0.5,
              needleEndWidth: 5,
              knobStyle: const KnobStyle(
                knobRadius: 0.1,
                sizeUnit: GaugeSizeUnit.factor,
                color: Colors.black,
              ),
            ),
          ],
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 2.5,
              color: Colors.green,
            ),
            GaugeRange(
              startValue: 2.5,
              endValue: 5.5,
              color: Colors.yellow,
            ),
            GaugeRange(
              startValue: 5.5,
              endValue: 8.5,
              color: Colors.orange,
            ),
            GaugeRange(
              startValue: 8.5,
              endValue: 11.5,
              color: Colors.red,
            ),
            GaugeRange(
              startValue: 11.5,
              endValue: 14,
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }
}

class WindSpeed extends StatelessWidget {
  final double windSpeed;

  const WindSpeed({
    Key? key,
    required this.windSpeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double halfScreenWidth = (MediaQuery.of(context).size.width / 2) - 10;

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
            ),
            const SizedBox(height: 10),
            Image.asset(
              'assets/icons/wind.png', // Replace with your image asset path
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 10),
            Text(
              "$windSpeed km/h", // Replace with your wind speed data
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ));
  }
}

class HumidityMeter extends StatelessWidget {
  final int humidity;
  const HumidityMeter({Key? key, required this.humidity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double halfScreenWidth = (MediaQuery.of(context).size.width / 2) - 10;

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SleekCircularSlider(
                  min: 0,
                  max: 100,
                  initialValue: humidity.toDouble(),
                  appearance: CircularSliderAppearance(
                      customWidths: CustomSliderWidths(
                          handlerSize: 0, trackWidth: 12, progressBarWidth: 12),
                      infoProperties: InfoProperties(
                        bottomLabelText: "Humidity",
                        bottomLabelStyle: const TextStyle(
                            letterSpacing: 0.1, fontSize: 14, height: 1.5),
                      ),
                      animationEnabled: true,
                      size: 140,
                      customColors: CustomSliderColors(
                          hideShadow: true,
                          trackColor:
                              CustomColors.firstGradientColor.withAlpha(100),
                          progressBarColors: [
                            CustomColors.firstGradientColor,
                            CustomColors.secondGradientColor
                          ]))),
            ),
          ],
        ),
      ),
    ));
  }
}
