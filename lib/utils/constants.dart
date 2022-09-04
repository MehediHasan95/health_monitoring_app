import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String emptyFieldErrMsg = 'This field cannot be empty';

// Flushbar
void showFlushBar(BuildContext context, String msg) => Flushbar(
      icon: const Icon(
        Icons.sentiment_very_satisfied,
        size: 25,
        color: Colors.white,
      ),
      message: msg,
      messageColor: Colors.white,
      backgroundColor: Colors.grey.shade900,
      duration: const Duration(milliseconds: 4200),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(10),
    ).show(context);

// SnackBar
void showSnackBar(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

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
              title: const Icon(Icons.sentiment_very_dissatisfied),
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
