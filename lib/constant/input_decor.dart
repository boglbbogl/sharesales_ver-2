import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:sizer/sizer.dart';


final wonMaskFormatter = MoneyInputFormatter(
  thousandSeparator: ThousandSeparator.None,
  mantissaLength: 0,
  maxTextLength: 0,
);

// var wonMaskFormatter = new MaskTextInputFormatter(
//     mask: '###,###,###,###,##');

TextStyle salesInputStyle(){
  return TextStyle(
    fontSize: 15,
    color: Colors.black54,
  );
}

TextStyle pinkInputStyle(){
  return TextStyle(
    color: Colors.white,
  );
}

InputDecoration editAddExpenseInputDecor(String hint){
  return InputDecoration(
    enabledBorder: _editAddExpenseInputDecor(),
    focusedBorder: _editAddExpenseInputDecor(),
    labelText: hint,
    labelStyle: TextStyle(color: Colors.pink,),
  );
}
UnderlineInputBorder _editAddExpenseInputDecor() {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.pink,
    ),
  );
}



InputDecoration expenseInputDecor(String hint){
  return InputDecoration(
    enabledBorder: _expenseInputDecor(),
    focusedBorder: _expenseInputDecor(),
    labelText: hint,
      labelStyle: TextStyle(color: Colors.pink,),
  );
}

OutlineInputBorder _expenseInputDecor() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(
      color: Colors.pink,
    ),
  );
}

InputDecoration expenseChangeInputDecor(String hint){
  return InputDecoration(
    enabledBorder: _expenseInputDecor(),
    focusedBorder: _expenseInputDecor(),
    labelText: hint,
    labelStyle: TextStyle(color: Colors.pink,),
  );
}

InputDecoration salesChangeInputDecor(String hint) {
  return InputDecoration(
    enabledBorder: _blackActiveInputBorder(),
    focusedBorder: _blackActiveInputBorder(),
    errorBorder: _blackErrorInputBorder(),
    focusedErrorBorder: _blackErrorInputBorder(),
    labelText: hint,
    labelStyle: TextStyle(color: Colors.deepPurple),

  );
}
InputDecoration storeDetailScreenInputDecor(String label, String hint){
  return InputDecoration(
    enabledBorder: _storeDetailScreenActiveInputDecor(Colors.cyan.shade500),
    focusedBorder: _storeDetailScreenActiveInputDecor(Colors.cyan.shade500),
    errorBorder: _storeDetailScreenErrorInputDecor(),
    labelText: label,
    hintText: hint,
    alignLabelWithHint: true,
    labelStyle: TextStyle(color: Colors.cyan,),
  );
}

UnderlineInputBorder _storeDetailScreenErrorInputDecor() {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.pink,
    ),
  );
}

UnderlineInputBorder _storeDetailScreenActiveInputDecor(Color colors) {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: colors,
    ),
  );
}

InputDecoration blackInputDecor(String hint) {
  return InputDecoration(
    enabledBorder: _blackActiveInputBorder(),
    focusedBorder: _blackActiveInputBorder(),
    errorBorder: _blackErrorInputBorder(),
    focusedErrorBorder: _blackErrorInputBorder(),
    labelText: hint,
    labelStyle: TextStyle(color: Colors.deepPurple),
  );
}

UnderlineInputBorder _blackErrorInputBorder() {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.pink,
    ),
  );
}

UnderlineInputBorder _blackActiveInputBorder() {
  return UnderlineInputBorder(
    borderSide: BorderSide(
        color: Colors.deepPurple,
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
    labelStyle: TextStyle(color: Colors.pink,),
  );
}

UnderlineInputBorder _expenseTextAddInputDecor() {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.pink,
    ),
  );
}