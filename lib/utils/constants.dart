import 'package:flutter/material.dart';

const String emptyFieldErrMsg = 'This field may not be empty';

void showMsg(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.lightGreen,
      content: Text(
        msg,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      )));
}
