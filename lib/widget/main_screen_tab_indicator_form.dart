import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MainScreenTabIndicatorForm extends StatefulWidget {

  final List<String> values;
  final ValueChanged onToggleCallback;

  MainScreenTabIndicatorForm({
    required this.values,
    required this.onToggleCallback,
  });

  @override
  _MainScreenTabIndicatorFormState createState() => _MainScreenTabIndicatorFormState();
}

class _MainScreenTabIndicatorFormState extends State<MainScreenTabIndicatorForm> {

  bool _initialPosition = true;

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 60.w,
      height: 4.5.h,
      margin: EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _initialPosition = !_initialPosition;
              var index = 0;
              if (!_initialPosition) {
                index = 1;
              }
              widget.onToggleCallback(index);
            },
            child: Container(
              width: 60.w,
              height: 4.5.h,
              decoration: ShapeDecoration(
                color: Colors.white70,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  widget.values.length,
                      (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      widget.values[index],
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
            alignment:
            _initialPosition ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: 35.w,
              //height: 5.w,
              decoration: ShapeDecoration(
                color: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                _initialPosition ? widget.values[0] : widget.values[1],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
