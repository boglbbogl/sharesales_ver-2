import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
import 'package:sizer/sizer.dart';

class StoreDetailScreen extends StatefulWidget {
  @override
  _StoreDetailScreenState createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _storeCodeController = TextEditingController();
  TextEditingController _representativeController = TextEditingController();
  TextEditingController _storeNameController = TextEditingController();
  TextEditingController _pocCodeController = TextEditingController();
  TextEditingController _openDateController = TextEditingController();
  TextEditingController _typeOfServiceController = TextEditingController();
  TextEditingController _typeOfBusinessController = TextEditingController();
  TextEditingController _storeLocationController = TextEditingController();

  @override
  void dispose() {
    _storeCodeController.dispose();
    _representativeController.dispose();
    _storeNameController.dispose();
    _pocCodeController.dispose();
    _openDateController.dispose();
    _typeOfServiceController.dispose();
    _typeOfBusinessController.dispose();
    _storeLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    UserModel? userModel =
    Provider.of<UserModelState>(context, listen: false).userModel;

    var _specialChar = ';^\\\$()[](){}*|/';

    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(backgroundColor: Colors.cyan.shade100,elevation: 0,),
            backgroundColor: Colors.cyan.shade100,
            body: Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.only(left: 20.w, right: 20.w),
                child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      _storeDetailScreenHalfTextForm('사업자 등록 번호','',  _storeCodeController, TextInputType.number, 
                          inputFormatter: [RestrictingInputFormatter.restrictFromString(restrictedChars: _specialChar), MaskedInputFormatter('###  ##  #####')]),
                      _storeDetailScreenHalfTextForm('대표자','',  _representativeController, TextInputType.text, 
                          inputFormatter:  [RestrictingInputFormatter.restrictFromString(restrictedChars: _specialChar)]),
                      _storeDetailScreenHalfTextForm('상호명/법인명','',  _storeNameController, TextInputType.text,
                          inputFormatter:  [RestrictingInputFormatter.restrictFromString(restrictedChars: _specialChar)]),
                      _storeDetailScreenHalfTextForm('생년월일/법인번호','',  _pocCodeController, TextInputType.number,
                          inputFormatter:  [RestrictingInputFormatter.restrictFromString(restrictedChars: _specialChar)]),
                      _storeDetailScreenHalfTextForm('개업일','ex) 2020-01-01',  _openDateController, TextInputType.number,
                          inputFormatter:  [RestrictingInputFormatter.restrictFromString(restrictedChars: _specialChar), MaskedInputFormatter('####-##-##')]),
                      _storeDetailScreenHalfTextForm('업태','대표 업태 하나만 작성하세요',  _typeOfServiceController, TextInputType.text,
                          inputFormatter:  [RestrictingInputFormatter.restrictFromString(restrictedChars: _specialChar)]),
                      _storeDetailScreenHalfTextForm('종목','대표 종목 하나만 작성하세요',  _typeOfBusinessController, TextInputType.text,
                          inputFormatter:  [RestrictingInputFormatter.restrictFromString(restrictedChars: _specialChar)]),
                      _storeDetailScreenHalfTextForm('사업장 소재지','',  _storeLocationController, TextInputType.text,
                          inputFormatter:  [RestrictingInputFormatter.restrictFromString(restrictedChars: _specialChar)]),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text('사업자 등록증 내용과 다를 경우 계정 이용이 불가합니다.'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text('정확한 정보를 입력해 주세요.'),
                      ),
                      _storeDetailScreenTextButton('지금 ',Colors.pink,
                          onPressed: (){
                        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(userModel!.userKey).update({
                              'storeCode' : _storeCodeController.text.isEmpty ? '' : _storeCodeController.text,
                            });
                          }),
                      _storeDetailScreenTextButton('나중에 ',Colors.cyan,
                          onPressed: (){}),

                    ],
                  ),
              ),
              ),

          ),

    );
  }

  TextButton _storeDetailScreenTextButton(String title,Color colors, {dynamic onPressed}) {
    return TextButton(
                        onPressed: onPressed,
                        child: Container(
                          height: 5.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                            color: colors,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                              child: Text(title + '등록하기',
                            style: TextStyle(
                                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),)),
                        ));
  }

  Container _storeDetailScreenHalfTextForm(String label, String hint,TextEditingController controller,TextInputType keyboardType,
      {List<TextInputFormatter>? inputFormatter}) {
    return Container(
                          // margin: EdgeInsets.symmetric(vertical: 1.h),
                          // width: 60.w,
                          height: 6.h,
                          child: TextFormField(
                            keyboardType: keyboardType,
                            inputFormatters: inputFormatter!,
                            controller: controller,
                            style: salesInputStyle(),
                            cursorColor: Colors.black,
                            decoration: storeDetailScreenInputDecor(label, hint),
                          ),
                        );
  }
}
