import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:pie_chart/pie_chart.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);
  static const String routeNames = '/Chart';

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  int key = 0;
  late List<ChartValue> _chartValue = [];

  Map<String, double> getCategoryData() {
    Map<String, double> catMap = {};
    for (var item in _chartValue) {
      if (catMap.containsKey(item.bpm) == false) {
        catMap[item.bpm] = 1;
        // catMap[item.spo2] = 1;
        // catMap[item.tempC] = 1;
      } else {
        // ignore: avoid_types_as_parameter_names
        catMap.update(item.bpm, (double) => catMap[item.bpm]! + 1);
        // ignore: avoid_types_as_parameter_names
        // catMap.update(item.spo2, (double) => catMap[item.spo2]! + 1);
        // ignore: avoid_types_as_parameter_names
        // catMap.update(item.tempC, (double) => catMap[item.tempC]! + 1);
      }
    }
    return catMap;
  }

  List<Color> colorList = const [
    Color.fromRGBO(82, 98, 255, 1),
    Color.fromRGBO(46, 198, 255, 1),
    Color.fromRGBO(123, 201, 82, 1),
    Color.fromRGBO(255, 171, 67, 1),
    Color.fromRGBO(252, 91, 57, 1),
    Color.fromRGBO(139, 135, 130, 1),
  ];

  Widget pieChartExampleOne() {
    return PieChart(
      key: ValueKey(key),
      dataMap: getCategoryData(),
      initialAngleInDegree: 0,
      animationDuration: const Duration(milliseconds: 2000),
      chartType: ChartType.ring,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      ringStrokeWidth: 32,
      colorList: colorList,
      chartLegendSpacing: 32,
      chartValuesOptions: const ChartValuesOptions(
          showChartValuesOutside: true,
          showChartValuesInPercentage: true,
          showChartValueBackground: true,
          showChartValues: true,
          chartValueStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      centerText: 'Chart',
      legendOptions: const LegendOptions(
          showLegendsInRow: false,
          showLegends: true,
          legendShape: BoxShape.rectangle,
          legendPosition: LegendPosition.right,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> senValueStream =
        FirebaseFirestore.instance.collection('sensorData').snapshots();

    void getExpfromSanapshot(snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _chartValue = [];
        for (int i = 0; i < snapshot.docs.length; i++) {
          var a = snapshot.docs[i];
          ChartValue senValue = ChartValue.fromJson(a.data());
          _chartValue.add(senValue);
        }
      }
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            StreamBuilder<Object>(
              stream: senValueStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final data = snapshot.requireData;
                getExpfromSanapshot(data);
                return pieChartExampleOne();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChartValue {
  String bpm;
  String spo2;
  String tempC;

  ChartValue({
    required this.bpm,
    required this.spo2,
    required this.tempC,
  });

  factory ChartValue.fromJson(Map<String, dynamic> json) {
    return ChartValue(
      bpm: json['bpm'],
      spo2: json['spo2'],
      tempC: json['tempC'],
    );
  }
}
