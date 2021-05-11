import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/firebase_auth/firebase_auth_state.dart';

import 'package:sizer/sizer.dart';

class SignMainScreen extends StatefulWidget {
  @override
  _SignMainScreenState createState() => _SignMainScreenState();
}

class _SignMainScreenState extends State<SignMainScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  TextEditingController _cpwController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    _cpwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      appBar: AppBar(backgroundColor: Colors.cyanAccent,elevation: 0,),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 100),
          child: Text('시작하기', style: TextStyle(fontSize: 80, color: Colors.black54, fontWeight: FontWeight.bold),),
        ),
        InkWell(
          onTap: (){

            showMaterialModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                closeProgressThreshold: 5.0,
                enableDrag: false,
                elevation: 90.0,
                animationCurve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: 300),
                barrierColor: Colors.black87,
                backgroundColor: Colors.lightBlueAccent,
                context: context,
                builder: (BuildContext context){
                  return Container(
                    height: 95.h,
                    child: ListView(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20.h,),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('첫 방문 인가요 ?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 70),),
                        ),
                        InkWell(
                          onTap: (){

                            _pwController.clear();
                            _cpwController.clear();

                            _createUserShowModalBottomSheet(context) ;
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Text('회원가입 하러 가기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.white),),
                                Icon(Icons.double_arrow, color: Colors.white,),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h,),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('회원 인가요 ?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 70),),
                        ),
                        InkWell(
                          onTap: (){
                            _pwController.clear();
                            _cpwController.clear();
                            _logInUserShowModalBottomSheet(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Text('로그인 하러 가기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.white),),
                                Icon(Icons.double_arrow, color: Colors.white,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
            // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignMainSubScreen()));
          },
          child: Container(
            width: 70.w,
            height: 10.h,
            child: Icon(
              Icons.double_arrow,
            ),
          ),
        ),
      ],
    ),
    );
  }

  Future _logInUserShowModalBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              closeProgressThreshold: 5.0,
                              enableDrag: false,
                              elevation: 90.0,
                              animationCurve: Curves.fastOutSlowIn,
                              duration: Duration(milliseconds: 300),
                              barrierColor: Colors.black87,
                              backgroundColor: Colors.amber,
                              context: context,
                              builder: (BuildContext context){
                                return GestureDetector(
                                  onTap: ()=>FocusScope.of(context).unfocus(),
                                  child: Form(
                                    key: _formKey,
                                    child: Container(
                                      height: 90.h,
                                      margin: EdgeInsets.only(right: 10.h, left: 3.h),
                                      child: ListView(
                                        children: <Widget>[
                                          SizedBox(height: 15.h,),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 12),
                                            child: Text('이메일', style: TextStyle(color: Colors.deepPurple, fontSize: 70, fontWeight: FontWeight.bold),),
                                          ),
                                          TextFormField(
                                            controller: _emailController,
                                            style: TextStyle(color: Colors.white, fontSize: 30),
                                            // autofocus: true,
                                            decoration: signMainUpScreenInputDecor('email', 'ex) abcd@efg.com', colors: Colors.deepPurple, errorColor: Colors.cyanAccent),
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: (text){
                                              if(text!.isNotEmpty && text.contains('@') && text.contains('.')){
                                                return null;
                                              } else {
                                                return '이메일 주소를 입력해 주세요';
                                              }
                                            },
                                          ),
                                          SizedBox(height: 5.h,),
                                          _emailController.text.contains('.') ?
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 12),
                                            child: Text('비밀번호', style: TextStyle(color: Colors.deepPurple, fontSize: 70, fontWeight: FontWeight.bold),),
                                          ) : Container(),
                                          _emailController.text.contains('.') ?
                                          TextFormField(
                                            controller: _pwController,
                                            style: TextStyle(color: Colors.white, fontSize: 30),
                                            // autofocus: true,
                                            decoration: signMainUpScreenInputDecor('', '', colors: Colors.deepPurple, errorColor: Colors.cyanAccent),
                                            validator: (text){
                                              if(text!.isNotEmpty && text.length > 7){
                                                return null;
                                              } else {
                                                return '8자리 이상으로 만들어 주세요';
                                              }
                                            },
                                          ) : Container(),
                                          SizedBox(height: 5.h,),
                                          _pwController.text.isNotEmpty ?
                                          InkWell(
                                            onTap: () {
                                              if(_formKey.currentState!.validate()){
                                                Provider.of<FirebaseAuthState>(context, listen: false)
                                                    .login(context, email: _emailController.text, password: _pwController.text);
                                                print('작동완료');
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  '로그인하기   ',
                                                  style: TextStyle(
                                                      color: Colors.deepOrange,
                                                      fontSize: 40,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                Icon(
                                                  Icons.double_arrow,
                                                  color: Colors.deepOrange,
                                                ),
                                              ],
                                            ),
                                          ) : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
  }

  Future _createUserShowModalBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                          ),
                          closeProgressThreshold: 5.0,
                          enableDrag: false,
                          elevation: 90.0,
                          animationCurve: Curves.fastOutSlowIn,
                          duration: Duration(milliseconds: 300),
                          barrierColor: Colors.black87,
                          backgroundColor: Colors.deepPurple,
                          context: context,
                          builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: ()=>FocusScope.of(context).unfocus(),
                                  child :Form(
                                    key: _formKey,
                                    child: Container(
                                      height: 90.h,
                                      margin: EdgeInsets.only(right: 10.h, left: 3.h),
                                      child: ListView(
                                        children: <Widget>[
                                          SizedBox(height: 15.h,),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 12),
                                            child: Text('이메일', style: TextStyle(color: Colors.amberAccent, fontSize: 70, fontWeight: FontWeight.bold),),
                                          ),
                                          TextFormField(
                                            controller: _emailController,
                                            style: TextStyle(color: Colors.white, fontSize: 30),
                                            // autofocus: true,
                                            decoration: signMainUpScreenInputDecor('email', 'ex) abcd@efg.com', colors: Colors.amberAccent, errorColor: Colors.pink),
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: (text){
                                              if(text!.isNotEmpty && text.contains('@') && text.contains('.')){
                                                return null;
                                              } else {
                                                return '이메일 주소를 입력해 주세요';
                                              }
                                            },
                                          ),
                                          SizedBox(height: 5.h,),
                                          _emailController.text.contains('.') ?
                                          TextFormField(
                                            controller: _pwController,
                                            style: TextStyle(color: Colors.white, fontSize: 30),
                                            // autofocus: true,
                                            decoration: signMainUpScreenInputDecor('비밀번호','', colors: Colors.amberAccent, errorColor: Colors.pink),
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: (text){
                                              if(text!.isNotEmpty && text.length > 7){
                                                return null;
                                              } else {
                                                return '10자리 이상으로 만들어 주세요';
                                              }
                                            },
                                          ) : Container(),
                                          _emailController.text.contains('.') ?
                                          TextFormField(
                                            controller: _cpwController,
                                            style: TextStyle(color: Colors.white, fontSize: 30),
                                            // autofocus: true,
                                            decoration: signMainUpScreenInputDecor('비밀번호확인','', colors: Colors.amberAccent, errorColor: Colors.pink),
                                            validator: (text){
                                              if(text!.isNotEmpty && _pwController.text == text){
                                                return null;
                                              } else {
                                                return '비밀번호가 일치하지 않습니다.';
                                              }
                                            },
                                          ) : Container(),
                                          SizedBox(height: 5.h,),
                                          _pwController.text.isNotEmpty && _cpwController.text.isNotEmpty && _pwController.text.length == _cpwController.text.length ?
                                          InkWell(
                                            onTap: () {
                                              if(_formKey.currentState!.validate()) {
                                                Provider.of<FirebaseAuthState>(context, listen: false)
                                                    .registerUser(
                                                  context, email: _emailController.text,
                                                  password: _pwController.text,);
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  '계정 생성하기   ',
                                                  style: TextStyle(
                                                      color: Colors.cyanAccent,
                                                      fontSize: 40,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                Icon(
                                                  Icons.double_arrow,
                                                  color: Colors.cyanAccent,
                                                ),
                                              ],
                                            ),
                                          ) : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                          });
  }
}


