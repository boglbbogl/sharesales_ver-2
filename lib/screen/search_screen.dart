import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/app_bar.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';
import 'package:sharesales_ver2/firebase_firestore/chart_model.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
import 'package:sharesales_ver2/widget/my_progress_indicator.dart';
import 'package:sharesales_ver2/widget/search_screen_chart_form.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'management_screen.dart';

class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DateRangePickerController _dayRangePickerController = DateRangePickerController();
  DateRangePickerController _monthRangePickerController = DateRangePickerController();

  PageController _pageDoughnutChartViewController = PageController(viewportFraction: 0.7, initialPage: 0);
  PageController _pageBarChartViewController = PageController(viewportFraction: 0.7, initialPage: 0);
  PageController _pageRadialChartViewController = PageController(viewportFraction: 0.7, initialPage: 0);
  PageController _pageTextViewController = PageController(viewportFraction: 0.8);

  String _rangePickerStartDate;
  String _rangePickerEndDate;
  DateTime _rangePickerStartDateTime;
  DateTime _rangePickerEndDateTime;

  bool _isExpanded = false;

  @override
  void dispose() {
    _dayRangePickerController.dispose();
    _pageTextViewController.dispose();
    _pageBarChartViewController.dispose();
    _pageRadialChartViewController.dispose();
    _pageTextViewController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _rangePickerStartDateTime=DateTime(1000,01,01);
    _rangePickerEndDateTime=DateTime(1000,01,02);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    UserModel userModel = Provider.of<UserModelState>(context, listen: false).userModel;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(COLLECTION_SALES_MANAGEMENT).doc(userModel.userKey).collection(userModel.userName)
      .where('stdDate', isGreaterThanOrEqualTo: _rangePickerStartDateTime,
          isLessThanOrEqualTo: _rangePickerEndDateTime==null?_rangePickerStartDateTime.add(Duration(days: 1)):_rangePickerEndDateTime.add(Duration(days: 1)))
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if(!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
          return MyProgressIndicator();
        }
        final List<dynamic> listStdDate = [];
        final listTotalSales = [];
        final listActualSales = [];
        final listDiscount = [];
        final listDelivery = [];
        final listCreditCard = [];
        final listGiftCard = [];
        final listVos = [];
        final listVat = [];
        final listCash = [];
        final listCashReceipt = [];
        final listFoodProvisionExpanse = [];
        final listBeverageExpanse = [];
        final listAlcoholExpanse = [];
        final listExpenseAddTotalAmount = [];
        var listShowExpenseAddList = [];

        snapshot.data.docs.forEach((element) {
          var docQuery = element.data();
          listTotalSales.add(docQuery['totalSales']);
          listActualSales.add(docQuery['actualSales']);
          listDiscount.add(docQuery['discount']);
          listDelivery.add(docQuery['delivery']);
          listCreditCard.add(docQuery['creditCard']);
          listGiftCard.add(docQuery['giftCard']);
          listVos.add(docQuery['vos']);
          listVat.add(docQuery['vat']);
          listCash.add(docQuery['cash']);
          listCashReceipt.add(docQuery['cashReceipt']);
          listStdDate.add(docQuery['stdDate']);
          listFoodProvisionExpanse.add(docQuery['foodProvisionExpense']);
          listBeverageExpanse.add(docQuery['beverageExpense']);
          listAlcoholExpanse.add(docQuery['alcoholExpense']);
          listExpenseAddTotalAmount.add(docQuery['expenseAddTotalAmount']);
          listShowExpenseAddList.addAll(docQuery['expenseAddList']);
        });

        int totalSales = _listDataNullCheckForm(listTotalSales);
        int actualSales = _listDataNullCheckForm(listActualSales);
        int vos = _listDataNullCheckForm(listVos);
        int vat = _listDataNullCheckForm(listVat);
        int discount = _listDataNullCheckForm(listDiscount);
        int creditCard = _listDataNullCheckForm(listCreditCard);
        int cash = _listDataNullCheckForm(listCash);
        int cashReceipt = _listDataNullCheckForm(listCashReceipt);
        int delivery = _listDataNullCheckForm(listDelivery);
        int giftCard = _listDataNullCheckForm(listGiftCard);
        int expenseAddTotalAmount = _listDataNullCheckForm(listExpenseAddTotalAmount);
        int foodProvisionExpense = _listDataNullCheckForm(listFoodProvisionExpanse);
        int beverageExpense = _listDataNullCheckForm(listBeverageExpanse);
        int alcoholExpense = _listDataNullCheckForm(listAlcoholExpanse);
        int totalExpense = expenseAddTotalAmount + foodProvisionExpense + alcoholExpense;

          List<BarChartData> barChartData = [];
          for(int index=0;index<snapshot.data.docs.length;index++) {
            DocumentSnapshot document = snapshot.data.docs[index];
            barChartData.add(BarChartData.fromMap(document.data() ));}

        double doughnutMainTotalExpense = (totalExpense/actualSales)*100;
        double doughnutMainTotalActualSales = ((actualSales-totalExpense)/actualSales)*100;


          List<CircularChartData> circularChartData = [
            CircularChartData(title: "Delivery : " + koFormatMoney.format(delivery) + ' \\', color: Colors.lightBlue, labelTitle: "Delivery",radialSales: delivery),
            CircularChartData(title: "실제매출 : " + koFormatMoney.format(actualSales) + ' \\', color: Colors.deepOrange, labelTitle: "실제매출",radialSales: actualSales),
            CircularChartData(title: "할인 : " + koFormatMoney.format(discount) + ' \\', color: Colors.amber, labelTitle: "할인",radialSales: discount),
            CircularChartData(title: "총 매출 : " + koFormatMoney.format(totalSales) + ' \\', color: Colors.deepPurple, labelTitle: "총 매출",radialSales: totalSales),
            CircularChartData(title: "음료+주류 : " + koFormatMoney.format(beverageExpense+alcoholExpense) + ' \\', color: Colors.purpleAccent, labelTitle: "음료+주류",radialExpense: beverageExpense+alcoholExpense),
            CircularChartData(title: "식자재 : " + koFormatMoney.format(foodProvisionExpense) + ' \\', color: Colors.orange, labelTitle: "식자재",radialExpense: foodProvisionExpense),
            CircularChartData(title: "총 지출 : " + koFormatMoney.format(totalExpense) + ' \\', color: Colors.teal, labelTitle: "총 지출",radialExpense: totalExpense),
            CircularChartData(title: "총 지출 : " + koFormatMoney.format(totalExpense) + ' \\', color: Colors.deepPurple, labelTitle: "총 지출",radialMainShow: totalExpense),
            CircularChartData(title: "식자재 : " + koFormatMoney.format(foodProvisionExpense) + ' \\', color: Colors.green, labelTitle: "식자재",radialMainShow: foodProvisionExpense),
            CircularChartData(title: "실제매출 : " + koFormatMoney.format(actualSales) + ' \\', color: Colors.redAccent, labelTitle: "실제매출",radialMainShow: actualSales),
            CircularChartData(title: '매출 : '  + koFormatMoney.format(actualSales) +' \\', color: Colors.grey[200], labelTitle: "",
                doughnutMain: doughnutMainTotalActualSales.isNaN ? 0.0 : doughnutMainTotalActualSales),
            CircularChartData(title: '지출 : ' + koFormatMoney.format(totalExpense) + ' \\', color: Colors.pink, labelTitle: "지출",
                doughnutMain: doughnutMainTotalExpense.isNaN ? 0.0 : doughnutMainTotalExpense),
            // CircularChartData(title: doughnutMainTotalActualSales.isNaN ? double.nan.toString()
            //     : "매출 ${double.parse(doughnutMainTotalActualSales.toStringAsFixed(1)).toString()} %",
            //     labelTitle: koFormatMoney.format(actualSales).toString()+' 원',
            //     color: Colors.deepPurple, doughnutMain: doughnutMainTotalActualSales.isNaN ? 0.0 : doughnutMainTotalActualSales),
            // CircularChartData(title: doughnutMainTotalExpense.isNaN ? double.nan.toString()
            //     : "지출 ${double.parse(doughnutMainTotalExpense.toStringAsFixed(1).toString())} %",
            //     labelTitle: koFormatMoney.format(totalExpense).toString()+' 원',
            //     color: Colors.pink, doughnutMain: doughnutMainTotalExpense.isNaN ? 0.0 : doughnutMainTotalExpense),
          ];

        return SafeArea(
          child: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
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
                                Text(_rangePickerStartDate == null ? '기간을 선택해주세요' : _rangePickerStartDate.replaceAll(".", ''),
                                  style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic, color: Colors.black54),),
                                Text(_rangePickerStartDate == _rangePickerEndDate ? '' : '   -   ', style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, color: Colors.black54),),
                                Text(_rangePickerEndDate == null || _rangePickerEndDate==_rangePickerStartDate ? '' : _rangePickerEndDate.replaceAll(".", ""),
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
                          expenseAddTotalAmount, foodProvisionExpense, beverageExpense, alcoholExpense, listShowExpenseAddList,
                          context, listShowExpenseAddList, totalExpense),
                      SearchScreenChartForm(barChartData, circularChartData, totalSales, totalExpense,
                          _pageBarChartViewController, _pageRadialChartViewController),
                      ExpandablePageView(
                        controller: _pageDoughnutChartViewController,
                        children: [
                          SfCircularChart(
                            annotations: <CircularChartAnnotation>[
                              CircularChartAnnotation(
                                height: '100%',
                                width: '100%',
                                widget: Container(
                                  child: PhysicalModel(
                                    shape: BoxShape.circle,
                                    elevation: 10,
                                    color: Colors.grey[200],
                                    child: Container(),
                                  ),
                                )
                              ),
                              CircularChartAnnotation(
                                widget: Container(
                                  child: Text("${double.parse(doughnutMainTotalExpense.toStringAsFixed(1).toString())} %",
                                  style: TextStyle(color: Colors.pink, fontFamily: 'Yanolja', fontWeight: FontWeight.bold, fontSize: 20),),
                                ),
                              ),
                            ],
                            tooltipBehavior: TooltipBehavior(
                              format: 'point.x',
                              borderColor: Colors.white,
                              color: Colors.white,
                              canShowMarker: true,
                              tooltipPosition: TooltipPosition.pointer,
                              borderWidth: 2,
                              enable: true,
                              elevation: 9,
                              textStyle: TextStyle(color: Colors.black54, fontSize: 14, fontFamily: 'Yanolja'),
                            ),
                            series: <DoughnutSeries<CircularChartData, dynamic>>[
                              DoughnutSeries<CircularChartData, dynamic>(
                                dataSource: circularChartData,
                                xValueMapper: (CircularChartData data, _)=>data.title,
                                yValueMapper: (CircularChartData data, _)=>data.doughnutMain,
                                dataLabelMapper: (CircularChartData data, _)=>data.labelTitle,
                                pointColorMapper: (CircularChartData data, _)=>data.color,
                                enableTooltip: true,
                                enableSmartLabels: true,
                                dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: TextStyle(fontFamily: 'Yanolja')),
                              ),
                            ],
                          ),

                        ],
                      ),
                      SfCircularChart(
                        tooltipBehavior: TooltipBehavior(
                          format: 'point.x',
                          borderColor: Colors.white,
                          color: Colors.white,
                          canShowMarker: true,
                          tooltipPosition: TooltipPosition.pointer,
                          borderWidth: 2,
                          enable: true,
                          elevation: 9,
                          textStyle: TextStyle(color: Colors.black54, fontSize: 14, fontFamily: 'Yanolja'),
                        ),
                        series: <PieSeries<CircularChartData, dynamic>>[
                          PieSeries<CircularChartData, dynamic>(
                            explode: true,
                            explodeIndex: 0,
                            // explodeOffset: '10%',
                            dataSource: circularChartData,
                            xValueMapper: (CircularChartData data, _)=>data.title,
                            yValueMapper: (CircularChartData data, _)=>data.doughnutMain,
                            dataLabelMapper: (CircularChartData data, _)=>data.labelTitle,
                            pointColorMapper: (CircularChartData data, _)=>data.color,
                            enableTooltip: true,
                            enableSmartLabels: true,
                            dataLabelSettings: DataLabelSettings(isVisible: true,),
                          ),
                        ],
                      ),
                      InkWell(onTap:(){},child: Text("UNDER PAGE VIEW WIDGET",style: TextStyle(color: Colors.black, fontSize: 13),)),
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
                                backgroundColor: Colors.white12,
                                context: context,
                                builder: (BuildContext context){
                                  return Container(
                                    height: size.height*0.2,
                                    child: Row(
                                      children: <Widget>[
                                        Opacity(
                                          opacity: 0,
                                          child: Container(
                                            width: size.width*0.1,
                                            height: size.height*0.25,
                                          ),
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
                                        Opacity(
                                          opacity: 0,
                                          child: Container(
                                            width: size.width*0.1,
                                            height: size.height*0.15,
                                          ),
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
                                          _rangePickerStartDate = DateFormat.yM('ko_KO')
                                              .format(args.value.startDate)
                                              .toString();
                                          _rangePickerEndDate = DateFormat.yM('ko_KO')
                                              .format(
                                              args.value.endDate ?? args.value.startDate)
                                              .toString();
                                          _rangePickerStartDateTime = args.value.startDate;
                                          _rangePickerEndDateTime = args.value.endDate;
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
                            _rangePickerStartDate = DateFormat.yMEd('ko_KO')
                                .format(args.value.startDate)
                                .toString();
                            _rangePickerEndDate = DateFormat.yMEd('ko_KO')
                                .format(
                                    args.value.endDate ?? args.value.startDate)
                                .toString();
                            _rangePickerStartDateTime = args.value.startDate;
                            _rangePickerEndDateTime = args.value.endDate;
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

  ExpandablePageView _searchScreenPageViewSalesAndExpenseTextList(int actualSales, int totalSales, int discount, int delivery,
      int creditCard, int vos, int vat, int cash, int cashReceipt, int giftCard, int totalExpenseAddTotalAmount, int foodProvisionExpanse,
      int beverageExpanse, int alcoholExpanse, List listShowExpenseAddList, BuildContext context, List showExpenseAddList, int totalExpense ) {
    return ExpandablePageView(
                      controller: _pageTextViewController,
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
                                  Text('총지출     ' + koFormatMoney.format(totalExpense),
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
                                                Text(listShowExpenseAddList.length.toString() + ' 건', style: TextStyle(color: Colors.white, fontSize: 13),),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5),
                                                  child: Text(koFormatMoney.format(totalExpenseAddTotalAmount), style: TextStyle(color: Colors.white, fontSize: 13),),
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

                                                  int _showExpenseAmountFormat = showExpenseAddList[index]['expenseAmount'];

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
                                                                  koFormatMoney.format(_showExpenseAmountFormat) + '  \\', style: TextStyle(
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
                koFormatMoney.format(data),
            style: TextStyle(
                color: color == null? Colors.white : color,
                fontSize: fontSize == null ? 13 : fontSize, height: 1.1),
          ),
          Expanded(child: Text('   \\', style: TextStyle(color: color == null ? Colors.white70 : color, fontSize: 8),))
        ],
      ),
    );
  }

  dynamic _listDataNullCheckForm(data){
    int dataIntForm = data.isEmpty || _rangePickerStartDateTime == null ? int.parse('0') : data.reduce((v, e) => v+e);
    return(dataIntForm);
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

