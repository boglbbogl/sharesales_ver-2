
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/alert_dialog_and_bottom_sheet_form.dart';
import 'package:sharesales_ver2/constant/app_bar.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';
import 'package:sharesales_ver2/widget/main_profile_setting_bottom_sheet.dart';
import 'package:sharesales_ver2/widget/profile_screen_body_flip_card.dart';
import 'package:sharesales_ver2/widget/profile_screen_body_tap_button.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
import 'package:sizer/sizer.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();


  TextEditingController _storeCodeController = TextEditingController();
  TextEditingController _storeNameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _representativeController = TextEditingController();
  TextEditingController _pocCodeController = TextEditingController();
  TextEditingController _openDateController = TextEditingController();
  TextEditingController _storeLocationController = TextEditingController();
  TextEditingController _typeOfBusinessController = TextEditingController();
  TextEditingController _typeOfServiceController = TextEditingController();

  @override
  void dispose() {
    _storeNameController.dispose();
    _representativeController.dispose();
    _pocCodeController.dispose();
    _openDateController.dispose();
    _userNameController.dispose();
    _storeLocationController.dispose();
    _typeOfBusinessController.dispose();
    _typeOfServiceController.dispose();
    _formKey.currentState!.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    UserModel? userModel =
    Provider.of<UserModelState>(context, listen: false).userModel!;

    _storeCodeController.text = userModel.storeCode!;
    _storeNameController.text = userModel.storeName!;
    _representativeController.text = userModel.representative!;
    _pocCodeController.text = userModel.pocCode!;
    _openDateController.text = userModel.openDate!;
    _storeLocationController.text = userModel.storeLocation!;
    _typeOfBusinessController.text = userModel.typeOfBusiness!;
    _typeOfServiceController.text = userModel.typeOfService!;
    _userNameController.text = userModel.userName!;


    return SafeArea(
      child: GestureDetector(
        onTap: ()=> FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.orange.shade50,
          appBar: mainAppBar(context, secondMainColor,'share sales', Colors.orange.shade50,
              IconButton(icon: Icon(Icons.settings, color: Colors.deepPurpleAccent,), onPressed: (){
                mainProfileSettingBottomSheet(context);
              },),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 5.h,),
                ProfileScreenBodyFlipCard(_userNameController ,cardKey, userModel: userModel,),
                SizedBox(height: 4.h),
                ProfileScreenBodyTapButton(_formKey,
                  _storeCodeController,
                  _storeNameController,
                  _userNameController,
                  _representativeController,
                  _pocCodeController,
                  _openDateController,
                  _storeLocationController,
                  _typeOfBusinessController,
                  _typeOfServiceController,userModel: userModel, cardKey: cardKey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
