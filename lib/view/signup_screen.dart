import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/utils/constants.dart';
import 'package:health_monitoring_app/view/signin_screen.dart';
import 'package:health_monitoring_app/view/successfull_screen.dart';
import 'package:intl/intl.dart';

const gender = ["Male", "Female"];

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const String routeNames = '/SignUpScreen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? selectGender;
  DateTime? dateOfBirth;
  String _errMsg = '';
  bool _obscureText = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
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
                      'CREATE AN ACCOUNT',
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
                      "Create an account. It's free",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    // Image.asset('assets/signin.jpg'),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      autofillHints: const [AutofillHints.name],
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          fillColor: Colors.white30,
                          filled: true,
                          hintText: 'Name',
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
                    DropdownButtonFormField<String>(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.male,
                            color: Colors.white,
                          ),
                          fillColor: Colors.white30,
                          filled: true,
                          hintText: "Gender",
                          hintStyle: TextStyle(color: Colors.white)),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      dropdownColor: Colors.pink.shade200,
                      value: selectGender,
                      onChanged: ((value) {
                        setState(() {
                          selectGender = value;
                        });
                      }),
                      items: gender
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
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
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.white,
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
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
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
                      height: 8,
                    ),
                    ElevatedButton.icon(
                      onPressed: _showDatePickerDialog,
                      icon: const Icon(Icons.date_range),
                      label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          child: Text(dateOfBirth == null
                              ? "Date of Birth"
                              : DateFormat("dd MMMM yyyy")
                                  .format(dateOfBirth!))),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        alignment: Alignment.centerLeft,
                        primary: Colors.white30,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: _SignUpUser,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      _errMsg,
                      style: const TextStyle(color: Colors.yellowAccent),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                              primary: Colors.pink.shade200),
                          onPressed: () {
                            Navigator.popAndPushNamed(
                                context, SignInScreen.routeNames);
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  void _SignUpUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        final uid = await AuthService.signUpUser(
          _nameController.text,
          selectGender!,
          dateOfBirth!,
          _emailController.text.toLowerCase(),
          _passwordController.text,
        );
        if (uid != null) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushNamedAndRemoveUntil(
              SuccessfullScreen.routeNames, (Route<dynamic> route) => false);
        }
      } on FirebaseAuthException catch (error) {
        setState(() {
          _errMsg = error.message!;
        });
      }
    }
  }

  void _showDatePickerDialog() async {
    final selectDateOfBirth = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (selectDateOfBirth != null) {
      setState(() {
        dateOfBirth = selectDateOfBirth;
      });
    }
  }
}
