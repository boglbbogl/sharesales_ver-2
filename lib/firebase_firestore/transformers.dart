import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';

import 'management_model.dart';

class Transformers {
  final toUser = StreamTransformer<DocumentSnapshot, UserModel>.fromHandlers(
      handleData: (snapshot, sink) async {
     sink.add(UserModel.fromSnapshot(snapshot));
  });

  final toSales =
      StreamTransformer<DocumentSnapshot, ManagementModel>.fromHandlers(
          handleData: (snapshot, sink) async {
            sink.add(ManagementModel.fromSnapshot(snapshot));
  });
  //
  // final combineListOfPosts =
  // StreamTransformer<List<List<SalesModel>>, List<SalesModel>>.fromHandlers(
  //     handleData: (listOfSales, sink) async {
  //       List<SalesModel> sales = [];
  //
  //       for (final salesList in listOfSales) {
  //         sales.addAll(salesList);
  //       }
  //
  //       sink.add(sales);
  //     });
  //
  //
  // final latestToTop =
  // StreamTransformer<List<SalesModel>, List<SalesModel>>.fromHandlers(
  //     handleData: (sales, sink) async {
  //       sales.sort((a,b)=>b.selectedDate.compareTo(a.selectedDate));
  //       sink.add(sales);
  //     });
}
