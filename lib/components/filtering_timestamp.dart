import 'package:flutter/material.dart';

class Filtering extends StatelessWidget {
  final List<dynamic> filtering;

  const Filtering({Key? key, required this.filtering}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> filter = filtering.isEmpty ? [] : filtering;
    return Container(
      width: 300,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columns: [
                DataColumn(
                  label:
                      Text("Filtering Water", style: TextStyle(fontSize: 25)),
                ),
              ],
              rows: List.generate(
                filter.length,
                (index) => DataRow(cells: [
                  DataCell(Text(filter.reversed.toList()[index].toString(),
                      style: TextStyle(fontSize: 20))),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
