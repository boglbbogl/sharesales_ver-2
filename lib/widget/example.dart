import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    RaisedButton(
                        onPressed: (){
                          setState(() {
                            showFloatingFlushbar(context);
                          });
                        }),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void showFloatingFlushbar(BuildContext context) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(20),
      borderRadius: 15,
      backgroundGradient: LinearGradient(
        colors: [Colors.green.shade800, Colors.greenAccent.shade700],
        stops: [0.6, 1],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      // All of the previous Flushbars could be dismissed by swiping down
      // now we want to swipe to the sides
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      // The default curve is Curves.easeOut
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: 'This is a floating Flushbar',
      message: 'Lorem ipsum dolor sit amet',
    )..show(context);
  }
}

class MySnackBarTopFlushBar extends StatelessWidget {
  const MySnackBarTopFlushBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      padding: EdgeInsets.all(10),
      borderRadius: 8,
      backgroundGradient: LinearGradient(
        colors: [Colors.green.shade800, Colors.greenAccent.shade700],
        stops: [0.6, 1],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      // All of the previous Flushbars could be dismissed by swiping down
      // now we want to swipe to the sides
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      // The default curve is Curves.easeOut
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: 'This is a floating Flushbar',
      message: 'Lorem ipsum dolor sit amet',
    )..show(context);
  }
}
