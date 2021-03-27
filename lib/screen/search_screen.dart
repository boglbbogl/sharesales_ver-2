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
  void initState() {
    rangePickerStartDateTime=DateTime.now().toUtc();
    rangePickerEndDateTime=DateTime.now().toUtc();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    UserModel userModel = Provider.of<UserModelState>(context, listen: false).userModel;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(COLLECTION_SALES_MANAGEMENT).doc(userModel.userKey).collection(userModel.userName)
      .where('stdDate', isGreaterThanOrEqualTo: rangePickerStartDateTime,
          isLessThanOrEqualTo: rangePickerEndDateTime==null?rangePickerStartDateTime.add(Duration(days: 1)):rangePickerEndDateTime.add(Duration(days: 1)))
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if(!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
          return MyProgressIndicator();
        }
        final totalSales = [];
        final actualSales = [];
        final discount = [];
        final delivery = [];
        final creditCard = [];
        final giftCard = [];
        final vos = [];
        final vat = [];
        final cash = [];
        final cashReceipt = [];

        snapshot.data.docs.forEach((element) {
          var docQuery = element.data();
          totalSales.add(docQuery['totalSales']);
          actualSales.add(docQuery['actualSales']);
          discount.add(docQuery['discount']);
          delivery.add(docQuery['delivery']);
          creditCard.add(docQuery['creditCard']);
          giftCard.add(docQuery['giftCard']);
          vos.add(docQuery['vos']);
          vat.add(docQuery['vat']);
          cash.add(docQuery['cash']);
          cashReceipt.add(docQuery['cashReceipt']);
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
                                    // color: Colors.deepOrange,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: SfDateRangePicker(
                                        monthCellStyle: DateRangePickerMonthCellStyle(
                                          specialDatesTextStyle: TextStyle(color: Colors.white),
                                          blackoutDateTextStyle: TextStyle(color: Colors.red),
                                          todayTextStyle: TextStyle(color: Colors.white),
                                          textStyle: TextStyle(color: Colors.white),
                                          weekendTextStyle: TextStyle(color: Colors.white),
                                          leadingDatesTextStyle: TextStyle(color: Colors.white),
                                          trailingDatesTextStyle: TextStyle(color: Colors.white),
                                          disabledDatesTextStyle: TextStyle(color: Colors.white),
                                        ),
                                        rangeTextStyle: TextStyle(color: Colors.white),
                                        selectionTextStyle: TextStyle(color: Colors.white),
                                        headerStyle: DateRangePickerHeaderStyle(
                                          textStyle: TextStyle(color: Colors.white),
                                        ),


                                        backgroundColor: Colors.amber[200],


                                        controller: _dayRangePickerController,
                                        allowViewNavigation: false,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(height: size.height*0.03,),
                              Container(height: size.height*0.05, child: Text(userModel.userName)),
                              _managementScreenSalesPageViewShowTextForm(FontWeight.bold, 18, Colors.indigo,size.height*0.05, '실제매출', actualSales,),
                              _managementScreenSalesPageViewShowTextForm(FontWeight.bold, 18, Colors.indigo,size.height*0.05, '총매출', totalSales,),
                              _managementScreenSalesPageViewShowTextForm(null, null, null, null, '할인', discount,),
                              _managementScreenSalesPageViewShowTextForm(null, null, null, null, 'Delivery', delivery,),
                              _managementScreenSalesPageViewShowTextForm(null, null, null, null, '신용카드', creditCard,),
                              _managementScreenSalesPageViewShowTextForm(null, null, null, null, '공급가액', vos,),
                              _managementScreenSalesPageViewShowTextForm(null, null, null, null, '세액', vat,),
                              _managementScreenSalesPageViewShowTextForm(null, null, null, null, '현금', cash,),
                              _managementScreenSalesPageViewShowTextForm(null, null, null, null, '현금영수증', cashReceipt,),
                              _managementScreenSalesPageViewShowTextForm(null, null, null, null, 'Gift card', giftCard,),
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
                  ],
                ),
              ),
            ),
          ),
        );

      }
    );
  }

  Container _managementScreenSalesPageViewShowTextForm(FontWeight fontWeight, double fontSize, Color color, double sizeHeight, String hint, data) {
    return Container(
      width: size.width*0.5,
      height: sizeHeight == null ? size.height*0.03 : sizeHeight,
      child: Text(
        '$hint -   ' +
            koFormatMoney.format(
                data.isEmpty || rangePickerStartDateTime == null
                    ? int.parse('0')
                    : data.reduce((v, e) => v + e)) + ' \\',
        style: TextStyle(
            color: color == null? Colors.black : color, fontWeight: fontWeight == null ? FontWeight.w400 : fontWeight,
            fontSize: fontSize==null? 16 : fontSize),
      ),
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

