import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:keicy_inkwell/keicy_inkwell.dart';
import 'package:status_alert/status_alert.dart';
import 'package:provider/provider.dart';

import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';
import 'package:keicy_text_form_field/keicy_text_form_field.dart';
import 'package:keicy_cookie_provider/keicy_cookie_provider.dart';
import 'package:keicy_utils/validators.dart';
import 'package:keicy_navigator/keicy_navigator.dart';

import 'package:money_transfer_framework/money_transfer_framework.dart';

import '../App/index.dart';
import '../DashboardPage/index.dart';
import '../../Providers/AuthProvider/auth_provider.dart';

import 'index.dart';

class LoginView extends StatefulWidget {
  final LoginPageStyles loginPageStyles;

  const LoginView({
    this.loginPageStyles,
  });

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  AuthProvider _authProvider;
  KeicyProgressDialog _keicyProgressDialog;

  @override
  void initState() {
    super.initState();

    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(
      context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      layout: Layout.Column,
      padding: EdgeInsets.zero,
      width: widget.loginPageStyles.widthDp * 120,
      height: widget.loginPageStyles.widthDp * 120,
      progressWidget: Container(
        width: widget.loginPageStyles.widthDp * 120,
        height: widget.loginPageStyles.widthDp * 120,
        padding: EdgeInsets.all(widget.loginPageStyles.widthDp * 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.loginPageStyles.widthDp * 10),
        ),
        child: SpinKitFadingCircle(
          color: AppColors.primaryColor,
          size: widget.loginPageStyles.widthDp * 80,
        ),
      ),
      message: "",
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _authProvider.addListener(_authProviderListener);
    });
  }

  @override
  void dispose() {
    _authProvider.removeListener(_authProviderListener);

    super.dispose();
  }

  void _authProviderListener() async {
    if (_authProvider.authState.progressState != 1 && _keicyProgressDialog.isShowing()) {
      await _keicyProgressDialog.hide();
    }

    switch (_authProvider.authState.progressState) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        KeicyNavigator.push(context, AppRoutes.DashboardPage, DashboardPage());
        break;
      case -1:
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          blurPower: 3,
          backgroundColor: Colors.white,
          title: _authProvider.authState.errorString,
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.loginPageStyles.fontSp * 16, color: AppColors.blackColor, height: 1.5),
          ),
          margin: (widget.loginPageStyles.runtimeType == LoginPageMobileStyles)
              ? EdgeInsets.all(widget.loginPageStyles.widthDp * 80)
              : EdgeInsets.symmetric(
                  horizontal: (widget.loginPageStyles.deviceWidth - widget.loginPageStyles.widthDp * 300) / 2,
                  vertical: (widget.loginPageStyles.deviceHeight - widget.loginPageStyles.widthDp * 300) / 2,
                ),
          configuration: IconConfiguration(
            icon: Icons.error_outline,
            color: AppColors.primaryColor,
            size: widget.loginPageStyles.widthDp * 100,
          ),
        );
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: KeicyInkWell(
          child: Container(
            height: widget.loginPageStyles.mainHeight,
            padding: EdgeInsets.symmetric(
              horizontal: widget.loginPageStyles.primaryHorizontalPadding,
              vertical: widget.loginPageStyles.primaryVerticalPadding,
            ),
            alignment: Alignment.center,
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              spacing: widget.loginPageStyles.widthDp * 30,
              runSpacing: widget.loginPageStyles.widthDp * 40,
              children: [
                Container(
                  child: Image.asset(
                    AppAssets.logoImage,
                    width: widget.loginPageStyles.logoImageWidth,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Form(
                  key: _formkey,
                  child: Container(
                    width: widget.loginPageStyles.textFieldWidth + 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(LoginPageString.title, style: widget.loginPageStyles.titleStyle),
                        SizedBox(height: widget.loginPageStyles.widthDp * 20),
                        KeicyTextFormField(
                          width: widget.loginPageStyles.textFieldWidth,
                          height: widget.loginPageStyles.textFieldHeight,
                          widthDp: widget.loginPageStyles.widthDp,
                          textStyle: widget.loginPageStyles.formFieldTextStyle,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          borderRadius: widget.loginPageStyles.widthDp * 6,
                          border: Border.all(color: Colors.grey, width: 1),
                          errorBorder: Border.all(color: Colors.redAccent, width: 1),
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          prefixIcons: [Icon(Icons.email, size: widget.loginPageStyles.iconSize)],
                          label: LoginPageString.emailLabel,
                          hintText: LoginPageString.emailHint,
                          hintStyle: widget.loginPageStyles.formFieldHintStyle,
                          validatorHandler: (input) => !KeicyValidators.isValidEmail(input.trim()) ? ValidateErrorString.emailErrorText : null,
                          onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_passwordFocusNode),
                        ),
                        KeicyTextFormField(
                          width: widget.loginPageStyles.textFieldWidth,
                          height: widget.loginPageStyles.textFieldHeight,
                          widthDp: widget.loginPageStyles.widthDp,
                          textStyle: widget.loginPageStyles.formFieldTextStyle,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          borderRadius: widget.loginPageStyles.widthDp * 6,
                          border: Border.all(color: Colors.grey, width: 1),
                          errorBorder: Border.all(color: Colors.redAccent, width: 1),
                          obscureText: true,
                          enableShowPassword: true,
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          prefixIcons: [Icon(Icons.lock, size: widget.loginPageStyles.iconSize)],
                          label: LoginPageString.passwordLabel,
                          hintText: LoginPageString.passwordHint,
                          hintStyle: widget.loginPageStyles.formFieldHintStyle,
                          validatorHandler: (input) =>
                              input.trim().length < 6 ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "6") : null,
                          onFieldSubmittedHandler: (input) {
                            _loginHandler(context);
                          },
                        ),
                        SizedBox(height: widget.loginPageStyles.widthDp * 30),
                        KeicyRaisedButton(
                          width: widget.loginPageStyles.buttonWidth,
                          height: widget.loginPageStyles.buttonheight,
                          child: Text(LoginPageString.buttonText, style: widget.loginPageStyles.buttonTextStyle),
                          color: AppColors.primaryColor,
                          borderColor: Colors.transparent,
                          borderRadius: widget.loginPageStyles.widthDp * 6,
                          onPressed: () {
                            _loginHandler(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loginHandler(BuildContext context) async {
    if (!_formkey.currentState.validate()) return;
    _formkey.currentState.save();

    _authProvider.setAuthState(_authProvider.authState.update(progressState: 1), isNotifiable: false);
    await _keicyProgressDialog.show();

    _authProvider.login(email: _emailController.text.trim(), password: _passwordController.text.trim());
  }
}
