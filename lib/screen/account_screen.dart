import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sharesales_ver2/constant/duration.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/widget/account_screen_body.dart';
import 'package:sharesales_ver2/widget/account_screen_side_menu.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final sideWidth = size.width/2;

  PageSlide _pageSlide = PageSlide.closed;
  double pagePos = size.width;
  double bodyPos = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: Stack(
        children: <Widget>[
          AnimatedContainer(
              duration: mainDuration,
              child: AccountScreenBody(onPageChanged: () {
                setState(() {
                  _pageSlide = (_pageSlide == PageSlide.closed)
                      ? PageSlide.opened
                      : PageSlide.closed;
                  switch(_pageSlide){
                    case PageSlide.opened:
                      bodyPos = -sideWidth;
                      pagePos = size.width-sideWidth;
                      break;
                    case PageSlide.closed:
                      bodyPos = 0;
                      pagePos = size.width;
                      break;
                  }
                });
              }),
            transform: Matrix4.translationValues(bodyPos, 0, 0),
          ),
          AnimatedContainer(
            transform: Matrix4.translationValues(pagePos, 0, 0),
            duration: mainDuration,
            child: AccountScreenSideMenu(),
          ),
        ],
      ),
    );
  }
}

enum PageSlide { opened, closed }
