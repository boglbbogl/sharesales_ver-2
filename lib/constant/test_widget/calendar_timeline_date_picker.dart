import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';

class CalendarTimelineDatePicker extends StatefulWidget {
  @override
  _CalendarTimelineDatePickerState createState() => _CalendarTimelineDatePickerState();
}

class _CalendarTimelineDatePickerState extends State<CalendarTimelineDatePicker> {

  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now().add(Duration(days: 5));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Calendar Timeline',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.tealAccent[100]),
            ),
          ),
          CalendarTimeline(
            // showYears: true,
            initialDate: _selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now(),
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
            leftMargin: 20,
            monthColor: Colors.white70,
            dayColor: Colors.teal[200],
            dayNameColor: Color(0xFF333A47),
            activeDayColor: Colors.white,
            activeBackgroundDayColor: Colors.redAccent[100],
            dotsColor: Color(0xFF333A47),
            selectableDayPredicate: (date) => date.day != 23,
            locale: 'en',
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: FlatButton(
              color: Colors.teal[200],
              child: Text('RESET', style: TextStyle(color: Color(0xFF333A47))),
              onPressed: () => setState(() => _resetSelectedDate()),
            ),
          ),
          SizedBox(height: 20),
          Center(child: Text('Selected date is $_selectedDate', style: TextStyle(color: Colors.white)))
        ],
      ),
    );
  }
}