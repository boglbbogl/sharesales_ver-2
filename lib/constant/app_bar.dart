import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'color.dart';

AppBar mainAppBar(BuildContext context, Widget icon) {
  return AppBar(
    backgroundColor: blackColor,
    centerTitle: true,
    title: Text(
      'share sales',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontSize: fontSize,
        foreground: Paint()..shader = mainColor,
      ),
    ),
    actions: [
      icon,
    ],
  );
}
