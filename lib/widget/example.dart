import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/size.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {

  PageController pageController = PageController(viewportFraction: 0.8, initialPage: 0);

  bool test = true;
  bool test2 = true;

  var now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TEST'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(DateTime.now().toString().substring(0,7)),
            Text(DateTime(now.year, now.month-4).toString().substring(0,7)),
            InkWell(
              onTap: (){
                setState(() {
                  test = !test;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                ),
                height: size.height*0.05,
                width: size.width*0.2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width*0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: test ? Colors.lightBlueAccent : Colors.grey[300],
                      ),
                    ),
                    Container(
                      width: size.width*0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: test ? Colors.grey[300] : Colors.lightBlueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                setState(() {
                  test2 = !test2;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                ),
                height: size.height*0.05,
                width: size.width*0.2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width*0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: test2 ? Colors.lightBlueAccent : Colors.grey[300],
                      ),
                    ),
                    Container(
                      width: size.width*0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: test2 ? Colors.grey[300] : Colors.lightBlueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
