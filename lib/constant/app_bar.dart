import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'color.dart';

AppBar mainAppBar(BuildContext context, Widget icon, {appBarBottom}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    title: Text(
      'share sales',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontSize: fontSize,
        foreground: Paint()..shader = secondMainColor,
      ),
    ),
    actions: [
      icon,
    ],
    bottom: appBarBottom
  );
}
