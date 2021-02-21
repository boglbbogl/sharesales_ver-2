import 'package:flutter/material.dart';
import 'package:sharesales_ver2/widget/account_screen_body.dart';

class AccountScreen extends StatelessWidget {

  final duration = Duration(milliseconds: 3000);

  @override
  Widget build(BuildContext context) {

    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: Stack(
        children: <Widget>[
          Positioned(
              top: 0,
              bottom: 0,
              width: widthSize/2,
              child: Container(
                color: Colors.deepPurpleAccent,
              ),
          ),
          AccountScreenBody(),
        ],
      ),
    );
  }
}

