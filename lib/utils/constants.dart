import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

const String emptyFieldErrMsg = 'This field cannot be empty';

// Flushbar
void showFlushBar(BuildContext context, String msg) => Flushbar(
      icon: Icon(
        Icons.sentiment_very_satisfied,
        size: 25,
        color: Colors.grey.shade800,
      ),
      message: msg,
      messageColor: Colors.grey.shade800,
      backgroundColor: Colors.greenAccent,
      duration: const Duration(milliseconds: 4200),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(10),
    ).show(context);

void showNotFoundFlushBar(BuildContext context, String msg) => Flushbar(
      icon: const Icon(
        Icons.sentiment_very_dissatisfied,
        size: 25,
        color: Colors.white,
      ),
      message: msg,
      backgroundColor: Colors.redAccent,
      duration: const Duration(milliseconds: 1500),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(10),
    ).show(context);

// SnackBar
void showSnackBar(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
