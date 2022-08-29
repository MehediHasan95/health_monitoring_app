import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';
import 'package:health_monitoring_app/provider/user_provider.dart';
import 'package:health_monitoring_app/utils/constants.dart';
import 'package:health_monitoring_app/view/scan_user_data.dart';
import 'package:health_monitoring_app/view/welcome_screen.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({Key? key}) : super(key: key);
  static const String routeNames = '/DoctorDashboard';

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  late UserProvider _userProvider;
  final doctor = AuthService.currentUser;
  String scanQRCode = '';
  double totalBpm = 0;
  double totalSpo2 = 0;
  double totalTempC = 0;
  double totaltempF = 0;
  double averageBpm = 0;
  double averageSpo2 = 0;
  double averageTempC = 0;
  double averageTempF = 0;
  // ignore: prefer_typing_uninitialized_variables
  var myAge;
  List<Object> _dataList = [];

  bool isUserListVisible = true;
  bool isDetailVisible = false;

  @override
  void didChangeDependencies() {
    _userProvider = Provider.of<UserProvider>(context);
    super.didChangeDependencies();
    getDoctorProfileInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Doctor Dashboard'),
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
              Visibility(
                visible: isUserListVisible,
                child: Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: _userProvider.userList.length,
                    itemBuilder: (context, index) {
                      final profile = _userProvider.userList[index];
                      String? userID = profile.uid;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Card(
                          color: Colors.white70,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: ListTile(
                            onTap: () {
                              _searchFromDB(userID!);
                              setState(() {
                                totalBpm = 0;
                                totalSpo2 = 0;
                                totalTempC = 0;
                                totaltempF = 0;
                              });
                            },
                            leading: profile.gender == 'Male'
                                ? Image.asset('assets/man.png', height: 50)
                                : Image.asset('assets/woman.png', height: 50),
                            title: Text(
                              "${profile.username!} (${profile.gender!})",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800),
                            ),
                            subtitle: Text(profile.email!),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            iconColor: Colors.green,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Visibility(
                visible: isDetailVisible,
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
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Age: $myAge | Gender: $gender',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isUserListVisible = true;
                                            isDetailVisible = false;
                                          });
                                        },
                                        icon: const Icon(Icons.arrow_back_ios,
                                            color: Colors.red)),
                                  ],
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
                visible: isDetailVisible,
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
                        'Daily Reports',
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
                visible: isDetailVisible,
                child: Expanded(
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
                          color: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                top: 10.0,
                                bottom: 20.0,
                                right: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    DateFormat('dd/MM/yyyy, hh:mm a')
                                        .format(getValue.timestamp!)
                                        .toString(),
                                    style: const TextStyle(fontSize: 20)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("HR:"),
                                    LinearPercentIndicator(
                                      animation: true,
                                      animationDuration: 1000,
                                      width: 200,
                                      lineHeight: 15,
                                      percent:
                                          double.parse(getValue.bpm!) / 180,
                                      progressColor: Colors.green,
                                      leading: Text("${getValue.bpm!}PR"),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("OL:"),
                                    LinearPercentIndicator(
                                      animation: true,
                                      animationDuration: 1000,
                                      width: 200,
                                      lineHeight: 15,
                                      percent:
                                          double.parse(getValue.spo2!) / 110,
                                      progressColor: Colors.deepPurple,
                                      leading: Text("${getValue.spo2!}%"),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("BTC:"),
                                    LinearPercentIndicator(
                                      animation: true,
                                      animationDuration: 1000,
                                      width: 200,
                                      lineHeight: 15,
                                      percent:
                                          double.parse(getValue.tempC!) / 50,
                                      progressColor: Colors.amberAccent,
                                      leading: Text("${getValue.tempC!}°C"),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("BTF:"),
                                    LinearPercentIndicator(
                                      animation: true,
                                      animationDuration: 1000,
                                      width: 200,
                                      lineHeight: 15,
                                      percent:
                                          double.parse(getValue.bpm!) / 122,
                                      progressColor: Colors.pink,
                                      leading: Text("${getValue.tempF!}°F"),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    doctorGender == 'Male'
                        ? Image.asset('assets/man-doctor.png', height: 80)
                        : Image.asset('assets/woman-doctor.png', height: 80),
                    Text(
                      '$doctorName',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      '$doctorEmail',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                )),
            ListTile(
              onTap: (() {
                Navigator.popAndPushNamed(context, ScanUserData.routeNames);
              }),
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Scan Now'),
            ),
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

  void _searchFromDB(String userID) async {
    var data = await DatabaseHelper.db
        .collection('sensorData')
        .doc(userID)
        .collection('userData')
        .orderBy('timestamp', descending: true)
        .get();

    if (data.docs.isNotEmpty) {
      getUserProfileInfo(userID);
      getAverageValue(userID);
      isDetailVisible = true;
      isUserListVisible = false;
    } else {
      // ignore: use_build_context_synchronously
      showNotFoundFlushBar(context, 'Not found');
      isUserListVisible = true;
      isDetailVisible = false;
    }
    setState(() {
      _dataList =
          List.from(data.docs.map((doc) => SensorDataModel.fromSnapshot(doc)));
    });
  }

  Future getAverageValue(String userID) async {
    await DatabaseHelper.db
        .collection('sensorData/$userID/userData')
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

// User Profile info
  String username = '';
  String gender = '';
  DateTime? age;
  Future getUserProfileInfo(String userID) async {
    await DatabaseHelper.db
        .collection('userProfileInfo')
        .doc(userID)
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

  String? doctorName = '';
  String? doctorGender = '';
  String? doctorEmail = '';
  Future getDoctorProfileInfo() async {
    final uid = AuthService.currentUser?.uid;
    await DatabaseHelper.db.collection('doctor').doc(uid).get().then(
      (querySnapshot) {
        doctorName = querySnapshot.data()!['name'];
        doctorGender = querySnapshot.data()!['gender'];
        doctorEmail = querySnapshot.data()!['email'];
      },
    );
    setState(() {
      doctorName;
      doctorGender;
      doctorEmail;
    });
  }
}
