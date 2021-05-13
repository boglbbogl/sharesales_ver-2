import 'dart:ui';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
          position: FlashPosition.top,
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

void snackBarFlashBarExpenseAddForm(context,
    {String? massage,
      }){
  showFlash(
      duration: Duration(milliseconds: 1500),
      context: context,
      builder: (context, controller){
        return Flash(
          position: FlashPosition.bottom,
          margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
          backgroundColor: Colors.green,
          borderRadius: BorderRadius.circular(20),
          style: FlashStyle.floating,
          controller: controller,
          child: FlashBar(
            message: Text(massage!, style: TextStyle(color: Colors.white, fontSize: 18),textAlign: TextAlign.center,),
            // title: Text(title!, style: TextStyle(color: textColor, fontSize: 18),textAlign: TextAlign.center,),
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




