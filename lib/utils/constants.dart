import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:lottie/lottie.dart';

const String emptyUniqueErrMsg = 'Please Enter Your Registration ID';
const String emptyNameErrMsg = 'Please Enter Your Name';
const String emptyEmailErrMsg = 'Please Enter Your Email ID';
const String emptyPasswordErrMsg = 'Please Enter Your Password';
const String emptyGenderErrMsg = 'Please Select Your Gender';
const String emptySpecialistErrMsg = 'Please Select Your Specialist';
const String emptyHospitalErrMsg = 'Please Select Your Hospital';

// Flushbar
void showFlushBar(BuildContext context, String msg) => Flushbar(
      icon: const Icon(
        Icons.sentiment_very_satisfied,
        size: 25,
        color: Colors.white,
      ),
      message: msg,
      messageColor: Colors.white,
      backgroundColor: Colors.lightGreen.shade400,
      duration: const Duration(milliseconds: 2000),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(10),
    ).show(context);

void showFlushBarErrorMsg(BuildContext context, String msg) => Flushbar(
      icon: const Icon(
        Icons.sentiment_very_dissatisfied,
        size: 25,
        color: Colors.white,
      ),
      message: msg,
      messageColor: Colors.white,
      backgroundColor: Colors.redAccent,
      duration: const Duration(milliseconds: 2000),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(10),
    ).show(context);

// Show warning message
Future<bool?> showExitWarning(BuildContext context) async => showDialog<bool>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
          title: const Icon(Icons.warning),
          content: Text(
            'Before exiting, you must sign out',
            style: TextStyle(color: Colors.grey.shade800, fontSize: 18),
          ),
          actions: [
            CupertinoDialogAction(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('NO')),
            CupertinoDialogAction(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('YES')),
          ],
        ));

// Show not found warning
Future<bool?> showNotFoundWarning(BuildContext context) async =>
    showDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Center(child: FaIcon(FontAwesomeIcons.faceSadTear)),
              content: Text(
                'No Information Found',
                style: TextStyle(color: Colors.grey.shade800, fontSize: 18),
              ),
              actions: [
                CupertinoDialogAction(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('NO')),
              ],
            ));

// Show login warning
Future<bool?> showWarningMessage(BuildContext context, String errMsg) async =>
    showDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: LottieBuilder.asset("assets/error.json", height: 100),
              content: Text(
                errMsg,
                style: const TextStyle(color: Colors.redAccent, fontSize: 18),
              ),
            ));

// Show confirm alert dialog
Future<bool?> showConfirmAlert(
  BuildContext context,
) async =>
    showDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: LottieBuilder.asset('assets/confirm.json',
                  height: 120, repeat: false),
              content: Text("Your record has been successfully saved",
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade800)),
              actions: [
                CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('CLOSE')),
              ],
            ));

Future<bool?> deleteDialog(BuildContext context, String collection1,
        String doctorUID, String collection2, String uid) async =>
    showDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: LottieBuilder.asset('assets/delete.json', height: 120),
              content: Text(
                'Do you want to remove this account?',
                style: TextStyle(color: Colors.grey.shade800, fontSize: 18),
              ),
              actions: [
                CupertinoDialogAction(
                    onPressed: () => Navigator.pop(context, false),
                    child:
                        const Text('NO', style: TextStyle(color: Colors.red))),
                CupertinoDialogAction(
                    onPressed: () => {
                          Navigator.pop(context, true),
                          DatabaseHelper.db
                              .collection(collection1)
                              .doc(doctorUID)
                              .collection(collection2)
                              .doc(uid)
                              .delete()
                        },
                    child: const Text('YES',
                        style: TextStyle(color: Colors.green))),
              ],
            ));
