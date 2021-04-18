import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/duration.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
import 'package:sharesales_ver2/screen/management_screen.dart';

class AccountScreenBody extends StatefulWidget {
  final Function onPageChanged;
  final int nowActualSales;
  final int nowTotalExpense;
  final int lastActualSales;
  final int lastTotalExpense;

  const AccountScreenBody(this.nowActualSales, this.nowTotalExpense, this.lastActualSales, this.lastTotalExpense,
      {Key key, this.onPageChanged}) : super(key: key);

  @override
  _AccountScreenBodyState createState() => _AccountScreenBodyState();
}

class _AccountScreenBodyState extends State<AccountScreenBody> with SingleTickerProviderStateMixin {
  AnimationController _iconAniController;

  @override
  void initState() {
    _iconAniController = AnimationController(
      vsync: this,
      duration: mainDuration,
    );
    super.initState();
  }

  @override
  void dispose() {
    _iconAniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    DateTime now = DateTime.now();
    int nowActualSales = widget.nowActualSales==null ? int.parse('0') : widget.nowActualSales;
    int nowTotalExpense = widget.nowTotalExpense==null ? int.parse('0') : widget.nowTotalExpense;
    int lastActualSales = widget.lastActualSales==null ? int.parse('0') : widget.lastActualSales;
    int lastTotalExpense = widget.lastTotalExpense==null ? int.parse('0') : widget.lastTotalExpense;

    UserModel userModel =
        Provider.of<UserModelState>(context, listen: false).userModel;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple[50],
        appBar: _accountScreenAppBarForm(userModel),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30,),
              Container(
                height: size.height*0.33,
                width: size.width*0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      height: size.height*0.11,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepPurple[100],
                      ),
                      child: Row(
                        children: <Widget>[
                          _accountScreenNowLastMonthTextForm(now, Colors.lightBlueAccent, now.month),
                          _accountScreenMonthBodyTextForm(nowActualSales, nowTotalExpense),
                        ],
                      ),
                    ),
                    Container(
                      height: size.height*0.11,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepPurple[100],
                      ),
                      child: Row(
                        children: <Widget>[
                          _accountScreenMonthBodyTextForm(lastActualSales, lastTotalExpense),
                          _accountScreenNowLastMonthTextForm(now, Colors.orangeAccent, now.month-1),
                        ],
                      ),
                    ),
                    Container(
                      height: size.height*0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepPurple[100],
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: size.height*0.05,
                          child: Row(
                            children: <Widget>[
                              _accountScreenSalesAndExpenseLeftForm('매출',BorderRadius.vertical(top: Radius.circular(20))),
                              Container(
                                width: size.width*0.6,
                                  child: Text(koFormatMoney.format(nowActualSales-lastActualSales))),
                            ],
                          ),),
                          Container(
                            height: size.height*0.05,
                          child: Row(
                            children: [
                              _accountScreenSalesAndExpenseLeftForm('지출',BorderRadius.vertical(bottom: Radius.circular(20))),
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
    );
  }

  Container _accountScreenSalesAndExpenseLeftForm(String title, radius) {
    return Container(width: size.width*0.2,
                            decoration: BoxDecoration(
                            color: Colors.redAccent,
                              borderRadius: radius
                            ),
                              child: Center(child: Text(title,style: TextStyle(color: Colors.white),),),
                            );
  }

  AppBar _accountScreenAppBarForm(UserModel userModel) {
    return AppBar(
        backgroundColor: Colors.deepPurple[50],
        elevation: 0,
        title: Center(
          child: Text(userModel.userName,
              style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: 28,
            foreground: Paint()..shader = secondMainColor,
          ),),
        ),
        leading: IconButton(
          color: Colors.white,
          onPressed: (){},
          icon: Icon(Icons.add, color: Colors.deepPurple[50],),
        ),
        actions: [
                IconButton(
                  color: Colors.deepPurple,
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      progress: _iconAniController,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.onPageChanged();
                        _iconAniController.status == AnimationStatus.completed ? _iconAniController.reverse() : _iconAniController.forward();
                      });
                    }),
        ],
      );
  }

  Container _accountScreenMonthBodyTextForm(int nowActualSales, int nowTotalExpense) {
    return Container(
                          width: size.width*0.6,
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
                          width: size.width*0.2,
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
