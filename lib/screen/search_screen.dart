import 'package:badges/badges.dart';
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
    rangePickerStartDateTime=DateTime(1000,01,01);
    rangePickerEndDateTime=DateTime(1000,01,02);
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
        final List<dynamic> stdDate = [];

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
          stdDate.add(docQuery['stdDate']);
        });

        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: mainAppBar(context, IconButton(icon: Icon(Icons.search_rounded, size: 26, color: Colors.deepPurpleAccent,),
                onPressed: (){

            })),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: InkWell(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(rangePickerStartDate == null ? '기간을 선택해주세요' : rangePickerStartDate.replaceAll(".", ''),
                                style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic, color: Colors.black54),),
                              Text(rangePickerStartDate == rangePickerEndDate ? '' : '   -   ', style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, color: Colors.black54),),
                              Text(rangePickerEndDate == null || rangePickerEndDate==rangePickerStartDate ? '' : rangePickerEndDate.replaceAll(".", ""),
                                style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic, color: Colors.black54),),
                            ],
                          ),
                          onTap: (){
                            showMaterialModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                closeProgressThreshold: 5.0,
                                enableDrag: true,
                                animationCurve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 300),
                                barrierColor: Colors.black87,
                                backgroundColor: Colors.deepOrangeAccent,
                                context: context,
                                builder: (BuildContext context) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.dark(),
                                    ),
                                    child: StatefulBuilder(
                                      builder: (BuildContext context, StateSetter fulSetState) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          height: size.height * 0.45,
                                          // color: Colors.deepOrange,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: SfDateRangePicker(
                                              minDate: DateTime(2000, 01, 01),
                                              maxDate: DateTime(2100, 01, 01),
                                              monthCellStyle: DateRangePickerMonthCellStyle(
                                                textStyle: TextStyle(color: Colors.white),
                                                weekendDatesDecoration: BoxDecoration(
                                                  color: Colors.deepOrange,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                specialDatesDecoration: BoxDecoration(
                                                  color: Colors.deepOrange,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                todayTextStyle: TextStyle(color: Colors.white),
                                              ),
                                              startRangeSelectionColor: Colors.orange,
                                              endRangeSelectionColor: Colors.orange,
                                              rangeSelectionColor: Colors.orange,
                                              selectionTextStyle: TextStyle(color: Colors.white),
                                              todayHighlightColor: Colors.orange,
                                              selectionColor: Colors.orange,
                                              backgroundColor: Colors.deepOrangeAccent,
                                              controller: _dayRangePickerController,
                                              allowViewNavigation: false,
                                              view: DateRangePickerView.month,
                                              selectionMode: DateRangePickerSelectionMode.range,
                                              headerStyle: DateRangePickerHeaderStyle(
                                                  textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontStyle: FontStyle.italic)),
                                              monthViewSettings: DateRangePickerMonthViewSettings(
                                                blackoutDates: stdDate,
                                                enableSwipeSelection: false,
                                              ),
                                              onSelectionChanged:
                                                  (DateRangePickerSelectionChangedArgs args) {
                                                setState(() {
                                                  if (args.value is PickerDateRange) {
                                                    rangePickerStartDate = DateFormat.yMEd('ko_KO')
                                                        .format(args.value.startDate)
                                                        .toString();
                                                    rangePickerEndDate = DateFormat.yMEd('ko_KO')
                                                        .format(
                                                        args.value.endDate ?? args.value.startDate)
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
                                    ),
                                  );
                                });
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SizedBox(
                        width: size.width,
                        height: size.height*0.5,
                        child: PageView(
                          controller: _pageController,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Container(
                                decoration: _decorationContainerPageView([Colors.deepPurple[400],Colors.deepPurple[300],Colors.deepPurple[200]]),
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(height: size.height*0.01,),
                                  Container(height: size.height*0.04, child: Text('매출', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 18),),),
                                  Container(height: size.height*0.04, child: Text(userModel.userName.isEmpty? '로그인을 해주세요' : userModel.userName)),
                                  _managementScreenSalesPageViewShowTextForm(Colors.red[700], '실제매출', actualSales,),
                                  _managementScreenSalesPageViewShowTextForm(null, '총매출', totalSales,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Container(width: size.width*0.7, height: 2, color: Colors.white,),
                                  ),
                                  _managementScreenSalesPageViewShowTextForm(null, '할인', discount,),
                                  _managementScreenSalesPageViewShowTextForm(null, 'Delivery', delivery,),
                                  _managementScreenSalesPageViewShowTextForm(null, '신용카드', creditCard,),
                                  _managementScreenSalesPageViewShowTextForm(null, '공급가액', vos,),
                                  _managementScreenSalesPageViewShowTextForm(null, '세액', vat,),
                                  _managementScreenSalesPageViewShowTextForm(null, '현금', cash,),
                                  _managementScreenSalesPageViewShowTextForm(null, '현금영수증', cashReceipt,),
                                  _managementScreenSalesPageViewShowTextForm(null, 'Gift card', giftCard,),
                                ],
                              ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Container(
                                decoration: _decorationContainerPageView([Colors.pink[500], Colors.pink[400], Colors.pink[300]]),),
                            ),
                          ],
                        ),
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

  Container _managementScreenSalesPageViewShowTextForm(Color color,String hint, data) {
    return Container(
      width: size.width*0.6,
      height: size.height*0.032,
      child: Row(
        children: [
          Text(
            '$hint     ' +
                koFormatMoney.format(
                    data.isEmpty || rangePickerStartDateTime == null
                        ? int.parse('0')
                        : data.reduce((v, e) => v + e)),
            style: TextStyle(
                color: color == null? Colors.black : color,
                fontSize: 16),
          ),
          Text('   \\', style: TextStyle(color: color == null ? Colors.black : color, fontSize: 12),)
        ],
      ),
    );
  }

  BoxDecoration _decorationContainerPageView(List<Color> colorsList) {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black45,
          blurRadius: 5.0,
          // spreadRadius: 5.0,
          // offset: Offset(2.0,1.0),
        ),
      ],
      borderRadius: BorderRadius.circular(30),
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: colorsList,
      ),
    );
  }
}

