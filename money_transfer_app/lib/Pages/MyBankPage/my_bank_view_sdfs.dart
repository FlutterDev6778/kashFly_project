import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:keicy_dropdown_form_field/keicy_dropdown_form_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:money_transfer_app/Pages/Components/header_widget.dart';
import 'package:money_transfer_app/Pages/Components/searchable_dropdown.dart';
import 'package:money_transfer_app/Providers/PinCodeProvider/index.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';
import 'package:keicy_inkwell/keicy_inkwell.dart';
import 'package:keicy_text_form_field/keicy_text_form_field.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';
import 'package:keicy_utils/validators.dart';
import 'package:keicy_card_detect_provider/keicy_card_detect_provider.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class MyBankView extends StatefulWidget {
  final MyBankPageStyles myBankPageStyles;
  final bool isNewInfo;

  const MyBankView({
    Key key,
    @required this.myBankPageStyles,
    @required this.isNewInfo,
  }) : super(key: key);

  @override
  _MyBankViewState createState() => _MyBankViewState();
}

class _MyBankViewState extends State<MyBankView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expDateController = TextEditingController();
  TextEditingController _cvcController = TextEditingController();
  TextEditingController _zipController = TextEditingController();

  final FocusNode _cardNumberFocusNode = FocusNode();
  final FocusNode _expDateFocusNode = FocusNode();
  final FocusNode _cvcFocusNode = FocusNode();
  final FocusNode _zipFocusNode = FocusNode();

  CreditCard _creditCard;

  KeicyProgressDialog _keicyProgressDialog;

  AuthProvider _authProvider;
  UserProvider _userProvider;
  PaymentMethodProvider _paymentMethodProvider;

  @override
  void initState() {
    super.initState();

    _userProvider = UserProvider.of(context);
    _authProvider = AuthProvider.of(context);
    _paymentMethodProvider = PaymentMethodProvider.of(context);

    _authProvider.setAuthState(
      _authProvider.authState.update(progressState: 0, errorString: ""),
      isNotifiable: false,
    );
    _userProvider.setUserState(
      _userProvider.userState.update(progressState: 0, errorString: ""),
      isNotifiable: false,
    );

    _creditCard = CreditCard();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _paymentMethodProvider.addListener(_creditCardProviderListener);

      _keicyProgressDialog = KeicyProgressDialog.of(
        context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        layout: Layout.Column,
        padding: EdgeInsets.zero,
        width: widget.myBankPageStyles.widthDp * 120,
        height: widget.myBankPageStyles.widthDp * 120,
        progressWidget: Container(
          width: widget.myBankPageStyles.widthDp * 120,
          height: widget.myBankPageStyles.widthDp * 120,
          padding: EdgeInsets.all(widget.myBankPageStyles.widthDp * 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.myBankPageStyles.widthDp * 10),
          ),
          child: SpinKitFadingCircle(
            color: AppColors.primaryColor,
            size: widget.myBankPageStyles.widthDp * 80,
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
        _authProvider.setAuthState(
          _authProvider.authState.update(authStatement: AuthStatement.IsLogin, errorString: ""),
          isNotifiable: false,
        );

        if (widget.isNewInfo) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.BottomNavbar,
            (route) => false,
          );
        } else {
          Navigator.of(context).pop();
        }
        break;
      case -1:
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: _paymentMethodProvider.paymentMethodState.errorString,
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.myBankPageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.myBankPageStyles.widthDp * 80),
          padding: EdgeInsets.all(widget.myBankPageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.error_outline,
            color: Colors.redAccent,
            size: widget.myBankPageStyles.widthDp * 80,
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.scaffoldBackColor2,
      body: Container(
        height: widget.myBankPageStyles.mainHeight,
        child: KeicyInkWell(
          onTap: () {},
          child: Column(
            children: [
              HeaderWidget(
                title: MyBankPageString.title,
                widthDp: widget.myBankPageStyles.widthDp,
                fontSp: widget.myBankPageStyles.fontSp,
                haveBackIcon: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: _containerForm(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _containerForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.myBankPageStyles.widthDp * 20,
        vertical: widget.myBankPageStyles.widthDp * 30,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Card Number
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: KeicyTextFormField(
                    width: null,
                    height: widget.myBankPageStyles.formFieldHeight,
                    widthDp: widget.myBankPageStyles.widthDp,
                    controller: _cardNumberController,
                    focusNode: _cardNumberFocusNode,
                    labelSpacing: widget.myBankPageStyles.widthDp * 14,
                    fillColor: Colors.transparent,
                    borderRadius: widget.myBankPageStyles.borderRadius,
                    border: Border.all(color: Colors.transparent),
                    errorBorder: Border.all(color: Colors.redAccent),
                    contentHorizontalPadding: widget.myBankPageStyles.widthDp * 15,
                    textStyle: widget.myBankPageStyles.formFieldTextStyle,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      MaskTextInputFormatter(mask: 'xxxx-xxxx-xxxx-xxxx', filter: {'x': RegExp(r'[0-9]')}),
                    ],
                    fixedHeightState: false,
                    hintText: MyBankPageString.cardNumberHint,
                    hintStyle: widget.myBankPageStyles.formFieldHintStyle,
                    validatorHandler: (value) {
                      if (value.isEmpty) {
                        return " ";
                      } else if (value.replaceAll("-", '').length != 16) {
                        return " ";
                      }
                      return null;
                    },
                    onChangeHandler: (input) {
                      KeicyCardDetectProvider.of(context).detectCardType(input.trim());
                    },
                    onFieldSubmittedHandler: (input) {
                      FocusScope.of(context).requestFocus(_expDateFocusNode);
                    },
                    onSaveHandler: (input) {
                      _creditCard.number = input.trim().replaceAll(" ", '');
                    },
                  ),
                ),
                Consumer<KeicyCardDetectProvider>(
                  builder: (context, keicyCardDetectProvider, _) {
                    if (keicyCardDetectProvider.cardType == null || keicyCardDetectProvider.cardType == CreditCardType.unknown) return SizedBox();
                    _creditCard.brand = keicyCardDetectProvider.typeString;
                    return Container(
                      height: widget.myBankPageStyles.formFieldHeight,
                      alignment: Alignment.center,
                      child: Image.asset(
                        "lib/Assets/Images/Cards/${keicyCardDetectProvider.typeString}.png",
                        height: widget.myBankPageStyles.formFieldHeight * 0.5,
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: widget.myBankPageStyles.widthDp * 15),

            Row(
              children: [
                Expanded(
                  child: KeicyTextFormField(
                    width: null,
                    height: widget.myBankPageStyles.formFieldHeight,
                    widthDp: widget.myBankPageStyles.widthDp,
                    controller: _expDateController,
                    focusNode: _expDateFocusNode,
                    labelSpacing: widget.myBankPageStyles.widthDp * 14,
                    fillColor: Colors.transparent,
                    borderRadius: widget.myBankPageStyles.borderRadius,
                    border: Border.all(color: Colors.transparent),
                    errorBorder: Border.all(color: Colors.redAccent),
                    contentHorizontalPadding: widget.myBankPageStyles.widthDp * 15,
                    textStyle: widget.myBankPageStyles.formFieldTextStyle,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      MaskTextInputFormatter(mask: '##/##', filter: {'#': RegExp(r'[0-9]')}),
                    ],
                    hintText: MyBankPageString.expHint,
                    hintStyle: widget.myBankPageStyles.formFieldHintStyle,
                    validatorHandler: (value) {
                      if (value.isEmpty) {
                        return " ";
                      } else if (value.replaceAll("/", '').length != 4) {
                        return " ";
                      }
                      return null;
                    },
                    onFieldSubmittedHandler: (input) {
                      FocusScope.of(context).requestFocus(_cvcFocusNode);
                    },
                    onSaveHandler: (input) {
                      _creditCard.expMonth = int.parse(input.replaceAll("/", '').substring(0, 2));
                      _creditCard.expYear = int.parse(input.replaceAll("/", '').substring(2));
                    },
                  ),
                ),
                SizedBox(width: widget.myBankPageStyles.widthDp * 5),
                Expanded(
                  child: KeicyTextFormField(
                    width: null,
                    height: widget.myBankPageStyles.formFieldHeight,
                    widthDp: widget.myBankPageStyles.widthDp,
                    controller: _cvcController,
                    focusNode: _cvcFocusNode,
                    labelSpacing: widget.myBankPageStyles.widthDp * 14,
                    fillColor: Colors.transparent,
                    borderRadius: widget.myBankPageStyles.borderRadius,
                    border: Border.all(color: Colors.transparent),
                    errorBorder: Border.all(color: Colors.redAccent),
                    contentHorizontalPadding: widget.myBankPageStyles.widthDp * 15,
                    textStyle: widget.myBankPageStyles.formFieldTextStyle,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      MaskTextInputFormatter(mask: '###', filter: {'#': RegExp(r'[0-9]')}),
                    ],
                    hintText: MyBankPageString.cvcHint,
                    hintStyle: widget.myBankPageStyles.formFieldHintStyle,
                    validatorHandler: (value) {
                      if (value.isEmpty) {
                        return " ";
                      } else if (value.length != 3) {
                        return " ";
                      }
                      return null;
                    },
                    onFieldSubmittedHandler: (input) {
                      FocusScope.of(context).requestFocus(_zipFocusNode);
                    },
                    onSaveHandler: (input) {
                      _creditCard.cvc = input.trim();
                    },
                  ),
                ),
                SizedBox(width: widget.myBankPageStyles.widthDp * 5),
                Expanded(
                  child: KeicyTextFormField(
                    width: null,
                    height: widget.myBankPageStyles.formFieldHeight,
                    widthDp: widget.myBankPageStyles.widthDp,
                    controller: _zipController,
                    focusNode: _zipFocusNode,
                    labelSpacing: widget.myBankPageStyles.widthDp * 14,
                    fillColor: Colors.transparent,
                    borderRadius: widget.myBankPageStyles.borderRadius,
                    border: Border.all(color: Colors.transparent),
                    errorBorder: Border.all(color: Colors.redAccent),
                    contentHorizontalPadding: widget.myBankPageStyles.widthDp * 15,
                    textStyle: widget.myBankPageStyles.formFieldTextStyle,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    hintText: MyBankPageString.zipCodeHint,
                    hintStyle: widget.myBankPageStyles.formFieldHintStyle,
                    validatorHandler: (value) {
                      if (value.isEmpty) {
                        return " ";
                      }
                      return null;
                    },
                    onFieldSubmittedHandler: (input) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    onSaveHandler: (input) {
                      _creditCard.addressZip = input.trim();
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: widget.myBankPageStyles.widthDp * 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: widget.myBankPageStyles.widthDp * 20),
              child: Row(
                children: [
                  (widget.isNewInfo)
                      ? Expanded(
                          child: KeicyRaisedButton(
                            height: widget.myBankPageStyles.formFieldHeight,
                            color: Colors.transparent,
                            elevation: 0,
                            borderRadius: widget.myBankPageStyles.borderRadius,
                            child: Text(
                              MyBankPageString.skipLink,
                              style: widget.myBankPageStyles.buttonTextStyle.copyWith(color: AppColors.blackColor),
                            ),
                            onPressed: () {
                              _authProvider.setAuthState(
                                _authProvider.authState.update(authStatement: AuthStatement.IsLogin, errorString: ""),
                                isNotifiable: false,
                              );

                              Navigator.of(context).pushNamedAndRemoveUntil(
                                AppRoutes.BottomNavbar,
                                (route) => false,
                              );
                            },
                          ),
                        )
                      : SizedBox(),
                  (widget.isNewInfo) ? SizedBox(width: widget.myBankPageStyles.widthDp * 15) : SizedBox(),
                  Expanded(
                    child: KeicyRaisedButton(
                      height: widget.myBankPageStyles.formFieldHeight,
                      color: AppColors.primaryColor,
                      elevation: 0,
                      borderRadius: widget.myBankPageStyles.borderRadius,
                      child: Text(
                        MyBankPageString.saveButton,
                        style: widget.myBankPageStyles.buttonTextStyle,
                      ),
                      onPressed: () {
                        _saveHandler(context);
                      },
                    ),
                  ),
                ],
              ),
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
      _userProvider,
      _creditCard,
      true,
      null,
    );
  }
}
