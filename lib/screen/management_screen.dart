
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/app_bar.dart';
import 'package:sharesales_ver2/constant/change_library/change_month_strip_pub_dev.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/constant/snack_bar_style.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
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
        Provider.of<UserModelState>(context, listen: false).userModel;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(COLLECTION_SALES_MANAGEMENT)
          .doc(userModel.userKey)
          .collection(userModel.userName).orderBy("stdDate", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if(!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
          return MyProgressIndicator();
        }

        final monthActualSalesTotalShow = [];
        final monthExpenseTotalShow = [];
        final monthAddExpenseList = [];

         snapshot.data.docs.forEach((element)  {
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
            appBar: mainAppBar(context, IconButton(
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
                    children: snapshot.data.docs.map((snapshotData) {

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
                      } else
                      return SimpleFoldingCell.create(
                        frontWidget: GestureDetector(
                            onTap: () {
                              print('short click');
                              print(formatPickerMonth);
                              print(fireStoreMonthFormat);
                            },
                            onLongPress: () async {
                              setState(() {
                                _managementBottomSheet(
                                    context, snapshotData, userModel);
                              });
                            },
                            child: _foldingFrontWidget(snapshotData, expenseAmountOnlyResult)),
                        innerWidget: _foldingInnerWidget(snapshotData, expenseAmountOnlyResult, userModel),
                        cellSize: Size(MediaQuery.of(context).size.width, 110),
                        padding: EdgeInsets.all(12),
                        animationDuration: Duration(milliseconds: 300),
                        borderRadius: 20,
                        onOpen: () => print('cell opened'),
                        onClose: () => print('cell closed'),
                      );
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
      width: size.width*0.8,
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
          if (select != null || pickerMonth != null) {
            setState(() {
              pickerMonth = select;
            });
          } else {
            return MyProgressIndicator();
          }
        },
        initialMonth: pickerMonth,
      ),
    );
  }

  Container _managementScreenMonthTotalSalesAndTotalExpense(List monthActualSalesTotalShow, int monthTotalExpenseShowTextIntType) {
    return Container(
      width: size.width * 0.9,
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

  Future _managementBottomSheet(BuildContext context, QueryDocumentSnapshot snapshotData, UserModel userModel) {

    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      backgroundColor: Colors.black,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: size.height * 0.13,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: size.width * 0.4,
                    child: ListTile(
                      horizontalTitleGap: 0.01,
                      leading: Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 25,
                      ),
                      title: Text('삭제하기',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      onTap: () {
                        setState((){

                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),),
                              backgroundColor: Colors.pink,
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return Container(height: size.height * 0.09,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(child: Text('     ' + snapshotData['selectedDate'] + '  삭제 하시겠습니까 ?',
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                                          ),
                                          ),
                                          Container(width: size.width * 0.2,
                                            child: InkWell(
                                              child: Center(
                                                child: Text('Ok',
                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                FirebaseFirestore.instance.collection(COLLECTION_SALES_MANAGEMENT).doc(userModel.userKey).collection(userModel.userName)
                                                    .doc(snapshotData.id).delete();
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                          Container(color: Colors.pinkAccent, height: size.height * 0.08, width: size.width * 0.005,),
                                          Container(width: size.width * 0.2,
                                            child: InkWell(
                                              child: Center(
                                                child: Text('Cancel  ',
                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                          // SizedBox(
                                          //   width: size.width*0.01,
                                          // ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              });
                        });
                      },
                    ),
                  ),
                  Container(color: Colors.white,
                    height: size.height * 0.075,
                    width: size.width * 0.01,
                  ),
                  Container(
                    width: size.width * 0.4,
                    child: ListTile(horizontalTitleGap: 0.2,
                      leading: Icon(Icons.add_circle,
                        color: Colors.white,
                        size: 25,
                      ),
                      title: Text('추가하기',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      onTap: () {
                        _totalSalesController.text = koFormatMoney.format(snapshotData['totalSales']);
                        _actualSalesController.text = koFormatMoney.format(snapshotData['actualSales']);
                        _vosController.text = koFormatMoney.format(snapshotData['vos']);
                        _vatController.text = koFormatMoney.format(snapshotData['vat']);
                        _discountController.text = koFormatMoney.format(snapshotData['discount']);
                        _creditCardController.text = koFormatMoney.format(snapshotData['creditCard']);
                        _cashController.text = koFormatMoney.format(snapshotData['cash']);
                        _cashReceiptController.text = koFormatMoney.format(snapshotData['cashReceipt']);
                        _deliveryController.text = koFormatMoney.format(snapshotData['delivery']);
                        _giftCardController.text = koFormatMoney.format(snapshotData['giftCard']);
                        _foodProvisionController.text = koFormatMoney.format(snapshotData['foodProvisionExpense']);
                        _beverageController.text = koFormatMoney.format(snapshotData['beverageExpense']);
                        _alcoholController.text = koFormatMoney.format(snapshotData['alcoholExpense']);

                        setState((){
                          showModalBottomSheet(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Colors.green[500], Colors.green[500], Colors.green[400], Colors.green[300]],
                                      ),
                                    ),
                                    height: size.height * 0.09,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(12),
                                                bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                                color: Colors.white,
                                              ),
                                              width: size.width * 0.45,
                                              child: ListTile(horizontalTitleGap: 0.01,
                                                leading: Icon(Icons.add_outlined, color: Colors.white, size: 25,
                                                ),
                                                title: Text('   매출',
                                                  style: TextStyle(color: Colors.green[800],fontWeight: FontWeight.bold, fontSize: 21),
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  print('매출 click');
                                                  setState(() {

                                                    showMaterialModalBottomSheet(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(30),
                                                        ),
                                                        closeProgressThreshold: 5.0,
                                                        enableDrag: false,
                                                        animationCurve: Curves.fastOutSlowIn,
                                                        duration: Duration(milliseconds: 1500),
                                                        barrierColor: Colors.black87,
                                                        backgroundColor: Colors.white,
                                                        context: context,
                                                        builder: (BuildContext context) {

                                                          return StatefulBuilder(
                                                            builder: (BuildContext context, StateSetter setState){
                                                              return Padding(
                                                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                child: Container(
                                                                  height: size.height * 0.5,
                                                                  child: SingleChildScrollView(
                                                                    child: Stack(
                                                                      children: [
                                                                        Positioned(left: 15, top: 30,
                                                                          child: InkWell(
                                                                            child: Text('Cancel',
                                                                              style: TextStyle(color: Colors.deepPurple, fontSize: 20, fontWeight: FontWeight.bold,
                                                                                fontStyle: FontStyle.italic,
                                                                              ),
                                                                            ),
                                                                            onTap: () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: <Widget>[
                                                                            SizedBox(height: 30,),
                                                                            Container(height: salTtfHeightSize,
                                                                              child: Text(snapshotData['selectedDate'],
                                                                                style: TextStyle(color: Colors.black54, fontSize: 22,
                                                                                  fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            _salesEditTffForm('총매출', '실제매출', _totalSalesController, _actualSalesController),
                                                                            _salesEditTffForm('공급가액', '세액', _vosController, _vatController),
                                                                            _salesEditTffForm('할인', '신용카드', _discountController, _creditCardController),
                                                                            _salesEditTffForm('현금', '현금영수증', _cashController, _cashReceiptController),
                                                                            _salesEditTffForm('Delivery', 'Gift Card', _deliveryController, _giftCardController)

                                                                          ],
                                                                        ),
                                                                        Positioned(right: 15, top: 30,
                                                                          child: InkWell(
                                                                            child: Text('Save',
                                                                              style: TextStyle(
                                                                                color: Colors.deepPurple, fontSize: 20,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontStyle: FontStyle.italic,
                                                                              ),
                                                                            ),
                                                                            onTap: () async{

                                                                              await FirebaseFirestore.instance.collection(COLLECTION_SALES_MANAGEMENT).doc(userModel.userKey)
                                                                                  .collection(userModel.userName).doc(snapshotData.id).update({
                                                                                'totalSales': _totalSalesController.text.isEmpty ? int.parse('0') : int.parse(_totalSalesController.text.replaceAll(",", "")),
                                                                                'actualSales': _alcoholController.text.isEmpty ? int.parse('0') : int.parse(_actualSalesController.text.replaceAll(",", "")),
                                                                                'vos' : _vosController.text.isEmpty ? int.parse('0') : int.parse(_vosController.text.replaceAll(",", "")),
                                                                                'vat' : _vatController.text.isEmpty ? int.parse('0') : int.parse(_vatController.text.replaceAll(",", "")),
                                                                                'discount' : _discountController.text.isEmpty ? int.parse('0') : int.parse(_discountController.text.replaceAll(",", "")),
                                                                                'creditCard' : _creditCardController.text.isEmpty ? int.parse('0') : int.parse(_creditCardController.text.replaceAll(",", "")),
                                                                                'cash' : _cashController.text.isEmpty ? int.parse('0') : int.parse(_cashController.text.replaceAll(",", "")),
                                                                                'cashReceipt' : _cashReceiptController.text.isEmpty ? int.parse('0') : int.parse(_cashReceiptController.text.replaceAll(",", "")),
                                                                                'delivery' : _deliveryController.text.isEmpty ? int.parse('0') : int.parse(_deliveryController.text.replaceAll(",", "")),
                                                                                'giftCard' : _giftCardController.text.isEmpty ? int.parse('0') : int.parse(_giftCardController.text.replaceAll(",", "")),
                                                                              });
                                                                              Navigator.of(context).pop();
                                                                              _totalSalesController.clear();
                                                                              _actualSalesController.clear();
                                                                              _vosController.clear();
                                                                              _vatController.clear();
                                                                              _discountController.clear();
                                                                              _creditCardController.clear();
                                                                              _cashController.clear();
                                                                              _cashReceiptController.clear();
                                                                              _deliveryController.clear();
                                                                              _giftCardController.clear();
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }
                                                    );
                                                  });
                                                },
                                              ),
                                            ),
                                            Container(color: Colors.green,
                                              height: size.height * 0.06,
                                              width: size.width * 0.005,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(12),
                                                  bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
                                                  color: Colors.white,
                                              ),
                                              width: size.width * 0.45,
                                              child: ListTile(horizontalTitleGap: 0.01,
                                                leading: Icon(Icons.add_outlined, color: Colors.white, size: 25,
                                                ),
                                                title: Text('   지출',
                                                  style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 21),
                                                ),
                                                onTap: () {

                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  print('지출 click');

                                                  setState(() {

                                                    showMaterialModalBottomSheet(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(30),
                                                        ),
                                                        closeProgressThreshold: 5.0,
                                                        enableDrag: false,
                                                        elevation: 90.0,
                                                        animationCurve: Curves.fastOutSlowIn,
                                                        duration: Duration(milliseconds: 1500),
                                                        barrierColor: Colors.black87,
                                                        backgroundColor: Colors.white,
                                                        context: context,
                                                        builder: (BuildContext context) {

                                                          var upDateExpenseAddList = [];
                                                          upDateExpenseAddList.addAll(snapshotData.data()['expenseAddList'],);

                                                          List<int> upDateExpenseTotalAmount = [];

                                                          bool _titleBadge = false;
                                                          bool _amountBadge = false;

                                                          return StatefulBuilder(
                                                            builder: (BuildContext context, StateSetter setState) {

                                                              var addListToExpense = snapshotData.data()['expenseAddList'];

                                                              return Padding(
                                                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                child: Container(
                                                                  height: size.height * 0.5,
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      Stack(
                                                                        children: [
                                                                          Positioned(left: 15, top: 30,
                                                                            child: InkWell(
                                                                              child: Text('Cancel',
                                                                                style: TextStyle(color: Colors.pinkAccent, fontSize: 20,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontStyle: FontStyle.italic,
                                                                                ),
                                                                              ),
                                                                              onTap: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                            ),
                                                                          ),
                                                                          Positioned(right: 15, top: 30,
                                                                            child: InkWell(
                                                                              child: Text('Save',
                                                                                style: TextStyle(
                                                                                  color: Colors.pinkAccent, fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,
                                                                                ),
                                                                              ),
                                                                              onTap: () async{

                                                                                await FirebaseFirestore.instance.collection(COLLECTION_SALES_MANAGEMENT).doc(userModel.userKey)
                                                                                    .collection(userModel.userName).doc(snapshotData.id).update({
                                                                                  'foodProvisionExpense': _foodProvisionController.text.isEmpty ? int.parse('0') : int.parse(_foodProvisionController.text.replaceAll(",", "")),
                                                                                  'beverageExpense': _beverageController.text.isEmpty ? int.parse('0') : int.parse(_beverageController.text.replaceAll(",", "")),
                                                                                  'alcoholExpense': _alcoholController.text.isEmpty ? int.parse('0') : int.parse(_alcoholController.text.replaceAll(",", "")),
                                                                                });

                                                                                Navigator.of(context).pop();
                                                                                _foodProvisionController.clear();
                                                                                _beverageController.clear();
                                                                                _alcoholController.clear();
                                                                              },
                                                                            ),
                                                                          ),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              SizedBox(height: 30,),
                                                                              Container(
                                                                                height: salTtfHeightSize,
                                                                                child: Text(
                                                                                  snapshotData['selectedDate'],
                                                                                  style: TextStyle(
                                                                                    color: Colors.black54, fontSize: 22, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              _expenseEditTffForm('식자재', '음료', '주류', _foodProvisionController, _beverageController, _alcoholController),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(height: 20,),
                                                                      Container(height: 3, width: size.width * 0.9,
                                                                        color: Colors.grey,
                                                                      ),
                                                                      SizedBox(height: 20,),
                                                                      Container(
                                                                        height: size.height*0.04,
                                                                        width: size.width*0.8,
                                                                        child: RaisedButton(
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(30),
                                                                            ),
                                                                            color: Colors.deepOrange,
                                                                            child: Text('추가 지출 수정하기',style:  TextStyle(
                                                                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15,
                                                                                fontStyle: FontStyle.italic),),
                                                                            onPressed: () async{

                                                                              await FirebaseFirestore.instance.collection(COLLECTION_SALES_MANAGEMENT).doc(userModel.userKey)
                                                                                  .collection(userModel.userName).doc(snapshotData.id).update({
                                                                                'foodProvisionExpense': _foodProvisionController.text.isEmpty ? int.parse('0') : int.parse(_foodProvisionController.text.replaceAll(",", "")),
                                                                                'beverageExpense': _beverageController.text.isEmpty ? int.parse('0') : int.parse(_beverageController.text.replaceAll(",", "")),
                                                                                'alcoholExpense': _alcoholController.text.isEmpty ? int.parse('0') : int.parse(_alcoholController.text.replaceAll(",", "")),
                                                                              });

                                                                              Navigator.of(context).pop();
                                                                              _foodProvisionController.clear();
                                                                              _beverageController.clear();
                                                                              _alcoholController.clear();
                                                                              _editAddExpenseTitleController.clear();
                                                                              _editAddExpenseAmountController.clear();

                                                                              setState((){
                                                                                showMaterialModalBottomSheet(
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(30),
                                                                                    ),
                                                                                    closeProgressThreshold: 5.0,
                                                                                    isDismissible: false,
                                                                                    enableDrag: false,
                                                                                    elevation: 90.0,
                                                                                    animationCurve: Curves.fastOutSlowIn,
                                                                                    duration: Duration(milliseconds: 1500),
                                                                                    barrierColor: Colors.black87,
                                                                                    backgroundColor: Colors.deepOrangeAccent,
                                                                                    context: context,
                                                                                    builder: (BuildContext context){
                                                                                      return StatefulBuilder(
                                                                                          builder: (BuildContext context, StateSetter setState){



                                                                                            return Padding(
                                                                                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                                              child: Container(
                                                                                                height: size.height * 0.5,
                                                                                                child: Column(
                                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                                  children: <Widget>[
                                                                                                    Stack(
                                                                                                      children: [
                                                                                                        Positioned(left: 15, top: 15,
                                                                                                          child: InkWell(
                                                                                                            child: IconButton(
                                                                                                              icon: Icon(Icons.arrow_downward_outlined, color: Colors.pink, size: 30,),
                                                                                                              onPressed: () {
                                                                                                                Navigator.of(context).pop();
                                                                                                              },
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Positioned(right: 15, top: 30,
                                                                                                          child: InkWell(
                                                                                                            child: Text('Save',
                                                                                                              style: TextStyle(
                                                                                                                color: Colors.pink, fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,
                                                                                                              ),
                                                                                                            ),
                                                                                                            onTap: () async{
                                                                                                              int test = upDateExpenseTotalAmount.reduce((v, e) => v+e);

                                                                                                              await FirebaseFirestore.instance.collection(COLLECTION_SALES_MANAGEMENT).doc(userModel.userKey)
                                                                                                                  .collection(userModel.userName).doc(snapshotData.id).update({
                                                                                                               'expenseAddTotalAmount': FieldValue.increment(test.isNaN?int.parse('0'):test),
                                                                                                                'expenseAddList': FieldValue.arrayUnion(
                                                                                                                  upDateExpenseAddList)
                                                                                                              });
                                                                                                              Navigator.of(context).pop();
                                                                                                            },
                                                                                                          ),
                                                                                                        ),
                                                                                                        Column(
                                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                                          children: <Widget>[
                                                                                                            SizedBox(height: 30,),
                                                                                                            Container(
                                                                                                              height: salTtfHeightSize,
                                                                                                              child: Text(
                                                                                                                snapshotData['selectedDate'],
                                                                                                                style: TextStyle(
                                                                                                                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            Row(
                                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                                              children: <Widget>[
                                                                                                                Container(
                                                                                                                    width: size.width*0.5,
                                                                                                                    height: expTtfHeightSize,
                                                                                                                    child: Badge(
                                                                                                                      showBadge: _titleBadge,
                                                                                                                      position: BadgePosition.topEnd(end: 10, top: 30),
                                                                                                                      badgeColor: Colors.green,
                                                                                                                      child: TextFormField(
                                                                                                                        keyboardType: TextInputType.text,
                                                                                                                        textInputAction: TextInputAction.next,
                                                                                                                        controller: _editAddExpenseTitleController,
                                                                                                                        style: pinkInputStyle(),
                                                                                                                        decoration: editAddExpenseInputDecor('내용'),
                                                                                                                      ),
                                                                                                                    )),
                                                                                                                Container(
                                                                                                                    width: size.width*0.3,
                                                                                                                    height: expTtfHeightSize,
                                                                                                                    child: Badge(
                                                                                                                      showBadge: _amountBadge,
                                                                                                                      position: BadgePosition.topEnd(end: 10, top: 30),
                                                                                                                      badgeColor: Colors.green,
                                                                                                                      child: TextFormField(
                                                                                                                        keyboardType: TextInputType.number,
                                                                                                                        textInputAction: TextInputAction.done,
                                                                                                                        controller: _editAddExpenseAmountController,
                                                                                                                        style: pinkInputStyle(),
                                                                                                                        decoration: editAddExpenseInputDecor('지출금액'),
                                                                                                                        inputFormatters: [wonMaskFormatter],
                                                                                                                      ),
                                                                                                                    )),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                    Container(
                                                                                                      height: 30,
                                                                                                      width: size.width * 0.6,
                                                                                                      child: RaisedButton(
                                                                                                        onPressed: () {
                                                                                                          setState(() {
                                                                                                            if (_editAddExpenseTitleController.text.isEmpty) {
                                                                                                              _titleBadge = true;
                                                                                                              return snackBarManagementScreenTopFlushBar(context, '내용을 입력해 주세요', '필수 입력사항 입니다');
                                                                                                            } else if (_editAddExpenseAmountController.text.isEmpty) {
                                                                                                              _titleBadge = false;
                                                                                                              _amountBadge = true;
                                                                                                              return snackBarManagementScreenTopFlushBar(context, '지출금액을 입력해 주세요', '필수 입력사항 입니다');
                                                                                                            }
                                                                                                            _amountBadge = false;
                                                                                                            _titleBadge = false;
                                                                                                            upDateExpenseAddList.addAll([{
                                                                                                              'title': _editAddExpenseTitleController.text.trim(),
                                                                                                              'expenseAmount': int.parse(_editAddExpenseAmountController.text.replaceAll(",", "")),
                                                                                                            }]);
                                                                                                            upDateExpenseTotalAmount.add(int.parse(_editAddExpenseAmountController.text.replaceAll(",", "")));
                                                                                                            });
                                                                                                          if(_titleBadge == false && _amountBadge == false)
                                                                                                            _editAddExpenseTitleController.clear();
                                                                                                          _editAddExpenseAmountController.clear();
                                                                                                        },
                                                                                                        elevation: 5,
                                                                                                        color: Colors.pink,
                                                                                                        splashColor: Colors.white,
                                                                                                        child: Text(
                                                                                                          '추가하기',
                                                                                                          style: TextStyle(
                                                                                                            color: Colors.white,
                                                                                                              fontStyle: FontStyle.italic,
                                                                                                              fontWeight: FontWeight.bold),
                                                                                                        ),
                                                                                                        shape: RoundedRectangleBorder(
                                                                                                          borderRadius: BorderRadius.circular(30),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    StatefulBuilder(
                                                                                                      builder: (BuildContext context, StateSetter mySetState) {
                                                                                                        return Container(
                                                                                                          height: size.height * 0.2,
                                                                                                          width: size.width*0.9,
                                                                                                          child: ListView.separated(
                                                                                                            itemCount: upDateExpenseAddList.length,
                                                                                                            itemBuilder: (BuildContext context, int index) {

                                                                                                              int _showExpenseAmountFormat = upDateExpenseAddList[index]['expenseAmount'];
                                                                                                              return Column(
                                                                                                                children: [
                                                                                                                  Row(
                                                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                    children: <Widget>[
                                                                                                                      Container(
                                                                                                                        width: size.width*0.5,
                                                                                                                        child: Text(
                                                                                                                          upDateExpenseAddList[index]['title'].toString(), style: TextStyle(
                                                                                                                            color: Colors.white),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      Expanded(
                                                                                                                        child: Container(
                                                                                                                          width: size.width*0.2,
                                                                                                                          child: Text(
                                                                                                                            koFormatMoney.format(_showExpenseAmountFormat) + ' \\', style: TextStyle(
                                                                                                                              color: Colors.white),),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      InkWell(
                                                                                                                        child: Icon(Icons.delete_forever, color: Colors.pink,size: 20,),
                                                                                                                        onTap: () async{

                                                                                                                          await FirebaseFirestore.instance.collection(COLLECTION_SALES_MANAGEMENT).doc(userModel.userKey)
                                                                                                                              .collection(userModel.userName).doc(snapshotData.id).update({
                                                                                                                            'expenseAddTotalAmount': FieldValue.increment(-_showExpenseAmountFormat),
                                                                                                                            'expenseAddList': FieldValue.arrayRemove([
                                                                                                                              upDateExpenseAddList[index]]),
                                                                                                                          });

                                                                                                                          mySetState((){
                                                                                                                            upDateExpenseAddList.removeAt(index);
                                                                                                                            // print(upDateExpenseAddList[index]['expenseAmount']);
                                                                                                                            print(_showExpenseAmountFormat);
                                                                                                                          });
                                                                                                                        },
                                                                                                                      ),
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                ],
                                                                                                              );
                                                                                                            }, separatorBuilder: (BuildContext context, int index) {
                                                                                                            return Container(height: 15,);
                                                                                                          },
                                                                                                          ),
                                                                                                        );
                                                                                                      },
                                                                                                    ),
                                                                                                  ],

                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          });
                                                                                    });
                                                                              });
                                                                            }),
                                                                      ),
                                                                      StatefulBuilder(
                                                                        builder: (BuildContext context, StateSetter mySetState) {

                                                                          return Container(
                                                                            height: size.height * 0.17,
                                                                            width: size.width*0.9,
                                                                            child: ListView.separated(
                                                                              itemCount: addListToExpense.length,
                                                                              itemBuilder: (BuildContext context, int index) {

                                                                                int _showAddListToExpenseFormat = addListToExpense[index]['expenseAmount'];

                                                                                return Column(
                                                                                  children: [
                                                                                    Row(
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: <Widget>[
                                                                                        Container(
                                                                                          width: size.width*0.5,
                                                                                          child: Text(
                                                                                            addListToExpense[index]['title'].toString(), style: TextStyle(
                                                                                              color: Colors.black54),
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: Container(
                                                                                            width: size.width*0.2,
                                                                                            child: Text(
                                                                                              koFormatMoney.format(_showAddListToExpenseFormat) + ' \\', style: TextStyle(
                                                                                                color: Colors.black54),),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              }, separatorBuilder: (BuildContext context, int index) {
                                                                              return Container(height: 15,);
                                                                            },
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }
                                                    );
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        });

                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Builder _foldingFrontWidget(QueryDocumentSnapshot snapshotData, List expenseAmountOnlyResult) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.pink[100],Colors.redAccent[100]],
            ),
          ),
          // color: Color(0xFFecf2f9),
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      snapshotData['selectedDate'],
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _managementScreenCardLayoutForm(snapshotData, '실제 매출 : ' + koFormatMoney.format(snapshotData['actualSales']),
                      '식자재 : ' + koFormatMoney.format(snapshotData['foodProvisionExpense'])),
                  _managementScreenCardLayoutForm(snapshotData, '총 매출 : ' + koFormatMoney.format(snapshotData['totalSales']),
                    '기타 지출 : ' + koFormatMoney.format(
                      expenseAmountOnlyResult.isEmpty ? snapshotData['alcoholExpense'] + snapshotData['beverageExpense']
                          : expenseAmountOnlyResult.reduce((v, e) => v + e) +
                          snapshotData['alcoholExpense'] + snapshotData['beverageExpense']),),
                ],
              ),
              Positioned(
                top: 5,
                right: 5,
                height: 30,
                child: RaisedButton(
                  color: Colors.redAccent,
                  onPressed: () {
                    final _foldingCellState = context
                        .findRootAncestorStateOfType<SimpleFoldingCellState>();
                    _foldingCellState?.toggleFold();
                  },
                  child: Text(
                    'OPEN',
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textColor: Colors.white,
                  splashColor: Colors.white.withOpacity(0.8),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _foldingInnerWidget(QueryDocumentSnapshot snapshotData, List expenseAmountOnlyResult, UserModel userModel) {

    var showBottomSheetExpenseAddShow = snapshotData.data()['expenseAddList'];

    return Builder(
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple[100],Colors.purple[200],Colors.purple[200],Colors.purple[200],Colors.purple[100]]),
          ),
          // color: Colors.deepOrange,
          padding: EdgeInsets.only(top: 10),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      snapshotData['selectedDate'],
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 19,
                      ),
                    ),
                  ),
                  _managementScreenCardLayoutForm(snapshotData, '실제 매출 : ' + koFormatMoney.format(snapshotData['actualSales']),
                      '식자재 : ' + koFormatMoney.format(snapshotData['foodProvisionExpense'])),
                  _managementScreenCardLayoutForm(snapshotData, '총 매출 : ' + koFormatMoney.format(snapshotData['totalSales']),
                      '음료 : ' + koFormatMoney.format(snapshotData['beverageExpense'])),
                  _managementScreenCardLayoutForm(snapshotData, '공급가액 : ' + koFormatMoney.format(snapshotData['vos']),
                      '주류 : ' + koFormatMoney.format(snapshotData['alcoholExpense'])),
                  _managementScreenCardLayoutForm(snapshotData, '세액 : ' + koFormatMoney.format(snapshotData['vat']),''),
                  _managementScreenCardLayoutForm(snapshotData, '할인 : ' + koFormatMoney.format(snapshotData['discount']),
                      ''),
                  _managementScreenCardLayoutForm(snapshotData, '신용카드 : ' + koFormatMoney.format(snapshotData['creditCard']),
                      '추가 지출 : ' + expenseAmountOnlyResult.length.toString() + '  건' ),
                  _managementScreenCardLayoutForm(snapshotData, '현금 : ' + koFormatMoney.format(snapshotData['cash']),
                      '추가 지출 금액: ' + koFormatMoney.format(
                          expenseAmountOnlyResult.isEmpty ? int.parse('0') : expenseAmountOnlyResult.reduce((v, e) => v + e))),
                  _managementScreenCardLayoutWithDetailForm(snapshotData, context, showBottomSheetExpenseAddShow),
                  _managementScreenCardLayoutForm(snapshotData, 'Delivery : ' + koFormatMoney.format(snapshotData['delivery']), ''),
                  _managementScreenCardLayoutForm(snapshotData, 'Gift Card : ' + koFormatMoney.format(snapshotData['giftCard']), ''),
                ],
              ),
              Positioned(
                top: -10,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.more_vert_rounded),
                  onPressed: () {
                    _managementBottomSheet(
                        context, snapshotData, userModel);
                  },
                  color: Colors.black54,
                  splashColor: Colors.white.withOpacity(0.8),
                ),
              ),

              Positioned(
                right: 5,
                bottom: 0,
                child: RaisedButton(
                  onPressed: () {
                    final _foldingCellState = context
                        .findRootAncestorStateOfType<SimpleFoldingCellState>();
                    _foldingCellState?.toggleFold();
                  },
                  child: Text(
                    "Close",
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textColor: Colors.white,
                  color: Colors.deepPurple,
                  splashColor: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Row _salesEditTffForm(String leftHint, String rightHint, TextEditingController leftController, TextEditingController rightController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
            width: salTtfWidthSize,
            height: salTtfHeightSizeVer2,
            child: TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              controller: leftController,
              style: salesInputStyle(),
              decoration: salesChangeInputDecor(leftHint),
              inputFormatters: [wonMaskFormatter],
            )),
        Container(
            width: salTtfWidthSize,
            height: salTtfHeightSizeVer2,
            child: TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              controller: rightController,
              style: salesInputStyle(),
              decoration: salesChangeInputDecor(rightHint),
              inputFormatters: [wonMaskFormatter],
            )),
      ],
    );
  }

  Row _expenseEditTffForm(String startHint, String centerHint, String endHint,
      TextEditingController startController, TextEditingController centerController, TextEditingController endController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
            width: expTtfWidthSize,
            height: salTtfHeightSizeVer2,
            child: TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              controller: startController,
              style: salesInputStyle(),
              decoration: expenseChangeInputDecor(startHint),
              inputFormatters: [wonMaskFormatter],
            )),
        Container(
            width: expTtfWidthSize,
            height: salTtfHeightSizeVer2,
            child: TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              controller: centerController,
              style: salesInputStyle(),
              decoration: expenseChangeInputDecor(centerHint),
              inputFormatters: [wonMaskFormatter],
            )),
        Container(
            width: expTtfWidthSize,
            height: salTtfHeightSizeVer2,
            child: TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              controller: endController,
              style: salesInputStyle(),
              decoration: expenseChangeInputDecor(endHint),
              inputFormatters: [wonMaskFormatter],
            )),
      ],
    );
  }

  Padding _managementScreenCardLayoutForm(QueryDocumentSnapshot snapshotData, String leftTitle, rightTitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Container(
              width: size.width * 0.45,
              child: Text(
                leftTitle,
                style: _frontWidgetTextStyle(),
              ),
            ),
          ),
          Container(
            child: Text(
              rightTitle,
              style: _frontWidgetTextStyle(),
            ),
          ),
        ],
      ),
    );
  }

  Padding _managementScreenCardLayoutWithDetailForm(QueryDocumentSnapshot snapshotData, BuildContext context, showBottomSheetExpenseAddShow) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: size.width * 0.45,
            child: Text('현금영수증 : ' + koFormatMoney.format(snapshotData['cashReceipt']),
              style: _frontWidgetTextStyle(),
            ),
          ),
          Row(
            children: [
              Icon(Icons.expand_more_rounded, size: 13,color: Colors.white,),
              Icon(Icons.expand_more_rounded, size: 13,color: Colors.white,),
              InkWell(
                child: Container(
                    child: Text('자세히보기',style: TextStyle(color: Colors.white),),
                ),
                onTap: (){
                  showMaterialModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      closeProgressThreshold: 5.0,
                      elevation: 90.0,
                      animationCurve: Curves.fastOutSlowIn,
                      duration: Duration(milliseconds: 1500),
                      barrierColor: Colors.black54,
                      backgroundColor: Colors.deepOrangeAccent,
                      context: context,
                      builder: (BuildContext context){
                        return StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState){
                              return Container(
                                height: size.height * 0.4,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(height: 20,),
                                            Container(
                                              height: salTtfHeightSizeVer2,
                                              child: Text(
                                                snapshotData['selectedDate'],
                                                style: TextStyle(
                                                  color: Colors.indigo, fontSize: 22, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Text('내용',style: TextStyle(fontSize: 16),),
                                                Text('지출금액',style: TextStyle(fontSize: 16),),
                                              ],
                                            ),
                                            SizedBox(height: 7,),
                                            Container(
                                              width: size.width*0.8,
                                              height: 3,
                                              color: Colors.deepOrange,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: size.height * 0.23,
                                      width: size.width*0.8,
                                      child: ListView.separated(
                                        itemCount: showBottomSheetExpenseAddShow.length,
                                        itemBuilder: (BuildContext context, int index) {

                                          int _showBottomExpenseAmountFormat = showBottomSheetExpenseAddShow[index]['expenseAmount'];

                                          return Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 25),
                                                    child: Container(
                                                      width: size.width*0.5,
                                                      child: Text(
                                                        showBottomSheetExpenseAddShow[index]['title'].toString(), style: TextStyle(
                                                          color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      width: size.width*0.2,
                                                      child: Text(
                                                        koFormatMoney.format(_showBottomExpenseAmountFormat) +'   \\', style: TextStyle(
                                                          color: Colors.white),),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        }, separatorBuilder: (BuildContext context, int index) {
                                        return Container(height: 15,);
                                      },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      });
                },
              ),
              Icon(Icons.expand_more_rounded, size: 13,color: Colors.white,),
              Icon(Icons.expand_more_rounded, size: 13,color: Colors.white,),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _frontWidgetTextStyle() {
    return TextStyle(
        color: Colors.black, fontSize: 12);
  }
}