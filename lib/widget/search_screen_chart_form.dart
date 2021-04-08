import 'package:badges/badges.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/firebase_firestore/chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SearchScreenChartForm extends StatelessWidget {

  final List<BarChartData> barChartData;
  final List<CircularChartData> radialChartData;
  final List totalSales;
  final int totalResultExpenseGroup;

  const SearchScreenChartForm(this.barChartData,this.radialChartData, this.totalSales, this.totalResultExpenseGroup, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    PageController _pageBarChartViewController = PageController(viewportFraction: 0.7, initialPage: 1);
    PageController _pageRadialChartViewController = PageController(viewportFraction: 0.7, initialPage: 1);

    return Column(
      children: [
      ExpandablePageView(
        controller: _pageRadialChartViewController,
        children: [
          _searchScreenRadialChartToSalesAndExpense(radialChartData, (CircularChartData data, _)=>data.mainShow,
          totalSales.isEmpty ? double.parse('0.0') : totalSales.reduce((v, e) => v+e)*1.1+.0),
          _searchScreenRadialChartToSalesAndExpense(radialChartData, (CircularChartData data, _)=>data.sales,
          totalSales.isEmpty ? double.parse('0.0') : totalSales.reduce((v, e) => v+e)*1.1+.0),
          _searchScreenRadialChartToSalesAndExpense(radialChartData, (CircularChartData data, _)=>data.expense,
              totalResultExpenseGroup.isNaN ? double.parse('0') : totalResultExpenseGroup.toDouble()*1.1+.0),
        ],
      ),
        ExpandablePageView(
          controller: _pageBarChartViewController,
          children: [
            _searchScreenBarChartToSalesAndExpense(barChartData, '실제매출', '총 지출',[Colors.deepPurple[600], Colors.deepPurple[400], Colors.deepPurple[300]] ,
                [Colors.pink[500], Colors.pink[400], Colors.pink[200]],
                    (BarChartData data, _)=>data.actualSalesYValue, (BarChartData data, _)=>data.expenseTotalYValue, Colors.deepPurple, Colors.pink),
            _searchScreenBarChartToSalesAndExpense(barChartData, '총 매출', '실제매출', [Colors.amber[700], Colors.amber[500], Colors.amber[400]],
                [Colors.deepPurple[500],Colors.deepPurple[400], Colors.deepPurple[200]],
                    (BarChartData data, _)=>data.totalSalesYValue, (BarChartData data, _)=>data.actualSalesYValue, Colors.amber, Colors.deepPurple),
            _searchScreenBarChartToSalesAndExpense(barChartData, '총 지출', '식자재', [Colors.pink[600],Colors.pink[400], Colors.pink[300]],
                [Colors.lightBlue[600], Colors.lightBlue[400], Colors.lightBlue[300]],
                    (BarChartData data, _)=>data.expenseTotalYValue, (BarChartData data, _)=>data.foodProvisionExpenseYValue, Colors.pink, Colors.lightBlue),
          ],
        ),
      ],
    );
  }
  SfCircularChart _searchScreenRadialChartToSalesAndExpense(List<CircularChartData> radialChartData, yData, double maximumValue) {
    return SfCircularChart(
      margin: EdgeInsets.only(bottom: -15),
      tooltipBehavior: TooltipBehavior(
        format: 'point.x : point.y  \\',
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
          radius: '90%',
          cornerStyle: CornerStyle.bothCurve,
          dataSource: radialChartData,
          xValueMapper: (CircularChartData data, _)=>data.title,
          yValueMapper: yData,
          dataLabelMapper: (CircularChartData data, _)=>data.title,
          pointColorMapper: (CircularChartData data, _)=>data.color,
          enableTooltip: true,
          enableSmartLabels: true,
          dataLabelSettings: DataLabelSettings(
            isVisible: true, textStyle: TextStyle(color: Colors.black54, fontSize: 10, fontFamily: 'Yanolja'),),
          maximumValue: maximumValue,
        ),
      ],
    );
  }

  Column _searchScreenBarChartToSalesAndExpense(List<BarChartData> chartData, String firstTitle, String secondTitle, List<Color> firstColor, List<Color> secondColor
      , firstData, secondData, Color firstBadgeColor, Color secondBadgeColor) {
    return Column(
      children: [
        Container(
          width: size.width*0.7, height: size.height*0.25,
          child: SfCartesianChart(
            enableSideBySideSeriesPlacement: false,
            plotAreaBorderWidth: 0,
            margin: EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
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
                dataSource: chartData,
                width: 0.8,
                xValueMapper: (BarChartData data, _)=>data.selectedDateXValue.toString().substring(5,10),
                yValueMapper: firstData,
                isVisible: true,
                trackColor: Colors.black12,
                borderRadius: BorderRadius.only(topRight: Radius.circular(5), topLeft: Radius.circular(5)),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: firstColor,
                ),
                name: firstTitle,
              ),
              ColumnSeries<BarChartData, dynamic>(
                dataSource: chartData,
                width: 0.5,
                xValueMapper: (BarChartData data, _)=>data.selectedDateXValue.toString().substring(5,10),
                yValueMapper: secondData,
                isVisible: true,
                trackColor: Colors.black12,
                borderRadius: BorderRadius.only(topRight: Radius.circular(5), topLeft: Radius.circular(5)),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: secondColor,
                ),
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
