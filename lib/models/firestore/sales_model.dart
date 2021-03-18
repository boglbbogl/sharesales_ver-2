import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';

class SalesModel {
  final String userKey;
  final String totalSales;
  final String actualSales;
  final DateTime stdDate;
  final String selectedDate;
  final List<dynamic> expenseAddList;
  final String foodProvisionExpense;
  final String beverageExpense;
  final String alcoholExpense;
  final DocumentReference reference;

  SalesModel.fromMap(Map<String, dynamic> map, this.userKey, {this.reference})
      // : selectedDate = (map[KEY_SELECTEDDATE] as Timestamp).toDate(),
      : stdDate = (map[KEY_STDDATE] as DateTime).toUtc(),
        selectedDate = map[KEY_SELECTEDDATE],
        totalSales = map[KEY_TOTALSALES],
        actualSales = map[KEY_ACTUALSALES],
  expenseAddList = map[KEY_EXPENSEADDLIST],
        foodProvisionExpense = map[KEY_FOODPROVISION],
        beverageExpense = map[KEY_BEVERAGE],
        alcoholExpense = map[KEY_ALCOHOL];

  SalesModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), snapshot.id,
            reference: snapshot.reference);

  static Map<dynamic, dynamic> createMapForManagementList({
    String selectedDate,
    String userKey,
    DateTime stdDate,
    String totalSales,
    String actualSales,
    List<dynamic> expenseAddList,
    String foodProvisionExpense,
    String beverageExpense,
    String alcoholExpense,
  }) {
    Map<String, dynamic> map = Map();
    map[KEY_USERKEY] = userKey;
    map[KEY_ACTUALSALES] = actualSales;
    map[KEY_SELECTEDDATE] = selectedDate;
    map[KEY_STDDATE] = stdDate;
    map[KEY_TOTALSALES] = totalSales;
    map[KEY_EXPENSEADDLIST] = expenseAddList;
    map[KEY_FOODPROVISION] = foodProvisionExpense;
    map[KEY_BEVERAGE] = beverageExpense;
    map[KEY_ALCOHOL] = alcoholExpense;
    return map;
  }
}
