
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/app_bar.dart';
import 'package:sharesales_ver2/constant/change_library/change_month_strip_pub_dev.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
import 'package:sharesales_ver2/widget/management_screen_folding_cell_list.dart';
import 'package:sharesales_ver2/widget/my_progress_indicator.dart';
import 'create_management_screen.dart';

final koFormatMoney = NumberFormat.simpleCurrency(locale: "ko_KR", name: '', decimalDigits: 0);

class ManagementScreen extends StatefulWidget {

  @override
  _ManagementScreenState createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  TextEditingController _totalSalesController = TextEditingController();
  TextEditingController _actualSalesController = TextEditingController();
  TextEditingController _vosController = TextEditingController();
  TextEditingController _vatController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController _creditCardController = TextEditingController();
  TextEditingController _cashController = TextEditingController();
  TextEditingController _cashReceiptController = TextEditingController();
  TextEditingController _deliveryController = TextEditingController();
  TextEditingController _giftCardController = TextEditingController();
  TextEditingController _foodProvisionController = TextEditingController();
  TextEditingController _beverageController = TextEditingController();
  TextEditingController _alcoholController = TextEditingController();
  TextEditingController _editAddExpenseTitleController = TextEditingController();
  TextEditingController _editAddExpenseAmountController = TextEditingController();


  @override
  void dispose() {
    _totalSalesController.dispose();
    _actualSalesController.dispose();
    _vosController.dispose();
    _vatController.dispose();
    _discountController.dispose();
    _creditCardController.dispose();
    _cashController.dispose();
    _cashReceiptController.dispose();
    _deliveryController.dispose();
    _giftCardController.dispose();
    _foodProvisionController.dispose();
    _beverageController.dispose();
    _alcoholController.dispose();
    _editAddExpenseTitleController.dispose();
    _editAddExpenseAmountController.dispose();
    super.dispose();
  }

  DateTime pickerMonth = DateTime.now().toUtc();

  @override
  Widget build(BuildContext context) {

    UserModel userModel =
        Provider.of<UserModelState>(context, listen: false).userModel!;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(COLLECTION_SALES_MANAGEMENT)
          .doc(userModel.userKey)
          .collection(userModel.userName!).orderBy("stdDate", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if(!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
          return MyProgressIndicator();
        }

        final monthActualSalesTotalShow = [];
        final monthExpenseTotalShow = [];
        final monthAddExpenseList = [];

         snapshot.data!.docs.forEach((element)  {
           var docQuery = element.data();
           if(docQuery['selectedDate'].toString().substring(0, 7) == pickerMonth.toString().substring(0,7)) {
           List<dynamic> expenseAddListMapArray = docQuery['expenseAddList'];
           expenseAddListMapArray.forEach((element) {
             var monthExpenseAmount = element['expenseAmount'];
             int monthExpenseAmountIntType = int.parse(monthExpenseAmount.toString().replaceAll(",", ''));
             monthAddExpenseList.add(monthExpenseAmountIntType);
           });
            monthActualSalesTotalShow.add(docQuery['actualSales']);
            monthExpenseTotalShow.add(docQuery['foodProvisionExpense'] + docQuery['alcoholExpense'] + docQuery['beverageExpense'],);
          }
        });

         int monthChangeAddExpenseList = monthAddExpenseList.isEmpty ? int.parse('0') : monthAddExpenseList.reduce((v, e) => v + e);
         int monthChangeExpenseList = monthExpenseTotalShow.isEmpty ? int.parse('0') : monthExpenseTotalShow.reduce((v, e) => v + e);
         int monthTotalExpenseShowTextIntType = monthChangeAddExpenseList + monthChangeExpenseList;


        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: mainAppBar(context, 'share sales',null,IconButton(
            icon: Icon(
              Icons.create,
              color: Colors.deepPurpleAccent,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateManagementScreen()));
            },
          )),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _managementScreenMonthPicker(),
                Divider(color: Colors.black26,),
                _managementScreenMonthTotalSalesAndTotalExpense(monthActualSalesTotalShow, monthTotalExpenseShowTextIntType),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((snapshotData) {

                      final expenseAmountOnlyResult = [];
                      List<dynamic> expenseAddListInExpenseAmount = snapshotData.data()['expenseAddList'];
                      expenseAddListInExpenseAmount.forEach((element) {
                        var expenseAmount = element['expenseAmount'];
                        int expenseAmountIntType = int.parse(expenseAmount.toString().replaceAll(",", ''));
                        expenseAmountOnlyResult.add(expenseAmountIntType);
                      });

                      String formatPickerMonth = pickerMonth.toString().substring(0,7);
                      String fireStoreMonthFormat = snapshotData['selectedDate'].toString().substring(0, 7);

                      if(formatPickerMonth!=fireStoreMonthFormat){
                        return Container();
                      } else {
                        return ManagementScreenFoldingCellList(userModel, snapshotData, expenseAmountOnlyResult, _totalSalesController, _actualSalesController,
                            _vosController, _vatController, _discountController, _creditCardController, _cashController, _cashReceiptController,
                            _deliveryController, _giftCardController, _foodProvisionController, _beverageController, _alcoholController,
                            _editAddExpenseTitleController, _editAddExpenseAmountController);
                      }
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Container _managementScreenMonthPicker() {
    return Container(
      // width: size.width*0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
      ),
      child: MonthStrip(
        normalTextStyle: TextStyle(color: Colors.black26, fontSize: 17,),
        selectedTextStyle: TextStyle(color: Colors.deepPurple, fontSize: 22, fontWeight: FontWeight.bold),
        format: 'yyyy MM',
        from: DateTime(2000, 01),
        to: DateTime(2100, 01),
        height: size.height*0.04,
        viewportFraction: 0.4,
        onMonthChanged: (select){
          // if (select != null || pickerMonth != null) {
            setState(() {
              pickerMonth = select;
            });
          // } else {
          //   return MyProgressIndicator();
          // }
        },
        initialMonth: pickerMonth,
      ),
    );
  }

  Container _managementScreenMonthTotalSalesAndTotalExpense(List monthActualSalesTotalShow, int monthTotalExpenseShowTextIntType) {
    return Container(
      // width: size.width * 0.9,
      height: size.height * 0.05,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            '매출 : ' +
                koFormatMoney.format(monthActualSalesTotalShow.isEmpty
                    ? int.parse('0')
                    : monthActualSalesTotalShow.reduce((v, e) => v + e)),
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 17),
          ),
          Text(
            '지출 : ' +
                koFormatMoney.format(monthTotalExpenseShowTextIntType.isNaN
                    ? int.parse('0')
                    : monthTotalExpenseShowTextIntType),
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 17),
          ),
        ],
      ),
    );
  }
}