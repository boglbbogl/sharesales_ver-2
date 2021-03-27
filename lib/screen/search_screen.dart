import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/app_bar.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
import 'package:sharesales_ver2/widget/my_progress_indicator.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'management_screen.dart';


class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DateRangePickerController _dayRangePickerController = DateRangePickerController();
  PageController _pageController = PageController(viewportFraction: 0.8);

  String rangePickerStartDate;
  String rangePickerEndDate;
  DateTime rangePickerStartDateTime;
  DateTime rangePickerEndDateTime;

  @override
  void dispose() {
    _dayRangePickerController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    UserModel userModel = Provider.of<UserModelState>(context, listen: false).userModel;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(COLLECTION_SALES_MANAGEMENT).doc(userModel.userKey).collection(userModel.userName)
      .where('stdDate', isGreaterThanOrEqualTo: rangePickerStartDateTime)
          .where('stdDate', isLessThanOrEqualTo: rangePickerEndDateTime==null?rangePickerStartDateTime:rangePickerEndDateTime)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if(!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
          return MyProgressIndicator();
        }
        final totalSales = [];
        final actualSales = [];

        snapshot.data.docs.forEach((element) {
          var docQuery = element.data();
          totalSales.add(docQuery['totalSales']);
          actualSales.add(docQuery['actualSales']);
        });

        return SafeArea(
          child: Scaffold(
            appBar: mainAppBar(context, Container()),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(rangePickerStartDate == null ? '기간을 선택해주세요' : rangePickerStartDate,
                            style: TextStyle(color: Colors.white, fontSize: 20),),
                          Text(rangePickerStartDate == rangePickerEndDate ? '' : '   -   ', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),),
                          Text(rangePickerEndDate == null || rangePickerEndDate==rangePickerStartDate ? '' : rangePickerEndDate,
                            style: TextStyle(color: Colors.white, fontSize: 20),),
                          SizedBox(width: size.width*0.05,),
                          Icon(Icons.search, color: Colors.yellowAccent,),
                        ],
                      ),
                      onTap: (){
                        print(rangePickerStartDateTime);
                        showMaterialModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            closeProgressThreshold: 5.0,
                            enableDrag: true,
                            animationCurve: Curves.fastOutSlowIn,
                            duration: Duration(milliseconds: 300),
                            barrierColor: Colors.black87,
                            backgroundColor: Colors.black,
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter fulSetState) {
                                  return Container(
                                    height: size.height * 0.55,
                                    color: Colors.deepOrange,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: SfDateRangePicker(
                                        controller: _dayRangePickerController,
                                        allowViewNavigation: false,
                                        backgroundColor: Colors.amber,
                                        view: DateRangePickerView.month,
                                        selectionMode: DateRangePickerSelectionMode.range,
                                        monthViewSettings: DateRangePickerMonthViewSettings(
                                          enableSwipeSelection: false,
                                        ),
                                        onSelectionChanged: (DateRangePickerSelectionChangedArgs  args){
                                          setState((){
                                            if (args.value is PickerDateRange) {
                                              rangePickerStartDate = DateFormat('yyyy MM dd').format(args.value.startDate).toString();
                                              rangePickerEndDate = DateFormat('yyyy MM dd')
                                                  .format(args.value.endDate ?? args.value.startDate)
                                                  .toString();

                                              rangePickerStartDateTime = args.value.startDate;
                                              rangePickerEndDateTime = args.value.endDate;
                                            } else {
                                              return MyProgressIndicator();
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                        );
                      },
                    ),
                    SizedBox(height: size.height*0.05,),
                    SizedBox(
                      width: size.width,
                      height: size.height*0.5,
                      child: PageView(
                        controller: _pageController,
                        children: [
                          Container(
                            decoration: _decorationContainerPageView([Colors.amber[400],Colors.amber[300],Colors.amber[200]]),
                          child: Column(
                            children: <Widget>[
                            ],
                          ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Container(
                              decoration: _decorationContainerPageView([Colors.orange[500], Colors.orange[400], Colors.orange[300]]),),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          child:  Text(
                            '실제매출 : ' +
                                koFormatMoney.format(actualSales.isEmpty
                                    ? int.parse('0')
                                    : actualSales.reduce((v, e) => v + e)),
                            style: TextStyle(
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                        Container(
                          child:  Text(
                            '총매출 : ' +
                                koFormatMoney.format(totalSales.isEmpty
                                    ? int.parse('0')
                                    : totalSales.reduce((v, e) => v + e)),
                            style: TextStyle(
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      }
    );
  }

  BoxDecoration _decorationContainerPageView(List<Color> colorsList) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: colorsList,
      ),
    );
  }
}

