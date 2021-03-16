import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

final wonMaskFormatter = MoneyInputFormatter(
  thousandSeparator: ThousandSeparator.None,
  mantissaLength: 0,
  maxTextLength: 0
);

// var wonMaskFormatter = new MaskTextInputFormatter(
//     mask: '###,###,###,###,##');

TextStyle blackInputStyle(){
  return TextStyle(
    color: Colors.white,
  );
}

InputDecoration editAddExpenseInputDecor(String hint){
  return InputDecoration(
    enabledBorder: _editAddExpenseInputDecor(),
    focusedBorder: _editAddExpenseInputDecor(),
    labelText: hint,
    labelStyle: TextStyle(color: Colors.white,),
  );
}
UnderlineInputBorder _editAddExpenseInputDecor() {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
    ),
  );
}



InputDecoration expenseInputDecor(String hint){
  return InputDecoration(
    enabledBorder: _expenseInputDecor(),
    focusedBorder: _expenseInputDecor(),
    labelText: hint,
      labelStyle: TextStyle(color: Colors.redAccent,),
  );
}

OutlineInputBorder _expenseInputDecor() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(
      color: Colors.redAccent,
    ),
  );
}

InputDecoration expenseChangeInputDecor(String hint){
  return InputDecoration(
    enabledBorder: _expenseInputDecor(),
    focusedBorder: _expenseInputDecor(),
    labelText: hint,
    labelStyle: TextStyle(color: Colors.redAccent,),
  );
}

InputDecoration salesChangeInputDecor(String hint) {
  return InputDecoration(
    enabledBorder: _blackActiveInputBorder(),
    focusedBorder: _blackActiveInputBorder(),
    errorBorder: _blackErrorInputBorder(),
    focusedErrorBorder: _blackErrorInputBorder(),
    labelText: hint,
    labelStyle: TextStyle(color: Colors.amberAccent),

  );
}

InputDecoration blackInputDecor(String hint) {
  return InputDecoration(
    enabledBorder: _blackActiveInputBorder(),
    focusedBorder: _blackActiveInputBorder(),
    errorBorder: _blackErrorInputBorder(),
    focusedErrorBorder: _blackErrorInputBorder(),
    labelText: hint,
    labelStyle: TextStyle(color: Colors.amberAccent),
  );
}

UnderlineInputBorder _blackErrorInputBorder() {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.redAccent,
    ),
  );
}

UnderlineInputBorder _blackActiveInputBorder() {
  return UnderlineInputBorder(
    borderSide: BorderSide(
        color: Colors.amberAccent,
    ),
  );
}

InputDecoration amberInputDecor(String hint) {
  return InputDecoration(
    enabledBorder: _amberActiveInputBorder(),
    focusedBorder: _amberActiveInputBorder(),
    errorBorder: _blackErrorInputBorder(),
    focusedErrorBorder: _blackErrorInputBorder(),
    labelText: hint,
    labelStyle: TextStyle(color: Colors.black),
  );
}

UnderlineInputBorder _amberActiveInputBorder() {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.black,
    ),
  );
}

InputDecoration expenseTextAddInputDecor(String hint){
  return InputDecoration(
    enabledBorder: _expenseTextAddInputDecor(),
    focusedBorder: _expenseTextAddInputDecor(),
    labelText: hint,
    labelStyle: TextStyle(color: Colors.redAccent,),
  );
}

UnderlineInputBorder _expenseTextAddInputDecor() {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.redAccent,
    ),
  );
}