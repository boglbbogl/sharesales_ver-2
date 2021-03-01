import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/duration.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/widget/date_picker_cupertino.dart';
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

  bool _showTabBarBadge = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: _createScreenAppbar(context),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
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
                onPressed: () {
                  setState(() {
                    FocusScope.of(context).unfocus();
                    if (!_formKey.currentState.validate()) {
                      _showTabBarBadge = true;
                    } else
                      _showTabBarBadge = false;
                    _formKey.currentState.save();
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
