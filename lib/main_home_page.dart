import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/screen/management_screen.dart';
import 'package:sharesales_ver2/screen/search_screen.dart';
import 'package:sharesales_ver2/screen/store_detail_screen.dart';
import 'package:sharesales_ver2/widget/example.dart';
import 'constant/color.dart';
import 'constant/size.dart';
import 'firebase_auth/user_model_state.dart';
import 'screen/main_screen.dart';
import 'screen/ad_screen.dart';
import 'widget/my_progress_indicator.dart';

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {

  int _selectedIndex = 0;

  List<BottomNavigationBarItem> _btmNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: '',),
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.view_list), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: ''),
  ];

  List<Widget> _screenList = [
    Consumer<UserModelState>(builder: (BuildContext context, UserModelState? userModelState, Widget? child){
      if(userModelState == null || userModelState.userModel == null)
        return MyProgressIndicator();
      else
        return MainScreen();
    }),
    Consumer<UserModelState>(builder: (BuildContext context, UserModelState? userModelState, Widget? child){
      if(userModelState == null || userModelState.userModel == null)
        return MyProgressIndicator();
      else
        return SearchScreen();
    }),
    Consumer<UserModelState>(builder: (BuildContext context, UserModelState? userModelState, Widget? child){
      if(userModelState == null || userModelState.userModel == null)
        return MyProgressIndicator();
      else
        return ManagementScreen();
    }),
    HomeScreen(),
    Consumer<UserModelState>(builder: (BuildContext context, UserModelState? userModelState, Widget? child){
      if(userModelState == null || userModelState.userModel == null)
        return MyProgressIndicator();
      else
        return StoreDetailScreen();
    }),
  ];

  @override
  Widget build(BuildContext context) {
    //if (size == null) size = MediaQuery.of(context).size;
     size = MediaQuery.of(context).size;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screenList,
      ),
      bottomNavigationBar: _btmNav(
      ),
    );
  }

  BottomNavigationBar _btmNav() {
    return BottomNavigationBar(
      backgroundColor: _selectedIndex==0 ? Colors.pink.shade50 : _selectedIndex==1? Colors.deepPurple.shade50 : Colors.white,
      elevation: 1,
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      items: _btmNavItems,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: _selectedIndex==0 ? Colors.pinkAccent : _selectedIndex==1? Colors.deepPurpleAccent : Colors.deepOrangeAccent,
      unselectedItemColor: Colors.black26,
      onTap: (index){
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}