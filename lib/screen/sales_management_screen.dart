import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'sales_create_screen.dart';

class SalesManagementScreen extends StatefulWidget {
  @override
  _SalesManagementScreenState createState() => _SalesManagementScreenState();
}

class _SalesManagementScreenState extends State<SalesManagementScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'share sales',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: appbarFontsize,
            foreground: Paint()..shader = mainColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add,
            color: Colors.amberAccent,), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SalesCreateScreen()));
          },
          )
        ],
      ),
      body: Container(),
      floatingActionButton: _fabMultiButton(),
    );
  }

  SpeedDial _fabMultiButton() {
    return SpeedDial(
      activeIcon: Icons.clear,
      icon: Icons.add,
      buttonSize: 53,
      elevation: 1,
      overlayColor: Colors.black,
      foregroundColor: Colors.black,
      backgroundColor: Colors.yellowAccent,
      onOpen: () => print('open'),
      onClose: () => print('close'),
      children: [
        SpeedDialChild(
          elevation: 1,
          child: Icon(Icons.check),
          label: '매출등록',
          labelBackgroundColor: Colors.white10,
          foregroundColor: Colors.red,
          onTap: () => print('sales_click'),
        ),
        SpeedDialChild(
          child: Icon(Icons.check),
          label: '지출등록',
          backgroundColor: Colors.red,
          onTap: () => print('지출 클릭'),
        ),
      ],
    );
  }
}
