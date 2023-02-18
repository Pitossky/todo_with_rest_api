import 'package:flutter/material.dart';

void showDataMsg(BuildContext context,
    {String? message, Color? color, Color? textColor}) {
  final snackBar = SnackBar(
    content: Text(
      message.toString(),
      style: TextStyle(color: textColor),
    ),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
