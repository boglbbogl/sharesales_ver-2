import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import '../constant/input_decor.dart';
import '../constant/size.dart';

List<Map<String, String>> expenseAddMapList = [];

class ExpenseTextAddCreateForm extends StatefulWidget {
  @override
  _ExpenseTextAddCreateFormState createState() => _ExpenseTextAddCreateFormState();
}

class _ExpenseTextAddCreateFormState extends State<ExpenseTextAddCreateForm> {

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

  // List<Map<String, String>> expenseAddMapList = [{}];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
          children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: salTtfHeightSize,
              width: salTtfWidthSize * 1.5,
              child: Stack(
                children: [
                  Badge(
                    // showBadge: _titleBadge,
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
                    // showBadge: _amountBadge,
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
        ),
            RaisedButton(
                child: Text('array save'),
                onPressed: () {
                  setState(() {
                    expenseAddMapList.addAll([{
                      'title': expenseTitleController.text.trim(), 'expenseAmount': expenseAmountController.text.trim(),
                    }]);
                  });
                    expenseTitleController.clear();
                    expenseAmountController.clear();
                    print(expenseAddMapList);
                }),
            FlatButton(
              color: Colors.deepPurple,
                child: Text('Firestore save'),
                onPressed: () {
                print(expenseAddMapList);
                  setState(() {
                  });
                }),
            Container(
              height: size.height * 0.6,
              width: size.width * 0.98,
              child: ListView(
                controller: _scrollController,
                children: expenseAddMapList
                    .map((expense) => _expenseListView(expense))
                    .toList(),
              ),
            )
      ],
      ),
    );
  }
  Widget _expenseListView(Map<String, String> expense){
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
              expense['title'], style: TextStyle(color: Colors.white),
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
                    expenseAddMapList.remove(expense);
                  });
                  print(expense);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
