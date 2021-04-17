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
  final int totalSales;
  final int totalExpense;
  final double doughnutMainTotalExpense;
  final _pageBarChartViewController;
  final _pageRadialChartViewController;
  final _pageDoughnutChartViewController;
  final bool circularChartSwitcher;

  const SearchScreenChartForm(this.duration, this.barChartData,this.circularChartData, this.totalSales, this.totalExpense, this.doughnutMainTotalExpense,
      this._pageBarChartViewController, this._pageRadialChartViewController, this._pageDoughnutChartViewController, this.circularChartSwitcher, {Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {



    return Column(
      children: [
        AnimatedSwitcher(
            duration: duration,
        child: circularChartSwitcher ? _searchScreenToggleRadialChart():_searchScreenToggleDoughnutChart()),
        _searchScreenToggleBarChart(),
      ],
    );
  }

  ExpandablePageView _searchScreenToggleDoughnutChart() {
    return ExpandablePageView(
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
          SfCircularChart(
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
        ],
      );
  }

  ExpandablePageView _searchScreenToggleBarChart() {
    return ExpandablePageView(
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
      );
  }

  ExpandablePageView _searchScreenToggleRadialChart() {
    return ExpandablePageView(
      controller: _pageRadialChartViewController,
      children: [
        _searchScreenRadialChartToSalesAndExpense(circularChartData, (CircularChartData data, _)=>data.radialMainShow,
        totalSales.toDouble()*1.1+.0),
        _searchScreenRadialChartToSalesAndExpense(circularChartData, (CircularChartData data, _)=>data.radialSales,
        totalSales.toDouble()*1.1+.0),
        _searchScreenRadialChartToSalesAndExpense(circularChartData, (CircularChartData data, _)=>data.radialExpense,
            totalExpense.toDouble()*1.1+.0),
      ],
    );
  }

  SfCircularChart _searchScreenRadialChartToSalesAndExpense(List<CircularChartData> radialChartData, yData, double maximumValue) {
    return SfCircularChart(
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
          radius: '90%',
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
