import 'package:sizer/sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/snack_bar_style.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
import 'package:sharesales_ver2/widget/date_picker_create_form.dart';


class ManagementRepository {
  Future<void> createManagement(BuildContext context, UserModel userModel,
      Map<String, dynamic> managementData) async {

    final DocumentReference managementReference = FirebaseFirestore.instance.collection(COLLECTION_SALES_MANAGEMENT).doc(userModel.userKey)
    .collection(userModel.email!).doc(pickerDate.toUtc().toString().substring(0,10));
    final DocumentSnapshot managementSnapshot = await managementReference.get();

    String outputDate = pickerDate.toUtc().toString().substring(0,10);

    if (!managementSnapshot.exists) {
     await managementReference.set(managementData);
     Navigator.of(context).pop();
     snackBarFlashBarCreateManagementSuccessForm(context,
     massage: outputDate + ' 저장 완료',
   );
       print('Save success !!');
    } else if(managementSnapshot.exists){
      return snackBarFlashBarCreateManagementDatePickerWarning(context,
          massage: '날짜를 변경해 주세요',
          title: '이미 저장된 날짜 입니다',
          textColor:Colors.white,
          marginV : 5.h,
          marginH: 5.w,
          duration: 3000,
          backColors:Colors.deepOrange);
      print('Not Working !!');
    } else
      print('몰라');
  }
}

ManagementRepository managementRepository = ManagementRepository();