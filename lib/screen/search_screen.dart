import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/app_bar.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
import 'package:sharesales_ver2/widget/my_progress_indicator.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DateRangePickerController _dayRangePickerController = DateRangePickerController();

  @override
  void dispose() {
    _dayRangePickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    UserModel userModel = Provider.of<UserModelState>(context, listen: false).userModel;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(COLLECTION_SALES_MANAGEMENT).doc(userModel.userKey).collection(userModel.userName).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if(!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
          return MyProgressIndicator();
        } else

        return GestureDetector(
          onTap: ()=> FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Scaffold(
              appBar: mainAppBar(context, Container()),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.calendar_today_rounded, color: Colors.amber,),
                        onPressed: (){
                          setState(() {
                            print('click');
                            showMaterialModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                closeProgressThreshold: 5.0,
                                enableDrag: true,
                                // animationCurve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 300),
                                barrierColor: Colors.black87,
                                backgroundColor: Colors.black,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: size.height*0.55,
                                    color: Colors.deepOrange,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: SfDateRangePicker(
                                        controller: _dayRangePickerController,
                                        allowViewNavigation: false,
                                        backgroundColor: Colors.white,
                                        view: DateRangePickerView.month,
                                        monthViewSettings: DateRangePickerMonthViewSettings(
                                          enableSwipeSelection: false,
                                        ),
                                        selectionMode: DateRangePickerSelectionMode.range,
                                      ),
                                    ),
                                  );
                                }
                            );
                          });
                        }),
                    Container(
                      child: Text(_dayRangePickerController.selectedRange==null?
                      'error':_dayRangePickerController.selectedRange.startDate.toString().substring(0,10),
                        style: TextStyle(color: Colors.white),),
                    ),Container(
                      child: Text(_dayRangePickerController.selectedRange==null?
                      'error':_dayRangePickerController.selectedRange.endDate.toString().substring(0,10),
                        style: TextStyle(color: Colors.white),),
                    ),
                    Text('', style: TextStyle(color: Colors.white),),
                    Text(userModel.userName == null ? '로그인을 해주세요':userModel.userName, style: TextStyle(color: Colors.white),),
                    RaisedButton(onPressed: (){
                      print(_dayRangePickerController.selectedRange);
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
