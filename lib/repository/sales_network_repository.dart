import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/repository/user_network_repository.dart';
import 'package:sharesales_ver2/widget/date_picker_cupertino.dart';


UserNetworkRepository userNetworkRepository;

final FirebaseAuth _auth = FirebaseAuth.instance;
  final User user =  _auth.currentUser;
  final uid = user.uid;
  // String unique = '${uid}_$pickerDate';

class SalesNetworkRepository {
  Future<Map<String, dynamic>> createSalesAdd(String userKey, Map<String, dynamic> salesData) async{
    final DocumentReference salesReference =
        FirebaseFirestore.instance.collection(COLLECTION_SALES).doc('${uid}_$pickerDate'.substring(0,39));
    final DocumentSnapshot salesSnapshot = await salesReference.get();
    final DocumentReference userReference =
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(salesData[KEY_USERKEY]);

    FirebaseFirestore.instance.runTransaction((Transaction tx) async{
      if(!salesSnapshot.exists){
         tx.set(salesReference, salesData);
      } else
        return '0' ;
    });
  }
}

SalesNetworkRepository salesNetworkRepository = SalesNetworkRepository();