import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/app_bar.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/duration.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
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
        double actualSalesPercentage = (nowActualSales!/lastActualSales!)*100;
        double totalExpensePercentage = (nowTotalExpense!/lastTotalExpense!)*100;

        return SafeArea(
          child: GestureDetector(
            onTap: (){},
            child: Scaffold(
              appBar: mainAppBar(context, 'share sales', Colors.deepPurple[50],IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.deepPurpleAccent,
                ),
                onPressed: () {

                },
              ),
              appBarBottom: PreferredSize(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text('돈까스상회',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 28,
                      foreground: Paint()..shader = secondMainColor,
                    ),),
                  ),
                  preferredSize: Size(size.width*0.8, 50))
              ),
              backgroundColor: Colors.deepPurple[50],
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 26.h,
                        width: 80.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              height: 8.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.deepPurple.shade100,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: <Widget>[
                                    _accountScreenNowLastMonthTextForm(now, Colors.lightBlueAccent, now.month),
                                    _accountScreenMonthBodyTextForm(nowActualSales, nowTotalExpense),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 8.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.deepPurple.shade100,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: <Widget>[
                                    _accountScreenMonthBodyTextForm(lastActualSales, lastTotalExpense),
                                    _accountScreenNowLastMonthTextForm(now, Colors.orangeAccent, now.month-1),
                                  ],
                                ),
                              ),
                            ),
                            _accountScreenPostItFormByCompare(
                                now, nowActualSales, lastActualSales, actualSalesPercentage, nowTotalExpense, lastTotalExpense, totalExpensePercentage),
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

  Container _accountScreenPostItFormByCompare(DateTime now, int nowActualSales, int lastActualSales, double? actualSalesPercentage,
      int nowTotalExpense, int lastTotalExpense, double? totalExpensePercentage) {
    return Container(
                            height: 8.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.deepPurple.shade100,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: <Widget>[
                              Container(
                              width: 25.w,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(DateTime(now.year, now.month-1).toString().substring(6,7) + '월',
                                        style: TextStyle(fontSize: 22 ,fontWeight: FontWeight.bold, color: Colors.white)),
                                    Text('대비',
                                      style: TextStyle(fontSize: 22 ,fontWeight: FontWeight.bold, color: Colors.white),)
                                  ],
                                ),
                              ),
                              Container(
                                width: 55.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _accountScreenNowLastCompareTextForm('',nowActualSales, lastActualSales, actualSalesPercentage!.isNaN || actualSalesPercentage.isInfinite ? double.parse('0.0') : actualSalesPercentage),
                                    _accountScreenNowLastCompareTextForm('',nowTotalExpense, lastTotalExpense, totalExpensePercentage!.isNaN || totalExpensePercentage.isInfinite ? double.parse('0.0') : totalExpensePercentage),
                                  ],
                                ),
                              ),
                                ],
                              ),
                            ),
                          );
  }

  Row _accountScreenNowLastCompareTextForm(String title, int nowData, int lastData, double percentage) {
    return Row(
                                      children: [
                                        SizedBox(height: 1.5.h,),
                                        Container(
                                          height: 2.5.h,
                                          width: 5.w,
                                            child: Center(child: Text(title,style: TextStyle(
                                              color: (nowData>lastData)? Colors.blue:Colors.red,
                                              fontSize: 17,
                                            ),),)),
                                        Container(
                                          width: 45.w,
                                          child: Center(
                                            child: Text(koFormatMoney.format(nowData-lastData)+'  \\   /   ' + percentage.toStringAsFixed(1)+'  %',
                                            style: TextStyle(
                                              color: (nowData>lastData)? Colors.green.shade600:Colors.red, fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),),
                                          ),
                                        ),
                                      ],
                                    );
  }
  Container _accountScreenMonthBodyTextForm(int nowActualSales, int nowTotalExpense) {
    return Container(
      width: 55.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('매출   ' + koFormatMoney.format(nowActualSales)+ '  \\',
            style: TextStyle(
                color: Colors.black54, fontSize: 18),),
          SizedBox(height: 3,),
          Text('지출   ' + koFormatMoney.format(nowTotalExpense)+ '  \\',
            style: TextStyle(
                color: Colors.black54, fontSize: 18),),
        ],
      ),
    );
  }

  Container _accountScreenNowLastMonthTextForm(DateTime now, Color mainColor, monthType) {
    return Container(
      width: 25.w,
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
}

