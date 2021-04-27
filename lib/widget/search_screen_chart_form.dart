import 'package:badges/badges.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/firebase_firestore/chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SearchScreenChartForm extends StatelessWidget {

  final Duration duration;
  final List<BarChartData> barChartData;
  final List<CircularChartData> circularChartData;
  final int? totalSales;
  final int totalExpense;
  final double doughnutMainTotalExpense;
  final _pageBarChartViewController;
  final _pageRadialChartViewController;
  final _pageDoughnutChartViewController;
  final _pageLinearChartViewController;
  final bool circularChartSwitcher;
  final bool timeSeriesChartSwitcher;

  const SearchScreenChartForm(this.duration, this.barChartData,this.circularChartData, this.totalSales, this.totalExpense, this.doughnutMainTotalExpense,
      this._pageBarChartViewController, this._pageRadialChartViewController, this._pageDoughnutChartViewController, this._pageLinearChartViewController,
      this.circularChartSwitcher, this.timeSeriesChartSwitcher,{Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        AnimatedSwitcher(
            duration: duration,
        child: circularChartSwitcher ? _searchScreenToggleRadialChart():_searchScreenToggleDoughnutChart()),
        AnimatedSwitcher(
            duration: duration,
        child: timeSeriesChartSwitcher ? _searchScreenToggleBarChart():_searchScreenToggleLinearChart())
      ],
    );
  }

  ExpandablePageView _searchScreenToggleLinearChart() {
    return ExpandablePageView(
        controller: _pageLinearChartViewController,
        children: [
          _searchScreenLinearGradientForm('실제매출', '총지출',
              [Colors.deepPurpleAccent, Colors.blueAccent, Colors.lightBlueAccent], [Colors.pinkAccent, Colors.deepOrange, Colors.orangeAccent],Colors.deepPurpleAccent, Colors.pinkAccent,
                  (BarChartData data, _)=>data.actualSalesYValue, (BarChartData data,_)=>data.expenseTotalYValue ),
          _searchScreenLinearGradientForm('실제매출', '식자재',
              [Colors.deepPurpleAccent, Colors.blueAccent, Colors.lightBlueAccent], [Colors.green, Colors.greenAccent, Colors.lightGreen], Colors.deepPurpleAccent, Colors.greenAccent,
                  (BarChartData data, _)=>data.actualSalesYValue, (BarChartData data,_)=>data.foodProvisionExpenseYValue ),
          _searchScreenLinearGradientForm('총지출', '식자재',
              [Colors.pinkAccent, Colors.deepOrange, Colors.orangeAccent], [Colors.green, Colors.greenAccent, Colors.lightGreen], Colors.pinkAccent, Colors.greenAccent,
                  (BarChartData data, _)=>data.expenseTotalYValue, (BarChartData data,_)=>data.foodProvisionExpenseYValue ),
        ],
      );
  }

  Column _searchScreenLinearGradientForm(String firstTitle, String secondTitle, List<Color> firstColor, List<Color> secondColor,
      Color firstBadgeColor, Color secondBadgeColor, firstData, secondData ) {
    return Column(
      children: [
        Container(
            width: size.width*0.7, height: size.height*0.3,
            child: SfCartesianChart(
              enableSideBySideSeriesPlacement: false,
              plotAreaBorderWidth: 0,
              margin: EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 10),
              primaryXAxis: CategoryAxis(
                majorGridLines: MajorGridLines(width: 0,),
                majorTickLines: MajorTickLines(width: 0,),
                axisLine: AxisLine(width: 0,),
                labelStyle: TextStyle(color: Colors.black54),
                labelPosition: ChartDataLabelPosition.outside,
              ),
              primaryYAxis: NumericAxis(
                isVisible: false,
                numberFormat: NumberFormat.decimalPattern(),
                axisLine: AxisLine(width: 0),
                majorGridLines: MajorGridLines(width: 0),
                majorTickLines: MajorTickLines(size: 0),
              ),
              series: <ChartSeries<BarChartData, dynamic>>[
                SplineAreaSeries<BarChartData, dynamic>(
                  dataSource: barChartData,
                  xValueMapper: (BarChartData data, _)=>data.selectedDateXValue.toString().substring(5,10),
                  yValueMapper: firstData,
                  isVisible: true,
                  name: firstTitle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: firstColor,
                  ),
                ),
                SplineAreaSeries<BarChartData, dynamic>(
                  dataSource: barChartData,
                  xValueMapper: (BarChartData data, _)=>data.selectedDateXValue.toString().substring(5,10),
                  yValueMapper: secondData,
                  isVisible: true,
                  name: secondTitle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: secondColor,
                  ),
                ),
              ],
              legend: Legend(isVisible: false,),
              tooltipBehavior: TooltipBehavior(
                borderColor: Colors.white,
                color: Colors.white,
                canShowMarker: true,
                tooltipPosition: TooltipPosition.pointer,
                borderWidth: 2,
                enable: true,
                elevation: 9,
                textStyle: TextStyle(color: Colors.black54, fontSize: 17, fontFamily: 'Yanolja'),
              ),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Badge(badgeColor: firstBadgeColor ,),
            Container(
              child: Text('   $firstTitle', style: TextStyle(fontSize: 12, color: Colors.black54),),
            ),
            SizedBox(width: size.width*0.1,),
            Badge(badgeColor: secondBadgeColor ,),
            Container(
              child: Text('   $secondTitle', style: TextStyle(fontSize: 12, color: Colors.black54),),
            ),
          ],
        ),
      ],
    );
  }

  ExpandablePageView _searchScreenToggleDoughnutChart() {
    return ExpandablePageView(
        controller: _pageDoughnutChartViewController,
        children: [
          Container(
            height: size.height*0.3,
            child: SfCircularChart(
              annotations: <CircularChartAnnotation>[
                CircularChartAnnotation(
                    height: '100%',
                    width: '100%',
                    widget: Container(
                      child: PhysicalModel(
                        shape: BoxShape.circle,
                        elevation: 10,
                        color: Colors.grey[200]!,
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
                  radius: '90%',
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
          ),
          Container(
            height: size.height*0.3,
            child: SfCircularChart(
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                overflowMode: LegendItemOverflowMode.wrap,
                iconBorderWidth: 1,
                iconBorderColor: Colors.pink,
              ),
              annotations: [
                CircularChartAnnotation(
                  height: '55%',
                  width: '55%',
                  widget: Container(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: Center(child: Text('지출', style: TextStyle(fontSize: 14, color: Colors.black54, fontFamily: 'Yanolja'),)),
                    ),
                  ),
                ),
              ],
              series: <CircularSeries<CircularChartData, dynamic>>[
                DoughnutSeries<CircularChartData, dynamic>(
                  radius: '100%',
                  dataSource: circularChartData,
                  xValueMapper: (CircularChartData data, _)=>data.title,
                  yValueMapper: (CircularChartData data, _)=>data.doughnutExpense,
                  dataLabelMapper: (CircularChartData data, _)=>data.labelTitle,
                  pointColorMapper: (CircularChartData data, _)=>data.color,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                  enableTooltip: true,
                  enableSmartLabels: true,
                  dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ],
            ),
          ),
        ],
      );
  }

  ExpandablePageView _searchScreenToggleBarChart() {
    return ExpandablePageView(
        controller: _pageBarChartViewController,
        children: [
          _searchScreenBarChartToSalesAndExpense('실제매출', '총 지출',
                  (BarChartData data, _)=>data.actualSalesYValue, (BarChartData data, _)=>data.expenseTotalYValue, Colors.deepPurple, Colors.pink),
          _searchScreenBarChartToSalesAndExpense('총 매출', '실제매출',
                  (BarChartData data, _)=>data.totalSalesYValue, (BarChartData data, _)=>data.actualSalesYValue, Colors.amber, Colors.deepPurple),
          _searchScreenBarChartToSalesAndExpense('총 지출', '식자재',
                  (BarChartData data, _)=>data.expenseTotalYValue, (BarChartData data, _)=>data.foodProvisionExpenseYValue, Colors.pink, Colors.lightBlue),
        ],
      );
  }

  ExpandablePageView _searchScreenToggleRadialChart() {
    return ExpandablePageView(
      controller: _pageRadialChartViewController,
      children: [
        _searchScreenRadialChartToSalesAndExpense(circularChartData, (CircularChartData data, _)=>data.radialMainShow,
        totalSales!.toDouble()*1.1+.0),
        _searchScreenRadialChartToSalesAndExpense(circularChartData, (CircularChartData data, _)=>data.radialSales,
        totalSales!.toDouble()*1.1+.0),
        _searchScreenRadialChartToSalesAndExpense(circularChartData, (CircularChartData data, _)=>data.radialExpense,
            totalExpense.toDouble()*1.1+.0),
      ],
    );
  }

  Container _searchScreenRadialChartToSalesAndExpense(List<CircularChartData> radialChartData, yData, double maximumValue) {
    return Container(
      height: size.height*0.3,
      child: SfCircularChart(
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
        series: <RadialBarSeries<CircularChartData, dynamic>>[
          RadialBarSeries<CircularChartData, dynamic>(
            gap: '10%',
            radius: '100%',
            cornerStyle: CornerStyle.bothCurve,
            dataSource: radialChartData,
            xValueMapper: (CircularChartData data, _)=>data.title,
            yValueMapper: yData,
            dataLabelMapper: (CircularChartData data, _)=>data.labelTitle,
            pointColorMapper: (CircularChartData data, _)=>data.color,
            enableTooltip: true,
            enableSmartLabels: true,
            dataLabelSettings: DataLabelSettings(
              isVisible: true, textStyle: TextStyle(color: Colors.black54, fontSize: 10, fontFamily: 'Yanolja'),),
            maximumValue: maximumValue,
          ),
        ],
      ),
    );
  }

  Column _searchScreenBarChartToSalesAndExpense(String firstTitle, String secondTitle,
       firstData, secondData, Color firstBadgeColor, Color secondBadgeColor) {
    return Column(
      children: [
        Container(
          width: size.width*0.7, height: size.height*0.3,
          child: SfCartesianChart(
            enableSideBySideSeriesPlacement: false,
            plotAreaBorderWidth: 0,
            margin: EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 10),
            primaryXAxis: CategoryAxis(
              majorGridLines: MajorGridLines(width: 0,),
              majorTickLines: MajorTickLines(width: 0,),
              axisLine: AxisLine(width: 0,),
              labelStyle: TextStyle(color: Colors.black54),
              labelPosition: ChartDataLabelPosition.outside,
            ),
            primaryYAxis: NumericAxis(
              isVisible: false,
              numberFormat: NumberFormat.decimalPattern(),
              axisLine: AxisLine(width: 0),
              majorGridLines: MajorGridLines(width: 0),
              majorTickLines: MajorTickLines(size: 0),
            ),
            series: <ChartSeries<BarChartData, dynamic>>[
              ColumnSeries<BarChartData, dynamic>(
                dataSource: barChartData,
                width: 0.8,
                xValueMapper: (BarChartData data, _)=>data.selectedDateXValue.toString().substring(5,10),
                yValueMapper: firstData,
                isVisible: true,
                trackColor: Colors.black12,
                borderRadius: BorderRadius.only(topRight: Radius.circular(5), topLeft: Radius.circular(5)),
                name: firstTitle,
              ),
              ColumnSeries<BarChartData, dynamic>(
                dataSource: barChartData,
                width: 0.5,
                xValueMapper: (BarChartData data, _)=>data.selectedDateXValue.toString().substring(5,10),
                yValueMapper: secondData,
                isVisible: true,
                trackColor: Colors.black12,
                borderRadius: BorderRadius.only(topRight: Radius.circular(5), topLeft: Radius.circular(5)),
                name: secondTitle,
              ),
            ],
            legend: Legend(isVisible: false,),
            tooltipBehavior: TooltipBehavior(
              borderColor: Colors.white,
              color: Colors.white,
              canShowMarker: true,
              tooltipPosition: TooltipPosition.pointer,
              borderWidth: 2,
              enable: true,
              elevation: 9,
              textStyle: TextStyle(color: Colors.black54, fontSize: 17, fontFamily: 'Yanolja'),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Badge(badgeColor: firstBadgeColor ,),
            Container(
              child: Text('   $firstTitle', style: TextStyle(fontSize: 12, color: Colors.black54),),
            ),
            SizedBox(width: size.width*0.1,),
            Badge(badgeColor: secondBadgeColor ,),
            Container(
              child: Text('   $secondTitle', style: TextStyle(fontSize: 12, color: Colors.black54),),
            ),
          ],
        ),
      ],
    );
  }
}
