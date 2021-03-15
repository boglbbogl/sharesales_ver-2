
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/models/firestore/user_model.dart';
import 'package:sharesales_ver2/models/user_model_state.dart';
import 'package:sharesales_ver2/widget/my_progress_indicator.dart';
import 'create_management_screen.dart';

class ManagementScreen extends StatefulWidget {
  @override
  _ManagementScreenState createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  TextEditingController _totalSalesController = TextEditingController();
  TextEditingController _actualSalesController = TextEditingController();
  TextEditingController _foodprovisionController = TextEditingController();
  TextEditingController _beverageController = TextEditingController();
  TextEditingController _alcoholController = TextEditingController();

  @override
  void dispose() {
    _totalSalesController.dispose();
    _actualSalesController.dispose();
    _foodprovisionController.dispose();
    _beverageController.dispose();
    _alcoholController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        Provider.of<UserModelState>(context, listen: false).userModel;

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(COLLECTION_SALES)
            .doc(userModel.userKey)
            .collection(userModel.userName)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return MyProgressIndicator();
          }
          return SafeArea(
            child: Scaffold(
              appBar: _managementScreenAppBar(context),
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: size.width,
                    height: size.height * 0.1,
                    color: Colors.indigoAccent,
                  ),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: snapshot.data.docs.map((snapshotData) {
                        return SimpleFoldingCell.create(
                          // frontWidget: _buildFrontWidget(),
                          frontWidget: GestureDetector(
                              onTap: () => print('short click'),
                              onLongPress: () async {
                                _managementBottomSheet(
                                    context, snapshotData, userModel);
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
                  ),
                ],
              ),
            ),
          );
        },
    );
  }

  Future _managementBottomSheet(BuildContext context,
      QueryDocumentSnapshot snapshotData, UserModel userModel) {

    // var expenseAdd = expenseSnapshot.data['expenseAddList'];
    var addListToExpense = snapshotData.data()['expenseAddList'];


    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      backgroundColor: Colors.indigo,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: size.height * 0.13,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: size.width * 0.4,
                child: ListTile(
                  horizontalTitleGap: 0.01,
                  leading: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 25,
                  ),
                  title: Text('삭제하기',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),),
                        backgroundColor: Colors.redAccent,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(height: size.height * 0.07,
                            child: Row(
                              children: <Widget>[
                                Expanded(child: Text(' ' + snapshotData['selectedDate'] + '  삭제 하시겠습니까 ?',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                                  ),
                                ),
                                Container(width: size.width * 0.2,
                                  child: InkWell(
                                    child: Center(
                                      child: Text('Ok',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      FirebaseFirestore.instance.collection(COLLECTION_SALES).doc(userModel.userKey).collection(userModel.userName)
                                          .doc(snapshotData.id).delete();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                Container(color: Colors.red, height: size.height * 0.1, width: size.width * 0.005,),
                                Container(width: size.width * 0.2,
                                  child: InkWell(
                                    child: Center(
                                      child: Text('Cancel',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                // SizedBox(
                                //   width: size.width*0.01,
                                // ),
                              ],
                            ),
                          );
                        });
                  },
                ),
              ),
              Container(color: Colors.indigoAccent,
                height: size.height * 0.075,
                width: size.width * 0.01,
              ),
              Container(
                width: size.width * 0.4,
                child: ListTile(horizontalTitleGap: 0.2,
                  leading: Icon(Icons.add_circle,
                    color: Colors.white,
                    size: 25,
                  ),
                  title: Text('추가하기',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  onTap: () {
                    _totalSalesController.text = snapshotData['totalSales'];
                    _actualSalesController.text = snapshotData['actualSales'];
                    _foodprovisionController.text = snapshotData['foodProvisionExpense'];
                    _beverageController.text = snapshotData['beverageExpense'];
                    _alcoholController.text = snapshotData['alcoholExpense'];

                    showModalBottomSheet(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: size.height * 0.08,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                width: size.width * 0.4,
                                child: ListTile(horizontalTitleGap: 0.01,
                                  leading: Icon(Icons.add_outlined, color: Colors.white, size: 25,
                                  ),
                                  title: Text('매출',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    print('매출 click');
                                    setState(() {

                                      showMaterialModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        closeProgressThreshold: 5.0,
                                        animationCurve: Curves.fastOutSlowIn,
                                        duration: Duration(milliseconds: 1500),
                                        barrierColor: Colors.black87,
                                        backgroundColor: Colors.black,
                                        context: context,
                                        builder: (BuildContext context) => Container(
                                          height: size.height * 0.8,
                                          child: Stack(
                                            children: [
                                              Positioned(left: 15, top: 30,
                                                child: InkWell(
                                                  child: Text('Cancel',
                                                    style: TextStyle(color: Colors.amberAccent, fontSize: 20, fontWeight: FontWeight.bold,
                                                      fontStyle: FontStyle.italic,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                              Column(crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(height: 30,),
                                                  Container(height: salTtfHeightSize,
                                                    child: Text(snapshotData['selectedDate'],
                                                      style: TextStyle(color: Colors.indigo, fontSize: 22,
                                                        fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: <Widget>[
                                                      Container(width: salTtfWidthSize,
                                                          height: salTtfHeightSize,
                                                          child: TextFormField(
                                                            controller: _totalSalesController,
                                                            style: blackInputStyle(),
                                                            decoration: salesChangeInputDecor('총매출'),
                                                            inputFormatters: [wonMaskFormatter],
                                                          )),
                                                      Container(width: salTtfWidthSize,
                                                          height: salTtfHeightSize,
                                                          child: TextFormField(
                                                            controller: _actualSalesController,
                                                            style: blackInputStyle(),
                                                            decoration: salesChangeInputDecor('실제매출'),
                                                            inputFormatters: [wonMaskFormatter],
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Positioned(right: 15, top: 30,
                                                child: InkWell(
                                                  child: Text('Save',
                                                    style: TextStyle(
                                                      color: Colors.amberAccent, fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      fontStyle: FontStyle.italic,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    FirebaseFirestore.instance.collection(COLLECTION_SALES).doc(userModel.userKey)
                                                        .collection(userModel.userName).doc(snapshotData.id).update({
                                                      'totalSales': _totalSalesController.text,
                                                      'actualSales': _actualSalesController.text,
                                                    });
                                                    Navigator.of(context).pop();
                                                    _totalSalesController.clear();
                                                    _actualSalesController.clear();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                ),
                              ),
                              Container(color: Colors.red,
                                height: size.height * 0.04,
                                width: size.width * 0.01,
                              ),
                              Container(
                                width: size.width * 0.4,
                                child: ListTile(horizontalTitleGap: 0.01,
                                  leading: Icon(Icons.add_outlined, color: Colors.white, size: 25,
                                  ),
                                  title: Text('지출',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    print('지출 click');

                                    setState(() {
                                      showMaterialModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        closeProgressThreshold: 5.0,
                                        animationCurve: Curves.fastOutSlowIn,
                                        duration: Duration(milliseconds: 1500),
                                        barrierColor: Colors.black87,
                                        backgroundColor: Colors.black,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (BuildContext context, StateSetter stateSetter) {
                                              return Container(
                                                height: size.height * 0.95,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        Positioned(left: 15, top: 30,
                                                          child: InkWell(
                                                            child: Text('Cancel',
                                                              style: TextStyle(color: Colors.redAccent, fontSize: 20,
                                                                fontWeight: FontWeight.bold,
                                                                fontStyle: FontStyle.italic,
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                          ),
                                                        ),
                                                        Positioned(right: 15, top: 30,
                                                          child: InkWell(
                                                            child: Text('Save',
                                                              style: TextStyle(
                                                                color: Colors.redAccent, fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              FirebaseFirestore.instance.collection(COLLECTION_SALES).doc(userModel.userKey)
                                                                  .collection(userModel.userName).doc(snapshotData.id).update({
                                                                'foodProvisionExpense': _foodprovisionController.text,
                                                                'beverageExpense': _beverageController.text,
                                                                'alcoholExpense': _alcoholController.text,
                                                              });
                                                              Navigator.of(context).pop();
                                                              _foodprovisionController.clear();
                                                              _beverageController.clear();
                                                              _alcoholController.clear();
                                                            },
                                                          ),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: <Widget>[
                                                            SizedBox(height: 30,),
                                                            Container(
                                                              height: salTtfHeightSize,
                                                              child: Text(
                                                                snapshotData['selectedDate'],
                                                                style: TextStyle(
                                                                  color: Colors.indigo, fontSize: 22, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: <Widget>[
                                                                Container(width: expTtfWidthSize,
                                                                    height: expTtfHeightSize,
                                                                    child: TextFormField(
                                                                      controller: _foodprovisionController,
                                                                      style: blackInputStyle(),
                                                                      decoration: expenseChangeInputDecor('식자재'),
                                                                      inputFormatters: [wonMaskFormatter],
                                                                    )),
                                                                Container(width: expTtfWidthSize,
                                                                    height: expTtfHeightSize,
                                                                    child: TextFormField(
                                                                      controller: _beverageController,
                                                                      style: blackInputStyle(),
                                                                      decoration: expenseChangeInputDecor('음료'),
                                                                      inputFormatters: [wonMaskFormatter],
                                                                    )),
                                                                Container(
                                                                    width: expTtfWidthSize,
                                                                    height: expTtfHeightSize,
                                                                    child: TextFormField(
                                                                      controller: _alcoholController,
                                                                      style: blackInputStyle(),
                                                                      decoration: expenseChangeInputDecor('주류'),
                                                                      inputFormatters: [wonMaskFormatter],
                                                                    )),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Container(height: 3, width: size.width * 0.9,
                                                      color: Colors.grey,
                                                    ),
                                                    Container(
                                                      height: size.height * 0.5,
                                                      width: size.width*0.9,
                                                      child: ListView.separated(
                                                        itemCount: addListToExpense.length,
                                                        itemBuilder: (BuildContext context, int index) {

                                                          Map<String, dynamic> removeList = snapshotData['expenseAddList'][index];

                                                          return Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: <Widget>[
                                                              Container(
                                                                width: size.width*0.4,
                                                                child: Text(
                                                                  addListToExpense[index]['title'].toString(), style: TextStyle(color: Colors.white),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Container(
                                                                  width: size.width*0.2,
                                                                  child: Text(
                                                                    addListToExpense[index]['expenseAmount'].toString(), style: TextStyle(color: Colors.white),
                                                                  ),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                child: Text('delete', style: TextStyle(color: Colors.amberAccent),),
                                                                onTap: (){
                                                                  stateSetter((){
                                                                    FirebaseFirestore.instance.collection(COLLECTION_SALES).doc(userModel.userKey)
                                                                        .collection(userModel.userName).doc(snapshotData.id).update({
                                                                      'expenseAddList': FieldValue.arrayRemove([
                                                                        removeList ]),
                                                                    });
                                                                  });

                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        }, separatorBuilder: (BuildContext context, int index) {
                                                        return SizedBox(height: 10,);
                                                      },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      );
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
                            '식자재 : ' + snapshotData['foodProvisionExpense'],
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
                            '기타지출 : ' + snapshotData['alcoholExpense'],
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
                    // print(snapshotData['expenseAddList'][0]['title']);
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
