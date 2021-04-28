import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sizer/sizer.dart';


class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 90.w,
        height: 20.h,
        color: Colors.redAccent,
        child: Text('sdklfjsdlkjf',style: TextStyle(fontSize: 20.sp),),
      ),
    );
  }
}
