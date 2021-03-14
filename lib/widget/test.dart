import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/models/firestore/user_model.dart';
import 'package:sharesales_ver2/models/user_model_state.dart';

import 'my_progress_indicator.dart';

class test extends StatefulWidget {
  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {

    UserModel userModel =
        Provider.of<UserModelState>(context, listen: false).userModel;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(COLLECTION_SALES)
          .doc(userModel.userKey)
          .collection(userModel.userName)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return MyProgressIndicator();
        }
        return SafeArea(
        );
      }
    );
  }
}
