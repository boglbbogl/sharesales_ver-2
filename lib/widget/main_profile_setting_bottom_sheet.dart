import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/alert_dialog_and_bottom_sheet_form.dart';
import 'package:sharesales_ver2/firebase_auth/firebase_auth_state.dart';
import 'package:sizer/sizer.dart';

void mainProfileSettingBottomSheet(context){
  showMaterialModalBottomSheetShareSalesConstantForm(
    context,  duration: Duration(milliseconds: 300), height: 30.h, colors: Colors.black,
    widget: ListView(
      children: <Widget>[
        _profileScreenSettingListView(title: '탈퇴하기', icon: Icons.delete_forever_sharp, onTap: (){
          Navigator.of(context).pop();
          alertDialogForm(context, type: CoolAlertType.error, backColors: Colors.black, confirmBtnColors: Colors.black,
              title: '탈퇴 하시겠습니까 ?', text: '', confirmBtnText: '탈퇴하기', onConfirmBtnTap: (){});
        }),
        Divider(height: 0.2.h,color: Colors.white12,),
        _profileScreenSettingListView(title: '로그아웃', icon: Icons.logout, onTap: (){
          Navigator.of(context).pop();
          alertDialogForm(context, type: CoolAlertType.warning, title: '로그아웃 하시겠습니까 ?', text: '', confirmBtnText: '로그아웃',
              backColors: Colors.pinkAccent, confirmBtnColors: Colors.pinkAccent, onConfirmBtnTap: (){
                Navigator.of(context).pop();
                Provider.of<FirebaseAuthState>(context, listen: false)
                    .signOut();
              });
        }),
        Divider(height: 0.2.h,color: Colors.white12,),
        _profileScreenSettingListView(title: '문의하기', icon: Icons.email, onTap: (){
        }),
      ],
    ),
  );
}
Padding _profileScreenSettingListView({required onTap, required String title, required icon}) {
  return Padding(
    padding: const EdgeInsets.only(left: 30),
    child: ListTile(
      onTap: onTap,
      horizontalTitleGap: 30,
      title: Text(title,style: TextStyle(color: Colors.white),
      ),
      leading: Icon(icon, color: Colors.white,),
    ),
  );
}

