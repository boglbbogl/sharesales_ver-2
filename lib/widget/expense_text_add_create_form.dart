import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/constant/snack_bar_style.dart';
import 'package:sharesales_ver2/screen/management_screen.dart';
import 'package:sizer/sizer.dart';


List<Map<dynamic, dynamic>> expenseAddMapList = [];
List<int> expenseAmountTotal = [];

class ExpenseTextAddCreateForm extends StatefulWidget {
  @override
  _ExpenseTextAddCreateFormState createState() => _ExpenseTextAddCreateFormState();
}

class _ExpenseTextAddCreateFormState extends State<ExpenseTextAddCreateForm> {

  bool _titleBadge = false;
  bool _amountBadge = false;

  TextEditingController expenseTitleController = TextEditingController();
  TextEditingController expenseAmountController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    expenseTitleController.dispose();
    expenseAmountController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget> [
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 80.w,
                height: 5.h,
                child: Text('추가 지출', style: TextStyle(color: Colors.black54, fontSize: 20), textAlign: TextAlign.center,),
              ),
            ],
          ),
      _expenseTextAddTff(),
      _expenseTextAddDivider(context),
        Container(
          height: 40.h,
          width: 98.w,
          child: ListView(
            shrinkWrap: true,
            controller: _scrollController,
            children: expenseAddMapList
                .map((expense) => _expenseTextAddListView(expense))
                .toList(),
          ),
        )
      ],
    );
  }

  Stack _expenseTextAddDivider(BuildContext context) {
    return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              height: 1,
              child: Container(
                color: Colors.deepOrange,
                height: 1,
              ),
            ),
            Container(
              color: Colors.deepOrange,
              height: 2,
              width: 90.w,
            ),
            Container(
              height: 30,
              width: 50.w,
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    FocusScope.of(context).unfocus();
                      if (expenseTitleController.text.isEmpty) {
                        _titleBadge = true;
                        return snackBarManagementScreenTopFlushBar(context, '내용을 입력해 주세요', '필수 입력사항 입니다');
                      } else if (expenseAmountController.text.isEmpty) {
                        _titleBadge = false;
                        _amountBadge = true;
                        return snackBarManagementScreenTopFlushBar(context, '지출금액을 입력해 주세요', '필수 입력사항 입니다');
                      }
                      _amountBadge = false;
                      _titleBadge = false;

                    expenseAddMapList.addAll([{
                      'title': expenseTitleController.text.trim(),
                      'expenseAmount': int.parse(expenseAmountController.text.replaceAll(",", "")),
                    }]);
                    expenseAmountTotal.add(int.parse(expenseAmountController.text.replaceAll(",", "")));
                  });

                  if(_titleBadge == false && _amountBadge == false)
                  expenseTitleController.clear();
                  expenseAmountController.clear();
                },

                elevation: 0,
                color: Colors.deepOrangeAccent,
                splashColor: Colors.deepPurple,
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
          ],
        );
  }

  Row _expenseTextAddTff() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            height: 8.h,
            width: 50.w,
            child: Stack(
              children: [
                Badge(
                  showBadge: _titleBadge,
                  position: BadgePosition.topEnd(end: 10, top: 30),
                  badgeColor: Colors.green,
                  child: TextFormField(
                    controller: expenseTitleController,
                    style: salesInputStyle(),
                    cursorColor: Colors.white,
                    decoration: expenseTextAddInputDecor('내용'),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 8.h,
            width: 30.w,
            child: Stack(
              children: [
                Badge(
                  showBadge: _amountBadge,
                  position: BadgePosition.topEnd(end: 10, top: 30),
                  badgeColor: Colors.green,
                  child: TextFormField(
                    inputFormatters: [wonMaskFormatter],
                    controller: expenseAmountController,
                    style: salesInputStyle(),
                    cursorColor: Colors.white,
                    decoration: expenseTextAddInputDecor('지출금액'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  }

  Widget _expenseTextAddListView(Map<dynamic, dynamic> expense,){
   return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 19, left: 10),
          child: Text(
            '내용 : ',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        Flexible(
          child: ListTile(
            onTap: () {
              // _toggleExpense(addText);123123
            },
          title: Text(
              expense.values.first, style: TextStyle(color: Colors.black),
              ),
            ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 19, left: 10),
          child: Text(
            '/ ',
            style: TextStyle(color: Colors.black),
          ),
        ),
        Flexible(
          child: ListTile(
            onTap: () {
              // _toggleExpense(addText);123123
            },
            title: Text(
              koFormatMoney.format(expense.values.last),
              style: TextStyle(color: Colors.black),
            ),
            trailing: SizedBox(
              width: 35,
              child: IconButton(
                color: Colors.black54,
                icon: Icon(Icons.delete_forever),
                onPressed: () {
                  setState(() {
                    print(expense.values.last);
                    expenseAddMapList.remove(expense);
                    expenseAmountTotal.remove(expense.values.last);
                  });
                  // print(expense);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  SnackBar titleSnackBar = SnackBar(
    duration: Duration(seconds: 1),
    content: Text(
      '지출 내용을 입력 해주세요',
      style: snackBarStyle(),
    ),
    backgroundColor: Colors.lightBlueAccent,
  );

  SnackBar amountSnackBar = SnackBar(
    duration: Duration(seconds: 1),
    content: Text(
      '지출 금액을 입력 해주세요',
      style: snackBarStyle(),
    ),
    backgroundColor: Colors.lightBlueAccent,
  );
}
