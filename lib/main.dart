import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/models/firebase_auth_state.dart';
import 'package:sharesales_ver2/screen/auth_screen.dart';
import 'package:sharesales_ver2/widget/my_progress_indicator.dart';
import 'constant/color.dart';
import 'main_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  FirebaseAuthState _firebaseAuthState = FirebaseAuthState();
  Widget _currentWidget;

  @override
  Widget build(BuildContext context) {
    _firebaseAuthState.watchAuthChange();
    return ChangeNotifierProvider<FirebaseAuthState>.value(
      value: _firebaseAuthState,
      child: MaterialApp(
        title: 'share sales',
        theme: ThemeData(
          canvasColor: blackColor,
          primarySwatch: blackColor,
        ),
        home: Consumer(
            builder: (BuildContext context, FirebaseAuthState firebaseAuthState, Widget child) {
              switch(firebaseAuthState.firebaseAuthStatus){
                case FirebaseAuthStatus.logout:
                  _currentWidget = AuthScreen();
                  break;
                  case FirebaseAuthStatus.login:
                  _currentWidget = MainHomePage();
                  break;
                default:
                  _currentWidget = MyProgressIndicator();
              }
              return AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
              child: _currentWidget,
              );
            },
        ),
        // home: AuthScreen(),
      ),
    );
  }
}
