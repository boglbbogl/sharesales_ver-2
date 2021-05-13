import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/app_bar.dart';
import 'package:sharesales_ver2/constant/color.dart';
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

  int? _pocSelected=0;

  @override
  Widget build(BuildContext context) {

    UserModel? userModel =
    Provider.of<UserModelState>(context, listen: false).userModel;

    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: mainAppBar(context, detailScreenAppBarColor,'사업자 인증', Colors.cyan.shade100, Icon(Icons.warning, color: Colors.cyan.shade100,), backBtn: false),
            backgroundColor: Colors.cyan.shade100,
            body: Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.only(left: 20.w, right: 20.w),
                child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      SizedBox(height: 1.h,),
                      _storeDetailScreenGroupButtonForm(),
                      _storeDetailScreenHalfTextForm('사업자 등록 번호','',  _storeCodeController, TextInputType.number,
                          inputFormatter: [MaskedInputFormatter('###-##-#####')],
                          validator: (text)=>text!.toString().trim().length==12?null:'정확하게 입력해 주세요'),
                      _storeDetailScreenHalfTextForm('대표자','',  _representativeController, TextInputType.text,
                          inputFormatter:  [FilteringTextInputFormatter.allow(RegExp('[ㄱ-ㅎ|가-힣|a-z|A-Z]'))], validator: (text)=>text!.isNotEmpty?null:'', ),
                      _storeDetailScreenHalfTextForm(_pocSelected==0?'상호명':'법인명','',  _storeNameController, TextInputType.text,
                          inputFormatter:  [], validator: (text)=>text!.isNotEmpty?null:''),
                      _pocSelected==0 ? _storeDetailScreenHalfTextForm('생년월일', 'ex) 2000-11-11', _pocCodeController, TextInputType.number,
                      inputFormatter: [MaskedInputFormatter('####-##-##')], validator: (text)=>text!.toString().trim().length==10?null:'정확하게 입력해 주세요') :
                          _storeDetailScreenHalfTextForm('법인등록번호', '123456-7891011', _pocCodeController, TextInputType.number,
                          inputFormatter: [MaskedInputFormatter('######-#######')], validator: (text)=>text!.toString().trim().length==14?null:'정확하게 입력해 주세요'),
                      _storeDetailScreenHalfTextForm('개업일','ex) 2020-01-01',  _openDateController, TextInputType.number,
                          inputFormatter:  [MaskedInputFormatter('####-##-##')], validator: (text)=>text!.toString().trim().length==10?null:'정확하게 입력해 주세요'),
                      _storeDetailScreenHalfTextForm('업태','대표 업태 하나만 작성하세요',  _typeOfServiceController, TextInputType.text,
                          inputFormatter:  [FilteringTextInputFormatter.allow(RegExp('[ㄱ-ㅎ|가-힣|a-z|A-Z]'))], validator: (text)=>text.isNotEmpty?null:''),
                      _storeDetailScreenHalfTextForm('종목','대표 종목 하나만 작성하세요',  _typeOfBusinessController, TextInputType.text,
                          inputFormatter:  [FilteringTextInputFormatter.allow(RegExp('[ㄱ-ㅎ|가-힣|a-z|A-Z]'))], validator: (text)=>text.isNotEmpty?null:''),
                      _storeDetailScreenHalfTextForm('사업장 소재지','',  _storeLocationController, TextInputType.text,
                          inputFormatter:  []),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Center(child: Text('사업자 등록증 내용과 다를 경우 계정 이용이 불가합니다.', style: TextStyle(color: Colors.black54),)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Center(child: Text('정확한 정보를 입력해 주세요.',style: TextStyle(color: Colors.black54),)),
                      ),
                      _storeDetailScreenTextButton('지금 ',Colors.pink,
                          onPressed: (){
                            FocusScope.of(context).unfocus();
                            if(_formKey.currentState!.validate()) {
                          FirebaseFirestore.instance.collection(
                              COLLECTION_USERS).doc(userModel!.userKey).update({
                            'representative': _representativeController.text.isEmpty ? '' : _representativeController.text,
                            'storeName': _storeNameController.text.isEmpty ? '' : _storeNameController.text,
                            'storeCode': _storeCodeController.text.isEmpty ? '' : _storeCodeController.text,
                            'personalOrCorporate': _pocSelected == 0 ? '개인' : '법인',
                            'pocCode': _pocCodeController.text.isEmpty ? '' : _pocCodeController.text,
                            'openDate': _openDateController.text.isEmpty ? '' : _openDateController.text,
                            'typeOfService': _typeOfServiceController.text.isEmpty ? '' : _typeOfServiceController.text,
                            'typeOfBusiness': _typeOfBusinessController.text.isEmpty ? '' : _typeOfBusinessController.text,
                            'storeLocation': _storeLocationController.text.isEmpty ? '' : _storeLocationController.text,
                            'userName': userModel.email!.split('@')[0].toString(),
                          });
                          _representativeController.clear();
                          _storeNameController.clear();
                          _storeCodeController.clear();
                          _pocCodeController.clear();
                          _openDateController.clear();
                          _typeOfServiceController.clear();
                          _typeOfBusinessController.clear();
                          _storeLocationController.clear();
                          Navigator.of(context).pop();
                            } else {
                            }

                          }),
                      _storeDetailScreenTextButton('나중에 ',Colors.cyan,
                          onPressed: (){
                        Navigator.of(context).pop();
                          }),

                    ],
                  ),
              ),
              ),

          ),

    );
  }

  Center _storeDetailScreenGroupButtonForm() {
    return Center(
                      child: GroupButton(
                        spacing: 10,
                        buttonHeight: 4.h,
                        buttonWidth: 27.w,
                        selectedColor: Colors.lightBlue,
                        unselectedColor: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                        buttons: ['개인', '기업'],
                        onSelected: (index, v){
                          setState(() {
                            if(index==0){
                              _pocSelected = index;
                              _pocCodeController.clear();
                            }
                            _pocSelected = index;
                            _pocCodeController.clear();
                          });

                        },
                        selectedButtons: ['개인'],
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
      {List<TextInputFormatter>? inputFormatter, validator}) {
    return Container(
                          // margin: EdgeInsets.symmetric(vertical: 0.1.h),
                          // width: 60.w,
                          height: 7.h,
                          child: TextFormField(
                            validator: validator,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: keyboardType,
                            inputFormatters: inputFormatter!,
                            controller: controller,
                            style: salesInputStyle(),
                            cursorColor: Colors.black,
                            decoration: storeDetailScreenInputDecor(label, hint,),
                          ),
                        );
  }
}

enum POC{PERSONAL, CORPORATE}