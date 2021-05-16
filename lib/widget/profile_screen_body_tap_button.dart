import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sharesales_ver2/constant/alert_dialog_and_bottom_sheet_form.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/constant/snack_bar_style.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
import 'package:sizer/sizer.dart';

class ProfileScreenBodyTapButton extends StatelessWidget {

  final userModel;
  final cardKey;
  final _formKey;
  final _storeCodeController;
  final _storeNameController;
  final _userNameController;
  final _representativeController;
  final _pocCodeController;
  final _openDateController;
  final _storeLocationController;
  final _typeOfBusinessController;
  final _typeOfServiceController;

  const ProfileScreenBodyTapButton(
      this._formKey,
  this._storeCodeController,
  this._storeNameController,
  this._userNameController,
  this._representativeController,
  this._pocCodeController,
  this._openDateController,
  this._storeLocationController,
  this._typeOfBusinessController,
  this._typeOfServiceController,
  {Key? key, required this.userModel, required this.cardKey}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    return DefaultTextStyle(
      style: TextStyle(color: Colors.black45, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Yanolja'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            onTap: (){
              if(userModel.storeCode!.isEmpty || userModel.storeCode!.length==0 || userModel.storeName!.isEmpty || userModel.storeName!.length==0 ||
                  userModel.personalOrCorporate!.isEmpty || userModel.pocCode!.isEmpty || userModel.openDate!.isEmpty || userModel.representative!.isEmpty ||
                  userModel.typeOfBusiness!.isEmpty || userModel.typeOfService!.isEmpty){
                return snackBarFlashBarCreateManagementSuccessForm(context, massage: '삭제할 인증정보가 없습니다');
              } else
              return showMaterialModalBottomSheetShareSalesConstantForm(
                context,  duration: Duration(milliseconds: 300), height: 10.h, colors: Colors.pinkAccent,
                widget: DefaultTextStyle(
                  style: TextStyle(color: Colors.white, fontFamily: 'Yanolja', fontSize: 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(child: Container(width: 40.w,child: Text('삭제'), alignment: Alignment.center,), onTap: (){
                        alertDialogForm(context, type: CoolAlertType.warning, backColors: Colors.pinkAccent, confirmBtnColors: Colors.pinkAccent,
                        confirmBtnText: '삭제하기', title: '삭제 하시겠습니까 ?', text: '삭제 후 이용에 제한이 발생합니다', onConfirmBtnTap: (){
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
                              snackBarFlashBarCreateManagementSuccessForm(context, massage: '삭제 하였습니다');
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            });
                      },),
                      Container(height: 7.h, width: 0.5.w,color: Colors.white,),
                      InkWell(child: Container(width: 40.w,child: Text('취소'),alignment: Alignment.center,), onTap: ()=>Navigator.of(context).pop(),),
                    ],
                  ),
                ),);

            },
            child: Column(
              children: [
                Icon(Icons.clear_sharp, color: Colors.black45,),
                Text('삭제하기'),
              ],
            ),
          ),
          InkWell(
            onTap: ()  async{
              if(userModel.storeCode!.isEmpty || userModel.storeCode!.length==0 || userModel.storeName!.isEmpty || userModel.storeName!.length==0 ||
                  userModel.personalOrCorporate!.isEmpty || userModel.pocCode!.isEmpty || userModel.openDate!.isEmpty || userModel.representative!.isEmpty ||
                  userModel.typeOfBusiness!.isEmpty || userModel.typeOfService!.isEmpty){
                return userInformationCorrectWidgetBottomForm(context, userModel);
              } else{
                return alertDialogForm(context, type: CoolAlertType.info, backColors: Colors.deepPurple, confirmBtnColors: Colors.deepPurple,
                confirmBtnText: '수정하기', title: '수정 하시겠습니까 ?', text: '사업자 번호는 수정할 수 없습니다', onConfirmBtnTap:
                        (){
                          Navigator.of(context).pop();
                          _businessInformationCorrectWidgetBottomForm(context, userModel);
                        });
              }},
            child: Column(
              children: [
                Icon(Icons.create_outlined, color: Colors.black45,),
                Text('수정하기'),
              ],
            ),
          ),
          InkWell(
            onTap: (){
              cardKey.currentState!.toggleCard();
            },
            child: Column(
              children: [
                Icon(Icons.details_sharp, color: Colors.black45,),
                Text('자세히보기'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future userInformationCorrectWidgetBottomForm(BuildContext context, UserModel userModel){
    return showMaterialModalBottomSheet(
        closeProgressThreshold: 5.0,
        elevation: 0,
        enableDrag: false,
        animationCurve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 1500),
        barrierColor: Colors.white12,
        backgroundColor: Colors.white12,
        context: context,
        builder: (BuildContext context){
          return GestureDetector(
            onTap: ()=> FocusScope.of(context).unfocus(),
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                              // if(_secondFormKey.currentState!.validate()) {
                                FirebaseFirestore.instance.collection(
                                    COLLECTION_USERS).doc(userModel.userKey).update({
                                  'userName' : _userNameController.text.isEmpty ? '':_userNameController.text,
                                });
                                snackBarFlashBarCreateManagementSuccessForm(context, massage: '수정 하였습니다');
                                Navigator.of(context).pop();
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
          );
        });
  }

  Future _businessInformationCorrectWidgetBottomForm(BuildContext context, UserModel userModel) {
    return showMaterialModalBottomSheet(
        closeProgressThreshold: 5.0,
        elevation: 0,
        enableDrag: false,
        animationCurve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 1500),
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
                                  snackBarFlashBarCreateManagementSuccessForm(context, massage: '수정 하였습니다');
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
                                validator: (text)=>text.isNotEmpty?null:''),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
  //
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
      validator: validator==null? null:validator,
    );
  }
}
