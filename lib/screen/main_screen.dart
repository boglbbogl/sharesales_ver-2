import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sharesales_ver2/constant/alert_dialog_and_bottom_sheet_form.dart';
import 'package:sharesales_ver2/constant/app_bar.dart';
import 'package:sharesales_ver2/constant/color.dart';
import 'package:sharesales_ver2/constant/firestore_keys.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sharesales_ver2/firebase_auth/firebase_auth_state.dart';
import 'package:sharesales_ver2/firebase_auth/user_model_state.dart';
import 'package:sharesales_ver2/firebase_firestore/chart_model.dart';
import 'package:sharesales_ver2/firebase_firestore/user_model.dart';
import 'package:sharesales_ver2/screen/create_management_screen.dart';
import 'package:sharesales_ver2/screen/store_detail_screen.dart';
import 'package:sharesales_ver2/widget/main_screen_chart_form.dart';
import 'package:sharesales_ver2/widget/main_screen_tab_indicator_form.dart';
import 'package:sharesales_ver2/widget/my_progress_indicator.dart';
import 'package:sizer/sizer.dart';
import 'management_screen.dart';


class MainScreen extends StatefulWidget {


  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AdvancedDrawerController _advancedDrawerController = AdvancedDrawerController();


  @override
  void dispose() {
    _advancedDrawerController.dispose();
    super.dispose();
  }
  int _initialChartPage = 0;

  @override
  Widget build(BuildContext context) {

    UserModel userModel =
        Provider.of<UserModelState>(context, listen: false).userModel!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(COLLECTION_SALES_MANAGEMENT)
          .doc(userModel.userKey)
          .collection(userModel.email!)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData || snapshot.data == null || snapshot.hasError ) {
          return MyProgressIndicator();
        }
        
        final nowActualSalesList = [];
        final nowTotalExpenseList = [];
        final lastActualSalesList = [];
        final lastTotalExpenseList = [];
        final test = [];

        DateTime now = DateTime.now();

        snapshot.data!.docs.forEach((element) {
          if(element['selectedDate'].toString().substring(0,7)==DateTime(now.year, now.month).toString().substring(0,7)) {
            nowActualSalesList.add(element['actualSales']);
            nowTotalExpenseList.add(element['expenseAddTotalAmount'] + element['foodProvisionExpense'] + element['alcoholExpense'] + element['beverageExpense']);
          } else if(element['selectedDate'].toString().substring(0,7)==DateTime(now.year, now.month-1).toString().substring(0,7)){
            lastActualSalesList.add(element['actualSales']);
            lastTotalExpenseList.add(element['expenseAddTotalAmount'] + element['foodProvisionExpense'] + element['alcoholExpense'] + element['beverageExpense']);
            test.add(element['selectedDate']);
          }
        });

        int? nowActualSales = nowActualSalesList.isEmpty ? int.parse('0') : nowActualSalesList.reduce((v, e) => v+e);
        int? nowTotalExpense = nowTotalExpenseList.isEmpty ? int.parse('0') : nowTotalExpenseList.reduce((v, e) => v+e);
        int? lastActualSales = lastActualSalesList.isEmpty ? int.parse('0') : lastActualSalesList.reduce((v, e) => v+e);
        int? lastTotalExpense = lastTotalExpenseList.isEmpty ? int.parse('0') : lastTotalExpenseList.reduce((v, e) => v+e);
        double actualSalesPercentage = (nowActualSales!/lastActualSales!)*100;
        double totalExpensePercentage = (nowTotalExpense!/lastTotalExpense!)*100;

