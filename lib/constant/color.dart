import 'package:flutter/material.dart';

  final Shader appbarColor = LinearGradient(
    colors: <Color>[Color(0xffff6e02), Color(0xffffff00), Color(0xffff6d00)],
  ).createShader(new Rect.fromLTWH(0.0, 300.0, 300.0, 0.0));


const MaterialColor blackColor = MaterialColor(
  0xFF000000,
  <int, Color>{
    50: Color(0x0000000),
    100: Color(0x1000000),
    200: Color(0x2000000),
    300: Color(0x3000000),
    400: Color(0x4000000),
    500: Color(0x5000000),
    600: Color(0x6000000),
    700: Color(0x7000000),
    800: Color(0x8000000),
    900: Color(0x9000000),
  },
);