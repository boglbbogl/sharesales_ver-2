
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/models/firestore/user_model.dart';
import 'package:sharesales_ver2/widget/date_picker_cupertino.dart';

class ManagementRepository {
  Future<void> createManagement(UserModel userModel,
      Map<String, dynamic> managementData) async {

    final DocumentReference managementReference = FirebaseFirestore.instance.collection(COLLECTION_SALES).doc(userModel.userKey)
    .collection(userModel.userName).doc(pickerDate.toUtc().toString().substring(0,10));
    final DocumentSnapshot managementSnapshot = await managementReference.get();

    if (!managementSnapshot.exists) {
      managementReference.set(managementData);
    } else
      managementReference.update(managementData);
  }
}

ManagementRepository managementRepository = ManagementRepository();