import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/duration.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';
import 'package:sharesales_ver2/firebase_firestore/firestore_management_repository.dart';
import 'package:sharesales_ver2/firebase_firestore/management_model.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
import 'package:sharesales_ver2/widget/date_picker_create_form.dart';
import 'package:sharesales_ver2/widget/expense_create_form.dart';
import 'package:sharesales_ver2/widget/expense_text_add_create_form.dart';
import 'package:sharesales_ver2/widget/sales_create_form.dart';
import 'package:sizer/sizer.dart';


class CreateManagementScreen extends StatefulWidget {

  final String? userKey;

  const CreateManagementScreen( {Key? key, this.userKey,}) : super(key: key);


  @override
  _CreateManagementScreenState createState() => _CreateManagementScreenState();
}

class _CreateManagementScreenState extends State<CreateManagementScreen> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SelectedIndicator _selectedIndicator = SelectedIndicator.left;

  double _salesPos = 0.w;
  double _expensePos = size.width.w;

  bool _showTabBarBadge = false;

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

  @override
  void initState() {
    expenseAddMapList.clear();
    expenseAmountTotal.clear();
    super.initState();
  }

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
                  DatePickerCreateForm(),
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
                          vosController: _vosController,
                          vatController: _vatController,
                          discountController: _discountController,
                          creditCardController: _creditCardController,
                          cashController: _cashController,
                          cashReceiptController: _cashReceiptController,
                          deliveryController: _deliveryController,
                          giftCardController: _giftCardController,
                        ),
                      ),
                      AnimatedContainer(
                        duration: mainDuration,
                        transform: Matrix4.translationValues(_expensePos, 0, 0),
                        curve: Curves.fastOutSlowIn,
                        child: ExpenseCreateForm(
                          foodProvisionsController: _foodProvisionController,
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
              ? Colors.deepPurple
              : Colors.pink,
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
                        ? Colors.deepPurple
                        : Colors.pink,
                    badgeContent: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndicator = SelectedIndicator.left;
                          _salesPos = 0;
                          _expensePos = size.width.w;
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
                          _expensePos = size.width.w;
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
                                ? Colors.deepPurple
                                : Colors.black54,
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
                    _salesPos = -size.width.w;
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
                          ? Colors.black54
                          : Colors.pink,
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
      backgroundColor: Colors.white,
      elevation: 10,
      title: Text(
        'CREATE',
        style: TextStyle(
            color: _selectedIndicator == SelectedIndicator.left
                ? Colors.deepPurple
                : Colors.pink,
            // foreground:  Paint()..shader = mainColor,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic),
      ),
      iconTheme: IconThemeData(
          color: _selectedIndicator == SelectedIndicator.left
              ? Colors.deepPurple
              : Colors.pink),
      actionsIconTheme: IconThemeData(
          color: _selectedIndicator == SelectedIndicator.left
              ? Colors.deepPurple
              : Colors.pink),
      actions: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Badge(
                showBadge: _showTabBarBadge,
                position: BadgePosition.topEnd(end: 5, top: 5),
                badgeColor: _selectedIndicator == SelectedIndicator.right
                    ? Colors.deepPurple
                    : Colors.pink,
                child: IconButton(
                  icon: Icon(Icons.save_alt_rounded, size: 35,),
                  onPressed: () async{

                    UserModel? userModel =
                        Provider.of<UserModelState>(context, listen: false)
                            .userModel;

                      FocusScope.of(context).unfocus();

                      if (!_formKey.currentState!.validate()) {
                        setState(() {
                          _showTabBarBadge = true;
                        });
                      } else {
                        _showTabBarBadge = false;
                        _formKey.currentState!.save();

                        await managementRepository.createManagement(context,
                            userModel!,
                            ManagementModel.createMapForManagementList(
                              userKey: userModel.userKey,
                              actualSales: _actualSalesController.text.isEmpty ? int.parse('0') : int.parse(_actualSalesController.text.replaceAll(",", "")),
                              totalSales: _totalSalesController.text.isEmpty ? int.parse('0') : int.parse(_totalSalesController.text.replaceAll(",", "")),
                              vos: _vosController.text.isEmpty ? int.parse('0') : int.parse(_vosController.text.replaceAll(",", "")),
                              vat: _vatController.text.isEmpty ? int.parse('0') : int.parse(_vatController.text.replaceAll(",", "")),
                              discount: _discountController.text.isEmpty ? int.parse('0') : int.parse(_discountController.text.replaceAll(",", "")),
                              creditCard: _creditCardController.text.isEmpty ? int.parse('0') : int.parse(_creditCardController.text.replaceAll(",", "")),
                              cash: _cashController.text.isEmpty ? int.parse('0') : int.parse(_cashController.text.replaceAll(",", "")),
                              cashReceipt: _cashReceiptController.text.isEmpty ? int.parse('0') : int.parse(_cashReceiptController.text.replaceAll(",", "")),
                              delivery: _deliveryController.text.isEmpty ? int.parse('0') : int.parse(_deliveryController.text.replaceAll(",", "")),
                              giftCard: _giftCardController.text.isEmpty ? int.parse('0') : int.parse(_giftCardController.text.replaceAll(",", "")),
                              selectedDate: pickerDate.toUtc().toString().substring(0, 10),
                              expenseAddList: expenseAddMapList,
                              expenseAddTotalAmount: expenseAmountTotal.isEmpty?int.parse('0') : expenseAmountTotal.reduce((v, e) => v+e),
                              stdDate: pickerDate.toUtc(),
                              foodProvisionExpense: _foodProvisionController.text.isEmpty ? int.parse('0') : int.parse(_foodProvisionController.text.replaceAll(",", "")),
                              beverageExpense: _beverageController.text.isEmpty ? int.parse('0') : int.parse(_beverageController.text.replaceAll(",", "")),
                              alcoholExpense: _alcoholController.text.isEmpty ? int.parse('0') : int.parse(_alcoholController.text.replaceAll(",", "")),
                            ) as Map<String, dynamic>,);
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