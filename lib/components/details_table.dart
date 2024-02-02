import 'package:flutter/material.dart';
import '../../constants.dart';

class DetailsTable extends StatelessWidget {
  final List<dynamic> ph;
  final List<dynamic> temperature;
  final List<dynamic> hardness;
  final List<dynamic> timestamp;

  const DetailsTable(
      {Key? key,
      required this.ph,
      required this.temperature,
      required this.hardness,
      required this.timestamp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> new_ph = ph.isEmpty ? [] : ph;
    List<dynamic> new_temperature = temperature.isEmpty ? [] : temperature;
    List<dynamic> new_hardness = hardness.isEmpty ? [] : hardness;
    List<dynamic> new_timestamp = timestamp.isEmpty ? [] : timestamp;
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 15),
            child: Text(
              "RECENT DETAILS",
              style: TextStyle(fontSize: 35),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: [
                DataColumn(
                  label: Text("Timestamp", style: TextStyle(fontSize: 25)),
                ),
                DataColumn(
                  label: Text("Ph", style: TextStyle(fontSize: 25)),
                ),
                DataColumn(
                  label: Text("Temperature", style: TextStyle(fontSize: 25)),
                ),
                DataColumn(
                  label: Text("Hardness", style: TextStyle(fontSize: 25)),
                ),
              ],
              rows: List.generate(
                new_ph.length,
                (index) => DataRow(
                  cells: [
                    DataCell(Text(
                        new_timestamp.reversed.toList()[index].toString(),
                        style: TextStyle(fontSize: 20))),
                    DataCell(Text(new_ph.reversed.toList()[index].toString(),
                        style: TextStyle(fontSize: 20))),
                    DataCell(Text(
                        new_temperature.reversed.toList()[index].toString(),
                        style: TextStyle(fontSize: 20))),
                    DataCell(Text(
                        new_hardness.reversed.toList()[index].toString(),
                        style: TextStyle(fontSize: 20)))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
