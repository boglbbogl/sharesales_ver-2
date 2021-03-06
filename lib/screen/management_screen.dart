import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/widget/my_progress_indicator.dart';
import 'create_management_screen.dart';

class ManagementScreen extends StatefulWidget {
  @override
  _ManagementScreenState createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _managementScreenAppBar(context),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(COLLECTION_SALES)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return MyProgressIndicator();
                }
                return Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: snapshot.data.docs.map((snapshotData) {
                      return SimpleFoldingCell.create(
                        // frontWidget: _buildFrontWidget(),
                        frontWidget: GestureDetector(
                          onTap: ()=>print('short click'),
                            onLongPress: (){
                            },
                            child: _foldingFrontWidget(snapshotData)),
                        innerWidget: _foldingInnerWidget(snapshotData),
                        cellSize: Size(MediaQuery.of(context).size.width, 90),
                        padding: EdgeInsets.all(12),
                        animationDuration: Duration(milliseconds: 300),
                        borderRadius: 20,
                        onOpen: () => print('cell opened'),
                        onClose: () => print('cell closed'),
                      );
                    }).toList(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  AppBar _managementScreenAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: blackColor,
      centerTitle: true,
      title: Text(
        'share sales',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          fontSize: fontSize,
          foreground: Paint()..shader = mainColor,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.amberAccent,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateManagementScreen()));
          },
        )
      ],
    );
  }

  Builder _foldingFrontWidget(QueryDocumentSnapshot snapshotData) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          color: Colors.amber,
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      snapshotData['selectedDate'],
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 19,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: size.width * 0.45,
                          child: Text(
                            '실제 매출 : ' + snapshotData['actualSales'],
                            style: _frontWidgetTextStyle(),
                          ),
                        ),
                        Container(
                          child: Text(
                            '식자재 : ' + snapshotData['totalSales'],
                            style: _frontWidgetTextStyle(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: size.width * 0.45,
                          child: Text(
                            '총 매출 : ' + snapshotData['totalSales'],
                            style: _frontWidgetTextStyle(),
                          ),
                        ),
                        Container(
                          child: Text(
                            '기타지출 : ' + snapshotData['totalSales'],
                            style: _frontWidgetTextStyle(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 5,
                right: 5,
                height: 30,
                child: RaisedButton(
                  color: Colors.redAccent,
                  onPressed: () {
                    final _foldingCellState = context
                        .findRootAncestorStateOfType<SimpleFoldingCellState>();
                    _foldingCellState?.toggleFold();
                  },
                  child: Text(
                    "OPEN",
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textColor: Colors.white,
                  splashColor: Colors.white.withOpacity(0.8),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  TextStyle _frontWidgetTextStyle() {
    return TextStyle(
        fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: 14);
  }

  Widget _foldingInnerWidget(QueryDocumentSnapshot snapshotData) {
    return Builder(
      builder: (context) {
        return Container(
          color: Color(0xFFecf2f9),
          padding: EdgeInsets.only(top: 10),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  snapshotData['totalSales'],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "CARD DETAIL",
                ),
              ),
              Positioned(
                right: 5,
                bottom: 0,
                child: RaisedButton(
                  onPressed: () {
                    final _foldingCellState = context
                        .findRootAncestorStateOfType<SimpleFoldingCellState>();
                    _foldingCellState?.toggleFold();
                  },
                  child: Text(
                    "Close",
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textColor: Colors.white,
                  color: Colors.redAccent,
                  splashColor: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
