import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';

class SalesCreateScreen extends StatefulWidget {
  @override
  _SalesCreateScreenState createState() => _SalesCreateScreenState();
}

class _SalesCreateScreenState extends State<SalesCreateScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final tffSizeHeight = MediaQuery.of(context).size.width * 0.19;
    final tffSizeWidth = MediaQuery.of(context).size.width * 0.4;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CREATE',
          style: TextStyle(
              foreground: Paint()..shader = appbarColor,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        iconTheme: IconThemeData(color: Colors.amberAccent),
        actionsIconTheme: IconThemeData(color: Colors.yellowAccent),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
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
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      height: tffSizeHeight,
                      width: tffSizeWidth,
                      child: TextFormField(
                        validator: _salesInputValidator,
                        style: textInputStyle(),
                        cursorColor: Colors.white,
                        decoration: textInputDecor('총매출'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      height: tffSizeHeight,
                      width: tffSizeWidth,
                      child: TextFormField(
                        style: textInputStyle(),
                        cursorColor: Colors.white,
                        decoration: textInputDecor('실제매출'),
                        keyboardType: TextInputType.number,
                        validator: _salesInputValidator,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      height: tffSizeHeight,
                      width: tffSizeWidth,
                      child: TextFormField(
                        style: textInputStyle(),
                        cursorColor: Colors.white,
                        decoration: textInputDecor('공급가액'),
                        keyboardType: TextInputType.number,
                        validator: _salesInputValidator,
                      ),
                    ),
                    Container(
                      height: tffSizeHeight,
                      width: tffSizeWidth,
                      child: TextFormField(
                        style: textInputStyle(),
                        cursorColor: Colors.white,
                        decoration: textInputDecor('세액'),
                        keyboardType: TextInputType.number,
                        validator: _salesInputValidator,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _salesInputValidator(text) {
    if (text.isEmpty) {
      return '필수로 입력하여야 합니다.';
    } else
      return null;
  }
}
