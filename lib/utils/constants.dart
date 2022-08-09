import 'package:flutter/material.dart';

const String emptyFieldErrMsg = 'This field may not be empty';

void showMsg(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.lightGreen[100],
      content: Text(
        msg,
        style: TextStyle(
            color: Colors.lightGreen[600], fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      )));
}
