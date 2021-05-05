import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';

class UserModel {
  final String? userName;
  final String userKey;
  final String? email;
  final String? storeName;
  final DocumentReference? reference;

  UserModel.fromMap(Map<String, dynamic> map, this.userKey, {this.reference})
      : userName = map[KEY_USERNAME],
        email = map[KEY_EMAIL],
  storeName = map[KEY_STORENAME];

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data()!, snapshot.id,
      reference: snapshot.reference);

  static Map<String, dynamic> getMapForCreateUser(String? email) {
    Map<String, dynamic>? map = Map();
    map[KEY_USERNAME] = email!.isEmpty ? '' : email.split('@')[0];
    map[KEY_EMAIL] = email.isEmpty? '':email;
    map[KEY_STORENAME] = "";
    return map;
  }
}