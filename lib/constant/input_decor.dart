import 'package:flutter/material.dart';

TextStyle textInputStyle(){
  return TextStyle(
    color: Colors.white,
  );
}

InputDecoration textInputDecor(String hint) {
  return InputDecoration(
    enabledBorder: _activeInputBorder(),
    focusedBorder: _activeInputBorder(),
    errorBorder: _errorInputBorder(),
    focusedErrorBorder: _errorInputBorder(),
    labelText: hint,
    labelStyle: TextStyle(color: Colors.yellow),
  );
}

UnderlineInputBorder _errorInputBorder() {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.redAccent,
    ),
  );
}

UnderlineInputBorder _activeInputBorder() {
  return UnderlineInputBorder(
    borderSide: BorderSide(
        color: Colors.yellow,
    ),
  );
}

InputDecoration logoutInputDecor(String hint) {
  return InputDecoration(
    enabledBorder: _logoutActiveInputBorder(),
    focusedBorder: _logoutActiveInputBorder(),
    errorBorder: _errorInputBorder(),
    focusedErrorBorder: _errorInputBorder(),
    labelText: hint,
    labelStyle: TextStyle(color: Colors.black),
  );
}

UnderlineInputBorder _logoutActiveInputBorder() {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.black,
    ),
  );
}