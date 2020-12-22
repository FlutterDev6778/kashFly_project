import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:money_transfer_app/Pages/Components/index.dart';
import 'package:money_transfer_app/Pages/PinCodePage/pin_code_page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';

import 'package:keicy_inkwell/keicy_inkwell.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';
import 'package:keicy_utils/validators.dart';
import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Providers/index.dart';
import 'package:money_transfer_app/Pages/LoginPage/Styles/string.dart';

import 'index.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({
    Key key,
    @required this.verificationPageStyles,
    @required this.firstName,
    @required this.middleName,
    @required this.lastName,
    @required this.phoneNumber,
  }) : super(key: key);

  final String firstName;
  final String lastName;
  final String middleName;
  final String phoneNumber;
  final VerificationPageStyles verificationPageStyles;

  @override
  _VerificationViewState createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  AuthProvider _authProvider;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  KeicyProgressDialog _keicyProgressDialog;
  PhoneVerificationProvider _phoneVerificationProvider;
  final _pinCodeController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isPresessed;

  @override
  void dispose() {
    _phoneVerificationProvider.removeListener(_phoneVerificationProviderListener);
    _authProvider.removeListener(_authProviderListener);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _phoneVerificationProvider = PhoneVerificationProvider.of(context);
    _authProvider = AuthProvider.of(context);

    isPresessed = false;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _phoneVerificationProvider.addListener(_phoneVerificationProviderListener);
      _authProvider.addListener(_authProviderListener);

      _keicyProgressDialog = KeicyProgressDialog.of(
        context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        layout: Layout.Column,
        padding: EdgeInsets.zero,
        width: widget.verificationPageStyles.widthDp * 120,
        height: widget.verificationPageStyles.widthDp * 120,
        progressWidget: Container(
          width: widget.verificationPageStyles.widthDp * 120,
          height: widget.verificationPageStyles.widthDp * 120,
          padding: EdgeInsets.all(widget.verificationPageStyles.widthDp * 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.verificationPageStyles.widthDp * 10),
          ),
          child: SpinKitFadingCircle(
            color: AppColors.primaryColor,
            size: widget.verificationPageStyles.widthDp * 80,
          ),
        ),
        message: "",
      );
    });
  }

  void _authProviderListener() async {
    if (_authProvider.authState.progressState == 2) {
      _phoneVerificationProvider.confirmPhoneVerification(
        authProvider: _authProvider,
        firstName: widget.firstName,
      );
    } else if (_authProvider.authState.progressState == -1) {
      _phoneVerificationProvider.setPhoneVerificationState(
        _phoneVerificationProvider.phoneVerificationState.update(
          progressState: -1,
          errorString: _authProvider.authState.errorString,
        ),
      );
    }
  }

  void _phoneVerificationProviderListener() async {
    if (_phoneVerificationProvider.phoneVerificationState.progressState != 1 && _keicyProgressDialog.isShowing()) {
      await _keicyProgressDialog.hide();
    }

    switch (_phoneVerificationProvider.phoneVerificationState.progressState) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        isPresessed = false;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => PinCodePage(
              isNewPinCode: true,
              firstName: widget.firstName,
              middleName: widget.middleName,
              lastName: widget.lastName,
              phoneNumber: widget.phoneNumber,
            ),
          ),
          (route) => false,
        );
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (BuildContext context) => PinCodePage(
        //       isNewPinCode: true,
        //       firstName: widget.firstName,
        //       middleName: widget.middleName,
        //       lastName: widget.lastName,
        //       phoneNumber: widget.phoneNumber,
        //     ),
        //   ),
        // );
        break;
      case -1:
        isPresessed = false;
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: _phoneVerificationProvider.phoneVerificationState.errorString,
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.verificationPageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.verificationPageStyles.widthDp * 60),
          padding: EdgeInsets.all(widget.verificationPageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.error_outline,
            color: Colors.redAccent,
            size: widget.verificationPageStyles.widthDp * 80,
          ),
          blurPower: 3,
          backgroundColor: Colors.white,
        );

        Navigator.of(context).pop();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: widget.verificationPageStyles.mainHeight,
        child: KeicyInkWell(
          onTap: () {},
          child: Column(
            children: [
              // HeaderWidget(
              //   title: VerificationPageString.title + (widget?.phoneNumber ?? ""),
              //   widthDp: widget.verificationPageStyles.widthDp,
              //   fontSp: widget.verificationPageStyles.fontSp,
              //   haveBackIcon: true,
              // ),
              SizedBox(height: widget.verificationPageStyles.widthDp * 40),
              Expanded(child: _containerForm(context)),
              CustomNumberKeyboard(
                backColor: Colors.transparent,
                foreColor: AppColors.blackColor,
                fontSize: widget.verificationPageStyles.fontSp * 24,
                iconSize: widget.verificationPageStyles.widthDp * 24,
                keyHorizontalPadding: widget.verificationPageStyles.widthDp * 45,
                keyVerticalPadding: widget.verificationPageStyles.widthDp * 20,
                type: -1,
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
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: widget.verificationPageStyles.formPanelHorizontalPadding,
        vertical: widget.verificationPageStyles.formPanelVerticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            VerificationPageString.label + (widget?.phoneNumber ?? ""),
            style: widget.verificationPageStyles.labelStyle,
          ),
          SizedBox(height: widget.verificationPageStyles.widthDp * 33),
          PinCodeTextField(
            length: 6,
            keyboardType: TextInputType.number,
            textStyle: widget.verificationPageStyles.pinCodeTextStyle,
            pastedTextStyle: widget.verificationPageStyles.pinCodeTextStyle,
            enablePinAutofill: false,
            autoDismissKeyboard: false,
            autoFocus: true,
            animationType: AnimationType.fade,
            enableActiveFill: true,
            readOnly: true,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(widget.verificationPageStyles.widthDp * 10),
              fieldHeight: widget.verificationPageStyles.widthDp * 50,
              fieldWidth: widget.verificationPageStyles.widthDp * 40,
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
            onCompleted: (v) {
              if (isPresessed) return;
              isPresessed = true;
              _verificationHandler(context);
              print("Completed");
            },
            onChanged: (value) {
              print(value);
            },
            beforeTextPaste: (text) {
              print("Allowing to paste $text");
              return true;
            },
            appContext: context,
          ),
          SizedBox(height: widget.verificationPageStyles.widthDp * 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                VerificationPageString.resendDescription,
                style: widget.verificationPageStyles.descriptionTextStyle,
              ),
              new InkWell(
                onTap: () {
                  _resendCodeHandler(context);
                },
                child: new Text(VerificationPageString.resendLink, style: widget.verificationPageStyles.linkTextStyle),
              ),
            ],
          ),
          SizedBox(height: widget.verificationPageStyles.heightDp * 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                VerificationPageString.wrongDescription,
                style: widget.verificationPageStyles.descriptionTextStyle,
              ),
              new InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: new Text(VerificationPageString.wrongLink, style: widget.verificationPageStyles.linkTextStyle),
              ),
            ],
          ),
          // SizedBox(height: widget.verificationPageStyles.widthDp * 45),
          // KeicyRaisedButton(
          //   height: widget.verificationPageStyles.widthDp * 50,
          //   color: AppColors.secondaryColor,
          //   borderRadius: widget.verificationPageStyles.widthDp * 20,
          //   elevation: 0,
          //   child: Text(
          //     VerificationPageString.verificationButton,
          //     style: widget.verificationPageStyles.buttonTextStyle,
          //   ),
          //   onPressed: () {
          //     _verificationHandler(context);
          //   },
          // ),
        ],
      ),
    );
  }

  void _verificationHandler(BuildContext context) async {
    if (_phoneVerificationProvider.phoneVerificationState.progressState == 1) return;
    _phoneVerificationProvider.setPhoneVerificationState(
      _phoneVerificationProvider.phoneVerificationState.update(progressState: 1, errorString: ""),
    );
    await _keicyProgressDialog.show();

    _phoneVerificationProvider.setPhoneVerificationState(
      _phoneVerificationProvider.phoneVerificationState.update(progressState: 1, errorString: ""),
    );

    _authProvider.confirmPhoneVerification(smsCode: _pinCodeController.text.trim());
  }

  void _resendCodeHandler(BuildContext context) async {
    AuthProvider.of(context).phoneVerification(widget.phoneNumber);
  }
}
