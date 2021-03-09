import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(COLLECTION_SALES).doc().collection('subSales').snapshots(),
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.check), onPressed: () {
                List sn = snapshot.data.docs.toList();
                print(sn);
            },
            ),
            title: Text('Firestore Test', style: TextStyle(color: Colors.indigoAccent),),
          ),
        );
      }
    );
  }
}
