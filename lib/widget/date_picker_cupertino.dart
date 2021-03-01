import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/constant/snack_bar_style.dart';

class DatePickerCupertino extends StatefulWidget {
  @override
  _DatePickerCupertinoState createState() => _DatePickerCupertinoState();
}

class _DatePickerCupertinoState extends State<DatePickerCupertino> {
  // DateTime _selectedDate = DateTime.now();
  //
  // TextEditingController _textEditingController = TextEditingController();
  //
  // _selectDate() async {
  //   DateTime pickedDate = await showModalBottomSheet<DateTime>(
  //     backgroundColor: Colors.black,
  //     context: context,
  //     builder: (context) {
  //       DateTime tempPickedDate;
  //       return Container(
  //         height: size.height*0.3,
  //         child: Column(
  //           children: <Widget>[
  //             Container(
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: <Widget>[
  //                   CupertinoButton(
  //                     child: Text('취소'),
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                   ),
  //                   CupertinoButton(
  //                     child: Text('확인'),
  //                     onPressed: () {
  //                       Navigator.of(context).pop(tempPickedDate);
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Divider(
  //               height: 0,
  //               thickness: 1,
  //             ),
  //             Expanded(
  //               child: Container(
  //                 child: CupertinoDatePicker(
  //                   mode: CupertinoDatePickerMode.date,
  //                   onDateTimeChanged: (DateTime dateTime) {
  //                     tempPickedDate = dateTime;
  //                   },
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  //   if (pickedDate != null && pickedDate != _selectedDate) {
  //     setState(() {
  //       _selectedDate = pickedDate;
  //       _textEditingController.text = pickedDate.toString();
  //     });
  //   }
  // }

  DateTime pickerDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var formatDate = DateFormat('EEE, MMM dd, ' ' yyyy').format(pickerDate);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
            child: SizedBox(
              width: size.width * 0.9,
              height: size.height * 0.05,
              child: Center(
                child: Text(
                  '$formatDate',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            onTap: () {
              DatePicker.showDatePicker(context,
                theme: DatePickerTheme(
                  itemStyle: TextStyle(color: Colors.white),
                  backgroundColor: Colors.black,
                  headerColor: Colors.black,
                  doneStyle: TextStyle(color: Colors.redAccent),
                  cancelStyle: TextStyle(color: Colors.redAccent),
                  containerHeight: size.height * 0.3,
                ),
                showTitleActions: true,
                minTime: DateTime(2000, 1, 1),
                maxTime: DateTime(2100, 12, 31),
                onChanged: (selectedDate) {
                  setState(() {
                    if (selectedDate != null || pickerDate != null) {
                      pickerDate = selectedDate;
                    } else
                      return Scaffold.of(context).showSnackBar(pickerSnackBar);
                  });
                },
                // if(selectedDate != null || pickerDate != null){
                //   setState(() {
                //     pickerDate = selectedDate;
                //   }); } else
                //     return Scaffold.of(context).showSnackBar(pickerSnackBar);
                // },
                currentTime: pickerDate,
                locale: LocaleType.ko,
              );
            },
        ),
        // Container(
        //   child: InkWell(
        //       onTap: () {
        //         CupertinoRoundedDatePicker.show(context,
        //             textColor: Colors.white,
        //             background: Colors.pinkAccent,
        //             borderRadius: 20,
        //             initialDate: pickerDate,
        //             era: EraMode.CHRIST_YEAR,
        //             initialDatePickerMode: CupertinoDatePickerMode.date,
        //             onDateTimeChanged: (selectedDate) {
        //           setState(() {
        //             pickerDate = selectedDate;
        //             print('$selectedDate');
        //           });
        //         });
        //       },
        //       child: Text(
        //         '칼라',
        //         style: TextStyle(color: Colors.amberAccent),
        //       )),
        // ),
      ],
    );
  }
  SnackBar pickerSnackBar = SnackBar(
    duration: Duration(seconds: 1),
    content: Text(
      '날짜를 선택 해주세요',
      style: snackBarStyle(),
    ),
    backgroundColor: Colors.lightBlueAccent,
  );
}
