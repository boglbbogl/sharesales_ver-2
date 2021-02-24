import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/constant/size.dart';

class SalesCreateForm extends StatefulWidget {
  @override
  _SalesCreateFormState createState() => _SalesCreateFormState();
}

class _SalesCreateFormState extends State<SalesCreateForm> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _createTextForm('총매출','실제매출'),
        _createTextForm('공급가액','세액'),
        _createTextForm('할인','신용카드'),
        _createTextForm('현금','현금영수증'),
        _createTextForm('Delivery','Gift Card'),
      ],
    );
  }

  Row _createTextForm(String leftText, String rightText) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            height: salTtfHeightSize,
            width: salTtfWidthSize,
            child: TextFormField(
              validator: _salesInputValidator,
              style: blackInputStyle(),
              cursorColor: Colors.white,
              decoration: blackInputDecor(leftText),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
          ),
          Container(
            height: salTtfHeightSize,
            width: salTtfWidthSize,
            child: TextFormField(
              validator: _salesInputValidator,
              style: blackInputStyle(),
              cursorColor: Colors.white,
              decoration: blackInputDecor(rightText),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
          ),
        ],
      );
  }


  String _salesInputValidator(text) {
    if (text.isEmpty) {
      return '필수로 입력하여야 합니다.';
    } else
      return null;
  }
}
