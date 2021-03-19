import 'package:cloud_firestore/cloud_firestore.dart';
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
                      intTypeWrite();
                      test1Controller.clear();
                      test2Controller.clear();
                    });
                  },
              child: Text('Write')
              ),
              RaisedButton(
                  onPressed: (){
                    print(int.parse('0'));
                  },
                  child: Text('Update')
              ),
              RaisedButton(
                  onPressed: (){
                    intTypeRead();
                  },
                  child: Text('Read')
              ),
            ],
          ),
        ));
  }

  void intTypeWrite(){
    FirebaseFirestore.instance.collection('test').doc().set({
      '테스트': int.parse(test1Controller.text.replaceAll(',', "")),
      '테스트 2' : int.parse(test2Controller.text.replaceAll(',', "")),
      '테스트 3' : int.parse(test1Controller.text.replaceAll(',', "")) + int.parse(test2Controller.text.replaceAll(',', "")),
    });
  }

  void intTypeRead(){
    FirebaseFirestore.instance.collection('test').get().then((value) {
      value.docs.forEach((element) {
        var test = element.data()['테스트'];
        print(test);
        String test2 =  test;
        print(test2);

      });
    });
  }
}
