import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/utils/constants.dart';
import 'package:health_monitoring_app/view/doctor_registration_success.dart';
import 'package:health_monitoring_app/view/doctor_screen.dart';

const gender = ["Male", "Female"];
const specialist = [
  "Cardiologist",
  "Neurologist",
  "Chest & Medicine",
  "Medicine",
  "Radiologists",
  "Neuromedicine",
  "Kidney & Medicine"
];
const hospital = [
  "Evercare Hospital Dhaka",
  "Square Hospitals Ltd.",
  "United Hospitals Ltd.",
  "BIRDEM General Hospital",
  "National Heart Foundation",
  "Aysha Memorial Hospital",
  "Popular Hospital Dhaka"
];

class DoctorSignUp extends StatefulWidget {
  const DoctorSignUp({Key? key}) : super(key: key);
  static const String routeNames = '/DoctorSignUp';

  @override
  State<DoctorSignUp> createState() => _DoctorSignUpState();
}

class _DoctorSignUpState extends State<DoctorSignUp> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _verifiedController = TextEditingController();
  String? selectGender;
  String? selectSpecialist;
  String? selectHospital;
  String _errMsg = '';
  bool _obscureText = true;

  @override
  void dispose() {
    _verifiedController.dispose();
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
                      'DOCTOR SIGN UP',
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
                      height: 30,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      autofillHints: const [AutofillHints.name],
                      controller: _verifiedController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.verified,
                            color: Colors.white,
                          ),
                          fillColor: Colors.white30,
                          filled: true,
                          hintText: 'Unique ID',
                          hintStyle: TextStyle(color: Colors.white)),
                      cursorColor: Colors.white,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return emptyNameErrMsg;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 10,
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
                          return emptyNameErrMsg;
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
                          return emptyEmailErrMsg;
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
                          return emptyPasswordErrMsg;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<String>(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            selectGender == "Male" ? Icons.male : Icons.female,
                            color: Colors.white,
                          ),
                          fillColor: Colors.white30,
                          filled: true,
                          hintText: "Gender",
                          hintStyle: const TextStyle(color: Colors.white)),
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
                                child: Text(e, overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return emptyGenderErrMsg;
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
                            Icons.psychology,
                            color: Colors.white,
                          ),
                          fillColor: Colors.white30,
                          filled: true,
                          hintText: "Specialist",
                          hintStyle: TextStyle(color: Colors.white)),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      dropdownColor: Colors.pink.shade200,
                      value: selectSpecialist,
                      onChanged: ((value) {
                        setState(() {
                          selectSpecialist = value;
                        });
                      }),
                      items: specialist
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e, overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return emptySpecialistErrMsg;
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
                            Icons.home,
                            color: Colors.white,
                          ),
                          fillColor: Colors.white30,
                          filled: true,
                          hintText: "Hospital",
                          hintStyle: TextStyle(color: Colors.white)),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      dropdownColor: Colors.pink.shade200,
                      value: selectHospital,
                      onChanged: ((value) {
                        setState(() {
                          selectHospital = value;
                        });
                      }),
                      items: hospital
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e, overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return emptyHospitalErrMsg;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    ElevatedButton(
                      onPressed: () {
                        _doctorSignUp(_verifiedController.text);
                      },
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
                                context, DoctorScreen.routeNames);
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }

  // ignore: prefer_typing_uninitialized_variables
  var uniqueID;
  // ignore: prefer_typing_uninitialized_variables
  var isExist;

  void _doctorSignUp(verified) async {
    if (_formKey.currentState!.validate()) {
      await DatabaseHelper.db
          .collection("verifiedDoctor")
          .where("verified", isEqualTo: verified)
          .get()
          .then(
        (verifiedDoc) async {
          if (verifiedDoc.docs.isEmpty) {
            showFlushBarErrorMsg(context, "You are not verified doctor");
          } else if (verifiedDoc.docs.isNotEmpty) {
            for (var elements in verifiedDoc.docs) {
              uniqueID = elements.data()['verified'];
              if (uniqueID == verified) {
                await DatabaseHelper.db
                    .collection("doctor")
                    .where("uniqueId", isEqualTo: verified)
                    .get()
                    .then((exist) async {
                  if (exist.docs.isEmpty) {
                    try {
                      final uid = await AuthService.doctorSignUpUser(
                          _verifiedController.text,
                          _nameController.text,
                          _emailController.text.toLowerCase(),
                          _passwordController.text,
                          selectGender!,
                          selectSpecialist!,
                          selectHospital!);
                      if (uid != null) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            DoctorRegistrationSuccess.routeNames,
                            (Route<dynamic> route) => false);
                      }
                    } on FirebaseAuthException catch (error) {
                      setState(() {
                        _errMsg = error.message!;
                      });
                    }
                  }
                  for (var elements in exist.docs) {
                    isExist = elements.data()['uniqueId'];
                    if (isExist == verified) {
                      // ignore: use_build_context_synchronously
                      showFlushBarErrorMsg(context, "Already Exist");
                    }
                  }
                });
              }
            }
          }
        },
      );
    }
  }
}
