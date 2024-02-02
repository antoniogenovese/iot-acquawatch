import 'package:flutter/material.dart';

class Interchange extends StatelessWidget {
  final List<dynamic> interchange;

  const Interchange({Key? key, required this.interchange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> inter = interchange.isEmpty ? [] : interchange;
    return Container(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columns: [
                DataColumn(
                  label:
                      Text("Interchange Water", style: TextStyle(fontSize: 25)),
                ),
              ],
              rows: List.generate(
                inter.length,
                (index) => DataRow(cells: [
                  DataCell(Text(inter.reversed.toList()[index].toString(),
                      style: TextStyle(fontSize: 20))),
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