        final chartNowJanSales =[];
        final chartNowFebSales =[];
        final chartNowMarSales =[];
        final chartNowAprSales =[];
        final chartNowMaySales =[];
        final chartNowJunSales =[];
        final chartNowJulSales =[];
        final chartNowAugSales =[];
        final chartNowSepSales =[];
        final chartNowOctSales =[];
        final chartNowNovSales =[];
        final chartNowDecSales =[];
        final chartLastJanSales =[];
        final chartLastFebSales =[];
        final chartLastMarSales =[];
        final chartLastAprSales =[];
        final chartLastMaySales =[];
        final chartLastJunSales =[];
        final chartLastJulSales =[];
        final chartLastAugSales =[];
        final chartLastSepSales =[];
        final chartLastOctSales =[];
        final chartLastNovSales =[];
        final chartLastDecSales =[];
        final chartNowJanExpense =[];
        final chartNowFebExpense =[];
        final chartNowMarExpense =[];
        final chartNowAprExpense =[];
        final chartNowMayExpense =[];
        final chartNowJunExpense =[];
        final chartNowJulExpense =[];
        final chartNowAugExpense =[];
        final chartNowSepExpense =[];
        final chartNowOctExpense =[];
        final chartNowNovExpense =[];
        final chartNowDecExpense =[];
        final chartLastJanExpense =[];
        final chartLastFebExpense =[];
        final chartLastMarExpense =[];
        final chartLastAprExpense =[];
        final chartLastMayExpense =[];
        final chartLastJunExpense =[];
        final chartLastJulExpense =[];
        final chartLastAugExpense =[];
        final chartLastSepExpense =[];
        final chartLastOctExpense =[];
        final chartLastNovExpense =[];
        final chartLastDecExpense =[];

        snapshot.data!.docs.forEach((element) {
          String snapDate = element['selectedDate'].toString().substring(0,7);
          String compareNowDate = DateTime(now.year).toString().substring(0,4);
          String compareLastDate = DateTime(now.year-1).toString().substring(0,4);
          var act = element['actualSales'];
          var exp = element['expenseAddTotalAmount'] + element['foodProvisionExpense'] + element['alcoholExpense'] + element['beverageExpense'];
          if(snapDate==compareNowDate+'-01') {
            chartNowJanSales.add(act);
            chartNowJanExpense.add(exp);
          }else if(snapDate==compareNowDate+'-02'){
            chartNowFebSales.add(act);
            chartNowFebExpense.add(exp);
          }else if(snapDate==compareNowDate+'-03'){
            chartNowMarSales.add(act);
            chartNowMarExpense.add(exp);
          }else if(snapDate==compareNowDate+'-04'){
            chartNowAprSales.add(act);
            chartNowAprExpense.add(exp);
          }else if(snapDate==compareNowDate+'-05'){
            chartNowMaySales.add(act);
            chartNowMayExpense.add(exp);
          }else if(snapDate==compareNowDate+'-06'){
            chartNowJunSales.add(act);
            chartNowJunExpense.add(exp);
          }else if(snapDate==compareNowDate+'-07'){
            chartNowJulSales.add(act);
            chartNowJulExpense.add(exp);
          }else if(snapDate==compareNowDate+'-08'){
            chartNowAugSales.add(act);
            chartNowAugExpense.add(exp);
          }else if(snapDate==compareNowDate+'-09'){
            chartNowSepSales.add(act);
            chartNowSepExpense.add(exp);
          }else if(snapDate==compareNowDate+'-10'){
            chartNowOctSales.add(act);
            chartNowOctExpense.add(exp);
          }else if(snapDate==compareNowDate+'-11'){
            chartNowNovSales.add(act);
            chartNowNovExpense.add(exp);
          }else if(snapDate==compareNowDate+'-12'){
            chartNowDecSales.add(act);
            chartNowDecExpense.add(exp);
          }else if(snapDate==compareLastDate+'-01'){
            chartLastJanSales.add(act);
            chartLastJanExpense.add(exp);
          }else if(snapDate==compareLastDate+'-02'){
            chartLastFebSales.add(act);
            chartLastFebExpense.add(exp);
          }else if(snapDate==compareLastDate+'-03'){
            chartLastMarSales.add(act);
            chartLastMarExpense.add(exp);
          }else if(snapDate==compareLastDate+'-04'){
            chartLastAprSales.add(act);
            chartLastAprExpense.add(exp);
          }else if(snapDate==compareLastDate+'-05'){
            chartLastMaySales.add(act);
            chartLastMayExpense.add(exp);
          }else if(snapDate==compareLastDate+'-06'){
            chartLastJunSales.add(act);
            chartLastJunExpense.add(exp);
          }else if(snapDate==compareLastDate+'-07'){
            chartLastJulSales.add(act);
            chartLastJulExpense.add(exp);
          }else if(snapDate==compareLastDate+'-08'){
            chartLastAugSales.add(act);
            chartLastAugExpense.add(exp);
          }else if(snapDate==compareLastDate+'-09'){
            chartLastSepSales.add(act);
            chartLastSepExpense.add(exp);
          }else if(snapDate==compareLastDate+'-10'){
            chartLastOctSales.add(act);
            chartLastOctExpense.add(exp);
          }else if(snapDate==compareLastDate+'-11'){
            chartLastNovSales.add(act);
            chartLastNovExpense.add(exp);
          }else if(snapDate==compareLastDate+'-12'){
            chartLastDecSales.add(act);
            chartLastDecExpense.add(exp);
          }
        });

