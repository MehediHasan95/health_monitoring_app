import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_monitoring_app/provider/sensor_data_provider.dart';
import 'package:health_monitoring_app/view/dash_screen.dart';
import 'package:health_monitoring_app/view/doctor_screen.dart';
import 'package:health_monitoring_app/view/live_screen.dart';
import 'package:health_monitoring_app/view/send_database.dart';
import 'package:health_monitoring_app/view/signin_screen.dart';
import 'package:health_monitoring_app/view/signup_screen.dart';
import 'package:health_monitoring_app/view/splash_screen.dart';
import 'package:health_monitoring_app/view/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (create) => SensorDataProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashScreen(),
        routes: {
          WelcomeScreen.routeNames: (context) => const WelcomeScreen(),
          SignInScreen.routeNames: (context) => const SignInScreen(),
          SignUpScreen.routeNames: (context) => const SignUpScreen(),
          DoctorScreen.routeNames: (context) => const DoctorScreen(),
          LiveScreen.routeNames: (context) => const LiveScreen(),
          DashScreen.routeNames: (context) => const DashScreen(),
          SendDatabase.routeNames: (context) => const SendDatabase(),
        },
      ),
    );
  }
}
