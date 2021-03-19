import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';

class SalesModel {
  final String userKey;
  final int totalSales;
  final int actualSales;
  final DateTime stdDate;
  final String selectedDate;
  final List<dynamic> expenseAddList;
  final List<int> expenseAddListAmount;
  final int foodProvisionExpense;
  final int beverageExpense;
  final int alcoholExpense;
  final DocumentReference reference;

  SalesModel.fromMap(Map<String, dynamic> map, this.userKey, {this.reference})
      // : selectedDate = (map[KEY_SELECTEDDATE] as Timestamp).toDate(),
      : stdDate = (map[KEY_STDDATE] as DateTime).toUtc(),
        selectedDate = map[KEY_SELECTEDDATE],
        totalSales = map[KEY_TOTALSALES],
        actualSales = map[KEY_ACTUALSALES],
        expenseAddList = map[KEY_EXPENSEADDLIST],
        expenseAddListAmount = map[KEY_EXPENSEADDLISTAMOUNT],
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
    int totalSales,
    int actualSales,
    List<dynamic> expenseAddList,
    List<int> expenseAddListAmount,
    int foodProvisionExpense,
    int beverageExpense,
    int alcoholExpense,
  }) {
    Map<String, dynamic> map = Map();
    map[KEY_USERKEY] = userKey;
    map[KEY_ACTUALSALES] = actualSales;
    map[KEY_SELECTEDDATE] = selectedDate;
    map[KEY_STDDATE] = stdDate;
    map[KEY_TOTALSALES] = totalSales;
    map[KEY_EXPENSEADDLIST] = expenseAddList;
    map[KEY_EXPENSEADDLISTAMOUNT] = expenseAddListAmount;
    map[KEY_FOODPROVISION] = foodProvisionExpense;
    map[KEY_BEVERAGE] = beverageExpense;
    map[KEY_ALCOHOL] = alcoholExpense;
    return map;
  }
}
