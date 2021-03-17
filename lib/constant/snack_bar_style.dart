import 'dart:ui';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

TextStyle snackBarStyle() {
  return TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    fontSize: 18,
  );
}


void snackBarManagementScreenTopFlushBar(BuildContext context, String title) {
  Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    padding: EdgeInsets.all(20),
    margin: EdgeInsets.all(20),
    borderRadius: 12,
    backgroundGradient: LinearGradient(
      colors: [Colors.green.shade800, Colors.greenAccent.shade700],
      stops: [0.6, 1],
    ),
    boxShadows: [
      BoxShadow(
        color: Colors.black45,
        offset: Offset(3, 3),
        blurRadius: 3,
      ),
    ],
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    title: title,
    message: "<<<  밀어서 제거하기  >>>",
  )..show(context);
}