import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';
import 'package:health_monitoring_app/view/welcome_screen.dart';
import 'package:intl/intl.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({Key? key}) : super(key: key);
  static const String routeNames = '/DoctorDashboard';

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  bool isVisible = false;
  bool notFound = false;
  bool isScan = true;
  final user = AuthService.currentUser;
  String scanQRCode = '';
  List<Object> _dataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Doctor Portal'),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.purple.shade900,
        buttonBackgroundColor: Colors.pink,
        color: Colors.purple.shade900,
        onTap: (index) {
          _scanQR();
        },
        height: 60,
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
            children: [
              Visibility(
                visible: isScan,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 250.0),
                  child: Column(
                    children: const [
                      Text(
                        'SCAN NOW',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: notFound,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 250.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/notResult.png',
                        height: 100,
                      ),
                      const Text(
                        'Not Found',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: isVisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(username,
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white)),
                          Text(gender,
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: isVisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                        "Data Analysis",
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
              Visibility(
                visible: isVisible,
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 5.0, right: 5.0, top: 5.0),
                        child: Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(0.28),
                            1: FlexColumnWidth(0.18),
                            2: FlexColumnWidth(0.18),
                            3: FlexColumnWidth(0.18),
                            4: FlexColumnWidth(0.18),
                          },
                          border:
                              TableBorder.all(width: 0, color: Colors.white),
                          children: [
                            TableRow(
                                decoration:
                                    const BoxDecoration(color: Colors.pink),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text('Date & Time',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))
                                        ]),
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text('HR',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))
                                      ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text('OL',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))
                                      ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text('BTC',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))
                                      ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'BTF',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ]),
                                ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _dataList.length,
                  itemBuilder: (context, index) {
                    final getValue = _dataList[index] as SensorDataModel;
                    // return UserDataList(_dataList[index] as SensorDataModel);
                    return Column(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Table(
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  columnWidths: const {
                                    0: FlexColumnWidth(0.28),
                                    1: FlexColumnWidth(0.18),
                                    2: FlexColumnWidth(0.18),
                                    3: FlexColumnWidth(0.18),
                                    4: FlexColumnWidth(0.18),
                                  },
                                  border: TableBorder.all(
                                      width: 0, color: Colors.white),
                                  children: [
                                    TableRow(
                                        decoration: BoxDecoration(
                                            color: Colors.purple.shade900),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(getValue
                                                              .timestamp!)
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white))
                                                ]),
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('${getValue.bpm}b',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white))
                                              ]),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('${getValue.spo2}%',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white))
                                              ]),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('${getValue.tempC}°C',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white))
                                              ]),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${getValue.tempF}°F',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ]),
                                        ]),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ListTile(
                        //   title: Text(getValue.bpm!),
                        //   subtitle: Text(getValue.spo2!),
                        //   trailing: Text(getValue.tempC!),
                        // ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.purple.shade900,
                ),
                child: Center(
                  child: Text(
                    '${user?.email}',
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
            ListTile(
              onTap: _doctorSignOut,
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
            )
          ],
        ),
      ),
    );
  }

  void _doctorSignOut() {
    AuthService.signOut().then((_) {
      Navigator.pushReplacementNamed(context, WelcomeScreen.routeNames);
    });
  }

  void _searchFromDB(String scanQRCode) async {
    var data = await DatabaseHelper.db
        .collection('sensorData')
        .doc(scanQRCode)
        .collection('userData')
        .orderBy('timestamp', descending: true)
        .get();

    if (data.docs.isEmpty) {
      isVisible = false;
      notFound = true;
      isScan = false;
    } else {
      isVisible = true;
      notFound = false;
      isScan = false;
    }
    getUserProfileInfo(scanQRCode);
    setState(() {
      _dataList =
          List.from(data.docs.map((doc) => SensorDataModel.fromSnapshot(doc)));
    });
  }

  String username = '';
  String gender = '';
  Future getUserProfileInfo(String scanQRCode) async {
    await DatabaseHelper.db
        .collection('userProfileInfo')
        .doc(scanQRCode)
        .get()
        .then(
      (querySnapshot) {
        username = querySnapshot.data()!['username'];
        gender = querySnapshot.data()!['gender'];
      },
    );

    setState(() {
      username;
      gender;
    });
  }

// QR CODE Scan method
  void _scanQR() async {
    scanQRCode = await FlutterBarcodeScanner.scanBarcode(
        "#00FF00", "CLOSE", true, ScanMode.QR);
    return _searchFromDB(scanQRCode);
  }
}
