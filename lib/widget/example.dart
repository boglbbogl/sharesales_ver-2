import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/size.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text('widget'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ExpandablePageView(
                children: [
                  ExpansionCard(
                    background: ColoredBox(
                      color: Colors.green,
                    ),
                      title: Container(
                                   height: 100,
                                  child: Column(
                                    children: <Widget>[
                                      Text('sdfklsjdfl'),
                                      Text('sdfklsjdfl'),
                                      Text('sdfklsjdfl'),
                                    ],
                                  ),),
                  children: [
                    Text('sdfklsjdfl'),
                    Text('sdfklsjdfl'),
                    Text('sdfklsjdfl'),
                  ],),
                  ExamplePage(Colors.blue, "1", 100),
                  ExamplePage(Colors.green, "2", 200),
                  ExamplePage(Colors.red, "3", 300),
                  Container(height: 400,),
                ],
              ),
              Container(height: 20,color: Colors.green,),
              // ExpandablePageView(
              //   animateFirstPage: true,
              //   estimatedPageSize: 100,
              //   itemCount: 3,
              //   itemBuilder: (context, index) {
              //     return ExamplePage(
              //       Colors.blue,
              //       index.toString(),
              //       (index + 1) * 100.0,
              //     );
              //   },
              // ),
              const SizedBox(height: 50),
              Text("UNDER PAGE VIEW WIDGET",style: TextStyle(color: Colors.white),),
            ],
          ),
        ));
  }
}
class ExamplePage extends StatelessWidget {
  final Color color;
  final String text;
  final double height;

  const ExamplePage(this.color, this.text, this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: 200,
      color: color,
      child: Column(
        children: [
          Center(
            child: Text(text),
          ),
          Center(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}