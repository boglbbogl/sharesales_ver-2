import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/constant/size.dart';

class AddText {
  bool isDone;
  String title;
  String title2;

  AddText(this.title, this.title2, {this.isDone = false});
}

class TextAddForm extends StatefulWidget {
  @override
  _TextAddFormState createState() => _TextAddFormState();
}

class _TextAddFormState extends State<TextAddForm> {
  final _expenseList = <AddText>[];

  TextEditingController _expController = TextEditingController();
  TextEditingController _exp2Controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _expController.dispose();
    _scrollController.dispose();
    _exp2Controller.dispose();
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
            Container(
              height: salTtfHeightSize,
              width: salTtfWidthSize * 1.5,
              child: TextFormField(
                controller: _expController,
                style: blackInputStyle(),
                cursorColor: Colors.white,
                decoration: expenseTextAddInputDecor('내용'),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              height: expTtfHeightSize,
              width: expTtfWidthSize,
              child: TextFormField(
                controller: _exp2Controller,
                style: blackInputStyle(),
                cursorColor: Colors.white,
                decoration: expenseTextAddInputDecor('지출금액'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            // Container(
            //   height: expTtfHeightSize/2,
            //   width: expTtfWidthSize/2,
            //   child: RaisedButton(
            //       color: Colors.redAccent,
            //       child: Text('Add..'),
            //       onPressed: () {
            //         _addExpense(AddText(_expController.text));
            //       }),
            // ),
          ],
        ),
        Stack(
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
              width: size.width*0.9,
            ),
            Container(
              height: 30,
              width: size.width*0.5,
              child: RaisedButton(
                onPressed: () {
                  _addExpense(AddText(_expController.text, _exp2Controller.text));
                },
                  elevation: 0,
                color: Colors.grey,
                splashColor: Colors.redAccent,
                child: Text('CLICK',style: TextStyle(fontWeight: FontWeight.bold),),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
        Container(
          height: size.height * 0.5,
          width: size.width*0.98,
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

  Widget _expenseListView(AddText addText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 19, left: 10),
          child: Text('내용 : ', style: TextStyle(color: Colors.white),),
        ),
        Flexible(
          child: ListTile(
            onTap: () {
              _toggleExpense(addText);
            },
            title: Text(
              addText.title,
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
          child: Text('지출금액 : ', style: TextStyle(color: Colors.white),),
        ),
        Flexible(
          child: ListTile(
            onTap: () {
              _toggleExpense(addText);
            },
            title: Text(
              addText.title2,
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
      _expController.text = '';
      _exp2Controller.text = '';
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
