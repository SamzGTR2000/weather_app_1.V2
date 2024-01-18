import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:weather_app_1/model/weather_data_daily.dart';
import 'package:weather_app_1/utils/costum_colors.dart';

class DailyBody extends StatefulWidget {
  final WeatherDataDaily weatherDataDaily;
  const DailyBody({Key? key, required this.weatherDataDaily}) : super(key: key);
  @override
  _DailyBodyState createState() =>
      _DailyBodyState(weatherDataDaily: weatherDataDaily);
}

class _DailyBodyState extends State<DailyBody> {
  final WeatherDataDaily weatherDataDaily;
  int selectedDate = 1;
  int selectedTimeStamp = 1705435200;
  _DailyBodyState({required this.weatherDataDaily});
  @override
  Widget build(BuildContext context) {
    List<int> getDates(List<int> timestamps) {
      return timestamps.map((timestamp) {
        final DateTime dateTime =
            DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        return dateTime.day;
      }).toList();
    }

    List<String> getMonths(List<int> timestamps) {
      return timestamps.map((timestamp) {
        final DateTime dateTime =
            DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        return DateFormat('MMM').format(dateTime);
      }).toList();
    }

    List<int> dts = weatherDataDaily.getDailyDts();

    int closestDt = weatherDataDaily.findClosestElement(dts, selectedTimeStamp);

    List<int?> tempListn = weatherDataDaily.getMaxList();
    List<int> tempList =
        tempListn.where((element) => element != null).map((e) => e!).toList();

    List<double> rainList = weatherDataDaily.getDailyRain();

    List<int> dateList = getDates(dts);
    List<String> monthList = getMonths(dts);

    // double? windSpeedn = weatherDataDaily.getWindSpeedForDt(closestDt);
    // if (windSpeedn != null) {
    //   print(windSpeedn);
    // }

    double windSpeed = weatherDataDaily.getWindSpeedForDt(closestDt) ?? 0.0;
    int humidity = weatherDataDaily.getHumidityForDt(closestDt) ?? 0;

    return Container(
      child: Column(
        children: [
          // First Row with Two Columns of Same Size
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 150,
                  child: WeatherInfoWidget(
                    weatherIcon: weatherDataDaily
                        .getDailyByDt(closestDt)!
                        .weather![0]
                        .icon!,
                    description: weatherDataDaily
                        .getDailyByDt(closestDt)!
                        .weather![0]
                        .description!,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 150,
                  child: DatePicker(
                    weatherDataDaily: weatherDataDaily,
                    onDateChanged: (value) {
                      setState(() {
                        selectedTimeStamp = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          // Second Row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 200,
                  child: WindSpeedRadialGauge(windSpeed: windSpeed),
                ),
              ),
              Expanded(
                child: Container(
                  height: 200,
                  child: HumidityComfortLevel(humidity: humidity),
                ),
              ),
            ],
          ),
          // Third Row
          Row(
            children: [
              Expanded(
                child: Container(
                    height: 320,
                    child: RainGaugeList(
                      rains: rainList,
                      dates: dateList,
                      months: monthList,
                    )),
              ),
            ],
          ),
          // Fourth Row
          Row(
            children: [
              Expanded(
                child: Container(
                    height: 320,
                    child: TemperatureGaugeList(
                      temperatures: tempList,
                      dates: dateList,
                      months: monthList,
                    )),
              ),
            ],
          ),
        ],
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

class DatePicker extends StatefulWidget {
  final WeatherDataDaily weatherDataDaily;
  final void Function(int) onDateChanged;
  DatePicker(
      {super.key, required this.weatherDataDaily, required this.onDateChanged});
  @override
  _DatePickerState createState() =>
      _DatePickerState(weatherDataDaily: weatherDataDaily);
}

class _DatePickerState extends State<DatePicker> {
  final WeatherDataDaily weatherDataDaily;
  _DatePickerState({required this.weatherDataDaily});

  int date = 1;
  int month = 1;
  int year = 2024;
  int timeStamp = 0;

  @override
  Widget build(BuildContext context) {
    int getTimeStamp() {
      DateTime selectedDate = DateTime(year, month, date);
      return selectedDate.millisecondsSinceEpoch ~/ 1000; // Convert to seconds
    }

    int timeStamp = getTimeStamp();
    if (timeStamp != null) {
      print(timeStamp);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          DateFormat('MMM, yyyy').format(DateTime(year, month, date)),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 1,
          width: 120,
          color: CustomColors.dividerLine,
        ),
        NumberPicker(
          value: date,
          minValue: 1,
          maxValue: 31,
          onChanged: (value) {
            setState(() {
              date = value;
              timeStamp = getTimeStamp();
              widget.onDateChanged(timeStamp);
            });
          },
          axis: Axis.horizontal,
          itemWidth: 50.0,
          textStyle: const TextStyle(fontSize: 18),
        ),
        Container(
          height: 1,
          width: 120,
          color: CustomColors.dividerLine,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          DateFormat('EEE').format(DateTime(year, month, date)),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class TemperatureGauge extends StatelessWidget {
  final int temp;
  final int date;
  final String month;

  TemperatureGauge(
      {required this.temp, required this.date, required this.month});

  @override
  Widget build(BuildContext context) {
    double halfScreenWidth = (MediaQuery.of(context).size.width / 2) - 10;
    return Container(
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
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildTemperatureLinearGauge('Temperature', temp.toDouble()),
          ),
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
          "$date th of $month",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        ),
      ],
    );
  }
}

class TemperatureGaugeList extends StatelessWidget {
  final List<int> temperatures;
  final List<int> dates;
  final List<String> months;

  const TemperatureGaugeList(
      {required this.temperatures, required this.dates, required this.months});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: CustomColors.dividerLine.withAlpha(150),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Image.asset(
                  'assets/icons/temperature.png',
                  width: 18,
                  height: 18,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: const Text(
                  "Temperature",
                  style: TextStyle(
                    color: CustomColors.textColorBlack,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 1,
            width: 400,
            color: CustomColors.dividerLine,
          ),
          SizedBox(
            height: 15,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: temperatures.asMap().entries.map((entry) {
                final int index = entry.key;
                final int temp = entry.value;
                final int date = dates[index];
                final String month = months[index];

                return TemperatureGauge(
                  temp: temp,
                  date: date,
                  month: month,
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class RainGauge extends StatelessWidget {
  final double rain;
  final int date;
  final String month;

  RainGauge({required this.rain, required this.date, required this.month});

  @override
  Widget build(BuildContext context) {
    double halfScreenWidth = (MediaQuery.of(context).size.width / 2) - 10;
    return Container(
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
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildTemperatureLinearGauge("$date", rain),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureLinearGauge(String title, double value) {
    return Column(
      children: [
        Text(
          '$value mm',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 150,
          width: 150,
          child: FittedBox(
            child: SfLinearGauge(
              minimum: 0,
              maximum: 100,
              orientation: LinearGaugeOrientation.vertical,
              ranges: const [
                LinearGaugeRange(
                  startValue: 0,
                  endValue: 100,
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
          "$date th of $month",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        ),
      ],
    );
  }
}

class RainGaugeList extends StatelessWidget {
  final List<double> rains;
  final List<int> dates;
  final List<String> months;

  const RainGaugeList(
      {required this.rains, required this.dates, required this.months});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: CustomColors.dividerLine.withAlpha(150),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Image.asset(
                  'assets/icons/rain.png',
                  width: 18,
                  height: 18,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: const Text(
                  "Precipitation",
                  style: TextStyle(
                    color: CustomColors.textColorBlack,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 1,
            width: 400,
            color: CustomColors.dividerLine,
          ),
          SizedBox(
            height: 15,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: rains.asMap().entries.map((entry) {
                final int index = entry.key;
                final double rain = entry.value;
                final int date = dates[index];
                final String month = months[index];

                return RainGauge(
                  rain: rain,
                  date: date,
                  month: month,
                );
              }).toList(),
              // children: rains.map((rain) {
              //   return RainGauge(
              //     rain: rain,
              //     date:
              //   );
              // }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class WindSpeedRadialGauge extends StatelessWidget {
  final double windSpeed;
  const WindSpeedRadialGauge({Key? key, required this.windSpeed})
      : super(key: key);

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
            // SFRadialGauge(weatherDataCurrent: weatherDataCurrent),
            Container(
              height: 150,
              width: 180,
              child: _WindSpeedRadialGauge(
                windSpeed: windSpeed,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _WindSpeedRadialGauge extends StatelessWidget {
  const _WindSpeedRadialGauge({
    super.key,
    required this.windSpeed,
  });

  final double windSpeed;

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minorTicksPerInterval:
              4, // Set the number of major ticks per interval

          radiusFactor: 0.8,
          startAngle: 150,
          endAngle: 30,
          minimum: 0,
          maximum: 50,
          canScaleToFit: true,
          axisLineStyle: const AxisLineStyle(
              thickness: 2,
              thicknessUnit: GaugeSizeUnit.logicalPixel,
              color: Colors.black),
          pointers: <GaugePointer>[
            NeedlePointer(
              value: windSpeed, // Set the UV index value here
              needleColor: Colors.black,
              needleLength: 0.8,
              needleStartWidth: 0.5,
              needleEndWidth: 3,
              knobStyle: const KnobStyle(
                knobRadius: 0.1,
                sizeUnit: GaugeSizeUnit.factor,
                color: Colors.black,
              ),
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Container(
                child: const Text(
                  'km/h',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent),
                ),
              ),
              angle: 90,
              positionFactor: 0.5,
            ),
          ],
        ),
      ],
    );
  }
}

class HumidityComfortLevel extends StatelessWidget {
  final int humidity;
  const HumidityComfortLevel({Key? key, required this.humidity})
      : super(key: key);

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
