import 'dart:ui';

class BarChartData {
  final String? selectedDateXValue;
  final int? totalSalesYValue;
  final int? actualSalesYValue;
  final int? discountSalesYValue;
  final int? deliverySalesYValue;
  final int? vatSalesYValue;
  final int? expenseTotalYValue;
  final int? foodProvisionExpenseYValue;
  final int? alcoholBeverageExpenseYValue;
  final int? addTotalAmountExpenseYValue;

  BarChartData.fromMap(Map<dynamic, dynamic> dataMap)
      : selectedDateXValue = dataMap['selectedDate'],

        totalSalesYValue = dataMap['totalSales'],
        actualSalesYValue = dataMap['actualSales'],
        discountSalesYValue = dataMap['discount'],
        deliverySalesYValue = dataMap['delivery'],
        vatSalesYValue = dataMap['vat'],

        expenseTotalYValue = dataMap['foodProvisionExpense'] + dataMap['alcoholExpense'] + dataMap['beverageExpense'] + dataMap['expenseAddTotalAmount'],
        foodProvisionExpenseYValue = dataMap['foodProvisionExpense'],
        alcoholBeverageExpenseYValue = dataMap['alcoholExpense'] + dataMap['beverageExpense'],
        addTotalAmountExpenseYValue = dataMap['expenseAddTotalAmount'];
}

class CircularChartData{
  final String? title;
  final String? labelTitle;
  final int? radialSales;
  final int? radialExpense;
  final int? radialMainShow;
  final int? pieSales;
  final double? doughnutMain;
  final double? doughnutExpense;
  final Color? color;

  CircularChartData({this.title, this.color,this.radialExpense, this.radialSales, this.radialMainShow, this.pieSales,
    this.doughnutMain, this.doughnutExpense, this.labelTitle});
}