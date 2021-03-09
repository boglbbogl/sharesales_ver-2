import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/duration.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/models/firestore/user_model.dart';
import 'package:sharesales_ver2/models/user_model_state.dart';
import 'package:sharesales_ver2/repository/sales_firestore_crud.dart';
import 'package:sharesales_ver2/repository/sales_network_repository.dart';
import 'package:sharesales_ver2/widget/date_picker_cupertino.dart';
import 'package:sharesales_ver2/widget/expense_create_form.dart';
import 'package:sharesales_ver2/widget/sales_create_form.dart';


class CreateManagementScreen extends StatefulWidget {
  final String userKey;

  const CreateManagementScreen({Key key, this.userKey,}) : super(key: key);

  @override
  _CreateManagementScreenState createState() => _CreateManagementScreenState();
}

class _CreateManagementScreenState extends State<CreateManagementScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SelectedIndicator _selectedIndicator = SelectedIndicator.left;

  double _salesPos = 0;
  double _expensePos = size.width;

  bool _showTabBarBadge = false;

  TextEditingController _totalSalesController = TextEditingController();
  TextEditingController _actualSalesController = TextEditingController();
  TextEditingController _foodprovisionController = TextEditingController();
  TextEditingController _beverageController = TextEditingController();
  TextEditingController _alcoholController = TextEditingController();

  @override
  void dispose() {
    _totalSalesController.dispose();
    _actualSalesController.dispose();
    _foodprovisionController.dispose();
    _beverageController.dispose();
    _alcoholController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // String formatDate = DateFormat('EEE, MMM dd, ' ' yyyy').format(pickerDate);


    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: _createScreenAppbar(context),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection(COLLECTION_SALES).snapshots(),
                  builder: (context, snapshot) {

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DatePickerCupertino(),
                        // InkWell(
                        //     child: SizedBox(
                        //       width: size.width * 0.9,
                        //       height: size.height * 0.05,
                        //       child: Center(
                        //         child: Text(
                        //           '$formatDate',
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold,
                        //             fontStyle: FontStyle.italic,
                        //             fontSize: 20,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //
                        //     onTap: () {
                        //       // print(stdDateList);
                        //       // print(snapshot.data.docs.addAll()['stdDate']);
                        //       DatePicker.showDatePicker(context,
                        //         theme: DatePickerTheme(
                        //           itemStyle: TextStyle(color: Colors.white),
                        //           backgroundColor: Colors.black,
                        //           headerColor: Colors.black,
                        //           doneStyle: TextStyle(color: Colors.redAccent),
                        //           cancelStyle: TextStyle(color: Colors.redAccent),
                        //           containerHeight: size.height * 0.3,
                        //         ),
                        //         showTitleActions: true,
                        //         minTime: DateTime(2000, 1, 1),
                        //         maxTime: DateTime(2100, 12, 31),
                        //         onChanged: (selectedDate) {
                        //
                        //         Timestamp ss = snapshot.data.docs.first['stdDate'];
                        //         var stdDate = DateTime.parse(ss.toDate().toString());
                        //
                        //         setState(() {
                        //           pickerDate = selectedDate;
                        //           if(pickerDate == stdDate || selectedDate == stdDate){
                        //             SnackBar snackBar = SnackBar(
                        //                       content: Text(
                        //                         "${stdDate.toString().substring(0, 10)}" +
                        //                             '이미 입력하였습니다.',
                        //                         style: snackBarStyle(),
                        //                       ),
                        //                       backgroundColor:
                        //                           Colors.lightBlueAccent,
                        //                     );
                        //                     Scaffold.of(context)
                        //                         .showSnackBar(snackBar);
                        //           }
                        //         });
                        //
                        //             // setState(() {
                        //             //   if (pickerDate != stdDate ||
                        //             //       selectedDate != stdDate) {
                        //             //     pickerDate = selectedDate;
                        //             //   } else if(pickerDate == stdDate || selectedDate == stdDate){
                        //             //     SnackBar snackBar = SnackBar(
                        //             //       content: Text(
                        //             //         "${stdDate.toString().substring(0, 10)}" +
                        //             //             '이미 입력하였습니다.',
                        //             //         style: snackBarStyle(),
                        //             //       ),
                        //             //       backgroundColor:
                        //             //           Colors.lightBlueAccent,
                        //             //     );
                        //             //     Scaffold.of(context)
                        //             //         .showSnackBar(snackBar);
                        //             //   }
                        //             //   print(pickerDate);
                        //             //   print(selectedDate);
                        //             //   print(stdDate);
                        //             // });
                        //             // setState(() {
                        //           //   if (selectedDate != null || pickerDate != null) {
                        //           //     pickerDate = selectedDate;
                        //           //   } else
                        //           //     return Scaffold.of(context).showSnackBar(pickerSnackBar);
                        //           //   print(selectedDate);
                        //           // });
                        //         },
                        //         currentTime: pickerDate,
                        //         locale: LocaleType.en,
                        //       );
                        //     }
                        // ),
                      ],
                    );
                  }
                ),
                _tapButton(),
                _tapIndicator(),
                SizedBox(
                  height: 40,
                ),
                Stack(
                  children: <Widget>[
                    AnimatedContainer(
                      duration: mainDuration,
                      transform: Matrix4.translationValues(_salesPos, 0, 0),
                      curve: Curves.fastOutSlowIn,
                      child: SalesCreateForm(
                        totalSalesController: _totalSalesController,
                        actualSalesController: _actualSalesController,
                      ),
                    ),
                    AnimatedContainer(
                      duration: mainDuration,
                      transform: Matrix4.translationValues(_expensePos, 0, 0),
                      curve: Curves.fastOutSlowIn,
                      child: ExpenseCreateForm(
                        foodprovisionsController: _foodprovisionController,
                        beverageController: _beverageController,
                        alcoholController: _alcoholController,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _tapIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 57),
      child: AnimatedContainer(
        duration: mainDuration,
        alignment: _selectedIndicator == SelectedIndicator.left
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Container(
          height: 3,
          width: size.width / 3,
          color: _selectedIndicator == SelectedIndicator.left
              ? Colors.amberAccent
              : Colors.redAccent,
        ),
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  Padding _tapButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: SizedBox(
        height: size.width * 0.12,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  Badge(
                    showBadge: _showTabBarBadge,
                    position: BadgePosition.bottomEnd(bottom: 9, end: 10),
                    badgeColor: _selectedIndicator == SelectedIndicator.right
                        ? Colors.amberAccent
                        : Colors.redAccent,
                    badgeContent: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndicator = SelectedIndicator.left;
                          _salesPos = 0;
                          _expensePos = size.width;
                        });
                      },
                      child: ImageIcon(
                        AssetImage('assets/images/exclamation_mark.png'),
                        size: 17,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          print('매출클릭');
                          _selectedIndicator = SelectedIndicator.left;
                          _salesPos = 0;
                          _expensePos = size.width;
                        });
                      },
                      child: Center(
                        child: Text(
                          '매출',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _selectedIndicator == SelectedIndicator.left
                                ? Colors.amberAccent
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    FocusScope.of(context).unfocus();
                    print('지출클릭');
                    _selectedIndicator = SelectedIndicator.right;
                    _salesPos = -size.width;
                    _expensePos = 0;
                  });
                },
                child: Center(
                  child: Text(
                    '지출',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: _selectedIndicator == SelectedIndicator.left
                          ? Colors.white
                          : Colors.redAccent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  AppBar _createScreenAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: blackColor,
      title: Text(
        'CREATE',
        style: TextStyle(
            color: _selectedIndicator == SelectedIndicator.left
                ? Colors.amberAccent
                : Colors.redAccent,
            // foreground:  Paint()..shader = mainColor,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic),
      ),
      iconTheme: IconThemeData(
          color: _selectedIndicator == SelectedIndicator.left
              ? Colors.amberAccent
              : Colors.redAccent),
      actionsIconTheme: IconThemeData(
          color: _selectedIndicator == SelectedIndicator.left
              ? Colors.amberAccent
              : Colors.redAccent),
      actions: [
        Stack(
          children: [
            Badge(
              showBadge: _showTabBarBadge,
              position: BadgePosition.topEnd(end: 5, top: 5),
              badgeColor: _selectedIndicator == SelectedIndicator.right
                  ? Colors.amberAccent
                  : Colors.redAccent,
              child: IconButton(
                icon: Icon(Icons.save),
                onPressed: () async{

                  UserModel userModel =
                      Provider.of<UserModelState>(context, listen: false)
                          .userModel;

                  // FirebaseFirestore.instance
                  //     .collection(COLLECTION_SALES)
                  //     .doc(userModel.userKey)
                  //     .collection('subSales')
                  //     .doc('$pickerDate'.substring(0, 10))
                  //     .set({
                  //   'user_key' : userModel.userKey,
                  //   'totalSales' : _totalSalesController.text,
                  //   'actualSales' : _actualSalesController.text,
                  //   'selectedDate' : pickerDate.toUtc().toString().substring(0,10),
                  //   'stdDate' : pickerDate.toUtc(),
                  //   // 'foodProvisionExpense' : _foodprovisionController.text,
                  //   // 'beverageExpense' : _beverageController.text,
                  //   // 'alcoholExpense' : _alcoholController.text,
                  // });
                  // FirebaseFirestore.instance
                  //     .collection(COLLECTION_SALES)
                  //     .doc(userModel.userKey)
                  //     .collection('subExpense')
                  //     .doc('$pickerDate'.substring(0, 10))
                  //     .set({
                  //   'stdDate' : pickerDate.toUtc(),
                  //   'foodProvisionExpense' : _foodprovisionController.text,
                  //   'beverageExpense' : _beverageController.text,
                  //   'alcoholExpense' : _alcoholController.text,
                  // });

                  final DocumentReference salesRef = FirebaseFirestore.instance.collection(COLLECTION_SALES).doc(userModel.userKey).collection('subSales')
                      .doc('$pickerDate'.substring(0, 10));
                  final DocumentSnapshot salesSnapshot = await salesRef.get();
                  if(!salesSnapshot.exists){
                    salesRef.set({
                        'user_key' : userModel.userKey,
                        'totalSales' : _totalSalesController.text,
                        'actualSales' : _actualSalesController.text,
                        'selectedDate' : pickerDate.toUtc().toString().substring(0,10),
                        'stdDate' : pickerDate.toUtc(),
                    });
                  }
                  final DocumentReference expenseRef = FirebaseFirestore.instance.collection(COLLECTION_SALES).doc(userModel.userKey).collection('subExpense')
                  .doc('$pickerDate'.substring(0, 10));
                  final DocumentSnapshot expenseSnapshot = await expenseRef.get();
                  if(!expenseSnapshot.exists){
                    expenseRef.set({
                        'stdDate' : pickerDate.toUtc(),
                      'selectedDate' : pickerDate.toUtc().toString().substring(0,10),
                      'foodProvisionExpense' : _foodprovisionController.text,
                        'beverageExpense' : _beverageController.text,
                        'alcoholExpense' : _alcoholController.text,
                      'etc' : [],
                    });
                  }

                  // final DocumentReference salesReference =
                  // FirebaseFirestore.instance.collection(COLLECTION_SALES).doc(
                  //   // uid);
                  //   // testKey(firebaseAuthState));
                  //     '$pickerDate'.substring(0, 10) + userModel.userKey);
                  // final DocumentSnapshot salesSnapshot = await salesReference.get();
                  // if (!salesSnapshot.exists) {
                  //   salesReference.set({
                  //     'user_key' : userModel.userKey,
                  //     'totalSales' : _totalSalesController.text,
                  //     'actualSales' : _actualSalesController.text,
                  //     'selectedDate' : pickerDate.toUtc().toString().substring(0,10),
                  //     'stdDate' : pickerDate.toUtc(),
                  //     'foodProvisionExpense' : _foodprovisionController.text,
                  //     'beverageExpense' : _beverageController.text,
                  //     'alcoholExpense' : _alcoholController.text,
                  //
                  //   });
                  // }
                  // await FirebaseFirestore.instance.collection(COLLECTION_SALES).doc(
                  //   // uid);
                  //   // testKey(firebaseAuthState));
                  //     '$pickerDate'.substring(0, 10) + userModel.userKey).set({
                  //   'user_key' : userModel.userKey,
                  //   'totalSales' : _totalSalesController.text,
                  // });
                  //
                  // await salesNetworkRepository.createSalesAdd(
                  //     widget.userKey,
                  //     SalesModel.getMapForCreateSales(
                  //       userKey: userModel.userKey,
                  //       actualSales: _actualSalesController.text,
                  //       totalSales: _totalSalesController.text,
                  //       selectedDate: pickerDate.toString().substring(0,10),
                  //       stdDate: pickerDate.toUtc(),
                  //       foodProvisionExpense: _foodprovisionController.text,
                  //       beverageExpense: _beverageController.text,
                  //       alcoholExpense: _alcoholController.text,
                  //     ));

                  setState(() {
                    FocusScope.of(context).unfocus();
                    if (!_formKey.currentState.validate()) {
                      _showTabBarBadge = true;
                    } else {
                      _showTabBarBadge = false;
                      _formKey.currentState.save();
                      Navigator.of(context).pop();
                    }
                    print(_totalSalesController.text);
                    print(_actualSalesController.text);
                  });
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 18, top: 18),
          child: InkWell(
            onTap: () {},
            child: Text(
              'save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

enum SelectedIndicator { left, right }