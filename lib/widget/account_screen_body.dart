import 'package:flutter/material.dart';

class AccountScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _appbar(),
        ],
      ),
    );
  }

  Row _appbar() {
    return Row(
      children: <Widget>[
        SizedBox(width: 44,),
        Expanded(
          child: Text(
            '돈까스상회',
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
            icon: Icon(
                Icons.menu,
            ),
            onPressed: (){

            }
        ),
      ],
    );
  }
}
