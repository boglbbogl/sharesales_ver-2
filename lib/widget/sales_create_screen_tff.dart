import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';

class SalesCreateScreenTff extends StatefulWidget {
  @override
  _SalesCreateScreenTffState createState() => _SalesCreateScreenTffState();
}

class _SalesCreateScreenTffState extends State<SalesCreateScreenTff> {
  @override
  Widget build(BuildContext context) {

    final tffSizeHeight = MediaQuery.of(context).size.width * 0.19;
    final tffSizeWidth = MediaQuery.of(context).size.width * 0.35;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: tffSizeHeight,
              width: tffSizeWidth,
              child: TextFormField(
                validator: _salesInputValidator,
                style: blackInputStyle(),
                cursorColor: Colors.white,
                decoration: blackInputDecor('실제매출'),
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              height: tffSizeHeight,
              width: tffSizeWidth,
              child: TextFormField(
                style: blackInputStyle(),
                cursorColor: Colors.white,
                decoration: blackInputDecor(''),
                keyboardType: TextInputType.number,
                validator: _salesInputValidator,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: tffSizeHeight,
              width: tffSizeWidth,
              child: TextFormField(
                style: blackInputStyle(),
                cursorColor: Colors.white,
                decoration: blackInputDecor('총매출'),
                keyboardType: TextInputType.number,
                validator: _salesInputValidator,
              ),
            ),
            Container(
              height: tffSizeHeight,
              width: tffSizeWidth,
              child: TextFormField(
                style: blackInputStyle(),
                cursorColor: Colors.white,
                decoration: blackInputDecor('할인'),
                keyboardType: TextInputType.number,
                validator: _salesInputValidator,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: tffSizeHeight,
              width: tffSizeWidth,
              child: TextFormField(
                style: blackInputStyle(),
                cursorColor: Colors.white,
                decoration: blackInputDecor('공급가액'),
                keyboardType: TextInputType.number,
                validator: _salesInputValidator,
              ),
            ),
            Container(
              height: tffSizeHeight,
              width: tffSizeWidth,
              child: TextFormField(
                style: blackInputStyle(),
                cursorColor: Colors.white,
                decoration: blackInputDecor('세액'),
                keyboardType: TextInputType.number,
                validator: _salesInputValidator,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: tffSizeHeight,
              width: tffSizeWidth,
              child: TextFormField(
                style: blackInputStyle(),
                cursorColor: Colors.white,
                decoration: blackInputDecor('배달'),
                keyboardType: TextInputType.number,
                validator: _salesInputValidator,
              ),
            ),
            Container(
              height: tffSizeHeight,
              width: tffSizeWidth,
              child: TextFormField(
                style: blackInputStyle(),
                cursorColor: Colors.white,
                decoration: blackInputDecor('신용카드'),
                keyboardType: TextInputType.number,
                validator: _salesInputValidator,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: tffSizeHeight,
              width: tffSizeWidth,
              child: TextFormField(
                style: blackInputStyle(),
                cursorColor: Colors.white,
                decoration: blackInputDecor('현금'),
                keyboardType: TextInputType.number,
                validator: _salesInputValidator,
              ),
            ),
            Container(
              height: tffSizeHeight,
              width: tffSizeWidth,
              child: TextFormField(
                style: blackInputStyle(),
                cursorColor: Colors.white,
                decoration: blackInputDecor('현금영수증'),
                keyboardType: TextInputType.number,
                validator: _salesInputValidator,
              ),
            ),
          ],
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
