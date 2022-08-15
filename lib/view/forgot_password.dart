import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/utils/constants.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String _errMsg = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              shrinkWrap: true,
              children: [
                Text(
                  'RESET PASSWORD',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.blue.shade900),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "You have requested to reset your password",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                Image.asset('assets/forgot-password.png'),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  controller: _emailController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email), hintText: 'Email ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return emptyFieldErrMsg;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _passwordReset,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Reset password'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  _errMsg,
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                )
              ],
            )),
      ),
    );
  }

  void _passwordReset() async {
    if (_formKey.currentState!.validate()) {
      try {
        await AuthService.passwordReset(_emailController.text.trim());
        setState(() {
          _emailController.text = '';
          showFlushBar(context, 'We have e-mailed your password reset link');
        });
      } on FirebaseAuthException catch (error) {
        setState(() {
          _errMsg = error.message!;
        });
      }
    }
  }
}
