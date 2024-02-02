import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class TempChart extends StatelessWidget {
  final double temperature;

  const TempChart({Key? key, required this.temperature});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Positioned.fill(
            child: SleekCircularSlider(
              max: 40,
              appearance: CircularSliderAppearance(
                size: 250,
                startAngle: 180,
                angleRange: 180,
                customColors: CustomSliderColors(
                    progressBarColors: [Colors.blue, Colors.black],
                    trackColor: temperature < 23 || temperature > 26
                        ? Colors.red
                        : Colors.white,
                    shadowColor: Colors.white),
                infoProperties: InfoProperties(
                    mainLabelStyle: TextStyle(
                        fontSize: 50,
                        color: temperature < 23 || temperature > 26
                            ? Colors.red
                            : Colors.white),
                    modifier: (double value) {
                      final roundedValue = value.toStringAsFixed(1);
                      return '$roundedValue °C';
                    },
                    bottomLabelStyle: TextStyle(
                        color: temperature < 23 || temperature > 26
                            ? Colors.red
                            : Colors.white,
                        fontSize: 25),
                    bottomLabelText: "Temperature"),
              ),
              initialValue: temperature,
            ),
          ),
        ],
      ),
    );
  }
}
