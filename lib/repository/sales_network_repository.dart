
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/widget/date_picker_cupertino.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final User user =  _auth.currentUser;
String uid = user.uid.toString();
// String unique = '${uid}_$pickerDate';

class SalesNetworkRepository {
  Future<void> createSalesAdd(String userKey,
      Map<String, dynamic> salesData) async {
    final DocumentReference salesReference =
    FirebaseFirestore.instance.collection(COLLECTION_SALES).doc(
        // uid);
      // testKey(firebaseAuthState));
        '$pickerDate'.substring(0, 10) + '_$uid');

    final DocumentSnapshot salesSnapshot = await salesReference.get();
    if (!salesSnapshot.exists) {
      salesReference.set(salesData);
    }
  }
}

SalesNetworkRepository salesNetworkRepository = SalesNetworkRepository();