import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sharesales_ver2/constant/size.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {

  PageController pageController = PageController(viewportFraction: 0.8, initialPage: 0);

  bool test = true;
  bool test2 = true;

  var now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TEST'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(DateTime.now().toString().substring(0,7)),
            Text(DateTime(now.year, now.month-4).toString().substring(0,7)),
            Container(width: MediaQuery.of(context).size.width*0.9, height: size.height*0.2, color: Colors.redAccent),
            Container(width: size.width*0.9, height: size.height*0.2, color: Colors.amberAccent,),
            Container(
              height: size.height*0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.deepPurple[100],
              ),
              child: Column(
                children: [
                  Container(
                    height: size.height*0.05,
                    child: Row(
                      children: <Widget>[
                    Container(width: size.width*0.25,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,

                      ),
                      child: Center(child: Text('dsfds',style: TextStyle(color: Colors.white),),),
                    ),
                        Container(
                            width: size.width*0.55,
                            child: Center(
                                child: Text('21321'))),
                      ],
                    ),),
                  Container(
                    height: size.height*0.05,
                    child: Row(
                      children: [
                    Container(width: size.width*0.25,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,

                      ),
                      child: Center(child: Text('dsf',style: TextStyle(color: Colors.white),),),
                    ),
                        Container(
                            width: size.width*0.55,
                            child: Text('123213')),
                      ],
                    ),),
                ],
              ),
            ),
            InkWell(child: Text('sdfsdfsdf', style: TextStyle(fontSize: 40),),
            onTap: (){showMaterialModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                closeProgressThreshold: 5.0,
                elevation: 90.0,
                animationCurve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: 1500),
                barrierColor: Colors.black54,
                backgroundColor: Colors.deepOrangeAccent,
                context: context,
                builder: (BuildContext context){
                  return Container(
                    height: size.height*0.5,
                  );
                });},),
          ],
        ),
      ),
    );
  }
}
