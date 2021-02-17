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
