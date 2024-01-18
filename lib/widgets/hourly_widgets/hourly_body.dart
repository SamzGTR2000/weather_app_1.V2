import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:weather_app_1/model/weather_data_hourly.dart';
import 'package:weather_app_1/utils/costum_colors.dart';

class hourlyBody extends StatefulWidget {
  final WeatherDataHourly weatherDataHourly;

  const hourlyBody({Key? key, required this.weatherDataHourly})
      : super(key: key);

  @override
  State<hourlyBody> createState() =>
      _hourlyBodyState(weatherDataHourly: weatherDataHourly);
}

class _hourlyBodyState extends State<hourlyBody> {
  final WeatherDataHourly weatherDataHourly;
  int selectedTimeStmap = 0;
  var hour = 0;
  var minute = 0;
  var timeFormat = "";
  int timeStamp = 0;
  _hourlyBodyState({required this.weatherDataHourly});
  @override
  Widget build(BuildContext context) {
    int getTimeStamp(int hour, int minute, String timeFormat) {
      DateTime dateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        hour + (timeFormat == "PM" ? 12 : 0), // Adjust hour for PM
        minute,
      );

      return dateTime.millisecondsSinceEpoch ~/ 1000;
    }

    int timeStamp = getTimeStamp(hour, minute, timeFormat);

    int getClosestSmallerTimestamp(
        List<int> timestampList, int targetTimestamp) {
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

    int findClosestElement(List<int> listOfDts, int currentDt) {
      if (listOfDts.isEmpty) {
        throw ArgumentError('List of timestamps is empty.');
      }

      // Sort the list of timestamps
      listOfDts.sort();

      // Find the index of the closest element using binary search
      int low = 0;
      int high = listOfDts.length - 1;
      int closestIndex = 0;

      while (low <= high) {
        int mid = (low + high) ~/ 2;
        int midValue = listOfDts[mid];

        if (midValue == currentDt) {
          // If the currentDt is found in the list, return it
          return midValue;
        } else if (midValue < currentDt) {
          low = mid + 1;
        } else {
          high = mid - 1;
        }

        // Update closestIndex based on the difference between currentDt and midValue
        if ((listOfDts[mid] - currentDt).abs() <
            (listOfDts[closestIndex] - currentDt).abs()) {
          closestIndex = mid;
        }
      }

      return listOfDts[closestIndex];
    }

    List<int> dts = weatherDataHourly.getHourlyDts();
    if (dts != null) {
      print("List : $dts");
    }
    if (timeStamp != null) {
      print("timeStamp: $timeStamp");
    }
    int? desiredTimestamp = findClosestElement(dts, timeStamp);

    if (desiredTimestamp != null) {
      print("desired dt: $desiredTimestamp");
    }

    return Column(
      children: [
        // Row 1
        Row(
          children: [
            // First column of Row 1
            Expanded(
              child: Column(
                children: [
                  // First row of the first column
                  Container(
                      height: 140,
                      width: 200,
                      child: TimePicker(
                        weatherDataHourly: weatherDataHourly,
                        onHourChanged: (value) {
                          setState(() {
                            hour = value;
                          });
                        },
                        onMinuteChanged: (value) {
                          setState(() {
                            minute = value;
                          });
                        },
                        onTimeFormatChanged: (value) {
                          setState(() {
                            timeFormat = value;
                          });
                        },
                      )),
                  // Second row of the first column
                  Container(
                      height: 120,
                      child: WeatherInfoWidget(
                          weatherIcon: weatherDataHourly
                              .getHourlyByDt(desiredTimestamp)!
                              .weather![0]
                              .icon!,
                          description: weatherDataHourly
                              .getHourlyByDt(desiredTimestamp)!
                              .weather![0]
                              .description!)),
                ],
              ),
            ),
            // Second column of Row 1
            Expanded(
              child: Container(
                  height: 250,
                  child: TemperatureGauge(
                      temp: weatherDataHourly
                          .getHourlyByDt(desiredTimestamp)!
                          .temp!,
                      feelsLike: weatherDataHourly
                          .getHourlyByDt(desiredTimestamp)!
                          .feelsLike!)),
            ),
          ],
        ),
        // Row 2
        Row(
          children: [
            // First column of Row 2
            Expanded(
              child: Container(
                  height: 200,
                  child: HumidityMeter(
                      humidity: weatherDataHourly
                          .getHourlyByDt(desiredTimestamp)!
                          .humidity!)),
            ),
            // Second column of Row 2

            Expanded(
              child: Container(
                  height: 200,
                  child: WindSpeed(
                      windSpeed: weatherDataHourly
                          .getHourlyByDt(desiredTimestamp)!
                          .windSpeed!)),
            ),
          ],
        ),
        // Row 3
        Row(
          children: [
            // First column of Row 3
            Expanded(
              child: Container(height: 200, child: UVIRadialGauge(uvi: 3)),
            ),
            Expanded(
              child: Container(
                  height: 200,
                  child: AqiRadialGauge(
                      uvi: weatherDataHourly
                          .getHourlyByDt(desiredTimestamp)!
                          .uvi!)),
            ),
            // Second column of Row 3
          ],
        ),
      ],
    );
  }
}

