import 'package:admin/components/details_components/temp_chart.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:admin/components/details_components/hard_chart.dart';
import 'package:admin/components/details_components/ph_chart.dart';

class DetailsComponents extends StatelessWidget {
  final List<dynamic> ph;
  final List<dynamic> temperature;
  final List<dynamic> hardness;

  const DetailsComponents(
      {Key? key,
      required this.ph,
      required this.temperature,
      required this.hardness})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int last_ph = ph.isEmpty ? 0 : ph.last.toInt();
    double last_temperature =
        temperature.isEmpty ? 0 : temperature.last.toDouble();
    int last_hardness = hardness.isEmpty ? 0 : hardness.last.toInt();
    return Container(
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "WATER DETAILS",
                style: TextStyle(fontSize: 35),
              ),
            ),
            PhChart(ph: last_ph),
            SizedBox(height: 40),
            TempChart(temperature: last_temperature),
            HardChart(hardness: last_hardness),
          ],
        ));
  }
}
