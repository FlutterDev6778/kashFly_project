import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keicy_navigator/keicy_navigator.dart';
import 'package:keicy_text_form_field/keicy_text_form_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:keicy_inkwell/keicy_inkwell.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';
import 'package:keicy_dropdown_form_field/keicy_dropdown_form_field.dart';
import 'package:keicy_utils/validators.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Pages/VerificationPage/index.dart';
import 'package:money_transfer_app/Providers/index.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';

import 'index.dart';

class LoginView extends StatefulWidget {
  final LoginPageStyles loginPageStyles;
  final int selectedTap;

  const LoginView({Key key, this.loginPageStyles, this.selectedTap}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  /// login
  final GlobalKey<FormState> _loginFormKey = new GlobalKey<FormState>();
  final TextEditingController _phoneForLoginController = TextEditingController();
  final FocusNode _phoneForLoginFocusNode = FocusNode();

  /// signup
  final GlobalKey<FormState> _signupFormKey = new GlobalKey<FormState>();
  final TextEditingController _firstNameForSignupController = TextEditingController();
  final FocusNode _firstNameForSignupFocusNode = FocusNode();
  final TextEditingController _middleNameForSignupController = TextEditingController();
  final FocusNode _middleNameForSignupFocusNode = FocusNode();
  final TextEditingController _lastNameForSignupController = TextEditingController();
  final FocusNode _lastNameForSignupFocusNode = FocusNode();
  final TextEditingController _phoneForSignupController = TextEditingController();
  final FocusNode _phoneForSignupFocusNode = FocusNode();

  AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();

    _authProvider = AuthProvider.of(context);
    _authProvider.setAuthState(
      _authProvider.authState.update(progressState: 0, errorString: ""),
      isNotifiable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: widget.loginPageStyles.mainHeight,
        child: SingleChildScrollView(
          child: KeicyInkWell(
            onTap: () {},
            child: Stack(
              children: [
                Stack(
                  children: [
                    Image.asset(
                      AppAssets.backImg,
                      width: widget.loginPageStyles.deviceWidth,
                      height: widget.loginPageStyles.heightDp * 375,
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      top: widget.loginPageStyles.heightDp * 68,
                      child: Container(
                        width: widget.loginPageStyles.deviceWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: widget.loginPageStyles.heightDp * 293,
                              height: widget.loginPageStyles.heightDp * 293,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Color(0xFFF8FBFF).withOpacity(0.1), width: 2),
                              ),
                              child: Center(
                                child: Container(
                                  width: widget.loginPageStyles.heightDp * 259,
                                  height: widget.loginPageStyles.heightDp * 259,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Color(0xFFF8FBFF).withOpacity(0.1), width: 2),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: widget.loginPageStyles.heightDp * 222,
                                      height: widget.loginPageStyles.heightDp * 222,
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.scaffoldBackColor),
                                      child: Center(
                                        child: Image.asset(
                                          AppAssets.logoImage,
                                          width: widget.loginPageStyles.heightDp * 150,
                                          height: widget.loginPageStyles.heightDp * 150,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: widget.loginPageStyles.widthDp * 300),
                    _containerTab(context),
                    widget.selectedTap == 0 ? _containerLoginForm(context) : _containerSignupForm(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _containerTab(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widget.loginPageStyles.widthDp * 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (widget.selectedTap != 0) {
                KeicyNavigator.push(context, AppRoutes.LoginPage, LoginPage(selectedTap: 0));
              }
            },
            child: Column(
              children: [
                Container(
                  width: widget.loginPageStyles.widthDp * 30,
                  height: widget.loginPageStyles.widthDp * 3,
                  color: widget.selectedTap == 0 ? widget.loginPageStyles.selectedTapStyle.color : Colors.transparent,
                ),
                SizedBox(height: widget.loginPageStyles.widthDp * 10),
                Text(
                  LoginPageString.loginTab,
                  style: widget.selectedTap == 0 ? widget.loginPageStyles.selectedTapStyle : widget.loginPageStyles.unSelectedTapStyle,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.selectedTap != 1) {
                KeicyNavigator.push(context, AppRoutes.LoginPage, LoginPage(selectedTap: 1));
              }
            },
            child: Column(
              children: [
                Container(
                  width: widget.loginPageStyles.widthDp * 30,
                  height: widget.loginPageStyles.widthDp * 3,
                  color: widget.selectedTap == 1 ? widget.loginPageStyles.selectedTapStyle.color : Colors.transparent,
                ),
                SizedBox(height: widget.loginPageStyles.widthDp * 10),
                Text(
                  LoginPageString.registerTab,
                  style: widget.selectedTap == 1 ? widget.loginPageStyles.selectedTapStyle : widget.loginPageStyles.unSelectedTapStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _containerLoginForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.loginPageStyles.widthDp * 20),
      child: Form(
        key: _loginFormKey,
        child: Column(
          children: [
            SizedBox(height: widget.loginPageStyles.widthDp * 50),
            KeicyTextFormField(
              width: null,
              height: widget.loginPageStyles.formFieldHeight,
              controller: _phoneForLoginController,
              focusNode: _phoneForLoginFocusNode,
              labelSpacing: widget.loginPageStyles.widthDp * 14,
              label: LoginPageString.phoneLabel,
              labelStyle: widget.loginPageStyles.labelStyle,
              fillColor: Color(0xFFF2F5FA),
              borderRadius: widget.loginPageStyles.textFieldBorderRadius,
              border: Border.all(color: Colors.transparent),
              errorBorder: Border.all(color: Colors.redAccent),
              contentHorizontalPadding: widget.loginPageStyles.widthDp * 20,
              prefixIcons: [
                Container(
                  child: Row(
                    children: [
                      Icon(Icons.phone, color: AppColors.secondaryColor, size: widget.loginPageStyles.iconSize),
                      SizedBox(width: widget.loginPageStyles.widthDp * 20),
                      Container(width: widget.loginPageStyles.widthDp, height: widget.loginPageStyles.widthDp * 37, color: Color(0xFFE5E5E5)),
                      SizedBox(width: widget.loginPageStyles.widthDp * 20),
                    ],
                  ),
                ),
              ],
              textStyle: widget.loginPageStyles.textFormFieldTextStyle,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                MaskTextInputFormatter(mask: AppConstants.maskString, filter: {'0': RegExp(r'[0-9]')}),
              ],
              hintText: LoginPageString.phoneHint,
              hintStyle: widget.loginPageStyles.hintTextStyle,
              validatorHandler: (input) => (input.length < 9) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "9") : null,
              onFieldSubmittedHandler: (input) {
                _loginHandler(context);
              },
            ),
            SizedBox(height: widget.loginPageStyles.widthDp * 35),
            Row(
              children: [
                KeicyRaisedButton(
                  width: widget.loginPageStyles.widthDp * 86,
                  height: widget.loginPageStyles.widthDp * 50,
                  gradient: AppColors.mainGradient,
                  borderRadius: widget.loginPageStyles.textFieldBorderRadius,
                  child: SvgPicture.asset(
                    AppAssets.faceIconImg,
                    width: widget.loginPageStyles.widthDp * 24,
                    height: widget.loginPageStyles.widthDp * 24,
                    fit: BoxFit.cover,
                  ),
                  elevation: 0,
                  onPressed: () {
                    // _loginHandler(context);
                  },
                ),
                SizedBox(width: widget.loginPageStyles.widthDp * 15),
                Expanded(
                  child: KeicyRaisedButton(
                    height: widget.loginPageStyles.widthDp * 50,
                    color: AppColors.secondaryColor,
                    borderRadius: widget.loginPageStyles.textFieldBorderRadius,
                    child: Text(
                      LoginPageString.loginButton,
                      style: widget.loginPageStyles.buttonTextStyle,
                    ),
                    elevation: 0,
                    onPressed: () {
                      _loginHandler(context);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: widget.loginPageStyles.widthDp * 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  LoginPageString.registerDescription,
                  style: widget.loginPageStyles.descriptionTextStyle,
                ),
                new InkWell(
                  onTap: () => KeicyNavigator.push(context, AppRoutes.LoginPage, LoginPage(selectedTap: 1)),
                  child: Text(LoginPageString.registerLink, style: widget.loginPageStyles.linkTextStyle),
                ),
              ],
            ),
            SizedBox(height: widget.loginPageStyles.widthDp * 30),
          ],
        ),
      ),
    );
  }

  Widget _containerSignupForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.loginPageStyles.widthDp * 20),
      child: Form(
        key: _signupFormKey,
        child: Column(
          children: [
            ///
            SizedBox(height: widget.loginPageStyles.widthDp * 30),
            KeicyTextFormField(
              width: null,
              height: widget.loginPageStyles.formFieldHeight,
              controller: _firstNameForSignupController,
              focusNode: _firstNameForSignupFocusNode,
              fillColor: Color(0xFFF2F5FA),
              borderRadius: widget.loginPageStyles.textFieldBorderRadius,
              border: Border.all(color: Colors.transparent),
              errorBorder: Border.all(color: Colors.redAccent),
              contentHorizontalPadding: widget.loginPageStyles.widthDp * 20,
              prefixIcons: [
                Container(
                  child: Row(
                    children: [
                      Icon(Icons.person_outline, color: AppColors.secondaryColor, size: widget.loginPageStyles.iconSize),
                      SizedBox(width: widget.loginPageStyles.widthDp * 20),
                      Container(width: widget.loginPageStyles.widthDp, height: widget.loginPageStyles.widthDp * 37, color: Color(0xFFE5E5E5)),
                      SizedBox(width: widget.loginPageStyles.widthDp * 20),
                    ],
                  ),
                ),
              ],
              textStyle: widget.loginPageStyles.textFormFieldTextStyle,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter(RegExp("[a-zA-Z]"), allow: true),
              ],
              hintText: LoginPageString.firstNameHint,
              hintStyle: widget.loginPageStyles.hintTextStyle,
              validatorHandler: (input) => (input.length < 3) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3") : null,
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(_middleNameForSignupFocusNode);
              },
            ),

            ///
            SizedBox(height: widget.loginPageStyles.widthDp * 5),
            KeicyTextFormField(
              width: null,
              height: widget.loginPageStyles.formFieldHeight,
              controller: _middleNameForSignupController,
              focusNode: _middleNameForSignupFocusNode,
              fillColor: Color(0xFFF2F5FA),
              borderRadius: widget.loginPageStyles.textFieldBorderRadius,
              border: Border.all(color: Colors.transparent),
              errorBorder: Border.all(color: Colors.redAccent),
              contentHorizontalPadding: widget.loginPageStyles.widthDp * 20,
              prefixIcons: [
                Container(
                  child: Row(
                    children: [
                      Icon(Icons.person_outline, color: AppColors.secondaryColor, size: widget.loginPageStyles.iconSize),
                      SizedBox(width: widget.loginPageStyles.widthDp * 20),
                      Container(width: widget.loginPageStyles.widthDp, height: widget.loginPageStyles.widthDp * 37, color: Color(0xFFE5E5E5)),
                      SizedBox(width: widget.loginPageStyles.widthDp * 20),
                    ],
                  ),
                ),
              ],
              textStyle: widget.loginPageStyles.textFormFieldTextStyle,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter(RegExp("[a-zA-Z]"), allow: true),
              ],
              hintText: LoginPageString.middleNameHint,
              hintStyle: widget.loginPageStyles.hintTextStyle,
              validatorHandler: (input) => (input.length < 3) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3") : null,
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(_lastNameForSignupFocusNode);
              },
            ),

            ///
            SizedBox(height: widget.loginPageStyles.widthDp * 5),
            KeicyTextFormField(
              width: null,
              height: widget.loginPageStyles.formFieldHeight,
              controller: _lastNameForSignupController,
              focusNode: _lastNameForSignupFocusNode,
              fillColor: Color(0xFFF2F5FA),
              borderRadius: widget.loginPageStyles.textFieldBorderRadius,
              border: Border.all(color: Colors.transparent),
              errorBorder: Border.all(color: Colors.redAccent),
              contentHorizontalPadding: widget.loginPageStyles.widthDp * 20,
              prefixIcons: [
                Container(
                  child: Row(
                    children: [
                      Icon(Icons.person_outline, color: AppColors.secondaryColor, size: widget.loginPageStyles.iconSize),
                      SizedBox(width: widget.loginPageStyles.widthDp * 20),
                      Container(width: widget.loginPageStyles.widthDp, height: widget.loginPageStyles.widthDp * 37, color: Color(0xFFE5E5E5)),
                      SizedBox(width: widget.loginPageStyles.widthDp * 20),
                    ],
                  ),
                ),
              ],
              textStyle: widget.loginPageStyles.textFormFieldTextStyle,
              keyboardType: TextInputType.name,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter(RegExp("[a-zA-Z]"), allow: true),
              ],
              textInputAction: TextInputAction.next,
              hintText: LoginPageString.lastNameHint,
              hintStyle: widget.loginPageStyles.hintTextStyle,
              validatorHandler: (input) => (input.length < 3) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3") : null,
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(_phoneForSignupFocusNode);
              },
            ),

            ///
            SizedBox(height: widget.loginPageStyles.widthDp * 5),
            KeicyTextFormField(
              width: null,
              height: widget.loginPageStyles.formFieldHeight,
              controller: _phoneForSignupController,
              focusNode: _phoneForSignupFocusNode,
              fillColor: Color(0xFFF2F5FA),
              borderRadius: widget.loginPageStyles.textFieldBorderRadius,
              border: Border.all(color: Colors.transparent),
              errorBorder: Border.all(color: Colors.redAccent),
              contentHorizontalPadding: widget.loginPageStyles.widthDp * 20,
              prefixIcons: [
                Container(
                  child: Row(
                    children: [
                      Icon(Icons.phone, color: AppColors.secondaryColor, size: widget.loginPageStyles.iconSize),
                      SizedBox(width: widget.loginPageStyles.widthDp * 20),
                      Container(width: widget.loginPageStyles.widthDp, height: widget.loginPageStyles.widthDp * 37, color: Color(0xFFE5E5E5)),
                      SizedBox(width: widget.loginPageStyles.widthDp * 20),
                    ],
                  ),
                ),
              ],
              textStyle: widget.loginPageStyles.textFormFieldTextStyle,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                MaskTextInputFormatter(mask: AppConstants.maskString, filter: {'0': RegExp(r'[0-9]')}),
              ],
              hintText: LoginPageString.phoneHint,
              hintStyle: widget.loginPageStyles.hintTextStyle,
              validatorHandler: (input) => (input.length < 9) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "9") : null,
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),

            ///
            SizedBox(height: widget.loginPageStyles.widthDp * 25),
            KeicyRaisedButton(
              height: widget.loginPageStyles.widthDp * 50,
              color: AppColors.secondaryColor,
              borderRadius: widget.loginPageStyles.textFieldBorderRadius,
              child: Text(
                LoginPageString.registerButton,
                style: widget.loginPageStyles.buttonTextStyle,
              ),
              elevation: 0,
              onPressed: () {
                _signupHandler(context);
              },
            ),
            SizedBox(height: widget.loginPageStyles.widthDp * 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  LoginPageString.loginDescription,
                  style: widget.loginPageStyles.descriptionTextStyle,
                ),
                new InkWell(
                  onTap: () => KeicyNavigator.push(context, AppRoutes.LoginPage, LoginPage(selectedTap: 0)),
                  child: Text(LoginPageString.loginLink, style: widget.loginPageStyles.linkTextStyle),
                ),
              ],
            ),
            SizedBox(height: widget.loginPageStyles.widthDp * 30),
          ],
        ),
      ),
    );
  }

  void _loginHandler(BuildContext context) async {
    if (!_loginFormKey.currentState.validate()) return;

    String phoneNumber = _phoneForLoginController.text.trim().replaceAll(RegExp(r'[( )-]'), "");

    AuthProvider.of(context).phoneVerification(phoneNumber);

    FocusScope.of(context).requestFocus(FocusNode());

    Navigator.of(context).pushNamed(
      AppRoutes.VerificationPage,
      arguments: {"phoneNumber": phoneNumber},
    );
  }

  void _signupHandler(BuildContext context) async {
    if (!_signupFormKey.currentState.validate()) return;

    String phoneNumber = _phoneForSignupController.text.trim().replaceAll(RegExp(r'[( )-]'), "");

    AuthProvider.of(context).phoneVerification(phoneNumber);

    FocusScope.of(context).requestFocus(FocusNode());

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => VerificationPage(
          firstName: _firstNameForSignupController.text.trim(),
          middleName: _middleNameForSignupController.text.trim(),
          lastName: _lastNameForSignupController.text.trim(),
          phoneNumber: phoneNumber,
        ),
      ),
    );
  }
}
