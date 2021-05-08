import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:sharesales_ver2/screen/store_detail_screen.dart';

void alertDialogForm(BuildContext context ,{String? confirmBtnText, String? title, String? text, required CoolAlertType type,
  required Color backColors, required Color confirmBtnColors, onConfirmBtnTap}) {
  CoolAlert.show(
    context: context,
    type: type,
    title: title!,
    text: text!,
    showCancelBtn: true,
    cancelBtnText: '닫기',
    borderRadius: 20.0,
    loopAnimation: true,
    backgroundColor: backColors,
    confirmBtnColor: confirmBtnColors,
    confirmBtnText: confirmBtnText!,
    onConfirmBtnTap: onConfirmBtnTap,
    onCancelBtnTap: ()=>Navigator.of(context).pop(),
  );

  void _test(BuildContext context) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      title: '미등록',
      text: '사업자 인증 후 이용해 주세요',
      showCancelBtn: true,
      cancelBtnText: '닫기',
      borderRadius: 20.0,
      loopAnimation: true,
      backgroundColor: Colors.cyan,
      confirmBtnColor: Colors.cyan,
      confirmBtnText: '등록하기',
      onConfirmBtnTap: (){
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (context)=> StoreDetailScreen()));
      },
      onCancelBtnTap: ()=>Navigator.of(context).pop(),
    );
  }
}