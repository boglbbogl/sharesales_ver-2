import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/color.dart';

class SalesCreateScreen extends StatefulWidget {
  @override
  _SalesCreateScreenState createState() => _SalesCreateScreenState();
}

class _SalesCreateScreenState extends State<SalesCreateScreen> {
  @override
  Widget build(BuildContext context) {

    final heightSize = MediaQuery.of(context).size.height;
    final widthSize = MediaQuery.of(context).size.width;
    final tffSizeHeight = MediaQuery.of(context).size.width * 0.15;
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
        iconTheme: IconThemeData(
            color: Colors.amberAccent),
        actionsIconTheme: IconThemeData(color: Colors.yellowAccent),
        actions: [
          IconButton(
            icon: Icon(Icons.save), onPressed: () {  },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 18, top: 18),
            child: InkWell(
              onTap: (){},
              child: Text('save',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white
              ),),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: tffSizeHeight,
                width: tffSizeWidth,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    height: tffSizeHeight,
                    width: tffSizeWidth,
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                        labelText: '총매출',
                        labelStyle: TextStyle(color: Colors.yellow),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    height: tffSizeHeight,
                    width: tffSizeWidth,
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      cursorColor: Colors.pinkAccent,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amberAccent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amberAccent),
                        ),
                        labelText: '실제매출',
                        labelStyle: TextStyle(color: Colors.amberAccent),
                      ),
                      keyboardType: TextInputType.number,
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
                      style: TextStyle(
                        color: Colors.amberAccent,
                      ),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: '공급가액',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    height: tffSizeHeight,
                    width: tffSizeWidth,
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: '부가세',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
