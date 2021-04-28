import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/app_bar.dart';
import 'package:sharesales_ver2/constant/duration.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
import 'package:sharesales_ver2/widget/account_screen_body.dart';
import 'package:sharesales_ver2/widget/account_screen_side_menu.dart';
import 'package:sharesales_ver2/widget/my_progress_indicator.dart';
import 'package:sizer/sizer.dart';

import 'management_screen.dart';


class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  @override
  Widget build(BuildContext context) {

    UserModel userModel =
        Provider.of<UserModelState>(context, listen: false).userModel!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(COLLECTION_SALES_MANAGEMENT)
          .doc(userModel.userKey)
          .collection(userModel.userName!)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData || snapshot.data == null || snapshot.hasError ) {
          return MyProgressIndicator();
        }
        
        final nowActualSalesList = [];
        final nowTotalExpenseList = [];
        final lastActualSalesList = [];
        final lastTotalExpenseList = [];

        DateTime now = DateTime.now();

        snapshot.data!.docs.forEach((element) {
          if(element['selectedDate'].toString().substring(0,7)==DateTime(now.year, now.month).toString().substring(0,7)) {
            nowActualSalesList.add(element['actualSales']);
            nowTotalExpenseList.add(element['expenseAddTotalAmount'] + element['foodProvisionExpense'] + element['alcoholExpense'] + element['beverageExpense']);
          } else if(element['selectedDate'].toString().substring(0,7)==DateTime(now.year, now.month-1).toString().substring(0,7)){
            lastActualSalesList.add(element['actualSales']);
            lastTotalExpenseList.add(element['expenseAddTotalAmount'] + element['foodProvisionExpense'] + element['alcoholExpense'] + element['beverageExpense']);
          }
        });

        int? nowActualSales = nowActualSalesList.isEmpty ? int.parse('0') : nowActualSalesList.reduce((v, e) => v+e);
        int? nowTotalExpense = nowTotalExpenseList.isEmpty ? int.parse('0') : nowTotalExpenseList.reduce((v, e) => v+e);
        int? lastActualSales = lastActualSalesList.isEmpty ? int.parse('0') : lastActualSalesList.reduce((v, e) => v+e);
        int? lastTotalExpense = lastTotalExpenseList.isEmpty ? int.parse('0') : lastTotalExpenseList.reduce((v, e) => v+e);
        
        return SafeArea(
          child: GestureDetector(
            onTap: (){},
            child: Scaffold(
              appBar: mainAppBar(context, '가게명', Colors.deepPurple[50],IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.deepPurpleAccent,
                ),
                onPressed: () {

                },
              )),
              backgroundColor: Colors.deepPurple[50],
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 33.h,
                        width: 80.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              height: 11.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.deepPurple[100],
                              ),
                              child: Row(
                                children: <Widget>[
                                  _accountScreenNowLastMonthTextForm(now, Colors.lightBlueAccent, now.month),
                                  _accountScreenMonthBodyTextForm(nowActualSales!, nowTotalExpense!),
                                ],
                              ),
                            ),
                            Container(
                              height: 11.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.deepPurple[100],
                              ),
                              child: Row(
                                children: <Widget>[
                                  _accountScreenMonthBodyTextForm(lastActualSales!, lastTotalExpense!),
                                  _accountScreenNowLastMonthTextForm(now, Colors.orangeAccent, now.month-1),
                                ],
                              ),
                            ),
                            Container(
                              height: 10.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.deepPurple[100],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 5.h,
                                    child: Row(
                                      children: <Widget>[
                                        _accountScreenSalesAndExpenseLeftForm('매출',BorderRadius.vertical(top: Radius.circular(20))),
                                        Container(
                                            width: 55.w,
                                            child: Center(
                                                child: Text(koFormatMoney.format(nowActualSales-lastActualSales)))),
                                      ],
                                    ),),
                                  Container(
                                    height: 5.h,
                                    child: Row(
                                      children: [
                                        _accountScreenSalesAndExpenseLeftForm('지출',BorderRadius.vertical(bottom: Radius.circular(20))),
                                        Container(
                                            width: 55.w,
                                            child: Text(koFormatMoney.format(nowTotalExpense-lastTotalExpense))),
                                      ],
                                    ),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Container _accountScreenMonthBodyTextForm(int nowActualSales, int nowTotalExpense) {
    return Container(
      width: 60.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('매출   ' + koFormatMoney.format(nowActualSales)+ '  \\',
            style: TextStyle(
                color: Colors.black54, fontSize: 16),),
          SizedBox(height: 3,),
          Text('지출   ' + koFormatMoney.format(nowTotalExpense)+ '  \\',
            style: TextStyle(
                color: Colors.black54, fontSize: 16),),
        ],
      ),
    );
  }

  Container _accountScreenNowLastMonthTextForm(DateTime now, Color mainColor, monthType) {
    return Container(
      width: 20.w,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(DateTime(now.year, monthType).toString().substring(5,7),
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(DateTime(now.year, monthType).toString().substring(0,4),
            style: TextStyle(color: Colors.white),)
        ],
      ),
    );
  }
  Container _accountScreenSalesAndExpenseLeftForm(String title, radius) {
    return Container(width: 25.w,
      decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: radius
      ),
      child: Center(child: Text(title,style: TextStyle(color: Colors.white),),),
    );
  }
}

