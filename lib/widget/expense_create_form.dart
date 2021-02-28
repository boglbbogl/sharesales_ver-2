import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/widget/text_add_form.dart';

class ExpenseCreateForm extends StatefulWidget {
  final int index;

  const ExpenseCreateForm({Key key, this.index}) : super(key: key);

  @override
  _ExpenseCreateFormState createState() => _ExpenseCreateFormState();
}

class _ExpenseCreateFormState extends State<ExpenseCreateForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _expenseTextForm('식자재', '음료', '주류'),
          Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Text('추가하기',
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),),
                  SizedBox(
                    height: 20,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          height: 1,
                          width: size.width * 0.9,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            color: Colors.white,
                            height: 1,
                            width: size.width * 0.9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          TextAddForm(),
        ]);
  }

  Row _expenseTextForm(String startText, String centerText, String endText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: expTtfHeightSize,
          width: expTtfWidthSize,
          child: TextFormField(
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
