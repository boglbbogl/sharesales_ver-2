import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';

class SalesModel {
  final String userKey;
  final String totalSales;
  final DocumentReference reference;

  SalesModel.fromMap(Map<String, dynamic> map, this.userKey, {this.reference})
      : totalSales = map[KEY_TOTALSALES];

  SalesModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
      snapshot.data(),
      snapshot.id,
      reference: snapshot.reference
  );

  static Map<String, dynamic> getMapForCreateSales({String userKey, String totalSales, String actualSales}){
    Map<String, dynamic> map = Map();
    map[KEY_USERKEY] = userKey;
    map[KEY_TOTALSALES] = totalSales;
    map[KEY_ACTUALSALES] = actualSales;
    return map;
  }
}