class TimePicker extends StatefulWidget {
  final void Function(int) onHourChanged;
  final void Function(int) onMinuteChanged;
  final void Function(String) onTimeFormatChanged;
  final WeatherDataHourly weatherDataHourly;
  const TimePicker(
      {super.key,
      required this.weatherDataHourly,
      required this.onHourChanged,
      required this.onMinuteChanged,
      required this.onTimeFormatChanged});

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
  int timeStamp = 0;
  late String time = '';

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
    int getTimeStamp(int hour, int minute, String timeFormat) {
      DateTime dateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        hour + (timeFormat == "PM" ? 12 : 0), // Adjust hour for PM
        minute,
      );

      return dateTime.millisecondsSinceEpoch ~/ 1000;
    }

    int timeStamp = getTimeStamp(hour, minute, timeFormat);

    // if (timeStamp != null) {
    //   print(timeStamp);
    // }

    int timeStamp1 = 1705385400;
    List<int> dts = weatherDataHourly.getHourlyDts();
    int? desiredTimestamp = getClosestSmallerTimestamp(dts, timeStamp);
    Hourly? hourlyData = weatherDataHourly.getHourlyByDt(desiredTimestamp!);

    if (dts != null) {
      // print(dts);
    }

    // if (hour != null && minute != null && timeFormat != null) {
    //   print("hour is $hour : $minute $timeFormat");
    // }

    if (desiredTimestamp != null) {
      // print("Desired timestamp is $desiredTimestamp");
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                NumberPicker(
                  minValue: 0,
                  maxValue: 12,
                  value: hour,
                  zeroPad: true,
                  infiniteLoop: true,
                  itemWidth: 40,
                  itemHeight: 40,
                  onChanged: (value) {
                    setState(() {
                      hour = value;
                      widget.onHourChanged(hour);
                    });
                  },
                  textStyle: const TextStyle(fontSize: 18),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 120,
                  width: 1,
                  color: CustomColors.dividerLine,
                ),
                SizedBox(
                  width: 10,
                ),
                NumberPicker(
                  minValue: 0,
                  maxValue: 59,
                  value: minute,
                  zeroPad: true,
                  infiniteLoop: true,
                  itemWidth: 40,
                  itemHeight: 40,
                  onChanged: (value) {
                    setState(() {
                      minute = value;
                      widget.onMinuteChanged(minute);
                    });
                  },
                  textStyle: const TextStyle(fontSize: 18),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 120,
                  width: 1,
                  color: CustomColors.dividerLine,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          timeFormat = "AM";
                          widget.onTimeFormatChanged(timeFormat);
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
                          style: TextStyle(fontSize: 15),
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
                          widget.onTimeFormatChanged(timeFormat);
                          // timeStamp = getTimeStamp();
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
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
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
            SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/icons/wind.png', // Replace with your image asset path
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 10),
            Text(
              "$windSpeed km/h", // Replace with your wind speed data
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    ));
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
        child: Column(
          children: [
            const Text(
              "Temperature",
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
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildTemperatureLinearGauge(
                      'Temperature', temp.toDouble()),
                ),
                Expanded(
                  child: _buildTemperatureLinearGauge('Feels Like', feelsLike),
                )
              ],
            ),
          ],
        ));
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
      child: Column(
        children: [
          const Text(
            "UV Index",
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
          Container(
            height: 150,
            width: 180,
            child: _UVIRadialGauge(uvi),
          )
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

class AqiRadialGauge extends StatelessWidget {
  final double uvi;
  const AqiRadialGauge({Key? key, required this.uvi}) : super(key: key);

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
      child: Column(
        children: [
          const Text(
            "Air Quality Index",
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
          Container(
            height: 150,
            width: 180,
            child: _AqiRadialGauge(uvi),
          )
        ],
      ),
    );
  }

  Widget _AqiRadialGauge(double uvi) {
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
