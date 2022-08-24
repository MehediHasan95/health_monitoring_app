import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/provider/doctor_provider.dart';
import 'package:health_monitoring_app/utils/constants.dart';
import 'package:health_monitoring_app/view/doctor_dashboard.dart';
import 'package:provider/provider.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({Key? key}) : super(key: key);
  static const String routeNames = '/DoctorScreen';

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  String _errMsg = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pink.shade200, Colors.purple.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Center(
          child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                shrinkWrap: true,
                children: [
                  const Text(
                    'DOCTOR PORTAL',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Doctor sign in only",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  // const SizedBox(height: 30),
                  // Image.asset(
                  //   'assets/doctor.png',
                  //   height: 150,
                  // ),
                  const SizedBox(height: 50),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          color: Colors.white,
                          Icons.email,
                        ),
                        fillColor: Colors.white30,
                        filled: true,
                        hintText: 'Email ID',
                        hintStyle: TextStyle(color: Colors.white)),
                    cursorColor: Colors.white,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return emptyFieldErrMsg;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: _obscureText,
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          color: Colors.white,
                          icon: Icon(_obscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        fillColor: Colors.white30,
                        filled: true,
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.white)),
                    cursorColor: Colors.white,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return emptyFieldErrMsg;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: _doctorSignIn,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    _errMsg,
                    style: const TextStyle(color: Colors.yellowAccent),
                    textAlign: TextAlign.center,
                  )
                ],
              )),
        ),
      ),
    );
  }

  void _doctorSignIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        final uid = await AuthService.signInUser(
            _emailController.text, _passwordController.text);
        if (uid != null) {
          final isDoctor =
              // ignore: use_build_context_synchronously
              await Provider.of<DoctorProvider>(context, listen: false)
                  .isDoctor(AuthService.currentUser!.email!);
          if (isDoctor) {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, DoctorDashboard.routeNames);
          } else {
            setState(() {
              _errMsg = 'This panel is only for registered doctors';
            });
          }
        }
      } on FirebaseAuthException catch (error) {
        setState(() {
          _errMsg = error.message!;
        });
      }
    }
  }
}
