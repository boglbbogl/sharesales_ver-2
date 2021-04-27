import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/duration.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
import 'package:sharesales_ver2/widget/account_screen_body.dart';
import 'package:sharesales_ver2/widget/account_screen_side_menu.dart';
import 'package:sharesales_ver2/widget/my_progress_indicator.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final sideWidth = size.width / 2;

  PageSlide _pageSlide = PageSlide.closed;
  double pagePos = size.width;
  double bodyPos = 0;


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
        if(!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
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

        int? nowActualSales = nowActualSalesList.reduce((v, e) => v+e);
        int? nowTotalExpense = nowTotalExpenseList.reduce((v, e) => v+e);
        int? lastActualSales = lastActualSalesList.reduce((v, e) => v+e);
        int? lastTotalExpense = lastTotalExpenseList.reduce((v, e) => v+e);
        
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.deepPurple[50],
            body: Stack(
              children: <Widget>[
                AnimatedContainer(
                  duration: mainDuration,
                  child: AccountScreenBody(nowActualSales, nowTotalExpense, lastActualSales, lastTotalExpense,onPageChanged: () {
                    setState(() {
                      _pageSlide = (_pageSlide == PageSlide.closed)
                          ? PageSlide.opened
                          : PageSlide.closed;
                      switch (_pageSlide) {
                        case PageSlide.opened:
                          bodyPos = -sideWidth;
                          pagePos = size.width - sideWidth;
                          break;
                        case PageSlide.closed:
                          bodyPos = 0;
                          pagePos = size.width;
                          break;
                      }
                    });
                  }),
                  transform: Matrix4.translationValues(bodyPos, 0, 0),
                ),
                AnimatedContainer(
                  transform: Matrix4.translationValues(pagePos, 0, 0),
                  duration: mainDuration,
                  child: AccountScreenSideMenu(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum PageSlide { opened, closed }
