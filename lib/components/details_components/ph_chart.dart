import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PhChart extends StatelessWidget {
  final int ph;

  const PhChart({Key? key, required this.ph});

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> paiChartSelectionData = [
      ph == 0
          ? PieChartSectionData(
              color: Color.fromRGBO(255, 0, 0, 1),
              radius: 37,
              showTitle: false,
            )
          : PieChartSectionData(
              color: Color.fromRGBO(255, 0, 0, 1),
              showTitle: false,
              radius: 29,
            ),
      ph == 1
          ? PieChartSectionData(
              color: Color.fromRGBO(253, 83, 27, 1.0),
              showTitle: false,
              radius: 37,
            )
          : PieChartSectionData(
              color: Color.fromRGBO(253, 83, 27, 1.0),
              showTitle: false,
              radius: 29,
            ),
      ph == 2
          ? PieChartSectionData(
              color: Color.fromRGBO(255, 127, 0, 1),
              showTitle: false,
              radius: 37,
            )
          : PieChartSectionData(
              color: Color.fromRGBO(255, 127, 0, 1),
              showTitle: false,
              radius: 29,
            ),
      ph == 3
          ? PieChartSectionData(
              color: Color.fromRGBO(252, 164, 1, 1.0),
              showTitle: false,
              radius: 37,
            )
          : PieChartSectionData(
              color: Color.fromRGBO(252, 164, 1, 1.0),
              showTitle: false,
              radius: 29,
            ),
      ph == 4
          ? PieChartSectionData(
              color: Color.fromRGBO(252, 204, 2, 1.0),
              showTitle: false,
              radius: 37,
            )
          : PieChartSectionData(
              color: Color.fromRGBO(252, 204, 2, 1.0),
              showTitle: false,
              radius: 29,
            ),
      ph == 5
          ? PieChartSectionData(
              color: Color.fromRGBO(218, 223, 1, 1.0),
              showTitle: false,
              radius: 37,
            )
          : PieChartSectionData(
              color: Color.fromRGBO(218, 223, 1, 1.0),
              showTitle: false,
              radius: 29,
            ),
      ph == 6
          ? PieChartSectionData(
              color: Color.fromRGBO(110, 215, 1, 1.0),
              showTitle: false,
              radius: 37,
            )
          : PieChartSectionData(
              color: Color.fromRGBO(110, 215, 1, 1.0),
              showTitle: false,
              radius: 29,
            ),
      ph == 7
          ? PieChartSectionData(
              color: Color.fromRGBO(0, 181, 2, 1.0),
              showTitle: false,
              radius: 37,
            )
          : PieChartSectionData(
              color: Color.fromRGBO(0, 181, 2, 1.0),
              showTitle: false,
              radius: 29,
            ),
      ph == 8
          ? PieChartSectionData(
              color: Color.fromRGBO(0, 156, 1, 1.0),
              showTitle: false,
              radius: 37,
            )
          : PieChartSectionData(
              color: Color.fromRGBO(0, 156, 1, 1.0),
              showTitle: false,
              radius: 29,
            ),
      ph == 9
          ? PieChartSectionData(
              color: Color.fromRGBO(1, 191, 183, 1.0),
              showTitle: false,
              radius: 37,
            )
          : PieChartSectionData(
              color: Color.fromRGBO(1, 191, 183, 1.0),
              showTitle: false,
              radius: 29,
            ),
      ph == 10
          ? PieChartSectionData(
              color: Color.fromRGBO(0, 136, 201, 1.0),
              showTitle: false,
              radius: 37,
            )
          : PieChartSectionData(
              color: Color.fromRGBO(0, 136, 201, 1.0),
              showTitle: false,
              radius: 29,
            ),
      ph == 11
          ? PieChartSectionData(
              color: Color.fromRGBO(1, 76, 200, 1.0),
              showTitle: false,
              radius: 37,
            )
          : PieChartSectionData(
              color: Color.fromRGBO(1, 76, 200, 1.0),
              showTitle: false,
              radius: 29,
            ),
      ph == 12
          ? PieChartSectionData(
              color: Color.fromRGBO(51, 33, 184, 1.0),
              showTitle: false,
              radius: 37,
            )
          : PieChartSectionData(
              color: Color.fromRGBO(51, 33, 184, 1.0),
              showTitle: false,
              radius: 29,
            ),
      ph == 13
          ? PieChartSectionData(
              color: Color.fromRGBO(73, 12, 166, 1.0),
              showTitle: false,
              radius: 37,
            )
          : PieChartSectionData(
              color: Color.fromRGBO(73, 12, 166, 1.0),
              showTitle: false,
              radius: 29,
            ),
      ph == 14
          ? PieChartSectionData(
              color: Color.fromRGBO(62, 8, 143, 1.0),
              radius: 37,
            )
          : PieChartSectionData(
              color: Color.fromRGBO(62, 8, 143, 1.0),
              radius: 29,
            ),
    ];

    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 100,
              startDegreeOffset: -90,
              sections: paiChartSelectionData,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      this.ph.toString(),
                      style: TextStyle(
                          color: ph < 7 || ph > 8 ? Colors.red : Colors.white,
                          fontSize: 60),
                    ),
                    Text(
                      "ph",
                      style: TextStyle(
                          color: ph < 7 || ph > 8 ? Colors.red : Colors.white,
                          fontSize: 30),
                    )
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
