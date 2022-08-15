import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

const String emptyFieldErrMsg = 'This field cannot be empty';

void showFlushBar(BuildContext context, String msg) => Flushbar(
      icon: const Icon(
        Icons.cloud_done,
        size: 25,
        color: Colors.white,
      ),
      message: msg,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(23),
    ).show(context);
