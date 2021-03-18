import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/duration.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/constant/snack_bar_style.dart';
import 'package:sharesales_ver2/models/firestore/sales_model.dart';
import 'package:sharesales_ver2/models/firestore/user_model.dart';
import 'package:sharesales_ver2/models/user_model_state.dart';
import 'package:sharesales_ver2/repository/firestore_management_repository.dart';
import 'package:sharesales_ver2/widget/date_picker_cupertino.dart';
import 'package:sharesales_ver2/widget/expense_create_form.dart';
import 'package:sharesales_ver2/widget/expense_text_add_create_form.dart';
import 'package:sharesales_ver2/widget/sales_create_form.dart';


class CreateManagementScreen extends StatefulWidget {

  // final List expenseAddMapList;
  final String userKey;

  const CreateManagementScreen( {Key key, this.userKey,}) : super(key: key);


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
  void initState() {
    expenseAddMapList.clear();
    super.initState();
  }

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
          child: Builder(
            builder: (BuildContext context) =>
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(),
                  DatePickerCupertino(),
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
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Badge(
                showBadge: _showTabBarBadge,
                position: BadgePosition.topEnd(end: 5, top: 5),
                badgeColor: _selectedIndicator == SelectedIndicator.right
                    ? Colors.amberAccent
                    : Colors.redAccent,
                child: IconButton(
                  icon: Icon(Icons.save_alt_rounded, size: 35,),
                  onPressed: () async{

                    UserModel userModel =
                        Provider.of<UserModelState>(context, listen: false)
                            .userModel;

                      FocusScope.of(context).unfocus();

                      if (!_formKey.currentState.validate()) {
                        setState(() {
                          _showTabBarBadge = true;
                        });
                      } else {
                        _showTabBarBadge = false;
                        _formKey.currentState.save();
                        Navigator.of(context).pop();
                        await managementRepository.createManagement(context,
                            userModel,
                            SalesModel.createMapForManagementList(
                              userKey: userModel.userKey,
                              actualSales: _actualSalesController.text,
                              totalSales: _totalSalesController.text,
                              selectedDate: pickerDate.toUtc().toString().substring(0, 10),
                              expenseAddList: expenseAddMapList,
                              stdDate: pickerDate.toUtc(),
                              foodProvisionExpense: _foodprovisionController.text,
                              beverageExpense: _beverageController.text,
                              alcoholExpense: _alcoholController.text,
                            ));
                      }
                    },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

enum SelectedIndicator { left, right }