import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/constant/size.dart';


class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {

  TextEditingController test1Controller = TextEditingController();
  TextEditingController test2Controller = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: salTtfHeightSize,
                width: salTtfWidthSize,
                child: TextFormField(
                  controller: test1Controller,
                  inputFormatters: [wonMaskFormatter],
                  style: blackInputStyle(),
                  cursorColor: Colors.white,
                  decoration: blackInputDecor('숫자입력'),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ),
              Container(
                height: salTtfHeightSize,
                width: salTtfWidthSize,
                child: TextFormField(
                  controller: test2Controller,
                  // inputFormatters: [wonMaskFormatter, FilteringTextInputFormatter.allow(RegExp("[1-9]"))],
                  inputFormatters: [wonMaskFormatter],
                  style: blackInputStyle(),
                  cursorColor: Colors.white,
                  decoration: blackInputDecor('숫자입력 2'),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ),
              Text(test1Controller.text,style: TextStyle(color: Colors.redAccent),),
              RaisedButton(
                  onPressed: (){
                    setState(() {

                    });
                  },
              child: Text('Write')
              ),
              RaisedButton(
                  onPressed: (){
                  },
                  child: Text('Update')
              ),
              RaisedButton(
                  onPressed: (){
                  },
                  child: Text('Read')
              ),
            ],
          ),
        ));
  }

  void intTypeWrite(){

  }

  void intTypeRead(){
  }
}
