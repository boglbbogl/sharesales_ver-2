import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/constant/snack_bar_style.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
import 'package:sharesales_ver2/widget/my_progress_indicator.dart';

DateTime pickerDate = DateTime.now().toUtc();
String format = DateFormat('EEE, MMM dd, ' ' yyyy').format(pickerDate);

class DatePickerCreateForm extends StatefulWidget {
  @override
  _DatePickerCreateFormState createState() => _DatePickerCreateFormState();
}

class _DatePickerCreateFormState extends State<DatePickerCreateForm> {
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
                  color: Colors.deepOrangeAccent,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          onTap: () {
            DatePicker.showDatePicker(
              context,
              theme: DatePickerTheme(
                itemStyle: TextStyle(color: Colors.white),
                backgroundColor: Colors.deepOrangeAccent,
                headerColor: Colors.deepOrangeAccent,
                doneStyle: TextStyle(color: Colors.white),
                cancelStyle: TextStyle(color: Colors.white),
                containerHeight: size.height * 0.3,
              ),
              showTitleActions: true,
              minTime: DateTime(2000, 1, 1),
              maxTime: DateTime(2100, 12, 31),
              onChanged: (selectedDate) {
                setState(() {
                  if (selectedDate != null || pickerDate != null) {
                    pickerDate = selectedDate;
                  } else {
                    return MyProgressIndicator();
                  }
                });
                FirebaseFirestore.instance.collection(COLLECTION_SALES_MANAGEMENT).doc(userModel.userKey).collection(userModel.userName)
                    .get().then((snap) {
                  snap.docs.forEach((element) {
                    if(!element.exists) {
                      pickerDate = selectedDate;
                    }
                      String selectedDateInDb = element.data()['selectedDate'];
                      String changePickerDate = selectedDate.toUtc()
                          .toString()
                          .substring(0, 10);
                    setState(() {
                      if (selectedDateInDb == changePickerDate) {
                        return snackBarDatePickerMiddleFlushBarRedForm(context,  '$changePickerDate' + ' 날짜를 변경하세요', '이미 저장된 날짜입니다');
                      }
                    });
                  });
                });
              },
              currentTime: pickerDate.toUtc(),
              locale: LocaleType.ko,
            );
          },
        ),
      ],
    );
  }
}
