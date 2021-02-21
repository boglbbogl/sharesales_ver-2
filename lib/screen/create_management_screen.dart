import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/widget/sales_create_form.dart';

class CreateManagementScreen extends StatefulWidget {

  @override
  _CreateManagementScreenState createState() => _CreateManagementScreenState();
}

class _CreateManagementScreenState extends State<CreateManagementScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: _salesCreateAppbar(context),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SalesCreateForm(),
              ],
            ),
          ),
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
