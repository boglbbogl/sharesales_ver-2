import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sharesales_ver2/screen/store_detail_screen.dart';
import 'package:sizer/sizer.dart';

void showMaterialModalBottomSheetShareSalesConstantForm(context, {required widget, required duration, required height, required colors}){
  showMaterialModalBottomSheet(
    closeProgressThreshold: 5.0,
    elevation: 0,
    enableDrag: true,
    animationCurve: Curves.fastOutSlowIn,
    duration: duration,
    barrierColor: Colors.white12,
    backgroundColor: Colors.white12,
    context: context, builder: (BuildContext context){
     return GestureDetector(
       onTap: ()=> FocusScope.of(context).unfocus(),
       child: Container(
         height: height,
         decoration: BoxDecoration(
           color: colors,
           borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))
         ),
         child: widget,
       ),
     );
  });
}

void storeDetailWarningShowModalBottomSheetForm(context, {Color? backColors, Color? textColor}){
  showMaterialModalBottomSheet(
      closeProgressThreshold: 5.0,
      elevation: 0,
      enableDrag: true,
      animationCurve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 300),
      barrierColor: Colors.white12,
      backgroundColor: Colors.white12,
      context: context,
      builder: (BuildContext context){
        return Container(
          height: 20.h,
          child: Container(
            decoration: BoxDecoration(
              color: backColors,
              borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            ),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text('사업자 인증이 필요합니다', style: TextStyle(fontSize: 30,color: textColor),textAlign: TextAlign.center,),
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> StoreDetailScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('인증 하러가기  ', style: TextStyle(fontSize: 20,color: textColor),textAlign: TextAlign.center,),
                        Icon(Icons.double_arrow, color: textColor,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

void alertDialogForm(BuildContext context ,{String? confirmBtnText, String? title, String? text, required CoolAlertType type,
  required Color backColors, required Color confirmBtnColors, onConfirmBtnTap}) {
  CoolAlert.show(
    context: context,
    type: type,
    title: title!,
    text: text!,
    borderRadius: 20.0,
    loopAnimation: true,
    backgroundColor: backColors,
    confirmBtnColor: confirmBtnColors,
    confirmBtnText: confirmBtnText!,
    onConfirmBtnTap: onConfirmBtnTap,
  );

}