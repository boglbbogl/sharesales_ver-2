import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/models/firestore/sales_model.dart';

class SalesNetworkRepository {
  Future<void> createSalesAdd(String userKey, Map<String, dynamic> salesData) async{
    final DocumentReference salesReference =
        FirebaseFirestore.instance.collection(COLLECTION_SALES).doc(userKey);
    final DocumentSnapshot salesSnapshot = await salesReference.get();
    final DocumentReference userReference =
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(salesData[KEY_USERKEY]);

  }
}

SalesNetworkRepository salesNetworkRepository = SalesNetworkRepository();