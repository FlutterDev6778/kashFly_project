import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:money_transfer_app/Pages/Components/index.dart';
import 'package:money_transfer_app/Pages/LoginPage/index.dart';
import 'package:money_transfer_app/Pages/MyInfoPage/index.dart';
import 'package:money_transfer_app/Providers/PinCodeProvider/index.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';

import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';
import 'package:keicy_inkwell/keicy_inkwell.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';
import 'package:keicy_utils/validators.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Providers/index.dart';
import 'package:money_transfer_app/Pages/LoginPage/Styles/string.dart';

import 'index.dart';

class PinCodeView extends StatefulWidget {
  final PinCodePageStyles pinCodePageStyles;
  final bool isNewPinCode;
  final String firstName;
  final String middleName;
  final String lastName;
  final String phoneNumber;

  const PinCodeView({
    Key key,
    @required this.pinCodePageStyles,
    @required this.isNewPinCode,
    @required this.firstName,
    @required this.middleName,
    @required this.lastName,
    @required this.phoneNumber,
  }) : super(key: key);

  @override
  _PinCodeViewState createState() => _PinCodeViewState();
}

class _PinCodeViewState extends State<PinCodeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextEditingController _pinCodeController = TextEditingController();
  FocusNode _pinCodeFocusNode = FocusNode();

  PinCodeProvider _pinCodeProvider;
  KeicyProgressDialog _keicyProgressDialog;

  AuthProvider _authProvider;
  bool isPresessed;

  @override
  void initState() {
    super.initState();

    _authProvider = AuthProvider.of(context);
    _authProvider.setAuthState(
      _authProvider.authState.update(progressState: 0, errorString: ""),
      isNotifiable: false,
    );
    _pinCodeProvider = PinCodeProvider.of(context);
    isPresessed = false;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pinCodeProvider.addListener(_pincodeProviderListener);

      _keicyProgressDialog = KeicyProgressDialog.of(
        context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        layout: Layout.Column,
        padding: EdgeInsets.zero,
        width: widget.pinCodePageStyles.widthDp * 120,
        height: widget.pinCodePageStyles.widthDp * 120,
        progressWidget: Container(
          width: widget.pinCodePageStyles.widthDp * 120,
          height: widget.pinCodePageStyles.widthDp * 120,
          padding: EdgeInsets.all(widget.pinCodePageStyles.widthDp * 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.pinCodePageStyles.widthDp * 10),
          ),
          child: SpinKitFadingCircle(
            color: AppColors.primaryColor,
            size: widget.pinCodePageStyles.widthDp * 80,
          ),
        ),
        message: "",
      );
    });
  }

  @override
  void dispose() {
    _pinCodeProvider.removeListener(_pincodeProviderListener);

    super.dispose();
  }

  void _pincodeProviderListener() async {
    if (_pinCodeProvider.pinCodeState.progressState != 1 && _keicyProgressDialog.isShowing()) {
      await _keicyProgressDialog.hide();
    }

    switch (_pinCodeProvider.pinCodeState.progressState) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        isPresessed = false;
        Navigator.of(context).pushReplacementNamed(AppRoutes.BottomNavbar);
        break;
      case -1:
        isPresessed = false;
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: _pinCodeProvider.pinCodeState.errorString,
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.pinCodePageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.pinCodePageStyles.widthDp * 60),
          padding: EdgeInsets.all(widget.pinCodePageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.error_outline,
            color: Colors.redAccent,
            size: widget.pinCodePageStyles.widthDp * 80,
          ),
          blurPower: 3,
          backgroundColor: Colors.white,
        );
        Future.delayed(Duration(seconds: 2), () {
          _pinCodeController.clear();
          FocusScope.of(context).requestFocus(_pinCodeFocusNode);
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.whiteColor,
      body: Container(
        height: widget.pinCodePageStyles.mainHeight,
        child: KeicyInkWell(
          onTap: () {},
          child: Column(
            children: [
              HeaderWidget(
                title: widget.isNewPinCode ? PinCodePageString.createTitle : PinCodePageString.inputTitle,
                widthDp: widget.pinCodePageStyles.widthDp,
                fontSp: widget.pinCodePageStyles.fontSp,
                haveBackIcon: false,
              ),
              Expanded(child: _containerForm(context)),
              CustomNumberKeyboard(
                backColor: Colors.transparent,
                foreColor: AppColors.blackColor,
                fontSize: widget.pinCodePageStyles.fontSp * 24,
                iconSize: widget.pinCodePageStyles.widthDp * 24,
                keyHorizontalPadding: widget.pinCodePageStyles.widthDp * 45,
                keyVerticalPadding: widget.pinCodePageStyles.widthDp * 20,
                type: 0,
                forgottenFunction: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) => LoginPage(selectedTap: 0)),
                  );
                },
                onPress: (value) {
                  _pinCodeController.text = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _containerForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widget.pinCodePageStyles.widthDp * 25),
      child: Column(
        children: [
          SizedBox(height: widget.pinCodePageStyles.widthDp * 60),
          Form(
            key: _formKey,
            child: PinCodeTextField(
              focusNode: _pinCodeFocusNode,
              length: 4,
              keyboardType: TextInputType.number,
              textStyle: widget.pinCodePageStyles.pinCodeTextStyle,
              pastedTextStyle: widget.pinCodePageStyles.pastedTextStyle,
              autoDismissKeyboard: false,
              animationType: AnimationType.fade,
              autoFocus: true,
              enableActiveFill: true,
              enablePinAutofill: false,
              readOnly: true,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(widget.pinCodePageStyles.widthDp * 20),
                fieldHeight: widget.pinCodePageStyles.widthDp * 60,
                fieldWidth: widget.pinCodePageStyles.widthDp * 60,
                activeColor: Colors.transparent,
                inactiveColor: Colors.transparent,
                selectedColor: Colors.transparent,
                selectedFillColor: Color(0xFF0BA4F2),
                inactiveFillColor: Color(0xFFF0F2F7),
                activeFillColor: Color(0xFFF0F2F7),
              ),
              animationDuration: Duration(milliseconds: 300),
              backgroundColor: Colors.transparent,
              // errorAnimationController: errorController,
              controller: _pinCodeController,
              onCompleted: (value) async {
                if (isPresessed) return;
                isPresessed = true;
                _pinCodeHandler(context);
              },
              onChanged: (value) {},
              validator: (value) => (value.length != 4) ? "Please input 4 digits" : null,
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                return true;
              },
              appContext: context,
            ),
          ),
          (widget.isNewPinCode)
              ? SizedBox()
              : Column(
                  children: [
                    SizedBox(height: widget.pinCodePageStyles.widthDp * 30),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     new Text(
                    //       PinCodePageString.loginDescription,
                    //       style: widget.pinCodePageStyles.descriptionTextStyle,
                    //     ),
                    //     new InkWell(
                    //       onTap: () {
                    //         Navigator.of(context).pushReplacement(
                    //           MaterialPageRoute(builder: (BuildContext context) => LoginPage(selectedTap: 0)),
                    //         );
                    //       },
                    //       child: new Text(PinCodePageString.loginLink, style: widget.pinCodePageStyles.linkTextStyle),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: widget.pinCodePageStyles.widthDp * 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          PinCodePageString.registerDescription,
                          style: widget.pinCodePageStyles.descriptionTextStyle,
                        ),
                        new InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (BuildContext context) => LoginPage(selectedTap: 1)),
                            );
                          },
                          child: new Text(
                            PinCodePageString.registerLink,
                            style: widget.pinCodePageStyles.linkTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  void _pinCodeHandler(BuildContext context) async {
    if (_pinCodeController.text.trim() == "" || _pinCodeProvider.pinCodeState.progressState == 1) return;

    FocusScope.of(context).requestFocus(FocusNode());

    if (widget.firstName == "" || widget.firstName == null) {
      _pinCodeProvider.setPinCodeState(
        _pinCodeProvider.pinCodeState.update(progressState: 1),
      );
      await _keicyProgressDialog.show();

      _pinCodeProvider.loginWithPinCode(
        authProvider: _authProvider,
        userProvider: UserProvider.of(context),
        pinCode: _pinCodeController.text.trim(),
        isNewPinCode: widget.isNewPinCode,
      );
    } else {
      UserModel _userModel = UserModel();
      _userModel.pinCode = _pinCodeController.text.trim();
      _userModel.firstName = widget.firstName;
      _userModel.middleName = widget.middleName;
      _userModel.lastName = widget.lastName;
      _userModel.phoneNumber = widget.phoneNumber;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => MyInfoPage(userModel: _userModel),
        ),
      );
    }
  }
}
