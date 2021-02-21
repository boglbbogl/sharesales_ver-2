import 'package:flutter/material.dart';

class AccountScreenBody extends StatefulWidget {

  final Function onPageChanged;

  const AccountScreenBody({Key key, this.onPageChanged}) : super(key: key);

  @override
  _AccountScreenBodyState createState() => _AccountScreenBodyState();
}

class _AccountScreenBodyState extends State<AccountScreenBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
              widget.onPageChanged();
            }
        ),
      ],
    );
  }
}
