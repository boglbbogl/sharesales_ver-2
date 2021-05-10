import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/app_bar.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';
import 'package:sharesales_ver2/firebase_firestore/chart_model.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
import 'package:sharesales_ver2/widget/my_progress_indicator.dart';
import 'package:sharesales_ver2/widget/search_screen_chart_form.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'management_screen.dart';
import 'package:sizer/sizer.dart';

class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DateRangePickerController _dayRangePickerController = DateRangePickerController();
  DateRangePickerController _monthRangePickerController = DateRangePickerController();

  PageController _pageDoughnutChartViewController = PageController(viewportFraction: 0.7);
  PageController _pageBarChartViewController = PageController(viewportFraction: 0.7, initialPage: 0);
  PageController _pageLinearChartViewController = PageController(viewportFraction: 0.7, initialPage: 0);
  PageController _pageRadialChartViewController = PageController(viewportFraction: 0.7, initialPage: 0);
  PageController _pageTextViewController = PageController(viewportFraction: 0.7);

  String? _rangePickerStartDate;
  String? _rangePickerEndDate;
  DateTime? _rangePickerStartDateTime;
  DateTime? _rangePickerEndDateTime;

  bool circularChartSwitcher = true;
  bool timeSeriesChartSwitcher = true;

  Duration duration = Duration(milliseconds: 10000);

  @override
  void dispose() {
    _dayRangePickerController.dispose();
    _pageTextViewController.dispose();
    _pageBarChartViewController.dispose();
    _pageRadialChartViewController.dispose();
    _pageDoughnutChartViewController.dispose();
    _pageLinearChartViewController.dispose();
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

    UserModel userModel = Provider.of<UserModelState>(context, listen: false).userModel!;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(COLLECTION_SALES_MANAGEMENT).doc(userModel.userKey).collection(userModel.email!)
      .where('stdDate', isGreaterThanOrEqualTo: _rangePickerStartDateTime,
          isLessThanOrEqualTo: _rangePickerEndDateTime==null?_rangePickerStartDateTime!.add(Duration(days: 1)):_rangePickerEndDateTime!.add(Duration(days: 1)))
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

        snapshot.data!.docs.forEach((element) {
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
        int totalExpense = expenseAddTotalAmount + foodProvisionExpense + alcoholExpense + beverageExpense;

          List<BarChartData> barChartData = [];
          for(int index=0;index<snapshot.data!.docs.length;index++) {
            DocumentSnapshot document = snapshot.data!.docs[index];
            barChartData.add(BarChartData.fromMap(document.data()! ));}

        double doughnutMainTotalExpense = (totalExpense/actualSales)*100;
        double doughnutMainTotalActualSales = ((actualSales-totalExpense)/actualSales)*100;

        double doughnutExpenseFood = (foodProvisionExpense/totalExpense)*100;
        double doughnutExpenseBeverage = (beverageExpense/totalExpense)*100;
        double doughnutExpenseAlcohol = (alcoholExpense/totalExpense)*100;
        double doughnutExpenseAddAmount = (expenseAddTotalAmount/totalExpense)*100;


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
            CircularChartData(title: '매출 : '  + koFormatMoney.format(actualSales) +' \\', color: Colors.grey[200], labelTitle: "", doughnutMain: doughnutMainTotalActualSales.isNaN ? 0.0 : doughnutMainTotalActualSales),
            CircularChartData(title: '지출 : ' + koFormatMoney.format(totalExpense) + ' \\', color: Colors.pink, labelTitle: "지출", doughnutMain: doughnutMainTotalExpense.isNaN ? 0.0 : doughnutMainTotalExpense),
            CircularChartData(title: "식자재", color: Colors.pink, labelTitle: doughnutExpenseFood.toStringAsFixed(1)+' %', doughnutExpense: doughnutExpenseFood.isNaN ? 0.0 : doughnutExpenseFood),
            CircularChartData(title: "음료", color: Colors.orange, labelTitle: doughnutExpenseBeverage.toStringAsFixed(1)+' %', doughnutExpense: doughnutExpenseBeverage.isNaN ? 0.0 : doughnutExpenseBeverage),
            CircularChartData(title: "주류", color: Colors.deepOrange, labelTitle: doughnutExpenseAlcohol.toStringAsFixed(1)+' %', doughnutExpense: doughnutExpenseAlcohol.isNaN ? 0.0 : doughnutExpenseAlcohol),
            CircularChartData(title: "추가지출", color: Colors.green, labelTitle: doughnutExpenseAddAmount.toStringAsFixed(1)+' %', doughnutExpense: doughnutExpenseAddAmount.isNaN ? 0.0 : doughnutExpenseAddAmount),
          ];


        return SafeArea(
          child: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              backgroundColor: Colors.deepPurple.shade50,
              appBar: mainAppBar(context, secondMainColor,'share sales', Colors.deepPurple.shade50,
                IconButton(icon: Icon(Icons.search_rounded, size: 26, color: Colors.deepPurpleAccent,),
                  onPressed: ()=> _searchScreenShowBottomSheetRangeDatePickerList(context),),
                leadingIcon: _rangePickerStartDate==null ? Icon(Icons.autorenew_rounded, color: Colors.black54,) : IconButton(icon: Icon(Icons.autorenew_rounded),
                  color: circularChartSwitcher ? Colors.pinkAccent : Colors.green,
                onPressed: (){
                  setState(() {
                   circularChartSwitcher = !circularChartSwitcher;
                   timeSeriesChartSwitcher = !timeSeriesChartSwitcher;
                  });
                },),
                appBarBottom: PreferredSize(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: InkWell(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        Text(_rangePickerStartDate == null ? '기간을 선택해주세요' : _rangePickerStartDate!.replaceAll(".", ''), style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic, color: Colors.black54),),
                        Text(_rangePickerStartDate == _rangePickerEndDate ? '' : '   -   ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, color: Colors.black54),),
                        Text(_rangePickerEndDate == null || _rangePickerEndDate==_rangePickerStartDate ? '' : _rangePickerEndDate!.replaceAll(".", ""), style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic, color: Colors.black54),),
                      ],
                    ),
                    onTap: ()=> _searchScreenShowBottomSheetRangeDatePickerList(context),
                  ),
                ), preferredSize: Size(size.width*0.8, 50)),),
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      ExpandablePageView(
                        controller: _pageTextViewController,
                        children: [
                          _searchScreenPageViewContainerListTextFormBySales(actualSales, totalSales, context, vos, vat, discount, delivery, creditCard, cash, cashReceipt, giftCard),
                          _searchScreenPageViewContainerListTextFormByExpense(totalExpense, foodProvisionExpense, context, beverageExpense, alcoholExpense, listShowExpenseAddList, expenseAddTotalAmount),

                        ],
                      ),
                      _rangePickerStartDate == null ? Container() : SearchScreenChartForm(duration, barChartData, circularChartData, totalSales, totalExpense, doughnutMainTotalExpense,
                          _pageBarChartViewController, _pageRadialChartViewController,_pageDoughnutChartViewController, _pageLinearChartViewController,
                          circularChartSwitcher, timeSeriesChartSwitcher),
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

  InkWell _searchScreenPageViewContainerListTextFormByExpense(int totalExpense, int foodProvisionExpense, BuildContext context, int beverageExpense, int alcoholExpense, List listShowExpenseAddList, int expenseAddTotalAmount) {
    return InkWell(child: _searchScreenSalesAndExpensePageViewContainerForm(Colors.pink.shade400,'총 지출','식자재',totalExpense, foodProvisionExpense),
                        onTap: ()=>showMaterialModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            closeProgressThreshold: 5.0,
                            elevation: 90.0,
                            animationCurve: Curves.fastOutSlowIn,
                            duration: Duration(milliseconds: 1500),
                            barrierColor: Colors.black54,
                            backgroundColor: Colors.pink.shade500,
                            context: context,
                            builder: (BuildContext context){
                              return Container(
                                height: 30.h,
                                child: Container(
                                  height: 30.h,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(height: 25,),
                                        __searchScreenSalesAndExpensePageViewContainerFormInTextForm('식자재', foodProvisionExpense),
                                        __searchScreenSalesAndExpensePageViewContainerFormInTextForm('음료', beverageExpense),
                                        __searchScreenSalesAndExpensePageViewContainerFormInTextForm('주류', alcoholExpense),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Container(height: 3, width: size.width*0.5,color: Colors.pinkAccent,),
                                        ),
                                        InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text('추가지출  ', style: TextStyle(color: Colors.white),),
                                                Icon(Icons.search_rounded, color: Colors.white,),
                                              ],
                                            ),
                                          ),
                                          onTap: ()=>__searchScreenSalesAndExpensePageViewContainerFormInTextFormDetailAddExpenseView(context, listShowExpenseAddList),
                                        ),
                                        Text(listShowExpenseAddList.length.toString() + ' 건' +'    '+
                                        koFormatMoney.format(expenseAddTotalAmount) + ' 원', style: TextStyle(color: Colors.white),),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),);
  }

  InkWell _searchScreenPageViewContainerListTextFormBySales(int actualSales, int totalSales, BuildContext context, int vos, int vat, int discount, int delivery, int creditCard, int cash, int cashReceipt, int giftCard) {
    return InkWell(child: _searchScreenSalesAndExpensePageViewContainerForm(Colors.deepPurple.shade400,'실제매출','총 매출',actualSales, totalSales,),
                        onTap: ()=>showMaterialModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            closeProgressThreshold: 5.0,
                            elevation: 90.0,
                            animationCurve: Curves.fastOutSlowIn,
                            duration: Duration(milliseconds: 1500),
                            barrierColor: Colors.black54,
                            backgroundColor: Colors.deepPurple.shade500,
                            context: context,
                            builder: (BuildContext context){
                              return Container(
                                height: 30.h,
                                child: Container(
                                  height: 30.h,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(height: 25,),
                                        __searchScreenSalesAndExpensePageViewContainerFormInTextForm('공급가액', vos),
                                        __searchScreenSalesAndExpensePageViewContainerFormInTextForm('세액', vat),
                                        __searchScreenSalesAndExpensePageViewContainerFormInTextForm('할인', discount),
                                        __searchScreenSalesAndExpensePageViewContainerFormInTextForm('Delivery', delivery),
                                        __searchScreenSalesAndExpensePageViewContainerFormInTextForm('신용카드', creditCard),
                                        __searchScreenSalesAndExpensePageViewContainerFormInTextForm('현금', cash),
                                        __searchScreenSalesAndExpensePageViewContainerFormInTextForm('현금영수증', cashReceipt),
                                        __searchScreenSalesAndExpensePageViewContainerFormInTextForm('Gift Card', giftCard),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),);
  }

  Future __searchScreenSalesAndExpensePageViewContainerFormInTextFormDetailAddExpenseView(BuildContext context, List listShowExpenseAddList) {
    return showMaterialModalBottomSheet(
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
                                                      itemCount: listShowExpenseAddList.length,
                                                      itemBuilder: (BuildContext context, int index) {

                                                        int _showExpenseAmountFormat = listShowExpenseAddList[index]['expenseAmount'];

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
                                                                      listShowExpenseAddList[index]['title'].toString(), style: TextStyle(
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
  }

  Padding __searchScreenSalesAndExpensePageViewContainerFormInTextForm(String title,int value) {
    return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Text('$title : ' + koFormatMoney.format(value) + ' 원', style: TextStyle(
                                            color: Colors.white,
                                          ),),
                                        );
  }

  Padding _searchScreenSalesAndExpensePageViewContainerForm(Color color, String topTitle, String bottomTitle, int topValue, int bottomValue) {
    return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            width: 80.w,
                            height: 10.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: color,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('$topTitle : ' + koFormatMoney.format(topValue) + ' 원',
                                style: TextStyle(color: Colors.white, fontSize: 19),),
                                SizedBox(height: 4,),
                                Text('$bottomTitle : ' + koFormatMoney.format(bottomValue) + ' 원',
                                style: TextStyle(color: Colors.white, fontSize: 19),),
                              ],
                            ),
                          ),
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
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                                      ),
                                      child: ListView(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: ListTile(
                                              horizontalTitleGap: 30,
                                                leading: Text('Day', style: TextStyle(color: Colors.white),),
                                                title: Text('일자별', style: TextStyle(color: Colors.white),),
                                                dense: true,
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  _searchScreenDayRangeDatePicker(context);
                                                }
                                            ),
                                          ),
                                          Divider(height: 1,color: Colors.white12,),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: ListTile(
                                              horizontalTitleGap: 30,
                                                leading: Text('Month',style: TextStyle(color: Colors.white)),
                                                title: Text('월별',style: TextStyle(color: Colors.white)),
                                                dense: true,
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  _searchScreenMonthRangeDatePicker(context);
                                                }
                                            ),
                                          ),
                                          Divider(height: 1,color: Colors.white12,),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: ListTile(
                                              horizontalTitleGap: 30,
                                                leading: Text('Year',style: TextStyle(color: Colors.white)),
                                                title: Text('연도별',style: TextStyle(color: Colors.white)),
                                                dense: true,
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  _searchScreenYearRangeDatePicker(context);
                                                }
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
  }

  Future _searchScreenYearRangeDatePicker(BuildContext context){
    return showMaterialModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        closeProgressThreshold: 5.0,
        enableDrag: true,
        animationCurve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 300),
        barrierColor: Colors.black87,
        backgroundColor: Colors.lightGreen,
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
                      startRangeSelectionColor: Colors.lightBlue,
                      endRangeSelectionColor: Colors.lightBlue,
                      rangeSelectionColor: Colors.lightBlue,
                      selectionTextStyle: TextStyle(color: Colors.white),
                      todayHighlightColor: Colors.white,
                      selectionColor: Colors.lightGreen,
                      backgroundColor: Colors.lightGreen,
                      controller: _monthRangePickerController,
                      allowViewNavigation: false,
                      view: DateRangePickerView.decade,
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

  dynamic _listDataNullCheckForm(data){
    int? dataIntForm = data.isEmpty || _rangePickerStartDateTime == null ? int.parse('0') : data.reduce((v, e) => v+e);
    return(dataIntForm);
  }
}

