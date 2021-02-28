import 'package:flutter/material.dart';
import 'package:sharesales_ver2/screen/management_screen.dart';
import 'package:sharesales_ver2/widget/date_picker_cupertino.dart';
import 'package:sharesales_ver2/widget/example.dart';
import 'package:sharesales_ver2/widget/text_add_form.dart';

import 'constant/color.dart';
import 'constant/size.dart';
import 'screen/account_screen.dart';
import 'screen/ad_screen.dart';

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {

  int _selectedIndex = 0;

  List<BottomNavigationBarItem> _btmNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.view_list), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: ''),
  ];

  List<Widget> _screenList = [
    AdScreen(),
    Container(),
    ManagementScreen(),
    Container(color: Colors.green,),
    AccountScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    if (size == null) size = MediaQuery.of(context).size;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screenList,
      ),
      bottomNavigationBar: _btmNav(),
    );
  }

  BottomNavigationBar _btmNav() {
    return BottomNavigationBar(
      backgroundColor: blackColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      items: _btmNavItems,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.yellowAccent,
      unselectedItemColor: Colors.white54,
      onTap: (index){
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}