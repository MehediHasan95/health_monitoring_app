import 'package:flutter/material.dart';

const String emptyFieldErrMsg = 'This field must not be empty';

void showMsg(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
    msg,
    style: const TextStyle(color: Colors.greenAccent),
    textAlign: TextAlign.center,
  )));
}
