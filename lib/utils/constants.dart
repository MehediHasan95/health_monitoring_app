import 'package:flutter/material.dart';

const String emptyFieldErrMsg = 'This field may not be empty';

void showMsg(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.greenAccent,
      content: Text(
        msg,
        style: TextStyle(color: Colors.grey.shade800),
        textAlign: TextAlign.center,
      )));
}
