import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {

  PageController test1Controller = PageController(viewportFraction: 0.8);
  PageController test2Controller = PageController(viewportFraction: 0.5);

  @override
  Widget build(BuildContext context) {

    return Center(
        child: Container(
          height: size.height*0.8, width: size.width*0.8,color: Colors.blue,
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: (){
            showMaterialModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                closeProgressThreshold: 5.0,
                enableDrag: true,
                animationCurve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: 300),
                barrierColor: Colors.black87,
                backgroundColor: Colors.deepOrangeAccent,
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
                              minDate: DateTime(2000,01,01),
                              maxDate: DateTime(2100,01,01),
                              monthCellStyle: DateRangePickerMonthCellStyle(
                                textStyle: TextStyle(color: Colors.white),
                                weekendDatesDecoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                specialDatesDecoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                todayTextStyle: TextStyle(color: Colors.white),
                              ),
                              startRangeSelectionColor: Colors.orange,
                              endRangeSelectionColor: Colors.orange,
                              rangeSelectionColor: Colors.orange,
                              selectionTextStyle: TextStyle(color: Colors.white),
                              todayHighlightColor: Colors.orange,
                              selectionColor: Colors.orange,
                              backgroundColor: Colors.deepOrangeAccent,
                              // controller: _dayRangePickerController,
                              allowViewNavigation: false,
                              view: DateRangePickerView.year,
                              selectionMode: DateRangePickerSelectionMode.range,
                              headerStyle: DateRangePickerHeaderStyle(
                                  textStyle: TextStyle(
                                      fontWeight:FontWeight.bold,color: Colors.white,fontSize: 18,fontStyle: FontStyle.italic)),
                              monthViewSettings: DateRangePickerMonthViewSettings(
                                enableSwipeSelection: false,
                              ),
                              onSelectionChanged: (DateRangePickerSelectionChangedArgs  args){
                                // setState((){
                                //   if (args.value is PickerDateRange) {
                                //     rangePickerStartDate = DateFormat.yMEd('ko_KO').format(args.value.startDate).toString();
                                //     // rangePickerStartDate = DateFormat('yyyy MM dd').format(args.value.startDate).toString();
                                //     rangePickerEndDate = DateFormat.yMEd('ko_KO').
                                //     format(args.value.endDate ?? args.value.startDate).toString();
                                //     // rangePickerEndDate = DateFormat('yyyy MM dd')
                                //     //     .format(args.value.endDate ?? args.value.startDate)
                                //     //     .toString();
                                //
                                //     rangePickerStartDateTime = args.value.startDate;
                                //     rangePickerEndDateTime = args.value.endDate;
                                //   } else {
                                //     return MyProgressIndicator();
                                //   }
                                // });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
            );
          },
        ),
        ));
  }

}
