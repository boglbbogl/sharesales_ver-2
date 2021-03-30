import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/constant/snack_bar_style.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
import '../../widget/date_picker_create_form.dart';


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

  bool _titleBadge = false;
  bool _amountBadge = false;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  final List _expenseList = <AddText>[
  ];




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
      child: Stack(
        children: [
          Badge(
            showBadge: _amountBadge,
            position: BadgePosition.topEnd(end: 10,top: 30),
            badgeColor: Colors.amberAccent,
            child: TextFormField(
              inputFormatters: [wonMaskFormatter],
              controller: _amountController,
              style: salesInputStyle(),
              cursorColor: Colors.white,
              decoration: expenseTextAddInputDecor('지출금액'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),
          ),
        ],
      ),
    );
  }

  Container _titleTextFormField() {
    return Container(
      height: salTtfHeightSize,
      width: salTtfWidthSize * 1.5,
      child: Stack(
        children: [
          Badge(
            showBadge: _titleBadge,
            position: BadgePosition.topEnd(end: 10,top: 30),
            badgeColor: Colors.amberAccent,
            child: TextFormField(
              controller: _titleController,
              style: salesInputStyle(),
              cursorColor: Colors.white,
              decoration: expenseTextAddInputDecor('내용'),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ],
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
              setState(() {
                FocusScope.of(context).unfocus();
                if (_titleController.text.isEmpty) {
                  _titleBadge = true;
                  return Scaffold.of(context).showSnackBar(titleSnackBar);
                } else if (_amountController.text.isEmpty) {
                  _titleBadge = false;
                  _amountBadge = true;
                  return Scaffold.of(context).showSnackBar(amountSnackBar);
                }
                _amountBadge = false;
                _addExpense(
                    AddText(_titleController.text, _amountController.text));
              });


              // managementRepository.createManagement( userModel,SalesModel.createMapForManagementList(
              //   expenseAddList:FieldValue.arrayUnion([
              //     {'sdfkl':_titleController.text, 'sdfsdf':_amountController.text}
              //       ]),
              // ));

            //   FirebaseFirestore.instance.collection(COLLECTION_SALES).doc(userModel.userKey).collection(userModel.userName)
            //       .doc(pickerDate.toUtc().toString().substring(0,10)).set({
            //     'expenseAddList' : FieldValue.arrayUnion([{
            //       '내용' : _titleController.text,
            //       '금액' : _amountController.text,
            //     }]),
            //   },SetOptions(merge: true));
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
                  String expense = addText.expenseAmount;
                  setState(() {
                    _expenseList.remove(addText);
                    _titleController.text = addText.expenseTitle;
                    _amountController.text = addText.expenseAmount;
                    String expenseAmount = addText.expenseAmount;
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

  void _addExpense(AddText addText) {
    setState(() {
      _expenseList.add(addText);
      _titleController.text = addText.expenseTitle;
      _amountController.text = addText.expenseAmount;
      // print(addText.expenseAmount);
      // print(addText.expenseTitle);
      String expenseTitle = addText.expenseTitle;
      String expenseAmount = addText.expenseAmount;
      // print(expenseAmount);
      // Map<String, dynamic> list = [{
      //   'dsfds': expenseTitle,
      //   'sdfsdf': expenseAmount,
      // }];
      // print(list);
    UserModel userModel = Provider.of<UserModelState>(context, listen: false).userModel;

    FirebaseFirestore.instance.collection(COLLECTION_SALES_MANAGEMENT).doc(userModel.userKey).collection(userModel.userName)
          .doc(pickerDate.toUtc().toString().substring(0,10)).set({
        'expenseAdd' : FieldValue.arrayUnion([{
          // list,
        }]),
      },SetOptions(merge: true));

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
