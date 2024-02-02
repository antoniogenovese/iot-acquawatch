import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class HardChart extends StatelessWidget {
  final int hardness;

  const HardChart({Key? key, required this.hardness});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
            child: Column(
              children: [
                StepProgressIndicator(
                  totalSteps: 15,
                  currentStep: hardness.toInt(),
                  customSize: (index, _) => (index + 10) * 2.0,
                  padding: 2,
                  size: 15,
                  roundedEdges: Radius.circular(10),
                  selectedGradientColor: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.yellowAccent, Colors.deepOrange],
                  ),
                  unselectedGradientColor: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.black, Colors.blue],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Hardness: " + hardness.toString()+" °d",
                  style: TextStyle(
                      fontSize: 25,
                      color: hardness < 3 || hardness > 8
                          ? Colors.red
                          : Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
