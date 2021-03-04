import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/constant/snack_bar_style.dart';

DateTime pickerDate = DateTime.now();
String format = DateFormat('EEE, MMM dd, ' ' yyyy').format(pickerDate);

class DatePickerCupertino extends StatefulWidget {
  @override
  _DatePickerCupertinoState createState() => _DatePickerCupertinoState();
}

class _DatePickerCupertinoState extends State<DatePickerCupertino> {

  @override
  Widget build(BuildContext context) {
    String formatDate = DateFormat('EEE, MMM dd, ' ' yyyy').format(pickerDate);

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
                    print(selectedDate);
                  });
                },
                currentTime: pickerDate,
                locale: LocaleType.en,
              );
            },
        ),
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
DatePickerCupertino get datePickerCupertino =>DatePickerCupertino();