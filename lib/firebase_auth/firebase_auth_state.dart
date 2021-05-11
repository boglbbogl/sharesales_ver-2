import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sharesales_ver2/constant/alert_dialog_and_bottom_sheet_form.dart';
import 'package:sharesales_ver2/constant/snack_bar_style.dart';
import 'package:sharesales_ver2/firebase_firestore/firestore_user_repository.dart';

class FirebaseAuthState extends ChangeNotifier {
  FirebaseAuthStatus _firebaseAuthStatus = FirebaseAuthStatus.logout;
  User? _user;
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
      {required String email, required String password}) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .catchError((error) {
      print(error);
      String _massage = '';
      switch (error.code) {
        case 'email-already-in-use':
          _massage = '이미 사용중인 계정입니다';
          break;
        case 'invalid-email':
          _massage = '정확한 이메일 주소를 입력해 주세요';
          break;
        case 'operation-not-allowed':
          _massage = '잠시후 다시 시도해주세요';
          break;
        case 'weak-password':
          _massage = '8자리 이상의 비밀번호를 사용해 주세요';
          break;
      }
      snackBarFlashBarCreateAuthStateForm(context,
          massage: _massage, textColor: Colors.deepPurple,marginV: 10.h, marginH: 3.w, backColors: Colors.amber,duration: 2000);
    });
    _user = userCredential.user;
    if (_user == null) {
      snackBarFlashBarCreateAuthStateForm(context,
          massage: '잠시후 다시 이용해 주세요', textColor: Colors.deepPurple,marginV: 10.h, marginH: 3.w, backColors: Colors.amber,duration: 2000);
    } else {

      await userNetworkRepository.attemptCreateUser(
          userKey: _user!.uid, email: _user!.email!);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      snackBarFlashBarCreateAuthStateForm(context,
          massage: '${_user!.email}님 반갑습니다 ', textColor: Colors.white,marginV: 10.h, marginH: 3.w, backColors: Colors.black45, duration: 3000);
    }
  }

  void login(BuildContext context,
      {required String email, required String password}) async{
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .catchError((error) {
      print(error);
      String _massage = '';
      switch (error.code) {
        case 'invalid-email':
          _massage = '정확한 이메일 주소를 입력해 주세요';
          break;
        case 'user-disabled':
          _massage = '해당 계정은 관리자에 의해 사용이 중단 되었습니다.';
          break;
        case 'user-not-found':
          _massage = '해당 계정은 등록된 사용자가 아닙니다';
          break;
        case 'wrong-password':
          _massage = '비밀번호를 확인해 주세요';
          break;
      }
      snackBarFlashBarCreateAuthStateForm(context,
          massage: _massage, textColor: Colors.amber,marginV: 10.h, marginH: 3.w, backColors: Colors.deepPurple, duration: 2000);
    });

    _user = userCredential.user;
    if (_user == null) {
      snackBarFlashBarCreateAuthStateForm(context,
          massage: '잠시후 다시 이용해 주세요', textColor: Colors.deepPurple,marginV: 10.h, marginH: 3.w, backColors: Colors.amber,duration: 2000);
    } else{
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      snackBarFlashBarCreateAuthStateForm(context,
          massage: '${_user!.email}', textColor: Colors.white,marginV: 10.h, marginH: 3.w, backColors: Colors.black45, duration: 3000);
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

  void changeFirebaseAuthStatus([FirebaseAuthStatus? firebaseAuthStatus]) {
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
  User? get user => _user;
}

enum FirebaseAuthStatus { logout, progress, login }
