import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/app_bar.dart';
import 'package:sharesales_ver2/constant/color.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context, secondMainColor, 'share sales', Colors.orange.shade50, Icon(Icons.account_circle, color: Colors.orange.shade50,)),
      backgroundColor: Colors.orange.shade50,
    );
  }
}
