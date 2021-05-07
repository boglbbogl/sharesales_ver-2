import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';

class UserModel {
  final String? userName;
  final String userKey;
  final String? email;
  final String? representative;
  final String? storeName;
  final String? storeCode;
  final String? personalOrCorporate;
  final String? pocCode;
  final String? openDate;
  final String? typeOfService;
  final String? typeOfBusiness;
  final String? storeLocation;
  final DocumentReference? reference;

  UserModel.fromMap(Map<String, dynamic> map, this.userKey, {this.reference})
      : userName = map[KEY_USERNAME],
        email = map[KEY_EMAIL],
        representative = map[KEY_REPRESENTATIVE],
        storeName = map[KEY_STORENAME],
        storeCode = map[KEY_STORECODE],
        personalOrCorporate = map[KEY_PERSONALORCORPORATENUMBER],
        pocCode = map[KEY_POCCODE],
        openDate = map[KEY_OPENDATE],
        typeOfService = map[KEY_TYPEOFSERVICE],
        typeOfBusiness = map[KEY_TYPEOFBUSINESS],
        storeLocation = map[KEY_STORELOCATION];

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data()!, snapshot.id,
      reference: snapshot.reference);

  static Map<String, dynamic> getMapForCreateUser(String? email) {
    Map<String, dynamic>? map = Map();
    // map[KEY_USERNAME] = email!.isEmpty ? '' : email.split('@')[0];
    map[KEY_USERNAME] = '';
    map[KEY_EMAIL] = email;
    map[KEY_REPRESENTATIVE] = '';
    map[KEY_STORENAME] = '';
    map[KEY_STORECODE] = '';
    map[KEY_PERSONALORCORPORATENUMBER] = '';
    map[KEY_POCCODE] = '';
    map[KEY_OPENDATE] = '';
    map[KEY_TYPEOFSERVICE] = '';
    map[KEY_TYPEOFBUSINESS] = '';
    map[KEY_STORELOCATION] = '';
    return map;
  }
}