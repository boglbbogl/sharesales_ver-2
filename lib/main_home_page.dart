import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/material_black.dart';

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {

  int _selectedIndex = 0;
  PageController _pageController = PageController(initialPage: 0);


  List<BottomNavigationBarItem> _btmNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.star_half_outlined), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.details_outlined), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: ''),
  ];

  List<Widget> _pageList = [
   Container(color: Colors.yellow,),
   Container(),
   Container(color: Colors.grey,),
   Container(color: Colors.green,),
   Container(color: Colors.red,),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pageList,
        onPageChanged: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: blackColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: _btmNavItems,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.white54,
        onTap: (index){
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn,);
          });
        },
      ),
    );
  }
}
