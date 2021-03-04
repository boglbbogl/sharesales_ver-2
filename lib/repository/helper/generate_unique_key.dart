import 'package:sharesales_ver2/models/firestore/user_model.dart';
import 'package:sharesales_ver2/widget/date_picker_cupertino.dart';



String uniqueKey;
String getUniqueKey(UserModel userModel) {
  return uniqueKey = '${pickerDate}_${userModel.userKey}';
}