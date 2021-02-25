import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';

class DatePickerForm extends StatefulWidget {
  @override
  _DatePickerFormState createState() => _DatePickerFormState();
}

class _DatePickerFormState extends State<DatePickerForm> {
  DateTime selectedDateTime;

  @override
  void initState() {
    selectedDateTime=DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var showDateTime = DateFormat('EEE, d MMM yy').format(selectedDateTime);
    // final showDateTime = formatDate(selectedDateTime, [yyyy, '-', mm, '-', dd]);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Text(
            '',
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
        InkWell(
            onTap: () async {
              DateTime selectedDate = await showRoundedDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(
                  Duration(days: 0),
                ),
                firstDate: DateTime(DateTime.now().year - 1),
                lastDate: DateTime(DateTime.now().year + 1),
                listDateDisabled: [DateTime.now()],
                theme: ThemeData.dark(),
                height: 320,
                borderRadius: 15,
              );
              // if(selectedDateTime != null)
                setState(() {
                  print('not');
                  return selectedDateTime = selectedDate;
              }
              );
              print(selectedDate);
              print(selectedDateTime);
            },
            child: Text(
              'Select Date',
              style: TextStyle(color: Colors.green),
            ))
      ],
    );
  }
}
