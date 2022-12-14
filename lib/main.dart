import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_monitoring_app/view/doctor_list.dart';
import 'package:health_monitoring_app/provider/doctor_provider.dart';
import 'package:health_monitoring_app/provider/sensor_data_provider.dart';
import 'package:health_monitoring_app/provider/user_provider.dart';
import 'package:health_monitoring_app/view/about_screen.dart';
import 'package:health_monitoring_app/view/barcode_generator.dart';
import 'package:health_monitoring_app/view/dash_screen.dart';
import 'package:health_monitoring_app/view/doctor_dashboard.dart';
import 'package:health_monitoring_app/view/doctor_registration_success.dart';
import 'package:health_monitoring_app/view/doctor_screen.dart';
import 'package:health_monitoring_app/view/doctor_sign_up.dart';
import 'package:health_monitoring_app/view/health_tips_screen.dart';
import 'package:health_monitoring_app/view/live_screen.dart';
import 'package:health_monitoring_app/view/scan_user_data.dart';
import 'package:health_monitoring_app/view/signin_screen.dart';
import 'package:health_monitoring_app/view/signup_screen.dart';
import 'package:health_monitoring_app/view/splash_screen.dart';
import 'package:health_monitoring_app/view/successfull_screen.dart';
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
        ChangeNotifierProvider(create: (context) => SensorDataProvider()),
        ChangeNotifierProvider(create: (context) => DoctorProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: "Roboto"),
        home: const SplashScreen(),
        routes: {
          WelcomeScreen.routeNames: (context) => const WelcomeScreen(),
          SignInScreen.routeNames: (context) => const SignInScreen(),
          SignUpScreen.routeNames: (context) => const SignUpScreen(),
          DoctorScreen.routeNames: (context) => const DoctorScreen(),
          DoctorSignUp.routeNames: (context) => const DoctorSignUp(),
          LiveScreen.routeNames: (context) => const LiveScreen(),
          DashScreen.routeNames: (context) => const DashScreen(),
          DoctorDashboard.routeNames: (context) => const DoctorDashboard(),
          AboutScreen.routeNames: (context) => const AboutScreen(),
          HealthTipsScreen.routeNames: (context) => const HealthTipsScreen(),
          SuccessfullScreen.routeNames: (context) => const SuccessfullScreen(),
          BarcodeGenerate.routeNames: (context) => const BarcodeGenerate(),
          ScanUserData.routeNames: (context) => const ScanUserData(),
          DoctorList.routeNames: (context) => const DoctorList(),
          DoctorRegistrationSuccess.routeNames: (context) =>
              const DoctorRegistrationSuccess(),
        },
      ),
    );
  }
}
