import 'dart:ui';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sharesales_ver2/constant/size.dart';

TextStyle snackBarStyle() {
  return TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    fontSize: 18,
  );
}

void snackBarFlashBarCreateManagementSuccessForm(context,
    {String? massage,
    }){
  showFlash(
      duration: Duration(milliseconds: 2000),
      context: context,
      builder: (context, controller){
        return Flash(
          position: FlashPosition.bottom,
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.h),
          backgroundColor: Colors.black45,
          borderRadius: BorderRadius.circular(20),
          style: FlashStyle.floating,
          controller: controller,
          child: FlashBar(
            message: Text(massage!, style: TextStyle(color: Colors.white, fontSize: 22),textAlign: TextAlign.center,),
          ),);
      });
}

void snackBarFlashBarCreateManagementDatePickerWarning(context,
    {String? massage,
      String? title,
      Color? textColor,
      double? marginV,
      double? marginH,
      int? duration,
      Color? backColors}){
  showFlash(
      duration: Duration(milliseconds: duration!),
      context: context,
      builder: (context, controller){
        return Flash(
          position: FlashPosition.top,
          margin: EdgeInsets.symmetric(vertical: marginV!, horizontal: marginH!),
          backgroundColor: backColors!,
          borderRadius: BorderRadius.circular(20),
          style: FlashStyle.floating,
          controller: controller,
          child: FlashBar(
            message: Text(massage!, style: TextStyle(color: textColor!, fontSize: 22),textAlign: TextAlign.center,),
            title: Text(title!, style: TextStyle(color: textColor, fontSize: 18),textAlign: TextAlign.center,),
          ),);
      });
}

void snackBarFlashBarCreateAuthStateForm(context,
    {String? massage,
    Color? textColor,
    double? marginV,
    double? marginH,
      int? duration,
    Color? backColors}){
  showFlash(
      duration: Duration(milliseconds: duration!),
      context: context,
      builder: (context, controller){
        return Flash(
          position: FlashPosition.top,
          margin: EdgeInsets.symmetric(vertical: marginV!, horizontal: marginH!),
          backgroundColor: backColors!,
          borderRadius: BorderRadius.circular(20),
          style: FlashStyle.floating,
          controller: controller,
          child: FlashBar(
            progressIndicatorBackgroundColor: backColors,
            message: Text(massage!, style: TextStyle(color: textColor!, fontSize: 22),textAlign: TextAlign.center,),
          ),);
      });
}

void snackBarManagementScreenTopFlushBar(BuildContext context, String title, String message) {
  // Flushbar(
  //   flushbarPosition: FlushbarPosition.TOP,
  //   padding: EdgeInsets.all(20),
  //   duration: Duration(milliseconds: 1500),
  //   margin: EdgeInsets.all(50),
  //   borderRadius: 12,
  //   backgroundGradient: LinearGradient(
  //     colors: [Colors.green.shade800, Colors.lightGreenAccent.shade700],
  //     stops: [0.6, 1],
  //   ),
  //   boxShadows: [
  //     BoxShadow(
  //       color: Colors.black45,
  //       offset: Offset(3, 3),
  //       blurRadius: 3,
  //     ),
  //   ],
  //   dismissDirection: FlushbarDismissDirection.HORIZONTAL,
  //   forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
  //   title: title,
  //   message: message,
  // )..show(context);
}

void snackBarCreateManagementScreenTopFlushBarAmberForm(BuildContext context, String title, String message) {
  // Flushbar(
  //   flushbarPosition: FlushbarPosition.BOTTOM,
  //   padding: EdgeInsets.all(20),
  //   duration: Duration(milliseconds: 4000),
  //   margin: EdgeInsets.all(50),
  //   borderRadius: 12,
  //   backgroundGradient: LinearGradient(
  //     colors: [Colors.orange.shade800, Colors.amberAccent.shade700],
  //     stops: [0.6, 1],
  //   ),
  //   boxShadows: [
  //     BoxShadow(
  //       color: Colors.black45,
  //       offset: Offset(3, 3),
  //       blurRadius: 3,
  //     ),
  //   ],
  //   dismissDirection: FlushbarDismissDirection.HORIZONTAL,
  //   forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
  //   title: title,
  //   message: message,
  // )..show(context);
}

void snackBarCreateManagementScreenTopFlushBarGreenForm(BuildContext context, String title) {
  // Flushbar(
  //   flushbarPosition: FlushbarPosition.BOTTOM,
  //   padding: EdgeInsets.all(20),
  //   duration: Duration(milliseconds: 2000),
  //   margin: EdgeInsets.all(50),
  //   borderRadius: 12,
  //   backgroundGradient: LinearGradient(
  //     colors: [Colors.green.shade800, Colors.lightGreenAccent.shade700],
  //     stops: [0.6, 1],
  //   ),
  //   boxShadows: [
  //     BoxShadow(
  //       color: Colors.black45,
  //       offset: Offset(3, 3),
  //       blurRadius: 3,
  //     ),
  //   ],
  //   dismissDirection: FlushbarDismissDirection.HORIZONTAL,
  //   forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
  //   title: title,
  //   message: '  ',
  // )..show(context);
}

void snackBarDatePickerMiddleFlushBarRedForm(BuildContext context, String title, String message) {
  // Flushbar(
  //   flushbarPosition: FlushbarPosition.TOP,
  //   padding: EdgeInsets.all(20),
  //   duration: Duration(milliseconds: 1000),
  //   margin: EdgeInsets.only(left: 50, right: 50, top: size.height*0.4),
  //   borderRadius: 12,
  //   backgroundGradient: LinearGradient(
  //     colors: [Colors.deepOrange.shade800, Colors.red.shade700],
  //     stops: [0.6, 1],
  //   ),
  //   boxShadows: [
  //     BoxShadow(
  //       color: Colors.black45,
  //       offset: Offset(3, 3),
  //       blurRadius: 3,
  //     ),
  //   ],
  //   dismissDirection: FlushbarDismissDirection.HORIZONTAL,
  //   forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
  //   title: title,
  //   message: message,
  // )..show(context);
}