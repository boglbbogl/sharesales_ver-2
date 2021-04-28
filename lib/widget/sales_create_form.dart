import 'package:flutter/material.dart';
import 'package:sharesales_ver2/constant/input_decor.dart';
import 'package:sharesales_ver2/constant/size.dart';
import 'package:sizer/sizer.dart';

class SalesCreateForm extends StatelessWidget {
  const SalesCreateForm({
    Key? key,
    required TextEditingController totalSalesController,
    required TextEditingController actualSalesController,
    required TextEditingController vosController,
    required TextEditingController vatController,
    required TextEditingController discountController,
    required TextEditingController creditCardController,
    required TextEditingController cashController,
    required TextEditingController cashReceiptController,
    required TextEditingController deliveryController,
    required TextEditingController giftCardController,


  })  : _totalSalesController = totalSalesController,
        _actualSalesController = actualSalesController,
        _vosController = vosController,
        _vatController = vatController,
  _discountController = discountController,
  _creditCardController = creditCardController,
  _cashController = cashController,
  _cashReceiptController = cashReceiptController,
  _deliveryController = deliveryController,
  _giftCardController = giftCardController,

        super(key: key);

  final TextEditingController _totalSalesController;
  final TextEditingController _actualSalesController;
  final TextEditingController _vosController;
  final TextEditingController _vatController;
  final TextEditingController _discountController;
  final TextEditingController _creditCardController;
  final TextEditingController _cashController;
  final TextEditingController _cashReceiptController;
  final TextEditingController _deliveryController;
  final TextEditingController _giftCardController;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _createTextForm('총매출', '실제매출', _totalSalesController, _actualSalesController),
        _createTextForm('공급가액','세액', _vosController, _vatController),
        _createTextForm('할인','신용카드', _discountController, _creditCardController),
        _createTextForm('현금','현금영수증', _cashController, _cashReceiptController),
        _createTextForm('Delivery','Gift Card', _deliveryController, _giftCardController),
      ],
    );
  }

  Row _createTextForm(
      String leftText,
      String rightText,
      TextEditingController startController,
      TextEditingController endController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          height: 8.h,
          width: 30.w,
          child: TextFormField(
            controller: startController,
            inputFormatters: [wonMaskFormatter],
            // validator: _salesInputValidator,
            style: salesInputStyle(),
            cursorColor: Colors.deepPurple,
            decoration: blackInputDecor(leftText),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
        ),
        Container(
          height: 8.h,
          width: 30.w,
          child: TextFormField(
            controller: endController,
            inputFormatters: [wonMaskFormatter],
            // validator: _salesInputValidator,
            style: salesInputStyle(),
            cursorColor: Colors.deepPurple,
            decoration: blackInputDecor(rightText),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
        ),
      ],
    );
  }

  String? _salesInputValidator(text) {
    if (text.isEmpty) {
      return '필수 입력사항  ex)  0';
    } else
      return null;
  }
}
