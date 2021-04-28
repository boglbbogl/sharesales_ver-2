import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'color.dart';

AppBar mainAppBar(BuildContext context,String title, Color? colors, Widget actionIcon, {appBarBottom, Widget? leadingIcon}) {
  return AppBar(
    backgroundColor: colors==null ? Colors.white:colors,
    elevation: 0,
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontSize: fontSize,
        foreground: Paint()..shader = secondMainColor,
      ),
    ),
    actions: [
      actionIcon,
    ],
    leading: leadingIcon,
    bottom: appBarBottom
  );
}