        List<LineChartData> lineChartData = [
          LineChartData(title: '01',month: '01', nowActualSales: chartNowJanSales.isEmpty ? int.parse('0'):chartNowJanSales.reduce((v, e) => v+e),
          lastActualSales: chartLastJanSales.isEmpty ? int.parse('0'):chartLastJanSales.reduce((v, e) => v+e),
          nowTotalExpense: chartNowJanExpense.isEmpty ? int.parse('0'):chartNowJanExpense.reduce((v, e) => v+e),
          lastTotalExpense: chartLastJanExpense.isEmpty ? int.parse('0'):chartLastJanExpense.reduce((v, e) => v+e)),
          LineChartData(title: '01',month: '02', nowActualSales: chartNowFebSales.isEmpty ? int.parse('0'):chartNowFebSales.reduce((v, e) => v+e),
          lastActualSales: chartLastFebSales.isEmpty ? int.parse('0'):chartLastFebSales.reduce((v, e) => v+e),
          nowTotalExpense: chartNowFebExpense.isEmpty ? int.parse('0'):chartNowFebExpense.reduce((v, e) => v+e),
          lastTotalExpense: chartLastFebExpense.isEmpty ? int.parse('0'):chartLastFebExpense.reduce((v, e) => v+e)),
          LineChartData(title: '01',month: '03', nowActualSales: chartNowMarSales.isEmpty ? int.parse('0'):chartNowMarSales.reduce((v, e) => v+e),
          lastActualSales: chartLastMarSales.isEmpty ? int.parse('0'):chartLastMarSales.reduce((v, e) => v+e),
          nowTotalExpense: chartNowMarExpense.isEmpty ? int.parse('0'):chartNowMarExpense.reduce((v, e) => v+e),
          lastTotalExpense: chartLastMarExpense.isEmpty ? int.parse('0'):chartLastMarExpense.reduce((v, e) => v+e)),
          LineChartData(title: '01',month: '04', nowActualSales: chartNowAprSales.isEmpty ? int.parse('0'):chartNowAprSales.reduce((v, e) => v+e),
          lastActualSales: chartLastAprSales.isEmpty ? int.parse('0'):chartLastAprSales.reduce((v, e) => v+e),
          nowTotalExpense: chartNowAprExpense.isEmpty ? int.parse('0'):chartNowAprExpense.reduce((v, e) => v+e),
          lastTotalExpense: chartLastAprExpense.isEmpty ? int.parse('0'):chartLastAprExpense.reduce((v, e) => v+e)),
          LineChartData(title: '01',month: '05', nowActualSales: chartNowMaySales.isEmpty ? int.parse('0'):chartNowMaySales.reduce((v, e) => v+e),
          lastActualSales: chartLastMaySales.isEmpty ? int.parse('0'):chartLastMaySales.reduce((v, e) => v+e),
          nowTotalExpense: chartNowMayExpense.isEmpty ? int.parse('0'):chartNowMayExpense.reduce((v, e) => v+e),
          lastTotalExpense: chartLastMayExpense.isEmpty ? int.parse('0'):chartLastMayExpense.reduce((v, e) => v+e)),
          LineChartData(title: '01',month: '06', nowActualSales: chartNowJunSales.isEmpty ? int.parse('0'):chartNowJunSales.reduce((v, e) => v+e),
          lastActualSales: chartLastJunSales.isEmpty ? int.parse('0'):chartLastJunSales.reduce((v, e) => v+e),
          nowTotalExpense: chartNowJunExpense.isEmpty ? int.parse('0'):chartNowJunExpense.reduce((v, e) => v+e),
          lastTotalExpense: chartLastJunExpense.isEmpty ? int.parse('0'):chartLastJunExpense.reduce((v, e) => v+e)),
          LineChartData(title: '01',month: '07', nowActualSales: chartNowJulSales.isEmpty ? int.parse('0'):chartNowJulSales.reduce((v, e) => v+e),
          lastActualSales: chartLastJulSales.isEmpty ? int.parse('0'):chartLastJulSales.reduce((v, e) => v+e),
          nowTotalExpense: chartNowJulExpense.isEmpty ? int.parse('0'):chartNowJulExpense.reduce((v, e) => v+e),
          lastTotalExpense: chartLastJulExpense.isEmpty ? int.parse('0'):chartLastJulExpense.reduce((v, e) => v+e)),
          LineChartData(title: '01',month: '08', nowActualSales: chartNowAugSales.isEmpty ? int.parse('0'):chartNowAugSales.reduce((v, e) => v+e),
          lastActualSales: chartLastAugSales.isEmpty ? int.parse('0'):chartLastAugSales.reduce((v, e) => v+e),
          nowTotalExpense: chartNowAugExpense.isEmpty ? int.parse('0'):chartNowAugExpense.reduce((v, e) => v+e),
          lastTotalExpense: chartLastAugExpense.isEmpty ? int.parse('0'):chartLastAugExpense.reduce((v, e) => v+e)),
          LineChartData(title: '01',month: '09', nowActualSales: chartNowSepSales.isEmpty ? int.parse('0'):chartNowSepSales.reduce((v, e) => v+e),
          lastActualSales: chartLastSepSales.isEmpty ? int.parse('0'):chartLastSepSales.reduce((v, e) => v+e),
          nowTotalExpense: chartNowSepExpense.isEmpty ? int.parse('0'):chartNowSepExpense.reduce((v, e) => v+e),
          lastTotalExpense: chartLastSepExpense.isEmpty ? int.parse('0'):chartLastSepExpense.reduce((v, e) => v+e)),
          LineChartData(title: '01',month: '10', nowActualSales: chartNowOctSales.isEmpty ? int.parse('0'):chartNowOctSales.reduce((v, e) => v+e),
          lastActualSales: chartLastOctSales.isEmpty ? int.parse('0'):chartLastOctSales.reduce((v, e) => v+e),
          nowTotalExpense: chartNowOctExpense.isEmpty ? int.parse('0'):chartNowOctExpense.reduce((v, e) => v+e),
          lastTotalExpense: chartLastOctExpense.isEmpty ? int.parse('0'):chartLastOctExpense.reduce((v, e) => v+e)),
          LineChartData(title: '01',month: '11', nowActualSales: chartNowNovSales.isEmpty ? int.parse('0'):chartNowNovSales.reduce((v, e) => v+e),
          lastActualSales: chartLastNovSales.isEmpty ? int.parse('0'):chartLastNovSales.reduce((v, e) => v+e),
          nowTotalExpense: chartNowNovExpense.isEmpty ? int.parse('0'):chartNowNovExpense.reduce((v, e) => v+e),
          lastTotalExpense: chartLastNovExpense.isEmpty ? int.parse('0'):chartLastNovExpense.reduce((v, e) => v+e)),
          LineChartData(title: '01',month: '12', nowActualSales: chartNowDecSales.isEmpty ? int.parse('0'):chartNowDecSales.reduce((v, e) => v+e),
          lastActualSales: chartLastDecSales.isEmpty ? int.parse('0'):chartLastDecSales.reduce((v, e) => v+e),
          nowTotalExpense: chartNowDecExpense.isEmpty ? int.parse('0'):chartNowDecExpense.reduce((v, e) => v+e),
          lastTotalExpense: chartLastDecExpense.isEmpty ? int.parse('0'):chartLastDecExpense.reduce((v, e) => v+e)),
        ];
        
