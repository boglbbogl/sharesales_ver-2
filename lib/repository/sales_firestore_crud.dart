import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/models/firestore/user_model.dart';
import 'package:sharesales_ver2/models/user_model_state.dart';
import 'package:sharesales_ver2/repository/user_network_repository.dart';
import 'package:sharesales_ver2/widget/date_picker_cupertino.dart';

class SalesFirestoreCrud extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    UserModel userModel = Provider.of<UserModelState>(context).userModel;

    Future<void> createSalesAdd(String userKey,
        Map<String, dynamic> salesData) async {
      final DocumentReference salesReference =
      FirebaseFirestore.instance.collection(COLLECTION_SALES).doc(
        // uid);
        // testKey(firebaseAuthState));
          '$pickerDate'.substring(0, 10) + userModel.userKey);

      final DocumentSnapshot salesSnapshot = await salesReference.get();
      if (!salesSnapshot.exists) {
        salesReference.set(salesData);
      }
      return createSalesAdd(userKey, salesData);
    }
  }
}
SalesFirestoreCrud get salesFirestoreCrud => SalesFirestoreCrud();
