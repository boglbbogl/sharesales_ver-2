import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/duration.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/widget/expense_create_form.dart';
import 'package:sharesales_ver2/widget/sales_create_form.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SelectedIndicator _selectedIndicator = SelectedIndicator.left;

  double _salesPos = 0;
  double _expensePos = size.width;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _salesCreateAppbar(context),
        body: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(delegate: SliverChildListDelegate([
                      Column(
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
                                  curve: Curves.linearToEaseOut,
                                  child: SalesCreateForm()),
                            ],
                          ),

                        ],
                      ),
                    ]))
                  ],

                ),
              ),
            ),
          ],
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
          color: Colors.amberAccent,
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
                  });
                },
                child: Center(
                  child: Text(
                    '매출',
                    style: TextStyle(
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
                  });
                },
                child: Center(
                  child: Text(
                    '지출',
                    style: TextStyle(
                      color: _selectedIndicator == SelectedIndicator.left
                          ? Colors.white
                          : Colors.amberAccent,
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

  AppBar _salesCreateAppbar(BuildContext context) {
    return AppBar(
      title: Text(
        'CREATE',
        style: TextStyle(
            foreground: Paint()..shader = mainColor,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic),
      ),
      iconTheme: IconThemeData(color: Colors.amberAccent),
      actionsIconTheme: IconThemeData(color: Colors.yellowAccent),
      actions: [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: () {
            FocusScope.of(context).unfocus();
            if (!_formKey.currentState.validate()) {
              return;
            }
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