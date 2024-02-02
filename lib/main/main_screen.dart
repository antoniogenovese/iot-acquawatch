import 'package:admin/main/dashboard_screen.dart';
import 'package:aws_client/dynamo_document.dart';
import 'package:flutter/material.dart';
import 'package:admin/config.dart';

const String details_table_name = "Details";
const String timestamp_table_name = "Timestamp";

class MainScreen extends StatefulWidget {
  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  void _updatePage() {
    setState(() {});
  }

  Future<List<dynamic>> getDataFromDynamo() async {
    final db = DocumentClient(region: region, endpointUrl: endpointUrl);
    final responseD = await db.get(
      tableName: details_table_name,
      key: {"id": 1},
    );
    final Map<String, dynamic> dataD = responseD.item;

    final List<dynamic> interchange =
        dataD.containsKey('water_timestamp') ? dataD['water_timestamp'] : [];
    final List<dynamic> ph = dataD.containsKey('ph') ? dataD['ph'] : [];
    final List<dynamic> hardness =
        dataD.containsKey('hardness') ? dataD['hardness'] : [];
    final List<dynamic> temperature =
        dataD.containsKey('temperature') ? dataD['temperature'] : [];
    final List<dynamic> timestamp =
        dataD.containsKey('timestamp') ? dataD['timestamp'] : [];
    final String cron = dataD.containsKey('cron_timestamp')
        ? dataD['cron_timestamp']
        : "20 2 * * ? *";

    final responseT = await db.get(
      tableName: timestamp_table_name,
      key: {"id": 1},
    );
    final Map<String, dynamic> dataT = responseT.item;
    final List<dynamic> filtering = dataT['filtering_timestamp'];
    final List<dynamic> returnList = [
      ph,
      temperature,
      hardness,
      timestamp,
      interchange,
      filtering,
      cron
    ];
    print(returnList);
    return returnList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder<List<dynamic>>(
              future: getDataFromDynamo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                strokeWidth: 15,
                                strokeAlign: 5,

                              ),
                              SizedBox(height: 100),
                              Text("Caricamento dati in corso", style: TextStyle(fontSize: 30))
                            ],
                          )),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 5,
                        child: DashboardScreen(
                            returnList: snapshot.data!,
                            updatePage: _updatePage),
                      ),
                    ],
                  );
                }
              })),
    );
  }
}
