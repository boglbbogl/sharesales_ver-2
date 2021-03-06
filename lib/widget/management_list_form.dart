import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';

import 'my_progress_indicator.dart';

class FoldingCellSimpleDemo extends StatelessWidget {
  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(COLLECTION_SALES)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(!snapshot.hasData) {
                  return MyProgressIndicator();
                }
                return Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: snapshot.data.docs.map((e) {
                      return Container(
                        color: Color(0xFF2e282a),
                        alignment: Alignment.topCenter,
                        child: SimpleFoldingCell.create(
                            // key: _foldingCellKey,
                            frontWidget: _buildFrontWidget(),
                            // innerWidget: _buildInnerTopWidget(),
                            innerWidget: _buildInnerBottomWidget(),
                            cellSize: Size(MediaQuery.of(context).size.width, 125),
                            padding: EdgeInsets.all(15),
                            animationDuration: Duration(milliseconds: 300),
                            borderRadius: 10,
                            onOpen: () => print('cell opened'),
                            onClose: () => print('cell closed')),
                      );
                      // return Center(
                      //   child: Container(
                      //     width: size.width*0.2,
                      //     height: size.height*0.2,
                      //     child: Text(e['totalSales'],style: TextStyle(color: Colors.white),),
                      //   ),
                      // );
                    }).toList(),
                  ),
                );
              }),
        ],
      );

  }

  Widget _buildFrontWidget() {
    return Container(
        color: Color(0xFFffcd3c),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("CARD",
                style: TextStyle(
                    color: Color(0xFF2e282a),
                    fontFamily: 'OpenSans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w800)),
            FlatButton(
              onPressed: () => _foldingCellKey?.currentState?.toggleFold(),
              child: Text(
                "Open",
              ),
              textColor: Colors.white,
              color: Colors.indigoAccent,
              splashColor: Colors.white.withOpacity(0.5),
            )
          ],
        ));
  }

  Widget _buildInnerTopWidget() {
    return Container(
        color: Color(0xFFff9234),
        alignment: Alignment.center,
        child: Text("TITLE",
            style: TextStyle(
                color: Color(0xFF2e282a),
                fontFamily: 'OpenSans',
                fontSize: 20.0,
                fontWeight: FontWeight.w800)));
  }

  Widget _buildInnerBottomWidget() {
    return Container(
      color: Color(0xFFecf2f9),
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: FlatButton(
          onPressed: () => _foldingCellKey?.currentState?.toggleFold(),
          child: Text(
            "Close",
          ),
          textColor: Colors.white,
          color: Colors.indigoAccent,
          splashColor: Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
}