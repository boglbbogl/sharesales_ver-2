import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/constant/snack_bar_style.dart';
import 'package:sizer/sizer.dart';

class ProfileScreenBodyFlipCard extends StatelessWidget {

  final cardKey;
  final userModel;
  final _userNameController;

  const ProfileScreenBodyFlipCard(this._userNameController, this.cardKey,{Key? key, this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlipCard(
        key: cardKey,
        front: _profileScreenBodyFlipCardFrontForm(context),
        back: _profileScreenBodyFlipCardBackForm());
  }

  Container _profileScreenBodyFlipCardBackForm() {
    return Container(width: 90.w, height: 40.h, decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(20),
      ),
        child: userModel.storeCode.isEmpty ? Center(child: Text('사업자 인증 정보가 없습니다', style: TextStyle(color: Colors.white, fontSize: 24),)):
        ListView(
          children: <Widget>[
            SizedBox(height: 3.h,),
            _flipCardBackTextForm(title: userModel.storeCode!, margin: 0),
            _flipCardBackTextForm(title: userModel.personalOrCorporate=='개인' ? '개인사업자' : '법인사업자', margin: 0),
            SizedBox(height: 4.h,),
            Row(
              children: <Widget>[
                _flipCardBackBasicTextForm(hint: userModel.personalOrCorporate=='개인' ? '상 호 명 : ' : '법 인 명 : ' ),
                _flipCardBackTextForm(title: userModel.storeName!,),
              ],
            ),
            Row(
              children: <Widget>[
                _flipCardBackBasicTextForm(hint: '성      명 : '),
                _flipCardBackTextForm(title: userModel.representative!,),
              ],
            ),
            Row(
              children: <Widget>[
                _flipCardBackBasicTextForm(hint: userModel.personalOrCorporate=='개인' ? '생년월일 : ' : '법인등록번호 : '),
                _flipCardBackTextForm(title: userModel.pocCode!,),
              ],
            ),
            Row(
              children: <Widget>[
                _flipCardBackBasicTextForm(hint: '개업연월일 : '),
                _flipCardBackTextForm(title: userModel.openDate!,),
              ],
            ),
            Row(
              children: <Widget>[
                _flipCardBackBasicTextForm(hint: '사업의 종류 : '),
                _flipCardBackTextForm(title: userModel.typeOfService!,),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: _flipCardBackTextForm(title: userModel.typeOfBusiness!,),
                ),
              ],
            ),
            Row(
              children: [
                _flipCardBackBasicTextForm(hint: '사업장소재지'),
              ],
            ),
            _flipCardBackTextForm(title: userModel.storeLocation!),
          ],
        ),
      );
  }
  Container _flipCardBackBasicTextForm({required String hint}) {
    return Container(
      margin: EdgeInsets.only(left: 15.w, top: 5),
      width: 20.w,
      child: Text(hint, style: TextStyle(color: Colors.amber),textAlign: TextAlign.end,),
    );
  }

  Container _flipCardBackTextForm({required String title, double? margin=20}) {
    return Container(
      margin: EdgeInsets.only(left: margin!, top: 5),
        child: Text(title, textAlign: TextAlign.center, style: TextStyle(color: Colors.amber),));
  }

  SingleChildScrollView _profileScreenBodyFlipCardFrontForm(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(width: 80.w, height: 30.h,
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(20),
        ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InkWell(
                onTap: (){
                 showDialog(context: context, builder: (BuildContext context){
                   return AlertDialog(
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(20),
                     ),
                     backgroundColor: Colors.deepPurple,
                     content: TextFormField(
                       controller: _userNameController,
                       enabled: true,
                       keyboardType: TextInputType.text,
                       inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[ㄱ-ㅎ|가-힣|a-z|A-Z]'))],
                       style: TextStyle(color: Colors.white, fontSize: 20),
                       decoration: signMainUpScreenInputDecor('사용자이름', '', colors: Colors.amberAccent, errorColor: Colors.pink),
                       autovalidateMode: AutovalidateMode.onUserInteraction,
                       validator: (text)=>text!.isNotEmpty?null:'',
                     ),
                     actions: [
                       TextButton(
                           onPressed: ()=>Navigator.of(context).pop(), child: Text('닫기')),
                       TextButton(
                           onPressed: (){
                             FirebaseFirestore.instance.collection(
                                 COLLECTION_USERS).doc(userModel.userKey).update({
                               'userName' : _userNameController.text.isEmpty ? '':_userNameController.text,
                             });
                             snackBarFlashBarCreateManagementSuccessForm(context, massage: '수정 하였습니다');
                             Navigator.of(context).pop();
                           }, child: Text('저장'))
                     ],
                   );
                 });
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.orange,
                  child: Text(userModel.userName!, style: TextStyle(color: Colors.white),),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(userModel.storeName!.isEmpty ? userModel.userName!:userModel.storeName!, style: TextStyle(color: Colors.white, fontSize: 22),),
                  ),
                  Text(userModel.email!, style: TextStyle(color: Colors.white, fontSize: 18),),
                ],
              ),
            ],
          ),
        ),
      );
  }
}
