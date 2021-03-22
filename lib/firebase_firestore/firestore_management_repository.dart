
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
    .collection(userModel.userName).doc(pickerDate.toUtc().toString().substring(0,10));
    final DocumentSnapshot managementSnapshot = await managementReference.get();

    String outputDate = pickerDate.toUtc().toString().substring(0,10);

    if (!managementSnapshot.exists) {
     await managementReference.set(managementData);
     Navigator.of(context).pop();
     snackBarCreateManagementScreenTopFlushBarGreenForm(context, '$outputDate' + ' 저장 완료',);
       print('Save success !!');
    } else if(managementSnapshot.exists){
      snackBarCreateManagementScreenTopFlushBarAmberForm(context, '$outputDate' + '  저장 할 수 없습니다', '이미 존재하는 날짜입니다');
      print('Not Working !!');
    } else
      print('몰라');
  }

  Future<void> updateManagement(UserModel userModel,
      Map<String, dynamic> managementData) async{

    final DocumentReference managementReference = FirebaseFirestore.instance.collection(COLLECTION_SALES_MANAGEMENT).doc(userModel.userKey)
        .collection(userModel.userName).doc();
    final DocumentSnapshot managementSnapshot = await managementReference.get();

    if(!managementSnapshot.exists){
      print('저장이 안되네요');
    } managementReference.update(managementData);
  }

}

ManagementRepository managementRepository = ManagementRepository();