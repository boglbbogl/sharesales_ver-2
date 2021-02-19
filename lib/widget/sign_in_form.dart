import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/models/firebase_auth_state.dart';
import '../main_home_page.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
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
        body: Padding(
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
                    foreground: Paint()..shader = mainColor,
                  ),),
                ),
                SizedBox(height: 100,),
                TextFormField(
                  cursorColor: Colors.white,
                  style: blackInputStyle(),
                  controller: _emailController,
                  decoration: blackInputDecor('Email'),
                  validator: (text){
                    if(text.isNotEmpty && text.contains('@')){
                      return null;
                    } else {
                      return '정확한 이메일 입력해라';
                    }
                  },
                ),
                TextFormField(
                  cursorColor: Colors.white,
                  style: blackInputStyle(),
                  controller: _pwController,
                  decoration: blackInputDecor('Password'),
                  validator: (text){
                    if(text.isNotEmpty && text.length > 3){
                      return null;
                    } else {
                      return '3자리 이상으로 해';
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
                  child: FlatButton(
                    color: Colors.amberAccent,
                    onPressed: (){
                      if(_formKey.currentState.validate());
                      {
                        print('잘 작동해');
                        Provider.of<FirebaseAuthState>(context, listen: false)
                            .login(context, email: _emailController.text, password: _pwController.text);
                      }},
                    child: Text(
                      'START',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 240),
                  child: IconButton(
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> MainHomePage()));
                      }, icon: Icon(Icons.star_half_outlined,),color: Colors.amberAccent,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
