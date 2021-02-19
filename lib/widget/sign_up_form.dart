import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/main_home_page.dart';
import 'package:sharesales_ver2/models/firebase_auth_state.dart';

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
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          color: Colors.amberAccent,
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 100),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Center(
                    child: Text('share sales',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 40,
                        foreground: Paint()..shader = subColor,
                      ),),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: amberInputDecor('Email'),
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
                    decoration: amberInputDecor('Password'),
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
                    decoration: amberInputDecor('Confirm Password'),
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
                            print('기능잘 작동합니다');
                            Provider.of<FirebaseAuthState>(context, listen: false).registerUser(context, email: _emailController.text, password: _pwController.text);
                          }
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
      ),
    );
  }
}
