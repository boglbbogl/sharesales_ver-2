import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirebaseAuthState extends ChangeNotifier{
  FirebaseAuthStatus _firebaseAuthStatus = FirebaseAuthStatus.logout;
  User _user;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void watchAuthChange(){
    _firebaseAuth.authStateChanges().listen((firebaseUser) {
      if(firebaseUser == null && _user == null){
        return;
      } else if(firebaseUser != null){
        _user = firebaseUser;
        changeFirebaseAuthStatus();
      }
    });
  }

  void registerUser({@required String email, @required String password}) async{
    await _firebaseAuth.createUserWithEmailAndPassword(email: email.trim(), password: password.trim())
    .catchError((error){
      print(error);
      String _massage = '';
      switch (error.code){
      case 'email-already-in-use':
        _massage = '이미 사용중';
        break;
      case 'invalid-email':
        _massage = '폼이 안맞어';
        break;
      case 'operation-not-allowed':
        _massage = '무슨뜻인지 몰겟어';
        break;
      case 'weak-password':
        _massage = '패스워드 일치 안해';
        break;
      }
      SnackBar snackBar = SnackBar(
          content: Text(_massage),);
      // Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  void login({@required String email, @required String password}){
    _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  void signOut(){
    _firebaseAuthStatus = FirebaseAuthStatus.logout;
    if(_user != null){
      _user = null;
      _firebaseAuth.signOut();
    }
    notifyListeners();
  }

  void changeFirebaseAuthStatus([FirebaseAuthStatus firebaseAuthStatus]){
    if(firebaseAuthStatus != null){
      _firebaseAuthStatus = firebaseAuthStatus;
    } else {
      if(_user != null){
        _firebaseAuthStatus = FirebaseAuthStatus.login;
      } else
        _firebaseAuthStatus = FirebaseAuthStatus.logout;
    }
    notifyListeners();
  }
  FirebaseAuthStatus get firebaseAuthStatus => _firebaseAuthStatus;
}

enum FirebaseAuthStatus{
  logout, progress, login
}