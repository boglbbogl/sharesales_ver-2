import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/firebase_firestore/transformers.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';

class UserNetworkRepository with Transformers {
  Future<void> attemptCreateUser({String? userKey, String? email}) async {
    final DocumentReference userReference =
    FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(userKey);

    DocumentSnapshot snapshot = await userReference.get();
    if (!snapshot.exists) {
      return await userReference.set(UserModel.getMapForCreateUser(email));
    }
  }

  Stream<UserModel> getUserModelStream(String userKey) {
    return FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .doc(userKey)
        .snapshots()
        .transform(toUser);
  }
}

UserNetworkRepository userNetworkRepository = UserNetworkRepository();