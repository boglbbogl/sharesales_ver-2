import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/constant/size.dart';

class ExpenseCreateForm extends StatefulWidget {
  @override
  _ExpenseCreateFormState createState() => _ExpenseCreateFormState();
}

class _ExpenseCreateFormState extends State<ExpenseCreateForm> {
  final tffSizeHeight = size.width * 0.19;
  final tffSizeWidth = size.width * 0.40;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _expenseTextForm('식자재..1', '식자재..2'),
        _expenseTextForm('주류', '음료'),
        Container(
          height: tffSizeHeight,
          width: tffSizeWidth,
          child: TextFormField(
            style: blackInputStyle(),
            cursorColor: Colors.white,
            decoration: expenseInputDecor('Add..'),
          ),
        ),
      ],
    );
  }

  Row _expenseTextForm(String leftText, String rightText) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: tffSizeHeight,
            width: tffSizeWidth,
            child: TextFormField(
              style: blackInputStyle(),
              cursorColor: Colors.white,
              decoration: expenseInputDecor(leftText),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
          ),
          Container(
            height: tffSizeHeight,
            width: tffSizeWidth,
            child: TextFormField(
              style: blackInputStyle(),
              cursorColor: Colors.white,
              decoration: expenseInputDecor(rightText),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
          ),
        ],
      );
  }
}
