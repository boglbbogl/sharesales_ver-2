import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';

class SalesModel {
  final String userKey;
  final String totalSales;
  final String actualSales;
  final DateTime selectedDate;
  final String foodProvisionExpense;
  final String beverageExpense;
  final String alcoholExpense;
  final DocumentReference reference;

  SalesModel.fromMap(Map<String, dynamic> map, this.userKey, {this.reference})
      : selectedDate = map[KEY_SELECTEDDATE],
        totalSales = map[KEY_TOTALSALES],
        actualSales = map[KEY_ACTUALSALES],
        foodProvisionExpense = map[KEY_FOODPROVISION],
        beverageExpense = map[KEY_BEVERAGE],
        alcoholExpense = map[KEY_ALCOHOL];

  SalesModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), snapshot.id,
            reference: snapshot.reference);

  static Map<String, dynamic> getMapForCreateSales({
    String userKey,
    String selectedDate,
    String totalSales,
    String actualSales,
    String foodProvisionExpense,
    String beverageExpense,
    String alcoholExpense,
  }) {
    Map<String, dynamic> map = Map();
    map[KEY_USERKEY] = userKey;
    map[KEY_ACTUALSALES] = actualSales;
    map[KEY_SELECTEDDATE] = selectedDate;
    map[KEY_TOTALSALES] = totalSales;
    map[KEY_FOODPROVISION] = foodProvisionExpense;
    map[KEY_BEVERAGE] = beverageExpense;
    map[KEY_ALCOHOL] = alcoholExpense;
    return map;
  }
}
