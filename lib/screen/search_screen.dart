import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/app_bar.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
import 'package:sharesales_ver2/widget/my_progress_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'management_screen.dart';

class ChartData{
  final String xValue;
  final int yValue;

  ChartData.fromMap(Map<dynamic, dynamic> dataMap)
    :xValue = dataMap ['selectedDate'],
    yValue = dataMap['actualSales'];
}

class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DateRangePickerController _dayRangePickerController = DateRangePickerController();
  DateRangePickerController _monthRangePickerController = DateRangePickerController();

  PageController _pageController = PageController(viewportFraction: 0.8);

  String rangePickerStartDate;
  String rangePickerEndDate;
  DateTime rangePickerStartDateTime;
  DateTime rangePickerEndDateTime;

  bool _isExpanded = false;

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
        final List<dynamic> stdDate = [];
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
        final foodProvisionExpanse = [];
        final beverageExpanse = [];
        final alcoholExpanse = [];
        final expenseAmountOnlyResult = [];
        var showExpenseAddList = [];


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
          foodProvisionExpanse.add(docQuery['foodProvisionExpense']);
          beverageExpanse.add(docQuery['beverageExpense']);
          alcoholExpanse.add(docQuery['alcoholExpense']);
          showExpenseAddList.addAll(docQuery['expenseAddList']);
          List<dynamic> expenseAddListInExpenseAmount = docQuery['expenseAddList'];
          expenseAddListInExpenseAmount.forEach((element) {
            var expenseAmount = element['expenseAmount'];
            int expenseAmountIntType = int.parse(expenseAmount.toString().replaceAll(",", ''));
            expenseAmountOnlyResult.add(expenseAmountIntType);
          });
        });

        int expenseAddListTotalAmount = expenseAmountOnlyResult.isEmpty ? int.parse('0') : expenseAmountOnlyResult.reduce((v, e) => v+e);
        int foodProvisionExpensePlus = foodProvisionExpanse.isEmpty ? int.parse('0') : foodProvisionExpanse.reduce((v, e) => v+e);
        int beverageExpensePlus = beverageExpanse.isEmpty ? int.parse('0') : beverageExpanse.reduce((v, e) => v+e);
        int alcoholExpense = alcoholExpanse.isEmpty ? int.parse('0') : alcoholExpanse.reduce((v, e) => v+e);
        int totalResultExpenseGroup = expenseAddListTotalAmount + foodProvisionExpensePlus + beverageExpensePlus + alcoholExpense;

          List<ChartData> chartData = [];
          for(int index=0;index<snapshot.data.docs.length;index++) {
            DocumentSnapshot document = snapshot.data.docs[index];
            chartData.add(ChartData.fromMap(document.data()));
          }



        return SafeArea(
          child: GestureDetector(
            onTap: (){
              print(expenseAmountOnlyResult);
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: mainAppBar(context, IconButton(icon: Icon(Icons.search_rounded, size: 26, color: Colors.deepPurpleAccent,),
                  onPressed: ()=> _searchScreenShowBottomSheetRangeDatePickerList(context),)),
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
                              _searchScreenShowBottomSheetRangeDatePickerList(context);
                            },
                          ),
                        ),
                      _searchScreenPageViewSalesAndExpenseTextList(
                          actualSales, totalSales, discount, delivery, creditCard, vos, vat, cash, cashReceipt, giftCard,
                          totalResultExpenseGroup, foodProvisionExpanse, beverageExpanse, alcoholExpanse, expenseAmountOnlyResult,
                          context, showExpenseAddList),
                      Container(
                        width: size.width*0.8,
                        height: size.height*0.3,
                        child: SfCartesianChart(
                          title: ChartTitle(text: '매출',),
                          primaryXAxis: CategoryAxis(
                            labelStyle: TextStyle(color: Colors.black54),
                            labelPosition: ChartDataLabelPosition.outside,
                          ),
                          primaryYAxis: NumericAxis(
                          ),
                          series: <ChartSeries<ChartData, dynamic>>[
                            ColumnSeries<ChartData, dynamic>(
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _)=>data.xValue.toString(),
                                yValueMapper: (ChartData data, _)=>data.yValue,
                              isVisible: true,
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Colors.deepPurple,Colors.deepPurple[400], Colors.deepPurple[200]],
                              )
                            ),
                          ],
                        ),
                      ),
                      InkWell(onTap:()=>print(chartData.toList().first),child: Text("UNDER PAGE VIEW WIDGET",style: TextStyle(color: Colors.black, fontSize: 13),)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Future _searchScreenShowBottomSheetRangeDatePickerList(BuildContext context) {
    return showMaterialModalBottomSheet(
                                closeProgressThreshold: 5.0,
                                elevation: 0,
                                enableDrag: true,
                                animationCurve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 300),
                                barrierColor: Colors.white12,
                                backgroundColor: Colors.white,
                                context: context,
                                builder: (BuildContext context){
                                  return Container(
                                    height: size.height*0.2,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: size.width*0.1,
                                          height: size.height*0.25,
                                          color: Colors.white,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [Colors.green[500], Colors.green[500], Colors.green[400], Colors.green[300]],
                                            ),
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                                          ),
                                          width: size.width*0.8,
                                          height: size.height*0.25,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ListTile(
                                                    leading: Text('Day'),
                                                    title: Text('일자별',),
                                                    dense: true,
                                                    onTap: (){
                                                      Navigator.pop(context);
                                                      _searchScreenDayRangeDatePicker(context);
                                                    }
                                                  ),
                                                  Divider(height: 1,),
                                                  ListTile(
                                                      leading: Text('Month'),
                                                    title: Text('월별'),
                                                    dense: true,
                                                    onTap: (){
                                                      Navigator.pop(context);
                                                      _searchScreenMonthRangeDatePicker(context);
                                                    }
                                                  ),
                                                  Divider(height: 1,),
                                                  ListTile(
                                                    leading: Text('Year'),
                                                    title: Text('연도별'),
                                                    dense: true,
                                                    onTap: (){
                                                      Navigator.pop(context);
                                                      print('아직 못만듬');
                                                    }
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: size.width*0.1,
                                          height: size.height*0.15,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  );
                                });
  }

  Future _searchScreenMonthRangeDatePicker(BuildContext context) {
    return showMaterialModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      closeProgressThreshold: 5.0,
                      enableDrag: true,
                      animationCurve: Curves.fastOutSlowIn,
                      duration: Duration(milliseconds: 300),
                      barrierColor: Colors.black87,
                      backgroundColor: Colors.pinkAccent,
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
                                height: size.height * 0.35,
                                // color: Colors.deepOrange,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: SfDateRangePicker(
                                    minDate: DateTime(2000, 01, 01),
                                    maxDate: DateTime(2100, 01, 01),
                                    yearCellStyle: DateRangePickerYearCellStyle(
                                      textStyle: TextStyle(color: Colors.white),
                                      todayTextStyle: TextStyle(color: Colors.white),
                                    ),
                                    startRangeSelectionColor: Colors.deepPurple,
                                    endRangeSelectionColor: Colors.deepPurple,
                                    rangeSelectionColor: Colors.deepPurple,
                                    selectionTextStyle: TextStyle(color: Colors.white),
                                    todayHighlightColor: Colors.white,
                                    selectionColor: Colors.pinkAccent,
                                    backgroundColor: Colors.pinkAccent,
                                    controller: _monthRangePickerController,
                                    allowViewNavigation: false,
                                    view: DateRangePickerView.year,
                                    selectionMode: DateRangePickerSelectionMode.range,
                                    headerStyle: DateRangePickerHeaderStyle(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontStyle: FontStyle.italic)),
                                    monthViewSettings: DateRangePickerMonthViewSettings(
                                      enableSwipeSelection: false,
                                    ),
                                    onSelectionChanged:
                                        (DateRangePickerSelectionChangedArgs args) {
                                      setState(() {
                                        if (args.value is PickerDateRange) {
                                          rangePickerStartDate = DateFormat.yM('ko_KO')
                                              .format(args.value.startDate)
                                              .toString();
                                          rangePickerEndDate = DateFormat.yM('ko_KO')
                                              .format(
                                              args.value.endDate ?? args.value.startDate)
                                              .toString();
                                          rangePickerStartDateTime = args.value.startDate;
                                          rangePickerEndDateTime = args.value.endDate;
                                        }  else{
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
  }

  Future _searchScreenDayRangeDatePicker(BuildContext context) {
    return showMaterialModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        closeProgressThreshold: 5.0,
        enableDrag: true,
        animationCurve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 300),
        barrierColor: Colors.black87,
        backgroundColor: Colors.deepPurple,
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
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        specialDatesDecoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        todayTextStyle: TextStyle(color: Colors.white),
                      ),
                      startRangeSelectionColor: Colors.pinkAccent,
                      endRangeSelectionColor: Colors.pinkAccent,
                      rangeSelectionColor: Colors.pinkAccent,
                      selectionTextStyle: TextStyle(color: Colors.white),
                      todayHighlightColor: Colors.white,
                      selectionColor: Colors.deepPurple,
                      backgroundColor: Colors.deepPurple,
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
                        // blackoutDates: stdDate,
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
  }

  ExpandablePageView _searchScreenPageViewSalesAndExpenseTextList(List actualSales, List totalSales, List discount, List delivery,
      List creditCard, List vos, List vat, List cash, List cashReceipt, List giftCard, int totalResultExpenseGroup, List foodProvisionExpanse,
      List beverageExpanse, List alcoholExpanse, List expenseAmountOnlyResult, BuildContext context, List showExpenseAddList) {
    return ExpandablePageView(
                      controller: _pageController,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right:12),
                          child: ExpansionCard(
                            initiallyExpanded: _isExpanded,
                            borderRadius: 30,
                            background: DecoratedBox(
                              decoration: _decorationContainerPageView([Colors.deepPurple[400], Colors.deepPurple[400], Colors.deepPurple[500]]),
                              child: Container(
                                width: size.width, height: size.height*0.3,
                              ),
                            ),
                            title: Container(
                              width: size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  _searchScreenPageViewShowTextForm(16, 10.0, Colors.white, '실제매출', actualSales,),
                                  _searchScreenPageViewShowTextForm(16, 10.0, Colors.white, '총매출', totalSales,),
                                ],
                              ),),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(width: size.width*0.7, height: 2, color: Colors.white24,),
                              ),
                              Column(
                              children: <Widget>[
                                _searchScreenPageViewShowTextForm(null, 25.0 ,null, '할인', discount,),
                                _searchScreenPageViewShowTextForm(null, 25.0 ,null, 'Delivery', delivery,),
                                _searchScreenPageViewShowTextForm(null, 25.0 ,null, '신용카드', creditCard,),
                                _searchScreenPageViewShowTextForm(null, 25.0 ,null, '공급가액', vos,),
                                _searchScreenPageViewShowTextForm(null, 25.0 ,null, '세액', vat,),
                                _searchScreenPageViewShowTextForm(null, 25.0 ,null, '현금', cash,),
                                _searchScreenPageViewShowTextForm(null, 25.0 ,null, '현금영수증', cashReceipt,),
                                _searchScreenPageViewShowTextForm(null, 25.0 ,null, 'Gift card', giftCard,),
                              ],
                              ),
                            ],),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right:12),
                          child: ExpansionCard(
                            initiallyExpanded: _isExpanded,
                            borderRadius: 30,
                            background: DecoratedBox(
                              decoration: _decorationContainerPageView([Colors.pink[400], Colors.pink[400], Colors.pink[500]]),
                              child: Container(
                                width: size.width, height: size.height*0.3,
                              ),
                            ),
                            title: Container(
                              width: size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                              Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('총지출     ' + koFormatMoney.format(totalResultExpenseGroup),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16, height: 1.1),
                                  ),
                                  Expanded(child: Text('   \\', style: TextStyle(color: Colors.white70 , fontSize: 8),))
                                ],
                              ),
                            ),
                                  _searchScreenPageViewShowTextForm(16, 10.0, Colors.white, '식자재', foodProvisionExpanse,),
                                ],
                              ),),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(width: size.width*0.7, height: 2, color: Colors.white24,),
                              ),
                              Column(
                              children: <Widget>[
                                _searchScreenPageViewShowTextForm(null, 25.0 ,null, '음료', beverageExpanse,),
                                _searchScreenPageViewShowTextForm(null, 25.0 ,null, '주류', alcoholExpanse,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Container(width: size.width*0.7, height: 2, color: Colors.white24,),
                                ),
                                InkWell(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                                        child: Row(
                                          children: <Widget>[
                                            Text('추가지출       ',style: TextStyle(color: Colors.white, fontSize: 13),),
                                            Column(
                                              children: <Widget>[
                                                Text(expenseAmountOnlyResult.length.toString() + ' 건', style: TextStyle(color: Colors.white, fontSize: 13),),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5),
                                                  child: Text(koFormatMoney.format(expenseAmountOnlyResult.isEmpty || rangePickerStartDateTime == null ?
                                                  int.parse('0') : expenseAmountOnlyResult.reduce((v, e) => v+e)), style: TextStyle(color: Colors.white, fontSize: 13),),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 20),
                                              child: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white,),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: (){
                                    showMaterialModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        closeProgressThreshold: 5.0,
                                        elevation: 90.0,
                                        animationCurve: Curves.fastOutSlowIn,
                                        duration: Duration(milliseconds: 1500),
                                        barrierColor: Colors.black87,
                                        backgroundColor: Colors.deepOrangeAccent,
                                        context: context,
                                        builder: (BuildContext context){
                                          return Container(
                                            height: size.height*0.3,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 15),
                                              child: ListView.separated(
                                                itemCount: showExpenseAddList.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 40, top: 5),
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Container(
                                                              width: size.width*0.5,
                                                              child: Text(
                                                                showExpenseAddList[index]['title'].toString(), style: TextStyle(
                                                                  color: Colors.white),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                width: size.width*0.2,
                                                                child: Text(
                                                                  showExpenseAddList[index]['expenseAmount'].toString(), style: TextStyle(
                                                                    color: Colors.white),),
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }, separatorBuilder: (BuildContext context, int index) {
                                                return Container(height: 15,);
                                              },
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                ),
                              ],
                              ),
                            ],),
                        ),
                      ],
                    );
  }

  Padding _searchScreenPageViewShowTextForm(double fontSize, double paddingDouble, Color color, String hint, data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingDouble ?? 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$hint     ' +
                koFormatMoney.format(
                    data.isEmpty || rangePickerStartDateTime == null
                        ? int.parse('0')
                        : data.reduce((v, e) => v + e)),
            style: TextStyle(
                color: color == null? Colors.white : color,
                fontSize: fontSize == null ? 13 : fontSize, height: 1.1),
          ),
          Expanded(child: Text('   \\', style: TextStyle(color: color == null ? Colors.white70 : color, fontSize: 8),))
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

