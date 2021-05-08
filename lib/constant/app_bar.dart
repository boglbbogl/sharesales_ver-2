import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'color.dart';

AppBar mainAppBar(BuildContext context, Shader? shaderColor, String title, Color? colors, Widget actionIcon, {appBarBottom, Widget? leadingIcon,
bool? backBtn=true}) {
  return AppBar(
    backgroundColor: colors==null ? Colors.white:colors,
    automaticallyImplyLeading: backBtn!,
    elevation: 0,
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontSize: fontSize,
        foreground: Paint()..shader = shaderColor,
      ),
    ),
    actions: [
      actionIcon,
    ],
    leading: leadingIcon,
    bottom: appBarBottom,
  );
}
