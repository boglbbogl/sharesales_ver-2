import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/duration.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/constant/snack_bar_style.dart';
import 'package:sharesales_ver2/widget/expense_create_form.dart';
import 'package:sharesales_ver2/widget/sales_create_form.dart';

class CreateManagementScreen extends StatefulWidget {
  @override
  _CreateManagementScreenState createState() => _CreateManagementScreenState();
}

class _CreateManagementScreenState extends State<CreateManagementScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SelectedIndicator _selectedIndicator = SelectedIndicator.left;

  double _salesPos = 0;
  double _expensePos = size.width;

  @override
  Widget build(BuildContext context) {
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
                        child: SalesCreateForm()),
                    AnimatedContainer(
                        duration: mainDuration,
                        transform: Matrix4.translationValues(_expensePos, 0, 0),
                        curve: Curves.fastOutSlowIn,
                        child: ExpenseCreateForm()),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  SnackBar saveSnackBar = SnackBar(
    content: Text(
      '매출 항목은 필수로 입력 해야 합니다.  0을 입력하세요',
      // maxLines: 2,
      style: snackBarStyle(),
    ),
    backgroundColor: Colors.lightBlueAccent,
  );

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
                    color: _selectedIndicator == SelectedIndicator.left ? Colors.amberAccent: Colors.redAccent,
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
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              print('매출클릭');
                              _selectedIndicator = SelectedIndicator.left;
                              _salesPos = 0;
                              _expensePos = size.width;
                              FocusScope.of(context).unfocus();
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
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              print('지출클릭');
                              _selectedIndicator = SelectedIndicator.right;
                              _salesPos = -size.width;
                              _expensePos = 0;
                              FocusScope.of(context).unfocus();
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
          color: _selectedIndicator == SelectedIndicator.left ? Colors.amberAccent : Colors.redAccent,
            // foreground:  Paint()..shader = mainColor,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic),
      ),
      iconTheme: IconThemeData(
          color: _selectedIndicator == SelectedIndicator.left ? Colors.amberAccent : Colors.redAccent),
      actionsIconTheme: IconThemeData(
          color: _selectedIndicator == SelectedIndicator.left ? Colors.amberAccent : Colors.redAccent),
      actions: [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: () {
            FocusScope.of(context).unfocus();
            if (!_formKey.currentState.validate()) {
              return ;
              // return Scaffold.of(context).showSnackBar(saveSnackBar);
            }  else
            _formKey.currentState.save();
          },
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


enum SelectedIndicator{left, right}