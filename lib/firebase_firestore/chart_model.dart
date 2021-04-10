import 'dart:ui';

class BarChartData {
  final String selectedDateXValue;
  final int totalSalesYValue;
  final int actualSalesYValue;
  final int expenseTotalYValue;
  final int foodProvisionExpenseYValue;

  BarChartData.fromMap(Map<dynamic, dynamic> dataMap)
      : selectedDateXValue = dataMap['selectedDate'],
        totalSalesYValue = dataMap['totalSales'],
        actualSalesYValue = dataMap['actualSales'],
        expenseTotalYValue = dataMap['foodProvisionExpense'] + dataMap['alcoholExpense'] + dataMap['beverageExpense'] + dataMap['expenseAddTotalAmount'],
        foodProvisionExpenseYValue = dataMap['foodProvisionExpense'];
}

class CircularChartData{
  final String title;
  final int radialSales;
  final int radialExpense;
  final int radialMainShow;
  final int pieSales;
  final double pieMain;
  final Color color;

  CircularChartData(this.title, this.color,{this.radialExpense, this.radialSales, this.radialMainShow, this.pieSales, this.pieMain});
}