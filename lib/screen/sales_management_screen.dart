import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/size.dart';


class SalesManagementScreen extends StatefulWidget {

  @override
  _SalesManagementScreenState createState() => _SalesManagementScreenState();
}
class _SalesManagementScreenState extends State<SalesManagementScreen> {

  @override
  Widget build(BuildContext context) {

    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'share sales',
          style: TextStyle(
              fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          fontSize: appbarFontsize,
          foreground: Paint()..shader = appbarColor,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        buttonSize: 50,
        elevation: 1,
        overlayColor: Colors.black,
        backgroundColor: Colors.yellowAccent,
        onOpen: ()=>print('open'),
        onClose: ()=>print('close'),
        children: [
          SpeedDialChild(
            child: Icon(Icons.adb_outlined),
            label: '매출등록',
            labelBackgroundColor: Colors.blue,
            foregroundColor: Colors.red
          ),
          SpeedDialChild(
            label: '지출등록',
            backgroundColor: Colors.black,
            onTap: ()=>print('지출'),
          ),
        ],
      ),
    );
  }
}

