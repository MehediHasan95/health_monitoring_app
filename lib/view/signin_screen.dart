import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/utils/constants.dart';
import 'package:health_monitoring_app/view/forgot_password.dart';
import 'package:health_monitoring_app/view/live_screen.dart';
import 'package:health_monitoring_app/view/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  static const String routeNames = '/SignInScreen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              shrinkWrap: true,
              children: [
                Text(
                  'SIGN IN',
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
                  'Please sign in to continue',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                Image.asset('assets/signin.jpg'),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Enter your email address'),
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
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      hintText: 'Enter your password'),
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ForgotPassword();
                    }));
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: _signInUser,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue.shade900,
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
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('New member?'),
                    TextButton(
                      style:
                          TextButton.styleFrom(primary: Colors.blue.shade900),
                      onPressed: () {
                        Navigator.pushNamed(context, SignUpScreen.routeNames);
                      },
                      child: const Text('Sign Up'),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }

  void _signInUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        final uid = await AuthService.signInUser(
            _emailController.text, _passwordController.text);
        if (uid != null) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, LiveScreen.routeNames);
        }
      } on FirebaseAuthException catch (error) {
        setState(() {
          _errMsg = error.message!;
        });
      }
    }
  }
}
