import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';

class SalesModel {
  final String userKey;
  final String totalSales;
  final String actualSales;
  final DateTime selectedDate;
  final DocumentReference reference;

  SalesModel.fromMap(Map<String, dynamic> map, this.userKey, {this.reference})
      : selectedDate = map[KEY_SELECTEDDATE],
        totalSales = map[KEY_TOTALSALES],
        actualSales = map[KEY_ACTUALSALES];

  SalesModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), snapshot.id,
      reference: snapshot.reference);

  static Map<String, dynamic> getMapForCreateSales(
      {String userKey,
        String selectedDate,
        String totalSales,
      String actualSales,}) {
    Map<String, dynamic> map = Map();
    map[KEY_USERKEY] = userKey;
    map[KEY_ACTUALSALES] =actualSales;
    map[KEY_SELECTEDDATE] = selectedDate;
    map[KEY_TOTALSALES] = totalSales;
    return map;
  }
}