import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:money_transfer_app/Pages/Components/index.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';

import 'package:keicy_raised_button/keicy_raised_button.dart';
import 'package:keicy_inkwell/keicy_inkwell.dart';
import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';
import 'package:keicy_utils/date_time_convert.dart';
import 'package:keicy_utils/validators.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class ChangePinCodeView extends StatefulWidget {
  final ChangePinCodePageStyles changePinCodePageStyles;

  const ChangePinCodeView({
    Key key,
    this.changePinCodePageStyles,
  }) : super(key: key);

  @override
  _ChangePinCodeViewState createState() => _ChangePinCodeViewState();
}

class _ChangePinCodeViewState extends State<ChangePinCodeView> with TickerProviderStateMixin {
  GlobalKey<FormState> _pinCodeFormKey = GlobalKey<FormState>();

  TextEditingController _pinCodeController = TextEditingController();

  UserProvider _userProvider;
  KeicyProgressDialog _keicyProgressDialog;
  bool isPresessed;

  @override
  void initState() {
    super.initState();
    _userProvider = UserProvider.of(context);

    isPresessed = false;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userProvider.addListener(_userProviderListener);

      _keicyProgressDialog = KeicyProgressDialog.of(
        context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        layout: Layout.Column,
        padding: EdgeInsets.zero,
        width: widget.changePinCodePageStyles.widthDp * 120,
        height: widget.changePinCodePageStyles.widthDp * 120,
        progressWidget: Container(
          width: widget.changePinCodePageStyles.widthDp * 120,
          height: widget.changePinCodePageStyles.widthDp * 120,
          padding: EdgeInsets.all(widget.changePinCodePageStyles.widthDp * 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.changePinCodePageStyles.widthDp * 10),
          ),
          child: SpinKitFadingCircle(
            color: AppColors.primaryColor,
            size: widget.changePinCodePageStyles.widthDp * 80,
          ),
        ),
        message: "",
      );
    });
  }

  @override
  void dispose() {
    _userProvider.removeListener(_userProviderListener);

    super.dispose();
  }

  void _userProviderListener() async {
    if (_userProvider.userState.progressState != 1 && _keicyProgressDialog.isShowing()) {
      await _keicyProgressDialog.hide();
    }

    switch (_userProvider.userState.progressState) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        isPresessed = false;
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: 'Pin Number Successfully saved',
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.changePinCodePageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.changePinCodePageStyles.widthDp * 60),
          padding: EdgeInsets.all(widget.changePinCodePageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.check_circle_outline,
            color: AppColors.primaryColor,
            size: widget.changePinCodePageStyles.widthDp * 80,
          ),
          blurPower: 3,
          backgroundColor: Colors.white,
        );

        Navigator.of(context).pop(context);
        break;
      case -1:
        isPresessed = false;
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: _userProvider.userState.errorString,
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.changePinCodePageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.changePinCodePageStyles.widthDp * 60),
          padding: EdgeInsets.all(widget.changePinCodePageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.error_outline,
            color: Colors.redAccent,
            size: widget.changePinCodePageStyles.widthDp * 80,
          ),
          blurPower: 3,
          backgroundColor: Colors.white,
        );

        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeicyInkWell(
        child: Container(
          height: widget.changePinCodePageStyles.mainHeight,
          child: Column(
            children: [
              HeaderWidget(
                title: ChangePinCodePageString.title,
                widthDp: widget.changePinCodePageStyles.widthDp,
                fontSp: widget.changePinCodePageStyles.fontSp,
                haveBackIcon: true,
              ),
              Expanded(child: _containerPinCode(context)),
              CustomNumberKeyboard(
                backColor: Colors.transparent,
                foreColor: AppColors.blackColor,
                fontSize: widget.changePinCodePageStyles.fontSp * 24,
                iconSize: widget.changePinCodePageStyles.widthDp * 24,
                keyHorizontalPadding: widget.changePinCodePageStyles.widthDp * 45,
                keyVerticalPadding: widget.changePinCodePageStyles.widthDp * 20,
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

  Widget _containerPinCode(BuildContext context) {
    return Form(
      key: _pinCodeFormKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widget.changePinCodePageStyles.widthDp * 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: widget.changePinCodePageStyles.widthDp * 40),

            /// pin code
            PinCodeTextField(
              length: 4,
              keyboardType: TextInputType.number,
              textStyle: widget.changePinCodePageStyles.pinCodeTextStyle,
              pastedTextStyle: widget.changePinCodePageStyles.pinCodeTextStyle,
              enablePinAutofill: false,
              enableActiveFill: true,
              autoDismissKeyboard: false,
              autoFocus: true,
              animationType: AnimationType.fade,
              readOnly: true,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(widget.changePinCodePageStyles.widthDp * 20),
                fieldHeight: widget.changePinCodePageStyles.widthDp * 60,
                fieldWidth: widget.changePinCodePageStyles.widthDp * 60,
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
                print("))))))))))))))))))))))))))");
                _pinCodeController.text = _pinCodeController.text.substring(0, 4);
                _saveHandler(context);
              },
              onChanged: (value) {},
              beforeTextPaste: (text) {
                return true;
              },
              appContext: context,
              validator: (value) => value.length != 4 ? "Please enter 4 digits" : null,
            ),

            // /// button
            // SizedBox(height: widget.changePinCodePageStyles.widthDp * 60),
            // KeicyRaisedButton(
            //   height: widget.changePinCodePageStyles.widthDp * 50,
            //   color: AppColors.secondaryColor,
            //   borderRadius: widget.changePinCodePageStyles.textFieldBorderRadius,
            //   child: Text(
            //     ChangePinCodePageString.savePinCodeButton,
            //     style: widget.changePinCodePageStyles.buttonTextStyle,
            //   ),
            //   onPressed: () {
            //     // _saveHandler(context);
            //   },
            // ),
            // SizedBox(height: widget.changePinCodePageStyles.primaryVerticalPadding),
          ],
        ),
      ),
    );
  }

  void _saveHandler(BuildContext context) async {
    if (_pinCodeController.text.trim() == "") return;

    if (!_pinCodeFormKey.currentState.validate()) {
      print(_pinCodeController.text);
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());

    UserModel _userModel = UserModel.fromJson(_userProvider.userState.userModel.toJson());
    _userModel.pinCode = _pinCodeController.text.trim();

    _userProvider.saveUserData(
      userID: _userProvider.userState.userModel.id,
      userModel: _userModel,
    );
  }
}
