import 'package:sharesales_ver2/models/firestore/user_model.dart';

String getNewKey(UserModel userModel) => '${DateTime.now().millisecondsSinceEpoch}_${userModel.userKey}';