import 'package:flutter/material.dart';
import 'package:sharesales_ver2/widget/sign_in_form.dart';
import 'package:sharesales_ver2/widget/sign_up_form.dart';


class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {


  Widget signUpForm = SignUpForm();
  Widget signInForm = SignInForm();

  Widget currentWidget;

  @override
  void initState() {
    if (currentWidget == null) currentWidget = signUpForm;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          AnimatedSwitcher(
            duration: Duration(milliseconds: 1000),
            // switchInCurve: Curves.fastLinearToSlowEaseIn,
            switchOutCurve: Curves.fastLinearToSlowEaseIn,
            child: currentWidget,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    if (currentWidget is SignUpForm) {
                      currentWidget = signInForm;
                    } else {
                      currentWidget = signUpForm;
                    }
                  });
                },
                child: InkWell(
                  child: Text(
                    (currentWidget is SignUpForm) ? 'CREATE PAGE' : 'LOGIN PAGE',
                    style: TextStyle(
                      fontSize: 25,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: (currentWidget is SignUpForm) ? Colors.black : Colors.amberAccent),
                  ),
                ),
                // child: RichText(
                //   text: TextSpan(
                //     text: (currentWidget is SignUpForm) ? '로그인 하실래요?':'회원가입 하실래요?',
                //     children: [
                //       TextSpan(
                //         text: (currentWidget is SignUpForm) ? 'Sign In' : 'Sign UP',
                //         style: TextStyle(color: (currentWidget is SignUpForm) ? Colors.blue : Colors.redAccent),
                //       ),
                //       TextSpan(
                //         text: (currentWidget is SignUpForm) ? '테스트1' : 'test2',
                //       ),
                //     ],
                //   ),
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
