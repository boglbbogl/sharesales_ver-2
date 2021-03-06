// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:folding_cell/folding_cell/widget.dart';
// import 'package:provider/provider.dart';
// import 'package:sharesales_ver2/constant/firestore_keys.dart';
// import 'package:sharesales_ver2/models/firestore/sales_model.dart';
// import 'package:sharesales_ver2/repository/sales_network_repository.dart';
// import 'package:sharesales_ver2/widget/my_progress_indicator.dart';
//
// class ManagementListForm extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       child: ListView.builder(
//         scrollDirection: Axis.vertical,
//         itemCount: 20,
//         shrinkWrap: true,
//         itemBuilder: (context, index) {
//           return SimpleFoldingCell.create(
//             frontWidget: _buildFrontWidget(index),
//             innerWidget: _buildInnerWidget(index),
//             cellSize: Size(MediaQuery.of(context).size.width, 100),
//             padding: EdgeInsets.all(12),
//             animationDuration: Duration(milliseconds: 300),
//             borderRadius: 20,
//             onOpen: () => print('cell opened'),
//             onClose: () => print('cell closed'),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildFrontWidget(int index) {
//     return Builder(
//       builder: (BuildContext context) {
//         return Container(
//           color: Colors.redAccent,
//           alignment: Alignment.center,
//           child: Stack(
//             children: <Widget>[
//               Align(
//                 alignment: Alignment.center,
//                 child: Text(
//                   'salesData',
//                   // salesModel.totalSales,
//                 ),
//               ),
//               Positioned(
//                 right: 5,
//                 bottom: 0,
//                 child: InkWell(
//                   onTap: () {
//                     final _foldingCellState = context
//                         .findRootAncestorStateOfType<SimpleFoldingCellState>();
//                     _foldingCellState?.toggleFold();
//                   },
//                   child: Text(
//                     "Detail",
//                   ),
//                   splashColor: Colors.white.withOpacity(0.5),
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildInnerWidget(int index) {
//     return Builder(
//       builder: (context) {
//         return Container(
//           color: Color(0xFFecf2f9),
//           padding: EdgeInsets.only(top: 10),
//           child: Stack(
//             children: [
//               Align(
//                 alignment: Alignment.topCenter,
//                 child: Text(
//                   "CARD TITLE",
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.center,
//                 child: Text(
//                   "CARD DETAIL",
//                 ),
//               ),
//               Positioned(
//                 right: 5,
//                 bottom: 0,
//                 child: FlatButton(
//                   onPressed: () {
//                     final _foldingCellState = context
//                         .findRootAncestorStateOfType<SimpleFoldingCellState>();
//                     _foldingCellState?.toggleFold();
//                   },
//                   child: Text(
//                     "Close",
//                   ),
//                   textColor: Colors.white,
//                   color: Colors.indigoAccent,
//                   splashColor: Colors.white.withOpacity(0.5),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
