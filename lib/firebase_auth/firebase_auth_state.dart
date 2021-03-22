import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/snack_bar_style.dart';
import 'package:sharesales_ver2/firebase_firestore/firestore_user_repository.dart';

class FirebaseAuthState extends ChangeNotifier {
  FirebaseAuthStatus _firebaseAuthStatus = FirebaseAuthStatus.logout;
  User _user;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void watchAuthChange() {
    _firebaseAuth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser == null && _user == null) {
        return;
      } else if (firebaseUser != null) {
        _user = firebaseUser;
        changeFirebaseAuthStatus();
      }
    });
  }

  void registerUser(BuildContext context,
      {@required String email, @required String password}) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .catchError((error) {
      print(error);
      String _massage = '';
      switch (error.code) {
        case 'email-already-in-use':
          _massage = '이미 사용중';
          break;
        case 'invalid-email':
          _massage = '폼이 안맞어';
          break;
        case 'operation-not-allowed':
          _massage = '잠시후 다시 시도해주세요';
          break;
        case 'weak-password':
          _massage = '6자리 이상사용해라';
          break;
      }

      SnackBar snackBar = SnackBar(
        content: Text(
          _massage,
          style: snackBarStyle(),
        ),
        backgroundColor: Colors.lightBlueAccent,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });

    _user = userCredential.user;
    if (_user == null) {
      SnackBar snackBar = SnackBar(
        content: Text(
          '잠시후 다시 이용해 주세요',
          style: snackBarStyle(),
        ),
        backgroundColor: Colors.lightBlueAccent,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      await userNetworkRepository.attemptCreateUser(
          userKey: _user.uid, email: _user.email);
    }
  }

  void login(BuildContext context,
      {@required String email, @required String password}) async{
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .catchError((error) {
      print(error);
      String _massage = '';
      switch (error.code) {
        case 'invalid-email':
          _massage = 'Email 주소가 아닙니다';
          break;
        case 'user-disabled':
          _massage = '해당 Email 계정은 사용할 수 없습니다';
          break;
        case 'user-not-found':
          _massage = '회원이 아닙니다';
          break;
        case 'wrong-password':
          _massage = '패스워드가 정확하지 않습니다';
          break;
      }
      SnackBar snackBar = SnackBar(
        content: Text(
          _massage,
          style: snackBarStyle(),
        ),
        backgroundColor: Colors.lightBlueAccent,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });

    _user = userCredential.user;
    if (_user == null) {
      SnackBar snackBar = SnackBar(
        content: Text(
          '잠시후 다시 이용해 주세요',
          style: snackBarStyle(),
        ),
        backgroundColor: Colors.lightBlueAccent,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void signOut() {
    _firebaseAuthStatus = FirebaseAuthStatus.logout;
    if (_user != null) {
      _user = null;
      _firebaseAuth.signOut();
    }
    notifyListeners();
  }

  void changeFirebaseAuthStatus([FirebaseAuthStatus firebaseAuthStatus]) {
    if (firebaseAuthStatus != null) {
      _firebaseAuthStatus = firebaseAuthStatus;
    } else {
      if (_user != null) {
        _firebaseAuthStatus = FirebaseAuthStatus.login;
      } else
        _firebaseAuthStatus = FirebaseAuthStatus.logout;
    }
    notifyListeners();
  }

  FirebaseAuthStatus get firebaseAuthStatus => _firebaseAuthStatus;
  User get user => _user;
}

enum FirebaseAuthStatus { logout, progress, login }
