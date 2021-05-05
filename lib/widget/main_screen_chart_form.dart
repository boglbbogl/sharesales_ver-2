import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sharesales_ver2/firebase_firestore/chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sizer/sizer.dart';

class MainScreenChartForm extends StatelessWidget {
  const MainScreenChartForm({
    Key? key,
    required this.lineChartData,
    required this.now,
    required this.nowColors,
    required this.lastColors,
    required this.nowYValue,
    required this.lastYValue,
  }) : super(key: key);

  final List<LineChartData> lineChartData;
  final DateTime now;
  final Color nowColors;
  final Color lastColors;
  final nowYValue;
  final lastYValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w, height: 30.h,
      child: SfCartesianChart(
        enableSideBySideSeriesPlacement: false,
        plotAreaBorderWidth: 0,
        margin: EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 10),
        primaryXAxis: CategoryAxis(
          visibleMaximum: 12,
          visibleMinimum: 0,
          minimum: 1,
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
        series: <ChartSeries<LineChartData, dynamic>>[
          LineSeries<LineChartData, dynamic>(
            dataSource: lineChartData,
            width: 2,
            xValueMapper: (LineChartData data, _)=>data.month,
            yValueMapper: nowYValue,
            // yValueMapper: (LineChartData data, _)=>data.nowActualSales,
            dataLabelMapper: (LineChartData data, _)=>data.title,
            isVisible: true,
            color: nowColors,
            name: DateTime(now.year).toString().substring(0,4),
          ),
          LineSeries<LineChartData, dynamic>(
            dataSource: lineChartData,
            width: 2,
            xValueMapper: (LineChartData data, _)=>data.month,
            yValueMapper: lastYValue,
            dataLabelMapper: (LineChartData data, _)=>data.title,
            isVisible: true,
            color: lastColors,
            name: DateTime(now.year-1).toString().substring(0,4),
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
    );
  }
}
