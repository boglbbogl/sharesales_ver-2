import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/models/firestore/sales_model.dart';
import 'package:sharesales_ver2/repository/helper/transformers.dart';
import 'package:sharesales_ver2/repository/user_network_repository.dart';
import 'package:sharesales_ver2/widget/date_picker_cupertino.dart';


UserNetworkRepository userNetworkRepository;

final FirebaseAuth _auth = FirebaseAuth.instance;
final User user =  _auth.currentUser;
final uid = user.uid;
// String unique = '${uid}_$pickerDate';

class SalesNetworkRepository with Transformers{
  Future<void> createSalesAdd(String userKey,
      Map<String, dynamic> salesData) async {
    final DocumentReference salesReference =
    FirebaseFirestore.instance.collection(COLLECTION_SALES).doc(
        '$pickerDate'.substring(0, 10) + '_$uid');
    // FirebaseFirestore.instance.collection(COLLECTION_SALES).doc(uid).collection(COLLECTION_SALES).doc('$pickerDate');

    final DocumentSnapshot salesSnapshot = await salesReference.get();
    if (!salesSnapshot.exists) {
      salesReference.set(salesData);
    } 
  }
}

SalesNetworkRepository salesNetworkRepository = SalesNetworkRepository();