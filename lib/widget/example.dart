import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                  // inputFormatters: [wonMaskFormatter],
                  style: blackInputStyle(),
                  cursorColor: Colors.white,
                  decoration: blackInputDecor('숫자입력 2'),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ),
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
                    print(currencyFormat(1000000));
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
  static String currencyFormat(int price){
    final formatCurrency = NumberFormat.simpleCurrency(locale: "ko_KR", name: "", decimalDigits: 0,);
        return formatCurrency.format(price);
  }

  void intTypeWrite(){
    FirebaseFirestore.instance.collection('test').doc().set({
      '테스트': test1Controller.text,
      '테스트 2' : test2Controller.text,
      '테스트 3' : test1Controller.text + test2Controller.text,
    });
  }

  void intTypeRead(){
    FirebaseFirestore.instance.collection('test').get().then((value) {
      value.docs.forEach((element) {
        var test = element.data()['테스트'];
        int test2 = int.parse(test).toInt();
        print(test2);
        int testsu = test2+test2;
        print(testsu);
      });
    });
  }
}
