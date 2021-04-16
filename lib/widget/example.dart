import 'package:flutter/material.dart';

class Example extends StatefulWidget {

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text('테스트1'),
        ),
        SliverAppBar(
          title: Text('테스트1'),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index){
                return Container();
              }
          ),

        ),
      ],
    );
  }
}
