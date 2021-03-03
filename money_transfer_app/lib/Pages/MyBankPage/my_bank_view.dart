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
import 'package:money_transfer_app/Pages/Components/index.dart';

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
  TextEditingController _currentController = TextEditingController();

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

    _currentController = _cardNumberController;

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
          margin: EdgeInsets.all(widget.myBankPageStyles.widthDp * 60),
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
                  child: Column(
                    children: [
                      _containerForm(context),
                      CustomNumberKeyboard(
                        backColor: Colors.transparent,
                        foreColor: AppColors.blackColor,
                        fontSize: widget.myBankPageStyles.fontSp * 24,
                        iconSize: widget.myBankPageStyles.widthDp * 24,
                        keyHorizontalPadding: widget.myBankPageStyles.widthDp * 45,
                        keyVerticalPadding: widget.myBankPageStyles.widthDp * 20,
                        type: -1,
                        onBackspacePress: () {
                          String str;
                          if (_currentController == _cardNumberController) {
                            str = _currentController.text.replaceAll("-", "");
                            str = str.substring(0, str.length - 1);
                          } else if (_currentController == _expDateController) {
                            str = _currentController.text.replaceAll("/", "");
                            str = str.substring(0, str.length - 1);
                          } else if (_currentController == _cvcController) {
                            str = _currentController.text;
                            str = str.substring(0, str.length - 1);
                          } else if (_currentController == _zipController) {
                            str = _currentController.text;
                            str = str.substring(0, str.length - 1);
                          }
                          _editingHandler(str);
                        },
                        onPress: (value) {
                          String str;
                          if (_currentController == _cardNumberController) {
                            str = (_currentController.text.trim() + value.trim()).replaceAll("-", "");
                          } else if (_currentController == _expDateController) {
                            str = (_currentController.text.trim() + value.trim()).replaceAll("/", "");
                          } else if (_currentController == _cvcController) {
                            str = _currentController.text.trim() + value.trim();
                          } else if (_currentController == _zipController) {
                            str = _currentController.text.trim() + value.trim();
                          }
                          _editingHandler(str);
                        },
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: widget.myBankPageStyles.widthDp * 20),
                        child: Row(
                          children: [
                            (widget.isNewInfo)
                                ? Expanded(
                                    child: KeicyRaisedButton(
                                      height: widget.myBankPageStyles.widthDp * 50,
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
                                height: widget.myBankPageStyles.widthDp * 50,
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
                      SizedBox(height: widget.myBankPageStyles.widthDp * 20),
                    ],
                  ),
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
        vertical: widget.myBankPageStyles.widthDp * 30,
        horizontal: widget.myBankPageStyles.widthDp * 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Card Number
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: KeicyTextFormField(
                    width: null,
                    height: widget.myBankPageStyles.formFieldHeight,
                    controller: _cardNumberController,
                    focusNode: _cardNumberFocusNode,
                    labelSpacing: widget.myBankPageStyles.widthDp * 14,
                    fillColor: Colors.transparent,
                    borderRadius: widget.myBankPageStyles.borderRadius,
                    border: Border(
                      bottom: BorderSide(
                        color: (_currentController == _cardNumberController) ? AppColors.primaryColor : Colors.transparent,
                      ),
                    ),
                    errorBorder: Border(bottom: BorderSide(color: Colors.redAccent)),
                    contentHorizontalPadding: widget.myBankPageStyles.widthDp * 15,
                    textStyle: widget.myBankPageStyles.formFieldTextStyle,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      MaskTextInputFormatter(mask: 'xxxx-xxxx-xxxx-xxxx', filter: {'x': RegExp(r'[0-9]')}),
                    ],
                    readOnly: true,
                    fixedHeightState: false,
                    hintText: MyBankPageString.cardNumberHint,
                    hintStyle: widget.myBankPageStyles.formFieldHintStyle,
                    errorStringFontSize: 0,
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
                    onTapHandler: () {
                      setState(() {
                        _currentController = _cardNumberController;
                      });
                    },
                  ),
                ),
                Consumer<KeicyCardDetectProvider>(
                  builder: (context, keicyCardDetectProvider, _) {
                    if (keicyCardDetectProvider.cardType == null || keicyCardDetectProvider.cardType == CreditCardType.unknown) return SizedBox();
                    _creditCard.brand = keicyCardDetectProvider.typeString;
                    return Container(
                      height: widget.myBankPageStyles.widthDp * 30,
                      alignment: Alignment.center,
                      child: Image.asset(
                        "lib/Assets/Images/Cards/${keicyCardDetectProvider.typeString}.png",
                        height: widget.myBankPageStyles.widthDp * 30,
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: widget.myBankPageStyles.widthDp * 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      KeicyTextFormField(
                        width: null,
                        height: widget.myBankPageStyles.formFieldHeight,
                        controller: _expDateController,
                        focusNode: _expDateFocusNode,
                        labelSpacing: widget.myBankPageStyles.widthDp * 14,
                        fillColor: Colors.transparent,
                        borderRadius: widget.myBankPageStyles.borderRadius,
                        border: Border(
                          bottom: BorderSide(
                            color: (_currentController == _expDateController) ? AppColors.primaryColor : Colors.transparent,
                          ),
                        ),
                        errorBorder: Border(bottom: BorderSide(color: Colors.redAccent)),
                        contentHorizontalPadding: widget.myBankPageStyles.widthDp * 15,
                        textStyle: widget.myBankPageStyles.formFieldTextStyle,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          MaskTextInputFormatter(mask: '##/##', filter: {'0': RegExp(r'[0-9]')}),
                        ],
                        readOnly: true,
                        errorStringFontSize: 0,
                        fixedHeightState: false,
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
                        onTapHandler: () {
                          setState(() {
                            _currentController = _expDateController;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: widget.myBankPageStyles.widthDp * 5),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      KeicyTextFormField(
                        width: null,
                        height: widget.myBankPageStyles.formFieldHeight,
                        controller: _cvcController,
                        focusNode: _cvcFocusNode,
                        labelSpacing: widget.myBankPageStyles.widthDp * 14,
                        fillColor: Colors.transparent,
                        borderRadius: widget.myBankPageStyles.borderRadius,
                        border: Border(
                          bottom: BorderSide(
                            color: (_currentController == _cvcController) ? AppColors.primaryColor : Colors.transparent,
                          ),
                        ),
                        errorBorder: Border(bottom: BorderSide(color: Colors.redAccent)),
                        contentHorizontalPadding: widget.myBankPageStyles.widthDp * 15,
                        textStyle: widget.myBankPageStyles.formFieldTextStyle,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          MaskTextInputFormatter(mask: '###', filter: {'0': RegExp(r'[0-9]')}),
                        ],
                        errorStringFontSize: 0,
                        readOnly: true,
                        fixedHeightState: false,
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
                        onTapHandler: () {
                          setState(() {
                            _currentController = _cvcController;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: widget.myBankPageStyles.widthDp * 5),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      KeicyTextFormField(
                        width: null,
                        height: widget.myBankPageStyles.formFieldHeight,
                        controller: _zipController,
                        focusNode: _zipFocusNode,
                        labelSpacing: widget.myBankPageStyles.widthDp * 14,
                        fillColor: Colors.transparent,
                        borderRadius: widget.myBankPageStyles.borderRadius,
                        border: Border(
                          bottom: BorderSide(
                            color: (_currentController == _zipController) ? AppColors.primaryColor : Colors.transparent,
                          ),
                        ),
                        errorBorder: Border(bottom: BorderSide(color: Colors.redAccent)),
                        contentHorizontalPadding: widget.myBankPageStyles.widthDp * 15,
                        textStyle: widget.myBankPageStyles.formFieldTextStyle,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        hintText: MyBankPageString.zipCodeHint,
                        hintStyle: widget.myBankPageStyles.formFieldHintStyle,
                        readOnly: true,
                        errorStringFontSize: 0,
                        fixedHeightState: false,
                        validatorHandler: (value) {
                          // if (value.isEmpty) {
                          //   return " ";
                          // }
                          return null;
                        },
                        onFieldSubmittedHandler: (input) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        onSaveHandler: (input) {
                          _creditCard.addressZip = input.trim();
                        },
                        onTapHandler: () {
                          setState(() {
                            _currentController = _zipController;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editingHandler(String str) {
    setState(() {
      if (_currentController == _cardNumberController) {
        KeicyCardDetectProvider.of(context).detectCardType(str);
        if (str.length <= 4) {
          _currentController.text = str;
        } else if (str.length > 4 && str.length <= 8) {
          _currentController.text = str.substring(0, 4) + "-" + str.substring(4, str.length);
        } else if (str.length > 8 && str.length <= 12) {
          _currentController.text = str.substring(0, 4) + "-" + str.substring(4, 8) + "-" + str.substring(8, str.length);
        } else if (str.length > 12 && str.length <= 16) {
          _currentController.text =
              str.substring(0, 4) + "-" + str.substring(4, 8) + "-" + str.substring(8, 12) + "-" + str.substring(12, str.length);
        }
      } else if (_currentController == _expDateController) {
        if (str.length <= 2) {
          _currentController.text = str;
        } else if (str.length > 2 && str.length <= 4) {
          _currentController.text = str.substring(0, 2) + "/" + str.substring(2, str.length);
        }
      } else if (_currentController == _cvcController) {
        if (str.length <= 3) {
          _currentController.text = str;
        }
      } else if (_currentController == _zipController) {
        _currentController.text = str;
      }
    });
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
