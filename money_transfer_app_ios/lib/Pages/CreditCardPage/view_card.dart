import 'package:flutter/material.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'package:keicy_card_detect_provider/keicy_card_detect_provider.dart';
import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';

import 'package:money_transfer_app/Providers/index.dart';
import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Pages/CreditCardPage/Styles/styles.dart';

import 'index.dart';

class ViewCard extends StatefulWidget {
  ViewCard({
    @required this.creditCardPageStyles,
    @required this.isAddCard,
    @required this.index,
    @required this.creditCard,
  });

  final CreditCardPageStyles creditCardPageStyles;
  final bool isAddCard;
  final int index;
  CreditCard creditCard;

  @override
  _ViewCardState createState() => _ViewCardState();
}

class _ViewCardState extends State<ViewCard> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  KeicyProgressDialog _keicyProgressDialog;
  PaymentMethodProvider _paymentMethodProvider;

  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expDateController = TextEditingController();
  TextEditingController _cvcController = TextEditingController();

  final FocusNode _cardNumberFocusNode = FocusNode();
  final FocusNode _expDateFocusNode = FocusNode();
  final FocusNode _cvcFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.creditCard == null) widget.creditCard = CreditCard();

    _cardNumberController.text =
        (widget.creditCard.last4 != "" && widget.creditCard.last4 != null) ? ("xxxx-xxxx-xxxx-" + widget.creditCard.last4) : "";
    _expDateController.text =
        "${widget.creditCard.expMonth ?? ''}${widget.creditCard.expYear != null ? '/' + widget.creditCard.expYear.toString() : ''}";
    _cvcController.text = widget.creditCard.cvc ?? "";

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _paymentMethodProvider.addListener(_creditCardProviderListener);

      _keicyProgressDialog = KeicyProgressDialog.of(
        context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        layout: Layout.Column,
        padding: EdgeInsets.zero,
        width: widget.creditCardPageStyles.widthDp * 120,
        height: widget.creditCardPageStyles.widthDp * 120,
        progressWidget: Container(
          width: widget.creditCardPageStyles.widthDp * 120,
          height: widget.creditCardPageStyles.widthDp * 120,
          padding: EdgeInsets.all(widget.creditCardPageStyles.widthDp * 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.creditCardPageStyles.widthDp * 10),
          ),
          child: SpinKitFadingCircle(
            color: AppColors.primaryColor,
            size: widget.creditCardPageStyles.widthDp * 80,
          ),
        ),
        message: "",
      );
    });
  }

  void _creditCardProviderListener() async {
    if (_paymentMethodProvider.paymentMethodState.progressState != 1 && _keicyProgressDialog.isShowing()) {
      await _keicyProgressDialog.hide();
    }

    switch (_paymentMethodProvider.paymentMethodState.progressState) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: 'Successfully added',
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.creditCardPageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.creditCardPageStyles.widthDp * 80),
          padding: EdgeInsets.all(widget.creditCardPageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.check_circle_outline,
            color: AppColors.primaryColor,
            size: widget.creditCardPageStyles.widthDp * 80,
          ),
          blurPower: 3,
          backgroundColor: Colors.white,
        );

        Navigator.of(context).pop();

        break;
      case -1:
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: _paymentMethodProvider.paymentMethodState.errorString,
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.creditCardPageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.creditCardPageStyles.widthDp * 80),
          padding: EdgeInsets.all(widget.creditCardPageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.error_outline,
            color: Colors.redAccent,
            size: widget.creditCardPageStyles.widthDp * 80,
          ),
          blurPower: 3,
          backgroundColor: Colors.white,
        );

        break;
      default:
    }
  }

  @override
  void dispose() {
    try {
      _paymentMethodProvider.removeListener(_creditCardProviderListener);
    } catch (e) {}

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KeicyCardDetectProvider()),
        ChangeNotifierProvider(create: (_) => PaymentMethodProvider()),
      ],
      child: Builder(builder: (context) {
        _paymentMethodProvider = PaymentMethodProvider.of(context);

        return _containerBody(context);
      }),
    );
  }

  Widget _containerBody(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: widget.creditCardPageStyles.deviceWidth * 0.8,
        height: widget.creditCardPageStyles.editCardHeight,
        padding: EdgeInsets.symmetric(
          horizontal: widget.creditCardPageStyles.editCardHorizontalPadding,
          vertical: widget.creditCardPageStyles.editCardVerticalPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: widget.creditCardPageStyles.widthDp * 30,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (widget.isAddCard) ? CreditCardPageString.addCardTitle : CreditCardPageString.viewCardTitle,
                        style: widget.creditCardPageStyles.editCardTitleStyle,
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    child: Consumer<KeicyCardDetectProvider>(builder: (context, keicyCardDetectProvider, _) {
                      widget.creditCard.brand = "";
                      if (keicyCardDetectProvider.cardType == null || keicyCardDetectProvider.cardType == CreditCardType.unknown) return SizedBox();
                      widget.creditCard.brand = keicyCardDetectProvider.typeString;
                      return Image.asset(
                        "lib/Assets/Images/Cards/${keicyCardDetectProvider.typeString}.png",
                        height: widget.creditCardPageStyles.widthDp * 30,
                        fit: BoxFit.fitHeight,
                      );
                    }),
                  ),
                ],
              ),
            ),
            TextFormField(
              focusNode: _cardNumberFocusNode,
              controller: _cardNumberController,
              style: widget.creditCardPageStyles.editCardTextStyle,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              textAlignVertical: TextAlignVertical.center,
              inputFormatters: [
                MaskTextInputFormatter(mask: 'xxxx-xxxx-xxxx-xxxx', filter: {'x': RegExp(r'[0-9]')}),
              ],
              decoration: new InputDecoration(
                hintText: '4242-4242-4242-4242',
                hintStyle: widget.creditCardPageStyles.editCardHintStyle,
                prefixIcon: Icon(Icons.credit_card),
                filled: true,
                isDense: true,
                isCollapsed: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.blackColor, width: 2)),
              ),
              onChanged: (input) {
                KeicyCardDetectProvider.of(context).detectCardType(input.trim());
              },
              onFieldSubmitted: (input) {
                FocusScope.of(context).requestFocus(_expDateFocusNode);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return CreditCardPageString.emptyCardErrorString;
                } else if (value.replaceAll("-", '').length != 16) {
                  return CreditCardPageString.incorrectCardErrorString;
                }
                return null;
              },
              onSaved: (input) {
                widget.creditCard.number = input.trim().replaceAll(" ", '');
              },
            ),
            TextFormField(
              focusNode: _expDateFocusNode,
              controller: _expDateController,
              style: widget.creditCardPageStyles.editCardTextStyle,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                MaskTextInputFormatter(mask: '##/####', filter: {'#': RegExp(r'[0-9]')}),
              ],
              decoration: new InputDecoration(
                hintText: 'MM/YYYY',
                hintStyle: widget.creditCardPageStyles.editCardHintStyle,
                prefixIcon: Icon(Icons.calendar_today),
                filled: true,
                isDense: true,
                isCollapsed: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.blackColor, width: 2)),
              ),
              onFieldSubmitted: (input) {
                FocusScope.of(context).requestFocus(_cvcFocusNode);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return CreditCardPageString.emptyExpiredErrorString;
                } else if (value.replaceAll("/", '').length != 6) {
                  return CreditCardPageString.incorrectExpiredErrorString;
                }
                return null;
              },
              onSaved: (input) {
                widget.creditCard.expMonth = int.parse(input.replaceAll("/", '').substring(0, 2));
                widget.creditCard.expYear = int.parse(input.replaceAll("/", '').substring(2));
              },
            ),
            TextFormField(
              focusNode: _cvcFocusNode,
              controller: _cvcController,
              style: widget.creditCardPageStyles.editCardTextStyle,
              keyboardType: TextInputType.number,
              inputFormatters: [
                MaskTextInputFormatter(mask: '###', filter: {'#': RegExp(r'[0-9]')}),
              ],
              textAlignVertical: TextAlignVertical.center,
              decoration: new InputDecoration(
                hintText: 'CVC',
                hintStyle: widget.creditCardPageStyles.editCardHintStyle,
                prefixIcon: Icon(FontAwesomeIcons.solidCreditCard),
                filled: true,
                isDense: true,
                isCollapsed: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.blackColor, width: 2)),
              ),
              onFieldSubmitted: (input) {
                // FocusScope.of(context).requestFocus(_cvcFocusNode);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return CreditCardPageString.emptyCVCErrorString;
                }
                return null;
              },
              onSaved: (input) {
                widget.creditCard.cvc = input.trim();
              },
            ),
            SizedBox(
              width: widget.creditCardPageStyles.widthDp * 200,
              child: RaisedButton(
                color: (widget.isAddCard) ? AppColors.primaryColor : Colors.transparent,
                elevation: 0,
                onPressed: () {
                  _saveHandler(context);
                },
                child: Text((widget.isAddCard) ? CreditCardPageString.addCardTitle : '', style: widget.creditCardPageStyles.editCardButtonStyle),
              ),
            ),
            Consumer<PaymentMethodProvider>(
              builder: (context, paymentMethodProvider, _) {
                return (paymentMethodProvider.paymentMethodState.errorString == "")
                    ? SizedBox()
                    : Column(
                        children: [
                          SizedBox(height: widget.creditCardPageStyles.widthDp * 5),
                          Text(
                            paymentMethodProvider.paymentMethodState.errorString,
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveHandler(BuildContext context) async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    FocusScope.of(context).requestFocus(new FocusNode());
    await _keicyProgressDialog.show();
    _paymentMethodProvider.setPaymentMethodState(
      _paymentMethodProvider.paymentMethodState.update(progressState: 1),
    );
    _paymentMethodProvider.savePaymentMethod(
      UserProvider.of(context),
      widget.creditCard,
      widget.isAddCard,
      widget.index,
    );
  }
}
