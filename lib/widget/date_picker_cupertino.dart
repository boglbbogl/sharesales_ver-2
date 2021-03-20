import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/constant/snack_bar_style.dart';
import 'package:sharesales_ver2/models/firestore/user_model.dart';
import 'package:sharesales_ver2/models/user_model_state.dart';
import 'package:sharesales_ver2/widget/my_progress_indicator.dart';

DateTime pickerDate = DateTime.now().toUtc();
String format = DateFormat('EEE, MMM dd, ' ' yyyy').format(pickerDate);

class DatePickerCupertino extends StatefulWidget {
  @override
  _DatePickerCupertinoState createState() => _DatePickerCupertinoState();
}

class _DatePickerCupertinoState extends State<DatePickerCupertino> {
  @override
  Widget build(BuildContext context) {
    String formatDate = DateFormat('EEE, MMM dd, ' ' yyyy').format(pickerDate);

    UserModel userModel =
        Provider.of<UserModelState>(context, listen: false).userModel;

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
            DatePicker.showDatePicker(
              context,
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
                FirebaseFirestore.instance.collection(COLLECTION_SALES_MANAGEMENT).doc(userModel.userKey).collection(userModel.userName)
                    .get().then((snap) {
                  snap.docs.forEach((element) {
                    String selectedDateInDb = element.data()['selectedDate'];
                    String changePickerDate = selectedDate.toUtc().toString().substring(0, 10);


                    if (selectedDate != null || pickerDate != null) {
                      pickerDate = selectedDate;
                    } else {
                      return MyProgressIndicator();
                    }
                    setState(() {
                      if (selectedDateInDb == changePickerDate) {
                        return snackBarDatePickerMiddleFlushBarRedForm(context,  '$changePickerDate' + ' 날짜를 변경하세요', '이미 저장된 날짜입니다');
                      }
                    });
                  });
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

DatePickerCupertino get datePickerCupertino => DatePickerCupertino();