        return SafeArea(
          child: GestureDetector(
            onTap: (){
              _advancedDrawerController.hideDrawer();
            },
            child: AdvancedDrawer(
              openRatio: 0.4,
              backdropColor: Colors.pink.shade200,
              controller: _advancedDrawerController,
              drawer: SafeArea(
                child: Container(
                  child: ListTileTheme(
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        // SizedBox(height: 8.h,),
                        ListTile(
                          onTap: () {
                            if(userModel.storeCode!.isEmpty || userModel.storeCode!.length==0 || userModel.storeName!.isEmpty || userModel.storeName!.length==0 ||
                                userModel.personalOrCorporate!.isEmpty || userModel.pocCode!.isEmpty || userModel.openDate!.isEmpty || userModel.representative!.isEmpty ||
                                userModel.typeOfBusiness!.isEmpty || userModel.typeOfService!.isEmpty){
                              _advancedDrawerController.hideDrawer();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StoreDetailScreen()));
                            } else{
                              _advancedDrawerController.hideDrawer();
                              alertDialogForm(context, type: CoolAlertType.success, title: '인증완료', text: '', confirmBtnText: '확인',
                                  backColors: Colors.amber, confirmBtnColors: Colors.amber, onConfirmBtnTap: (){
                                    Navigator.of(context).pop();
                                  });
                            }
                          },
                          leading: Icon(Icons.warning),
                          title: Text('사업자 인증'),
                        ),
                        ListTile(
                          onTap: () async{
                            alertDialogForm(context, type: CoolAlertType.warning, title: '로그아웃 하시겠습니까 ?', text: '', confirmBtnText: '로그아웃',
                                backColors: Colors.pinkAccent, confirmBtnColors: Colors.pinkAccent, onConfirmBtnTap: (){
                                  Navigator.of(context).pop();
                                  Provider.of<FirebaseAuthState>(context, listen: false)
                                      .signOut();
                                });
                          },
                          leading: Icon(Icons.logout),
                          title: Text('로그아웃'),
                        ),
                        SizedBox(height: 5.h,),

                        ListTile(
                          onTap: () {
                            _advancedDrawerController.hideDrawer();
                            (userModel.storeCode!.isEmpty || userModel.storeName!.isEmpty) ?
                            storeDetailWarningShowModalBottomSheetForm(context, backColors: Colors.amber.shade50, textColor: Colors.black54) :
                            _mainScreenProfileSimpleBottomSheetForm(context, userModel);

                          },
                          leading: Icon(Icons.account_circle),
                          title: Text('프로필'),
                        ),
                        ListTile(
                          onTap: (){
                            if(userModel.storeCode!.isEmpty || userModel.storeCode!.length==0 || userModel.storeName!.isEmpty || userModel.storeName!.length==0 ||
                                userModel.personalOrCorporate!.isEmpty || userModel.pocCode!.isEmpty || userModel.openDate!.isEmpty || userModel.representative!.isEmpty ||
                                userModel.typeOfBusiness!.isEmpty || userModel.typeOfService!.isEmpty){
                              alertDialogForm(context, type: CoolAlertType.error, title: '사업자 인증 후 이용해 주세요', text: '', confirmBtnText: '등록하기',
                                  backColors: Colors.cyan, confirmBtnColors: Colors.cyan, onConfirmBtnTap: (){
                                    Navigator.of(context).pop();
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> StoreDetailScreen()));
                                  });
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateManagementScreen()));
                            }
                          },
                          leading: Icon(Icons.create),
                          title: Text('추가'),
                        ),
                        ListTile(
                          onTap: (){},
                          leading: Icon(Icons.search_rounded),
                          title: Text('검색'),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: Icon(Icons.settings),
                          title: Text('설정'),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: Icon(Icons.favorite),
                          title: Text('문의하기'),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              child: Scaffold(
                appBar: mainAppBar(context, secondMainColor,'share sales', Colors.pink[50],
                    IconButton(color: Colors.deepPurple, icon: Icon(Icons.create), onPressed: (){
                   if(userModel.storeCode!.isEmpty || userModel.storeCode!.length==0 || userModel.storeName!.isEmpty || userModel.storeName!.length==0 ||
                       userModel.personalOrCorporate!.isEmpty || userModel.pocCode!.isEmpty || userModel.openDate!.isEmpty || userModel.representative!.isEmpty ||
                       userModel.typeOfBusiness!.isEmpty || userModel.typeOfService!.isEmpty){
                     alertDialogForm(context, type: CoolAlertType.error, title: '사업자 인증 후 이용해 주세요', text: '', confirmBtnText: '등록하기',
                         backColors: Colors.cyan, confirmBtnColors: Colors.cyan, onConfirmBtnTap: (){
                           Navigator.of(context).pop();
                           Navigator.push(context, MaterialPageRoute(builder: (context)=> StoreDetailScreen()));
                         });
                   } else {
                     Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) => CreateManagementScreen()));
                   }
                    }),
                leadingIcon: IconButton(color: Colors.pink, icon: ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: _advancedDrawerController,
                  builder: (context, value, child) {
                    return Icon(
                      value.visible! ? Icons.clear : Icons.menu,
                    );
                  },
                ),
                  onPressed: () {
                    _advancedDrawerController.showDrawer();
                  },
                ),
                appBarBottom: PreferredSize(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(userModel.storeName!.isEmpty ? userModel.userName! : userModel.storeName! ,
                        style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 20,
                        foreground: Paint()..shader = secondMainColor,
                      ),),
                    ),
                    preferredSize: Size(size.width*0.8, 50))
                ),
                backgroundColor: Colors.pink[50],
                body: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          // height: 30.h,
                          width: 90.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                height: 10.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.lightBlue.shade300,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: <Widget>[
                                      _mainScreenNowLastMonthTextForm(now, Colors.lightBlue.shade500, now.month),
                                      _mainScreenMonthBodyTextForm(nowActualSales, nowTotalExpense),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 1.h),
                                height: 10.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.orange.shade300,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: <Widget>[
                                      _mainScreenMonthBodyTextForm(lastActualSales, lastTotalExpense),
                                      _mainScreenNowLastMonthTextForm(now, Colors.orange.shade500, now.month-1),
                                    ],
                                  ),
                                ),
                              ),
                              _mainScreenPostItFormByCompare(
                                  now, nowActualSales, lastActualSales, actualSalesPercentage, nowTotalExpense, lastTotalExpense, totalExpensePercentage),
                            ],
                          ),
                        ),
                        MainScreenTabIndicatorForm(
                          values: ['매출', '지출'],
                          onToggleCallback: (value) {
                            setState(() {
                              _initialChartPage = value;
                            });
                          },
                        ),
                        _initialChartPage==0 ?
                        MainScreenChartForm(lineChartData: lineChartData, now: now, nowColors: Colors.pink, lastColors: Colors.indigoAccent,
                        nowYValue: (LineChartData chart, _)=>chart.nowActualSales, lastYValue: (LineChartData chart, _)=>chart.lastActualSales,) :
                        MainScreenChartForm(lineChartData: lineChartData, now: now, nowColors: Colors.pink, lastColors: Colors.indigoAccent,
                          nowYValue: (LineChartData chart, _)=>chart.nowTotalExpense, lastYValue: (LineChartData chart, _)=>chart.lastTotalExpense,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Badge(badgeColor: Colors.pink , shape: BadgeShape.square,),
                            Container(
                              child: Text('   '+DateTime(now.year).toString().substring(0,4), style: TextStyle(fontSize: 14, color: Colors.black54),),
                            ),
                            SizedBox(width: size.width*0.1,),
                            Badge(badgeColor: Colors.indigoAccent,shape: BadgeShape.square,),
                            Container(
                              child: Text('   '+DateTime(now.year-1).toString().substring(0,4), style: TextStyle(fontSize: 14, color: Colors.black54),),
                            ),
                          ],
                        ),
                        // Text(userModel.storeName.toString().isEmpty ? '231' : userModel.storeName.toString()),
                        Text(''),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future _mainScreenProfileSimpleBottomSheetForm(BuildContext context, UserModel userModel) {
    return showMaterialModalBottomSheet(
                duration: Duration(milliseconds: 2000),
                closeProgressThreshold: 5.0,
                elevation: 0,
                enableDrag: true,
                animationCurve: Curves.fastOutSlowIn,
                barrierColor: Colors.white12,
                backgroundColor: Colors.white12,
                context: context, builder: (BuildContext context){
              return Container(
                height: 45.h,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: DefaultTextStyle(
                  style: TextStyle(color: Colors.white, fontFamily: 'Yanolja', fontSize: 19),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    child: ListView(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 1.h),
                          child: Center(child: Text(userModel.storeCode!.isEmpty ? '' : userModel.storeCode!, style: TextStyle(fontSize: 22),)),
                        ),
                        Container(
                          child: Center(child: Text(userModel.personalOrCorporate=='개인' || userModel.personalOrCorporate!.isEmpty ? '개인사업자' : '법인사업자')),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 2.h),
                          width: 90.w,height: 0.1.h, color: Colors.deepOrangeAccent,),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 1.h),
                          child: Text(userModel.personalOrCorporate=='개인' ? '상         호   :   ' + userModel.storeName! :'법   인   명   :   ' + userModel.storeName! ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 1.h),
                                child: Text(userModel.representative!.isEmpty ?'성         명   :   ' : '성         명   :   ' + userModel.representative!),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 1.h),
                              child: Text(userModel.personalOrCorporate=='개인' ? '생년월일   :   ' +userModel.pocCode! : '법인등록번호   :   ' + userModel.pocCode!),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 1.h),
                          child: Text(userModel.openDate!.isEmpty ? '개업연월일   :   ' : '개업연월일   :   ' + userModel.openDate!),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 1.h),
                          child: Text('사업장소재지'),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5.h, bottom: 1.h),
                          child: Text(userModel.storeLocation!.isEmpty ? '': userModel.storeLocation!),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 1.h),
                          child: Text('사업의종류'),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5.h),
                          child: Text(userModel.typeOfService!.isEmpty ? '업태 : ' : '업태 : ' + userModel.typeOfService!),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5.h),
                          child: Text(userModel.typeOfBusiness!.isEmpty ? '업종 : ' : '업종 : ' + userModel.typeOfBusiness!),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
  }

  Container _mainScreenPostItFormByCompare(DateTime now, int nowActualSales, int lastActualSales, double? actualSalesPercentage,
      int nowTotalExpense, int lastTotalExpense, double? totalExpensePercentage) {
    return Container(
                            height: 10.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.red.shade100,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: <Widget>[
                              Container(
                              width: 25.w,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(DateTime(now.year, now.month-1).toString().substring(6,7) + '월',
                                        style: TextStyle(fontSize: 22 ,fontWeight: FontWeight.bold, color: Colors.white)),
                                    Text('대비',
                                      style: TextStyle(fontSize: 22 ,fontWeight: FontWeight.bold, color: Colors.white),)
                                  ],
                                ),
                              ),
                              Container(
                                width: 65.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _accountScreenNowLastCompareTextForm('',nowActualSales, lastActualSales, actualSalesPercentage!.isNaN || actualSalesPercentage.isInfinite ? double.parse('0.0') : actualSalesPercentage),
                                    _accountScreenNowLastCompareTextForm('',nowTotalExpense, lastTotalExpense, totalExpensePercentage!.isNaN || totalExpensePercentage.isInfinite ? double.parse('0.0') : totalExpensePercentage),
                                  ],
                                ),
                              ),
                                ],
                              ),
                            ),
                          );
  }

  Row _accountScreenNowLastCompareTextForm(String title, int nowData, int lastData, double percentage) {
    return Row(
                                      children: [
                                        SizedBox(height: 1.5.h,),
                                        Container(
                                          height: 2.5.h,
                                          width: 2.w,
                                            child: Center(child: Text(title,style: TextStyle(
                                              color: (nowData>lastData)? Colors.blue:Colors.red,
                                              fontSize: 17,
                                            ),),)),
                                        Container(
                                          width: 60.w,
                                          child: Center(
                                            child: Text(koFormatMoney.format(nowData-lastData)+'  \\   /   ' + percentage.toStringAsFixed(1)+'  %',
                                            style: TextStyle(
                                              color: (nowData>lastData)? Colors.lightBlue:Colors.redAccent, fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),),
                                          ),
                                        ),
                                      ],
                                    );
  }
  Container _mainScreenMonthBodyTextForm(int nowActualSales, int nowTotalExpense) {
    return Container(
      width: 65.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('매출   ' + koFormatMoney.format(nowActualSales)+ '  \\',
            style: TextStyle(
                color: Colors.white, fontSize: 18),),
          SizedBox(height: 3,),
          Text('지출   ' + koFormatMoney.format(nowTotalExpense)+ '  \\',
            style: TextStyle(
                color: Colors.white, fontSize: 18),),
        ],
      ),
    );
  }

  Container _mainScreenNowLastMonthTextForm(DateTime now, Color mainColor, monthType) {
    return Container(
      width: 25.w,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(DateTime(now.year, monthType).toString().substring(5,7),
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(DateTime(now.year, monthType).toString().substring(0,4),
            style: TextStyle(color: Colors.white),)
        ],
      ),
    );
  }
}

