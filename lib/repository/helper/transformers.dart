import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharesales_ver2/models/firestore/sales_model.dart';
import 'package:sharesales_ver2/models/firestore/user_model.dart';

class Transformers {
  final toUser = StreamTransformer<DocumentSnapshot, UserModel>.fromHandlers(
      handleData: (snapshot, sink) async {
     sink.add(UserModel.fromSnapshot(snapshot));
  });

  // final toSales =
  //     StreamTransformer<QuerySnapshot, List<SalesModel>>.fromHandlers(
  //         handleData: (snapshot, sink) async {
  //   List<SalesModel> sales = [];
  //
  //   snapshot.docs.forEach((documentSnapshot) {
  //     sales.add(SalesModel.fromSnapshot(documentSnapshot));
  //   });
  //   sink.add(sales);
  // });
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
