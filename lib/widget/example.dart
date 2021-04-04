import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 100,),
          SfCartesianChart(
            primaryYAxis: NumericAxis(),
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries>[
              ColumnSeries<SalesData, String>(
                dataSource: getColumnData(),
                xValueMapper: (SalesData sales,_)=>sales.x,
                yValueMapper: (SalesData sales,_)=>sales.y,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SalesData{
  String x;
  double y;
  SalesData(this.x, this.y);
}

dynamic getColumnData(){
  List<SalesData> columnData = <SalesData>[
    SalesData('test1', 10),
    SalesData('test2', 12),
    SalesData('test3', 14),
    SalesData('test4', 15),
    SalesData('test5', 12),
  ];
  return columnData;
}

