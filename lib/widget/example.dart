import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/size.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {

  PageController pageController = PageController(viewportFraction: 0.8, initialPage: 0);

  bool test;

  @override
  void initState() {
    test=true;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('TEST'),
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 2000),
            child: test ? firstTest():secondTest(),
          ),
          Padding(
            padding: const EdgeInsets.all(100),
            child: SizedBox(
              height: size.height*0.2,
              width: size.width*0.5,
              child: RaisedButton(onPressed: (){
                print('click');
                setState(() {
                  test = !test;
                });
              }),
            ),
          ),
        ],
      ),
    );
  }

  ExpandablePageView secondTest() {
    return ExpandablePageView(
      controller: pageController,
      children: <Widget>[
        Container(height: size.width*0.5, width: size.width*0.5, color: Colors.green,),
        Container(height: size.width*0.5, width: size.width*0.5, color: Colors.cyan,),
      ],
    );
  }

  ExpandablePageView firstTest() {
    return ExpandablePageView(
      controller: pageController,
      children: <Widget>[
        Container(height: size.width*0.5, width: size.width*0.5, color: Colors.amber,),
        Container(height: size.width*0.5, width: size.width*0.5, color: Colors.red,),
      ],
    );
  }
}
