import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/constant/snack_bar_style.dart';

class AddText {
  bool isDone;
  String expenseTitle;
  String expenseAmount;

  AddText(this.expenseTitle, this.expenseAmount, {this.isDone = false});
}

class TextAddForm extends StatefulWidget {
  @override
  _TextAddFormState createState() => _TextAddFormState();
}

class _TextAddFormState extends State<TextAddForm> {
  final _expenseList = <AddText>[];

  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _titleController.dispose();
    _scrollController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _titleTextFormField(),
            _amountTextFormField(),
          ],
        ),
        _textAddFormDivider(context),
        Container(
          height: size.height * 0.5,
          width: size.width * 0.98,
          child: ListView(
            controller: _scrollController,
            children: _expenseList
                .map((addText) => _expenseListView(addText))
                .toList(),
          ),
        )
      ],
    );
  }

  Container _amountTextFormField() {
    return Container(
      height: expTtfHeightSize,
      width: expTtfWidthSize,
      child: TextFormField(
        controller: _amountController,
        style: blackInputStyle(),
        cursorColor: Colors.white,
        decoration: expenseTextAddInputDecor('지출금액'),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Container _titleTextFormField() {
    return Container(
      height: salTtfHeightSize,
      width: salTtfWidthSize * 1.5,
      child: TextFormField(
        controller: _titleController,
        style: blackInputStyle(),
        cursorColor: Colors.white,
        decoration: expenseTextAddInputDecor('내용'),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Stack _textAddFormDivider(BuildContext context) {
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
          height: 1,
          width: size.width * 0.9,
        ),
        Container(
          height: 30,
          width: size.width * 0.5,
          child: RaisedButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (_titleController.text.isEmpty) {
                return Scaffold.of(context).showSnackBar(titleSnackBar);
              } else if (_amountController.text.isEmpty) {
                return Scaffold.of(context).showSnackBar(amountSnackBar);
              }
              _addExpense(
                  AddText(_titleController.text, _amountController.text));
            },
            elevation: 0,
            color: Colors.grey,
            splashColor: Colors.redAccent,
            child: Text(
              'CLICK',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }

  SnackBar titleSnackBar = SnackBar(
    content: Text(
      '지출 내용을 입력 해주세요',
      style: snackBarStyle(),
    ),
    backgroundColor: Colors.lightBlueAccent,
    action: SnackBarAction(label: '취소', onPressed: (){},),
  );

  SnackBar amountSnackBar = SnackBar(
    content: Text(
      '지출 금액을 입력 해주세요',
      style: snackBarStyle(),
    ),
    backgroundColor: Colors.lightBlueAccent,
  );


  Widget _expenseListView(AddText addText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
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
              _toggleExpense(addText);
            },
            title: Text(
              addText.expenseTitle,
              style: addText.isDone
                  ? TextStyle(
                      color: Colors.redAccent,
                      decoration: TextDecoration.lineThrough,
                      fontStyle: FontStyle.italic,
                    )
                  : TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 19),
          child: Text(
            '지출금액 : ',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Flexible(
          child: ListTile(
            onTap: () {
              _toggleExpense(addText);
            },
            title: Text(
              addText.expenseAmount,
              style: addText.isDone
                  ? TextStyle(
                      color: Colors.redAccent,
                      decoration: TextDecoration.lineThrough,
                      fontStyle: FontStyle.italic,
                    )
                  : TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
            ),
            trailing: SizedBox(
              width: 35,
              child: IconButton(
                color: Colors.white,
                icon: Icon(Icons.delete_forever),
                onPressed: () {
                  _deleteExpense(addText);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _addExpense(AddText addText) {
    setState(() {
      _expenseList.add(addText);
      _titleController.text = '';
      _amountController.text = '';
    });
  }

  void _deleteExpense(AddText addText) {
    setState(() {
      _expenseList.remove(addText);
    });
  }

  void _toggleExpense(AddText addText) {
    setState(() {
      addText.isDone = !addText.isDone;
    });
  }
}
