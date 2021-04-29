import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Exapmple2 extends StatefulWidget {
  @override
  _Exapmple2State createState() => _Exapmple2State();
}

class _Exapmple2State extends State<Exapmple2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: 90.w,
                height: 10.h,
                color: Colors.pinkAccent,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 30.w,
                      height: 10.h,
                      color: Colors.amberAccent,
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
