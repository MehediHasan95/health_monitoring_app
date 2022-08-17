import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

const String emptyFieldErrMsg = 'This field cannot be empty';

// Flushbar
void showFlushBar(BuildContext context, String msg) => Flushbar(
      icon: const Icon(
        Icons.cloud_done,
        size: 25,
        color: Colors.white,
      ),
      message: msg,
      backgroundColor: Colors.lightGreen,
      duration: const Duration(milliseconds: 4200),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(23),
    ).show(context);

// SnackBar
void showSnackBar(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
