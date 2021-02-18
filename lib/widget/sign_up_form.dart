import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

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
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Colors.amberAccent,
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 150),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: logoutInputDecor('Email'),
                  validator: (text){
                    if(text.isNotEmpty && text.contains('@')){
                      return null;
                    } else {
                      return '정확한 이메일 입력해라';
                    }
                  },
                ),
                TextFormField(
                  controller: _pwController,
                  decoration: logoutInputDecor('Password'),
                  validator: (text){
                    if(text.isNotEmpty && text.length > 3){
                      return null;
                    } else {
                      return '3자리 이상으로 해';
                    }
                  },
                ),
                TextFormField(
                  controller: _cpwController,
                  decoration: logoutInputDecor('Confirm Password'),
                  validator: (text){
                    if(text.isNotEmpty && _pwController.text == text){
                      return null;
                    } else {
                      return '비밀번호 불일치용';
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
                  child: FlatButton(
                    color: Colors.black,
                      onPressed: (){
                        if(_formKey.currentState.validate()){
                          return print('기능잘 작동합니다');
                        };
                      },
                      child: Text(
                        'CREATE',
                        style: TextStyle(
                          color: Colors.amberAccent,
                        ),
                      ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
