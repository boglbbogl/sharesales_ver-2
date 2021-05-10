import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/screen/auth__main_screen.dart';
import 'package:sharesales_ver2/widget/my_progress_indicator.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'dart:ui';

import 'firebase_auth/firebase_auth_state.dart';
import 'firebase_auth/user_model_state.dart';
import 'firebase_firestore/firestore_user_repository.dart';
import 'main_home_page.dart';
import 'package:sizer/sizer.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAuthState _firebaseAuthState = FirebaseAuthState();
  Widget? _currentWidget;

  @override
  Widget build(BuildContext context) {
    // ThemeData inheritTheme = Theme.of(context, shadowThemeOnly:true);

    _firebaseAuthState.watchAuthChange();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseAuthState>.value(
            value: _firebaseAuthState),
        ChangeNotifierProvider<UserModelState>(
          create: (_) => UserModelState(),
        ),
      ],
      child: Sizer(
        builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
        return MaterialApp(
          // debugShowCheckedModeBanner: ,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            SfGlobalLocalizations.delegate
          ],
          supportedLocales: [
            const Locale('en', 'US'),
            const Locale('ko', 'KO'),
          ],
          locale: const Locale('ko', 'KO'),
          title: 'share sales',
          theme: ThemeData(
            fontFamily: 'Yanolja',
            // canvasColor: blackColor,
            primarySwatch: Colors.red,
          ),
          home: Consumer(
            builder: (BuildContext context, FirebaseAuthState firebaseAuthState,
                Widget? child) {
              switch (firebaseAuthState.firebaseAuthStatus) {
                case FirebaseAuthStatus.logout:
                  _clearUserModel(context);
                  _currentWidget = SignMainScreen();
                  break;
                case FirebaseAuthStatus.login:
                  _initUserModel(firebaseAuthState, context);
                  _currentWidget = MainHomePage();
                  break;
                default:
                  _currentWidget = MyProgressIndicator();
              }
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 2000),
                child: _currentWidget,
              );
            },
          ),
          // home: MyProgressIndicator(),
        );
        },
      ),
    );
  }

  void _initUserModel(FirebaseAuthState firebaseAuthState, BuildContext context) async {

    UserModelState userModelState = Provider.of<UserModelState>(context, listen: false);

    userModelState.currentStreamSub = userNetworkRepository
        .getUserModelStream(firebaseAuthState.user!.uid)
        .listen((userModel) {
          userModelState.userModel = userModel;
    });
  }

  void _clearUserModel(BuildContext context){
    UserModelState userModelState = Provider.of<UserModelState>(context, listen: false);
    userModelState.clear();
  }

}
