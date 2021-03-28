import 'package:flutter/material.dart';


class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {

  TextEditingController test1Controller = TextEditingController();
  TextEditingController test2Controller = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(color: Colors.blue,),
    );
  }

}
