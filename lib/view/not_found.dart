import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/view/dash_screen.dart';

class NotFound extends StatefulWidget {
  const NotFound({Key? key}) : super(key: key);

  @override
  State<NotFound> createState() => _NotFoundState();
}

class _NotFoundState extends State<NotFound> {
  @override
  void initState() {
    super.initState();
    getUserProfileInfo();
  }

  Future<bool?> showWarning(BuildContext context) async => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Do you want to exit this app'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('No')),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Yes')),
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showWarning(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pink.shade200, Colors.purple.shade900],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/notFound.png'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sorry",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        username,
                        style: TextStyle(
                            color: Colors.pink.shade200,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    child: Text(
                      "Please connect your device properly",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pink.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, DashScreen.routeNames);
                        },
                        child: const Text('Dashboard'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String username = '';
  Future getUserProfileInfo() async {
    final uid = AuthService.currentUser?.uid;
    await DatabaseHelper.db.collection('userProfileInfo').doc(uid).get().then(
      (querySnapshot) {
        username = querySnapshot.data()!['username'];
      },
    );
    setState(() {
      username;
    });
  }
}
