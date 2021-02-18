import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/models/firebase_auth_state.dart';
import 'package:sharesales_ver2/screen/auth_screen.dart';

class AdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'share sales',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: appbarFontsize,
            foreground: Paint()..shader = mainColor,
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                  Icons.exit_to_app,),
              onPressed: (){
                Provider.of<FirebaseAuthState>(context, listen: false).signOut();
              })
        ],
      ),
    );
  }
}
