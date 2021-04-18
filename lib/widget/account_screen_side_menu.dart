import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/firebase_auth/firebase_auth_state.dart';

class AccountScreenSideMenu extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.settings,
                color: Colors.black,),
              title: Text('Setting'),
            ),
            GestureDetector(
              onTap: (){
                Provider.of<FirebaseAuthState>(context, listen: false)
                    .signOut();
              },
              child: ListTile(
                leading: Icon(Icons.exit_to_app,
                color: Colors.black,),
                title: Text('Log out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
