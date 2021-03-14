import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/constant/test_widget/text_add_form.dart';

import 'expense_text_add_create_form.dart';

class ExpenseCreateForm extends StatelessWidget {
  final int index;

  const ExpenseCreateForm(
      {Key key,
      this.index,
      TextEditingController foodprovisionsController,
      TextEditingController beverageController,
      TextEditingController alcoholController})
      : _foodprovisionsController = foodprovisionsController,
        _beverageController = beverageController,
        _alcoholController = alcoholController,
        super(key: key);

  final TextEditingController _foodprovisionsController;
  final TextEditingController _beverageController;
  final TextEditingController _alcoholController;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _expenseTextForm('식자재', '음료', '주류', _foodprovisionsController,
              _beverageController, _alcoholController),
          ExpenseTextAddCreateForm(),
        ]);
  }

  Row _expenseTextForm(
      String startText,
      String centerText,
      String endText,
      TextEditingController startController,
      TextEditingController centerController,
      TextEditingController endController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: expTtfHeightSize,
          width: expTtfWidthSize,
          child: TextFormField(
            controller: startController,
            inputFormatters: [wonMaskFormatter],
            style: blackInputStyle(),
            cursorColor: Colors.white,
            decoration: expenseInputDecor(startText),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
        ),
        Container(
          height: expTtfHeightSize,
          width: expTtfWidthSize,
          child: TextFormField(
            controller: centerController,
            inputFormatters: [wonMaskFormatter],
            style: blackInputStyle(),
            cursorColor: Colors.white,
            decoration: expenseInputDecor(centerText),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
        ),
        Container(
          height: expTtfHeightSize,
          width: expTtfWidthSize,
          child: TextFormField(
            controller: endController,
            inputFormatters: [wonMaskFormatter],
            style: blackInputStyle(),
            cursorColor: Colors.white,
            decoration: expenseInputDecor(endText),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
        ),
      ],
    );
  }
}
