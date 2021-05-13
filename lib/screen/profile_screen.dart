import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/alert_dialog_and_bottom_sheet_form.dart';
import 'package:sharesales_ver2/constant/app_bar.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/firebase_auth/firebase_auth_state.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';
import 'package:sharesales_ver2/widget/profile_screen_body_form.dart';
import 'package:sizer/sizer.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AdvancedDrawerController _advancedDrawerController = AdvancedDrawerController();

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
    _advancedDrawerController.dispose();
    _storeNameController.dispose();
    _representativeController.dispose();
    _pocCodeController.dispose();
    _openDateController.dispose();
    _userNameController.dispose();
    _storeLocationController.dispose();
    _typeOfBusinessController.dispose();
    _typeOfServiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    UserModel? userModel =
    Provider.of<UserModelState>(context, listen: false).userModel!;


    return SafeArea(
      child: GestureDetector(
        onTap: (){},
        child: AdvancedDrawer(
          openRatio: 0.4,
          backdropColor: Colors.orange,
          controller: _advancedDrawerController,
          drawer: SafeArea(
            child: Container(
              child: ListTileTheme(
                textColor: Colors.white,
                iconColor: Colors.white,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // SizedBox(height: 8.h,),
                    ListTile(
                      onTap: () {
                        _advancedDrawerController.hideDrawer();
                        alertDialogForm(context, type: CoolAlertType.warning, title: '탈퇴 하시겠습니까 ?', text: '모든 정보는 복구 불가합니다',
                            confirmBtnText: '탈퇴하기', backColors: Colors.redAccent, confirmBtnColors: Colors.redAccent, onConfirmBtnTap: (){
                              print('탈퇴폼');
                            });
                      },
                      leading: Icon(Icons.delete_forever_sharp),
                      title: Text('탈퇴하기'),
                    ),
                    ListTile(
                      onTap: () async{
                        _advancedDrawerController.hideDrawer();
                        alertDialogForm(context, type: CoolAlertType.warning, title: '로그아웃 하시겠습니까 ?', text: '', confirmBtnText: '로그아웃',
                            backColors: Colors.pinkAccent, confirmBtnColors: Colors.pinkAccent, onConfirmBtnTap: (){
                              Navigator.of(context).pop();
                              Provider.of<FirebaseAuthState>(context, listen: false)
                                  .signOut();
                            });
                      },
                      leading: Icon(Icons.logout),
                      title: Text('로그아웃'),
                    ),
                    SizedBox(height: 5.h,),
                    ListTile(
                      onTap: () async{
                        _advancedDrawerController.hideDrawer();
                        alertDialogForm(context, type: CoolAlertType.info, title: '수정 하시겠습니까 ?', text: '', confirmBtnText: '수정하기',
                            backColors: Colors.deepPurple, confirmBtnColors: Colors.deepPurple, onConfirmBtnTap: (){
                              _storeCodeController.text = userModel.storeCode!;
                              _storeNameController.text = userModel.storeName!;
                              _representativeController.text = userModel.representative!;
                              _pocCodeController.text = userModel.pocCode!;
                              _openDateController.text = userModel.openDate!;
                              _storeLocationController.text = userModel.storeLocation!;
                              _typeOfBusinessController.text = userModel.typeOfBusiness!;
                              _typeOfServiceController.text = userModel.typeOfService!;
                              _userNameController.text = userModel.userName!;
                              Navigator.of(context).pop();
                          if(userModel.storeCode!.isEmpty || userModel.storeCode!.length==0 || userModel.storeName!.isEmpty || userModel.storeName!.length==0 ||
                              userModel.personalOrCorporate!.isEmpty || userModel.pocCode!.isEmpty || userModel.openDate!.isEmpty || userModel.representative!.isEmpty ||
                              userModel.typeOfBusiness!.isEmpty || userModel.typeOfService!.isEmpty){
                            return _userInformationCorrectWidgetBottomForm(context, userModel);
                          } else{
                            return _businessInformationCorrectWidgetBottomForm(context, userModel);
                          }});
                      },
                      leading: Icon(Icons.account_circle_outlined),
                      title: Text('수정하기'),
                    ),
                    ListTile(
                      onTap: () {
                      },
                      leading: Icon(Icons.settings),
                      title: Text('설정'),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: Icon(Icons.favorite),
                      title: Text('문의하기'),
                    ),

                  ],
                ),
              ),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.orange.shade50,
            appBar: mainAppBar(context, secondMainColor,'share sales', Colors.orange.shade50,
                Icon(Icons.clear, color: Colors.orange.shade50,),
                leadingIcon: IconButton(color: Colors.pink, icon: ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: _advancedDrawerController,
                  builder: (context, value, child) {
                    return Icon(
                      value.visible! ? Icons.clear : Icons.menu,
                    );
                  },
                ),
                  onPressed: () {
                    _advancedDrawerController.showDrawer();
                  },
                ),
            ),
            body: ProfileScreenBodyForm(),
          ),
        ),
      ),
    );
  }

  Future _userInformationCorrectWidgetBottomForm(BuildContext context, UserModel userModel){
    return showMaterialModalBottomSheet(
        closeProgressThreshold: 5.0,
        elevation: 0,
        enableDrag: false,
        animationCurve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 2000),
        barrierColor: Colors.white12,
        backgroundColor: Colors.white12,
        context: context,
        builder: (BuildContext context){
          return GestureDetector(
            onTap: ()=> FocusScope.of(context).unfocus(),
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                key: _formKey,
                child: Container(
                  height: 50.h,
                  child: Container(decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),

                  ),
                  child:  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    child: DefaultTextStyle(
                      style: TextStyle(color: Colors.amber),
                      child: ListView(
                        children: <Widget>[
                          SizedBox(height: 2.h,),
                          InkWell(
                            onTap: (){
                              if(_formKey.currentState!.validate()) {
                                FirebaseFirestore.instance.collection(
                                    COLLECTION_USERS).doc(userModel.userKey).update({
                                  'userName' : _userNameController.text.isEmpty ? '':_userNameController.text,
                                });
                                Navigator.of(context).pop();
                                // _userNameController.dispose();
                              }
                            },
                            child: Row(
                              children: [
                                Text('수정하기  ',style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,fontFamily: 'Yanolja'),textAlign: TextAlign.center,),
                                Icon(Icons.double_arrow, color: Colors.amber,),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h,),
                          _correctTextFormFieldForm('사용자이름', controller: _userNameController, inputFormatter: [FilteringTextInputFormatter.allow(RegExp('[ㄱ-ㅎ|가-힣|a-z|A-Z]'))],
                          keyboardType: TextInputType.text, validator: (text)=> text.isEmpty?'':null),

                        ],
                      ),
                    ),
                  ),),
                ),
              ),
            ),
          );
        });
  }

  Future _businessInformationCorrectWidgetBottomForm(BuildContext context, UserModel userModel) {
    return showMaterialModalBottomSheet(
                    closeProgressThreshold: 5.0,
                    elevation: 0,
                    enableDrag: false,
                    animationCurve: Curves.fastOutSlowIn,
                    duration: Duration(milliseconds: 2000),
                    barrierColor: Colors.white12,
                    backgroundColor: Colors.white12,
                    context: context,
                    builder: (BuildContext context){

                      return Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Form(
                          key: _formKey,
                          child: Container(
                            height: 90.h,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                child: DefaultTextStyle(
                                  style: TextStyle(color: Colors.amber),
                                  child: ListView(
                                    children: <Widget>[
                                      SizedBox(height: 2.h,),
                                      InkWell(
                                        onTap: (){
                                          if(_formKey.currentState!.validate()) {
                                            FirebaseFirestore.instance.collection(
                                                COLLECTION_USERS).doc(userModel.userKey).update({
                                              'representative': _representativeController.text.isEmpty ? '' : _representativeController.text,
                                              'storeName': _storeNameController.text.isEmpty ? '' : _storeNameController.text,
                                              'pocCode': _pocCodeController.text.isEmpty ? '' : _pocCodeController.text,
                                              'openDate': _openDateController.text.isEmpty ? '' : _openDateController.text,
                                              'typeOfService': _typeOfServiceController.text.isEmpty ? '' : _typeOfServiceController.text,
                                              'typeOfBusiness': _typeOfBusinessController.text.isEmpty ? '' : _typeOfBusinessController.text,
                                              'storeLocation': _storeLocationController.text.isEmpty ? '' : _storeLocationController.text,
                                            });
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Text('수정하기  ',style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,fontFamily: 'Yanolja'),textAlign: TextAlign.center,),
                                          Icon(Icons.double_arrow, color: Colors.amber,),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10.h,),
                                      Text(userModel.personalOrCorporate=='개인' ? '개인사업자':'법인사업자', style: TextStyle(fontFamily: 'Yanolja', color: Colors.white, fontSize: 15),),
                                      _correctTextFormFieldForm('사업자번호',controller: _storeCodeController,enabled: false, keyboardType: TextInputType.number, inputFormatter: [], validator: (text){}),
                                      _correctTextFormFieldForm(userModel.personalOrCorporate=='개인' ? '상호':'법인명',controller: _storeNameController, inputFormatter: [], keyboardType: TextInputType.text,
                                          validator: (text)=>text!.isNotEmpty?null:''),
                                      _correctTextFormFieldForm('대표자',controller: _representativeController, inputFormatter: [FilteringTextInputFormatter.allow(RegExp('[ㄱ-ㅎ|가-힣|a-z|A-Z]'))], keyboardType: TextInputType.text,
                                          validator: (text)=>text!.isNotEmpty?null:''),
                                      userModel.personalOrCorporate=='개인' ?
                                      _correctTextFormFieldForm('생년월일', controller: _pocCodeController, inputFormatter: [MaskedInputFormatter('####-##-##')], keyboardType: TextInputType.number,
                                          validator: (text)=>text!.toString().trim().length==10?null:'정확하게 입력해 주세요')
                                      :_correctTextFormFieldForm('법인등록번호', controller: _pocCodeController, inputFormatter: [MaskedInputFormatter('######-#######')], keyboardType: TextInputType.number,
                                          validator: (text)=>text!.toString().trim().length==14?null:'정확하게 입력해 주세요'),
                                      _correctTextFormFieldForm('개업일',controller: _openDateController, inputFormatter: [MaskedInputFormatter('####-##-##')], keyboardType: TextInputType.number,
                                          validator: (text)=>text!.toString().trim().length==10?null:'정확하게 입력해 주세요'),
                                      _correctTextFormFieldForm('종목',controller: _typeOfBusinessController, inputFormatter: [FilteringTextInputFormatter.allow(RegExp('[ㄱ-ㅎ|가-힣|a-z|A-Z]'))], keyboardType: TextInputType.text,
                                          validator: (text)=>text.isNotEmpty?null:''),
                                      _correctTextFormFieldForm('업태',controller: _typeOfServiceController, inputFormatter: [FilteringTextInputFormatter.allow(RegExp('[ㄱ-ㅎ|가-힣|a-z|A-Z]'))], keyboardType: TextInputType.text,
                                          validator: (text)=>text.isNotEmpty?null:''),
                                      _correctTextFormFieldForm('주소',controller: _storeLocationController, inputFormatter: [], keyboardType: TextInputType.text,
                                          validator: (text){}),
                                      SizedBox(height: 5.h,),
                                      InkWell(
                                        onTap: (){
                                          FirebaseFirestore.instance.collection(
                                              COLLECTION_USERS).doc(userModel.userKey).update({
                                            'representative':  '',
                                            'storeName':  '',
                                            'pocCode':  '',
                                            'openDate':  '',
                                            'typeOfService':  '',
                                            'typeOfBusiness':  '',
                                            'storeLocation':  '',
                                            'personalOrCorporate': '',
                                            'storeCode': '',
                                          });
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Text('삭제하기', style: TextStyle(color: Colors.cyanAccent,fontSize: 30, fontWeight: FontWeight.bold,fontFamily: 'Yanolja'),textAlign: TextAlign.center,),
                                            Icon(Icons.clear_sharp, color: Colors.cyanAccent,)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
  }

  TextFormField _correctTextFormFieldForm(String title, {TextEditingController? controller, enabled=true, validator,
    List<TextInputFormatter>? inputFormatter,
    TextInputType? keyboardType}) {
    return TextFormField(
                                    controller: controller,
                                    enabled: enabled,
                                    keyboardType: keyboardType!,
                                    inputFormatters: inputFormatter!,
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                    decoration: signMainUpScreenInputDecor(title, '', colors: Colors.amberAccent, errorColor: Colors.pink),
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: validator,
                                  );
  }
}
