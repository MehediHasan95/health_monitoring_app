import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ScanUserData extends StatefulWidget {
  const ScanUserData({Key? key}) : super(key: key);
  static const String routeNames = '/ScanUserData';
  @override
  State<ScanUserData> createState() => _ScanUserDataState();
}

class _ScanUserDataState extends State<ScanUserData> {
  String scanQRCode = '';
  double totalBpm = 0;
  double totalSpo2 = 0;
  double totalTempC = 0;
  double totaltempF = 0;
  double averageBpm = 0;
  double averageSpo2 = 0;
  double averageTempC = 0;
  double averageTempF = 0;
  bool isVisiable = false;
  bool isNotFound = false;
  // ignore: prefer_typing_uninitialized_variables
  var myAge;

  List<Object> _dataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Scan Now'),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.purple.shade900,
        buttonBackgroundColor: Colors.pink,
        color: Colors.purple.shade900,
        onTap: (index) {
          _scanQR();
        },
        height: 55,
        items: const [
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(
              Icons.qr_code_scanner,
              color: Colors.white,
              size: 35,
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pink.shade200, Colors.purple.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Not Found
              Visibility(
                visible: isNotFound,
                child: const Center(
                  heightFactor: 10.0,
                  child: Text(
                    "Not Found",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              Visibility(
                visible: isVisiable,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.purple.shade900,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(13),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Age: $myAge | Gender: $gender',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "AVERAGE VALUE",
                                style: TextStyle(color: Colors.pink),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Text(averageBpm.toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontSize: 50,
                                      color: Colors.white,
                                    )),
                                const Text(
                                  'PR',
                                  style: TextStyle(
                                    height: 4,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(averageSpo2.toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontSize: 50,
                                      color: Colors.white,
                                    )),
                                const Text(
                                  '%',
                                  style: TextStyle(
                                    height: 4,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Text(averageTempC.toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontSize: 50,
                                      color: Colors.white,
                                    )),
                                const Text(
                                  '°C',
                                  style: TextStyle(
                                    height: 4,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(averageTempF.toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontSize: 50,
                                      color: Colors.white,
                                    )),
                                const Text(
                                  '°F',
                                  style: TextStyle(
                                    height: 4,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20)
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isVisiable,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 10.0),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Data Sheet',
                        style: TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _dataList.length,
                  itemBuilder: (context, index) {
                    final getValue = _dataList[index] as SensorDataModel;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        color: Colors.white70,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 10.0, bottom: 20.0, right: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Text(
                                    DateFormat('dd/MM/yyyy, hh:mm a')
                                        .format(getValue.timestamp!)
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade800)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("HR:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade800)),
                                    LinearPercentIndicator(
                                      animation: true,
                                      animationDuration: 1000,
                                      width: 200,
                                      lineHeight: 15,
                                      percent:
                                          double.parse(getValue.bpm!) / 180,
                                      backgroundColor: Colors.white30,
                                      linearGradient: LinearGradient(
                                          colors: [
                                            Colors.red,
                                            Colors.red.shade900
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.bottomRight),
                                      leading: Text("${getValue.bpm!}PR",
                                          style: TextStyle(
                                              color: Colors.grey.shade800)),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("OL:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade800)),
                                    LinearPercentIndicator(
                                      animation: true,
                                      animationDuration: 1000,
                                      width: 200,
                                      lineHeight: 15,
                                      percent:
                                          double.parse(getValue.spo2!) / 110,
                                      backgroundColor: Colors.white30,
                                      linearGradient: LinearGradient(
                                          colors: [
                                            Colors.green,
                                            Colors.green.shade900
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.bottomRight),
                                      // progressColor: Colors.lightGreen,
                                      leading: Text("${getValue.spo2!}%",
                                          style: TextStyle(
                                              color: Colors.grey.shade800)),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("BTC:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade800)),
                                    LinearPercentIndicator(
                                      animation: true,
                                      animationDuration: 1000,
                                      width: 200,
                                      lineHeight: 15,
                                      percent:
                                          double.parse(getValue.tempC!) / 50,
                                      backgroundColor: Colors.white30,
                                      linearGradient: LinearGradient(
                                          colors: [
                                            Colors.blue,
                                            Colors.blue.shade900
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.bottomRight),
                                      // progressColor: Colors.blueAccent,
                                      leading: Text("${getValue.tempC!}°C",
                                          style: TextStyle(
                                              color: Colors.grey.shade800)),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("BTF:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade800)),
                                    LinearPercentIndicator(
                                      animation: true,
                                      animationDuration: 1000,
                                      width: 200,
                                      lineHeight: 15,
                                      linearGradient: LinearGradient(
                                        colors: [
                                          Colors.amber,
                                          Colors.amber.shade800
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      percent:
                                          double.parse(getValue.bpm!) / 122,
                                      backgroundColor: Colors.white30,
                                      // progressColor: Colors.amberAccent,
                                      leading: Text("${getValue.tempF!}°F",
                                          style: TextStyle(
                                              color: Colors.grey.shade800)),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _searchFromDB(String scanQRCode) async {
    var data = await DatabaseHelper.db
        .collection('sensorData')
        .doc(scanQRCode)
        .collection('userData')
        .orderBy('timestamp', descending: true)
        .get();

    if (data.docs.isNotEmpty) {
      isVisiable = true;
      isNotFound = false;
      getUserProfileInfo(scanQRCode);
      getAverageValue(scanQRCode);
    } else {
      isNotFound = true;
    }

    setState(() {
      _dataList =
          List.from(data.docs.map((doc) => SensorDataModel.fromSnapshot(doc)));
    });
  }

  Future getAverageValue(String scanQRCode) async {
    await DatabaseHelper.db
        .collection('sensorData/$scanQRCode/userData')
        .get()
        .then(
      (querySnapshot) {
        int totalElements = querySnapshot.docs.length;
        for (var elements in querySnapshot.docs) {
          totalBpm = totalBpm + double.parse(elements.data()['bpm']);
          totalSpo2 = totalSpo2 + double.parse(elements.data()['spo2']);
          totalTempC = totalTempC + double.parse(elements.data()['tempC']);
          totaltempF = totaltempF + double.parse(elements.data()['tempF']);
          averageBpm = totalBpm / totalElements;
          averageSpo2 = totalSpo2 / totalElements;
          averageTempC = totalTempC / totalElements;
          averageTempF = totaltempF / totalElements;
        }
        setState(() {
          averageBpm;
          averageSpo2;
          averageTempC;
          averageTempF;
        });
      },
    );
  }

  String username = '';
  String gender = '';
  DateTime? age;
  Future getUserProfileInfo(String scanQRCode) async {
    await DatabaseHelper.db
        .collection('userProfileInfo')
        .doc(scanQRCode)
        .get()
        .then(
      (querySnapshot) {
        username = querySnapshot.data()!['username'];
        gender = querySnapshot.data()!['gender'];
        age = querySnapshot.data()!['birthday'].toDate();
      },
    );
    final today = DateTime.now();
    double diffAge = today.difference(age!).inDays / 365;
    myAge = diffAge.round();
    setState(() {
      username;
      gender;
      age;
    });
  }

// QR CODE Scan method
  void _scanQR() async {
    scanQRCode = await FlutterBarcodeScanner.scanBarcode(
        "#00FF00", "CLOSE", true, ScanMode.QR);
    setState(() {
      totalBpm = 0;
      totalSpo2 = 0;
      totalTempC = 0;
      totaltempF = 0;
    });
    return _searchFromDB(scanQRCode);
  }
}
