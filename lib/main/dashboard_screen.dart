import 'package:admin/components/timer.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:admin/components/interchange_timestamp.dart';
import 'package:admin/components//details_table.dart';
import 'package:admin/components/filtering_timestamp.dart';
import 'package:admin/components/details_components.dart';
import 'package:http/http.dart' as http;
import 'package:admin/config.dart';

class DashboardScreen extends StatelessWidget {
  final List<dynamic> returnList;
  final VoidCallback updatePage;

  const DashboardScreen(
      {Key? key, required this.returnList, required this.updatePage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> makeApiCall() async {
      String apiUrl = api_gateway;

      try {
        await http.post(Uri.parse(apiUrl),
            headers: {"Content-Type": "application/json"});
        await Future.delayed(Duration(seconds: 5));
        updatePage();
      } catch (error) {
        print('Error API: $error');
      }
    }

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Text(
              "ACQUAWATCH",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "RECYCLING SYSTEM",
                              style: TextStyle(fontSize: 35),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Interchange(interchange: returnList[4]),
                                SizedBox(width: 100),
                                Container(
                                  height: 300,
                                  child: Column(
                                    children: [
                                      Timer(
                                          cron: returnList[6],
                                          updatePage: updatePage),
                                      ElevatedButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.black38,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: defaultPadding * 1.5,
                                            vertical: defaultPadding,
                                          ),
                                        ),
                                        onPressed: () {
                                          makeApiCall();
                                        },
                                        child: Text("Activate system filtering",
                                            style: TextStyle(fontSize: 25)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 100),
                                Filtering(filtering: returnList[5]),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: defaultPadding),
                      DetailsTable(
                          ph: returnList[0],
                          temperature: returnList[1],
                          hardness: returnList[2],
                          timestamp: returnList[3]),
                    ],
                  ),
                ),
                SizedBox(width: defaultPadding),
                Expanded(
                    flex: 2,
                    child: DetailsComponents(
                        ph: returnList[0],
                        temperature: returnList[1],
                        hardness: returnList[2])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
