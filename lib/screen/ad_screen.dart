import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/screen/auth_screen.dart';
import 'package:sharesales_ver2/screen/create_management_screen.dart';

class AdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'share sales',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: fontSize,
            foreground: Paint()..shader = secondMainColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.logout, color: Colors.pink,),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AuthScreen()));
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.create, color: Colors.deepPurple,), onPressed: ()=>CreateManagementScreen()),
          IconButton(
              icon: Icon(Icons.account_circle, color: Colors.deepPurple,), onPressed: (){}),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  height: size.width,
                  width: size.width,
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text(
                    'Ad..1',
                    style: TextStyle(fontSize: 100),
                  )),
                ),
                Container(
                  height: size.height / 8,
                  width: size.width,
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text(
                    'Banner..1',
                  )),
                ),
                Container(
                  height: size.height / 8,
                  width: size.width,
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text(
                    'Banner..2',
                  )),
                ),
                Container(
                  height: size.height / 8,
                  width: size.width,
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text(
                    'Banner..3',
                  )),
                ),
                Container(
                  height: size.height / 8,
                  width: size.width,
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text(
                    'Banner..4',
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
