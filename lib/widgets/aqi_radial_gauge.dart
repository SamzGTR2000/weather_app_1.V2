import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:weather_app_1/model/weather_data_current.dart';
import 'package:weather_app_1/utils/costum_colors.dart';

class AqiRadialGauge extends StatelessWidget {
  final WeatherDataCurrent weatherDataCurrent;
  const AqiRadialGauge({Key? key, required this.weatherDataCurrent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.dividerLine.withAlpha(150),
        borderRadius: BorderRadius.circular(20),
      ),
      child: _RadialGauge(weatherDataCurrent: weatherDataCurrent),
    );
  }
}

class _RadialGauge extends StatelessWidget {
  const _RadialGauge({
    super.key,
    required this.weatherDataCurrent,
  });

  final WeatherDataCurrent weatherDataCurrent;

  @override
  Widget build(BuildContext context) {
    // return AqiSFRadialGauge(weatherDataCurrent: weatherDataCurrent);
    return Center(
      child: SizedBox(
        height: 200,
        child: Column(
          children: [
            const SizedBox(height: 15),
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
            // SFRadialGauge(weatherDataCurrent: weatherDataCurrent),
            Container(
                height: 150,
                width: 180,
                child: AqiSFRadialGauge(weatherDataCurrent: weatherDataCurrent))
          ],
        ),
      ),
    );
  }
}

class AqiSFRadialGauge extends StatelessWidget {
  const AqiSFRadialGauge({
    super.key,
    required this.weatherDataCurrent,
  });

  final WeatherDataCurrent weatherDataCurrent;

  @override
  Widget build(BuildContext context) {
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
              value: weatherDataCurrent.current.uvi!
                  .toDouble(), // Set the UV index value here
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
