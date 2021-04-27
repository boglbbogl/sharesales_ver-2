import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';

class ExpenseModel {
  final String userKey;
  final List<dynamic>? expenseAddList;
  final String? foodProvisionExpense;
  final String? beverageExpense;
  final String? alcoholExpense;
  final DocumentReference? reference;

  ExpenseModel.fromMap(Map<String, dynamic> map, this.userKey, {this.reference})
      : expenseAddList = map[KEY_EXPENSEADDLIST],
        foodProvisionExpense = map[KEY_FOODPROVISION],
        beverageExpense = map[KEY_BEVERAGE],
        alcoholExpense = map[KEY_ALCOHOL];

  ExpenseModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data()!, snapshot.id,
      reference: snapshot.reference);

  static Map<String, dynamic> updateMapForManagementList({
    List<dynamic>? expenseAddList,
    String? foodProvisionExpense,
    String? beverageExpense,
    String? alcoholExpense,
  }) {
    Map<String, dynamic> map = Map();
    map[KEY_EXPENSEADDLIST] = expenseAddList;
    map[KEY_FOODPROVISION] = foodProvisionExpense;
    map[KEY_BEVERAGE] = beverageExpense;
    map[KEY_ALCOHOL] = alcoholExpense;
    return map;
  }
}
