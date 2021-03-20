import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:sharesales_ver2/constant/snack_bar_style.dart';
import '../constant/input_decor.dart';
import '../constant/size.dart';

List<Map<String, String>> expenseAddMapList = [];

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
                width: size.width*0.85,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                  width: size.width*0.84,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Container(
                width: size.width*0.83,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text('추가 지출',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),),
              ),
            ],
          ),
      _expenseTextAddTff(),
      _expenseTextAddDivider(context),
        Container(
          height: size.height * 0.4,
          width: size.width * 0.98,
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
                color: Colors.red,
                height: 1,
              ),
            ),
            Container(
              color: Colors.white,
              height: 2,
              width: size.width * 0.85,
            ),
            Container(
              height: 30,
              width: size.width * 0.5,
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
                      'expenseAmount': expenseAmountController.text.trim(),
                    }]);
                  });

                  if(_titleBadge == false && _amountBadge == false)
                  expenseTitleController.clear();
                  expenseAmountController.clear();
                },

                elevation: 0,
                color: Colors.grey,
                splashColor: Colors.redAccent,
                child: Text(
                  '추가하기',
                  style: TextStyle(
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
            height: salTtfHeightSize,
            width: salTtfWidthSize * 1.5,
            child: Stack(
              children: [
                Badge(
                  showBadge: _titleBadge,
                  position: BadgePosition.topEnd(end: 10, top: 30),
                  badgeColor: Colors.amberAccent,
                  child: TextFormField(
                    controller: expenseTitleController,
                    style: blackInputStyle(),
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
            height: expTtfHeightSize,
            width: expTtfWidthSize,
            child: Stack(
              children: [
                Badge(
                  showBadge: _amountBadge,
                  position: BadgePosition.topEnd(end: 10, top: 30),
                  badgeColor: Colors.amberAccent,
                  child: TextFormField(
                    inputFormatters: [wonMaskFormatter],
                    controller: expenseAmountController,
                    style: blackInputStyle(),
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

  Widget _expenseTextAddListView(Map<String, String> expense){
   return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 19, left: 10),
          child: Text(
            '내용 : ',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Flexible(
          child: ListTile(
            onTap: () {
              // _toggleExpense(addText);123123
            },
          title: Text(
              expense.values.first, style: TextStyle(color: Colors.white),
              ),
            ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 19, left: 10),
          child: Text(
            '/ ',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Flexible(
          child: ListTile(
            onTap: () {
              // _toggleExpense(addText);123123
            },
            title: Text(
              expense.values.last, style: TextStyle(color: Colors.white),
            ),
            trailing: SizedBox(
              width: 35,
              child: IconButton(
                color: Colors.white,
                icon: Icon(Icons.delete_forever),
                onPressed: () {
                  setState(() {
                    print(expense.values.last);
                    expenseAddMapList.remove(expense);
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
