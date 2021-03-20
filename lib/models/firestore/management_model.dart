import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';

class ManagementModel {
  final String userKey;
  final int totalSales;
  final int actualSales;
  final int vos;
  final int vat;
  final int discount;
  final int creditCard;
  final int cash;
  final int cashReceipt;
  final int delivery;
  final int giftCard;
  final DateTime stdDate;
  final String selectedDate;
  final List<dynamic> expenseAddList;
  final int foodProvisionExpense;
  final int beverageExpense;
  final int alcoholExpense;
  final DocumentReference reference;

  ManagementModel.fromMap(Map<String, dynamic> map, this.userKey, {this.reference})
      // : selectedDate = (map[KEY_SELECTEDDATE] as Timestamp).toDate(),
      : stdDate = (map[KEY_STDDATE] as DateTime).toUtc(),
        selectedDate = map[KEY_SELECTEDDATE],
        totalSales = map[KEY_TOTALSALES],
        actualSales = map[KEY_ACTUALSALES],
        vos = map[KEY_VOS],
        vat = map[KEY_VAT],
        discount = map[KEY_DISCOUNT],
        creditCard = map[KEY_CREDITCARD],
        cash = map[KEY_CASH],
        cashReceipt = map[KEY_CASHRECEIPT],
        delivery = map[KEY_DELIVERY],
        giftCard = map[KEY_GIFTCARD],
        expenseAddList = map[KEY_EXPENSEADDLIST],
        foodProvisionExpense = map[KEY_FOODPROVISION],
        beverageExpense = map[KEY_BEVERAGE],
        alcoholExpense = map[KEY_ALCOHOL];

  ManagementModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), snapshot.id,
            reference: snapshot.reference);

  static Map<dynamic, dynamic> createMapForManagementList({
    String selectedDate,
    String userKey,
    DateTime stdDate,
    int totalSales,
    int actualSales,
    int vos,
    int vat,
    int discount,
    int creditCard,
    int cash,
    int cashReceipt,
    int delivery,
    int giftCard,
    List<dynamic> expenseAddList,
    int foodProvisionExpense,
    int beverageExpense,
    int alcoholExpense,
  }) {
    Map<String, dynamic> map = Map();
    map[KEY_USERKEY] = userKey;
    map[KEY_TOTALSALES] = totalSales;
    map[KEY_ACTUALSALES] = actualSales;
    map[KEY_VOS] = vos;
    map[KEY_VAT] = vat;
    map[KEY_DISCOUNT] = discount;
    map[KEY_CREDITCARD] = creditCard;
    map[KEY_CASH] = cash;
    map[KEY_CASHRECEIPT] = cashReceipt;
    map[KEY_DELIVERY] = delivery;
    map[KEY_GIFTCARD] = giftCard;
    map[KEY_SELECTEDDATE] = selectedDate;
    map[KEY_STDDATE] = stdDate;
    map[KEY_EXPENSEADDLIST] = expenseAddList;
    map[KEY_FOODPROVISION] = foodProvisionExpense;
    map[KEY_BEVERAGE] = beverageExpense;
    map[KEY_ALCOHOL] = alcoholExpense;
    return map;
  }
}
