import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/duration.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';

class AccountScreenBody extends StatefulWidget {
  final Function onPageChanged;

  const AccountScreenBody({Key key, this.onPageChanged}) : super(key: key);

  @override
  _AccountScreenBodyState createState() => _AccountScreenBodyState();
}

class _AccountScreenBodyState extends State<AccountScreenBody>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAniController;

  @override
  void initState() {
    _iconAniController = AnimationController(
      vsync: this,
      duration: mainDuration,
    );
    super.initState();
  }

  @override
  void dispose() {
    _iconAniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    UserModelState userModelState = Provider.of<UserModelState>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.amberAccent,
          title: Center(
            child: Text('돈까스상회',
                style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              foreground: Paint()..shader = subColor,
            ),),
          ),
          leading: IconButton(
            color: Colors.amberAccent,
            onPressed: (){},
            icon: Icon(Icons.add),
          ),
          actions: [
                  IconButton(
                    color: Colors.black,
                      icon: AnimatedIcon(
                        icon: AnimatedIcons.menu_close,
                        progress: _iconAniController,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.onPageChanged();
                          _iconAniController.status == AnimationStatus.completed ? _iconAniController.reverse() : _iconAniController.forward();
                        });
                      }),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // _appbar(),
            Container(
              height: 100,
              width: 100,
              color: Colors.red,
            child: Text(
              userModelState == null || userModelState.userModel == null ?
              "":userModelState.userModel.userName,
            ),
            ),
        Container(
          height: 100,
          width: 100,
          color: Colors.red,
          child: Text(
            userModelState == null || userModelState.userModel == null ?
            "":userModelState.userModel.userKey,
          ),
        ),
            // Container(
            //   height: 100,
            //   width: 100,
            //   color: Colors.red,
            //   child: Text('$uid'
            //   ),
            // ),
            Container(
              height: 100,
              width: 100,
              color: Colors.red,
              child: Text(''
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Row _appbar() {
  //   return Row(
  //     children: <Widget>[
  //       SizedBox(
  //         width: 44,
  //       ),
  //       Expanded(
  //         child: Text(
  //           '돈까스상회',
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //       IconButton(
  //           icon: AnimatedIcon(
  //             icon: AnimatedIcons.menu_close,
  //             progress: _iconAniController,
  //           ),
  //           onPressed: () {
  //             setState(() {
  //               widget.onPageChanged();
  //               _iconAniController.status == AnimationStatus.completed ? _iconAniController.reverse() : _iconAniController.forward();
  //             });
  //           }),
  //     ],
  //   );
  // }
}
