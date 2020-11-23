import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:keicy_inkwell/keicy_inkwell.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Providers/index.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';

import 'index.dart';

class RegisterView extends StatefulWidget {
  final RegisterPageStyles registerPageStyles;

  const RegisterView({
    Key key,
    this.registerPageStyles,
  }) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _middleNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          height: widget.registerPageStyles.mainHeight,
          child: KeicyInkWell(
            onTap: () {},
            child: Stack(
              children: [
                _containerBackground(context),
                _containerForm(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _containerBackground(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.transparent),
        Container(
          height: widget.registerPageStyles.widthDp * 250.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFFDD148),
          ),
        ),
        Positioned(
          bottom: widget.registerPageStyles.widthDp * 450.0,
          right: widget.registerPageStyles.widthDp * 100.0,
          child: Container(
            height: widget.registerPageStyles.widthDp * 400.0,
            width: widget.registerPageStyles.widthDp * 400.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFEE16D),
            ),
          ),
        ),
        Positioned(
          bottom: widget.registerPageStyles.widthDp * 500.0,
          left: widget.registerPageStyles.widthDp * 150.0,
          child: Container(
            height: widget.registerPageStyles.widthDp * 300.0,
            width: widget.registerPageStyles.widthDp * 300.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFEE16D).withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _containerForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        widget.registerPageStyles.formPanelHorizontalPadding,
        widget.registerPageStyles.formPanelTopPadding,
        widget.registerPageStyles.formPanelHorizontalPadding,
        0,
      ),
      child: Column(
        children: [
          Material(
            borderRadius: BorderRadius.circular(widget.registerPageStyles.widthDp * 8.0),
            elevation: 5.0,
            child: Container(
              height: widget.registerPageStyles.formPanelHeight,
              padding: EdgeInsets.all(widget.registerPageStyles.widthDp * 32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(RegisterPageString.title, style: widget.registerPageStyles.titleTextStyle),
                      ],
                    ),
                    TextFormField(
                      controller: _firstNameController,
                      focusNode: _firstNameFocusNode,
                      style: widget.registerPageStyles.textFormFieldTextStyle,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(height: 0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(widget.registerPageStyles.textFieldBorderRadius),
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                          color: AppColors.primaryColor,
                          size: widget.registerPageStyles.iconSize,
                        ),
                        contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                        hintText: RegisterPageString.fistNameHint,
                        hintStyle: widget.registerPageStyles.hintTextStyle,
                      ),
                      validator: (input) => (input.isEmpty) ? ValidateErrorString.textEmptyErrorText.replaceAll("{}", "First Name") : null,
                      onFieldSubmitted: (input) {
                        FocusScope.of(context).requestFocus(_middleNameFocusNode);
                      },
                    ),
                    TextFormField(
                      controller: _middleNameController,
                      focusNode: _middleNameFocusNode,
                      style: widget.registerPageStyles.textFormFieldTextStyle,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(height: 0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(widget.registerPageStyles.textFieldBorderRadius),
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                          color: AppColors.primaryColor,
                          size: widget.registerPageStyles.iconSize,
                        ),
                        contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                        hintText: RegisterPageString.middleNameHint,
                        hintStyle: widget.registerPageStyles.hintTextStyle,
                      ),
                      validator: (input) => (input.isEmpty) ? ValidateErrorString.textEmptyErrorText.replaceAll("{}", "Middle Name") : null,
                      onFieldSubmitted: (input) {
                        FocusScope.of(context).requestFocus(_lastNameFocusNode);
                      },
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      focusNode: _lastNameFocusNode,
                      style: widget.registerPageStyles.textFormFieldTextStyle,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(height: 0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(widget.registerPageStyles.textFieldBorderRadius),
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                          color: AppColors.primaryColor,
                          size: widget.registerPageStyles.iconSize,
                        ),
                        contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                        hintText: RegisterPageString.lastNameHint,
                        hintStyle: widget.registerPageStyles.hintTextStyle,
                      ),
                      validator: (input) => (input.isEmpty) ? ValidateErrorString.textEmptyErrorText.replaceAll("{}", "Last Name") : null,
                      onFieldSubmitted: (input) {
                        FocusScope.of(context).requestFocus(_phoneFocusNode);
                      },
                    ),
                    TextFormField(
                      controller: _phoneController,
                      focusNode: _phoneFocusNode,
                      style: widget.registerPageStyles.textFormFieldTextStyle,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        MaskTextInputFormatter(mask: AppConstants.maskString, filter: {'#': RegExp(r'[0-9]')}),
                      ],
                      decoration: InputDecoration(
                        errorStyle: TextStyle(height: 0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(widget.registerPageStyles.textFieldBorderRadius),
                        ),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: AppColors.primaryColor,
                          size: widget.registerPageStyles.iconSize,
                        ),
                        contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                        hintText: RegisterPageString.phoneHint,
                        hintStyle: widget.registerPageStyles.hintTextStyle,
                      ),
                      validator: (input) => (input.length < 9) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "9") : null,
                      onFieldSubmitted: (input) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _registerHandler(context);
                      },
                    ),
                    KeicyRaisedButton(
                      height: widget.registerPageStyles.widthDp * 50,
                      color: AppColors.primaryColor,
                      borderRadius: widget.registerPageStyles.textFieldBorderRadius,
                      child: Text(
                        RegisterPageString.registerButton,
                        style: widget.registerPageStyles.buttonTextStyle,
                      ),
                      onPressed: () {
                        _registerHandler(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: widget.registerPageStyles.widthDp * 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                RegisterPageString.loginDescription,
                style: widget.registerPageStyles.descriptionTextStyle,
              ),
              new InkWell(
                onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.LoginPage),
                child: Text(RegisterPageString.loginLink, style: widget.registerPageStyles.linkTextStyle),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _registerHandler(BuildContext context) async {
    if (!_formKey.currentState.validate()) return;

    String phoneNumber = _phoneController.text.trim().replaceAll(RegExp(r'[( )-]'), "");

    AuthProvider.of(context).phoneVerification(phoneNumber);

    FocusScope.of(context).requestFocus(FocusNode());

    Navigator.of(context).pushNamed(
      AppRoutes.VerificationPage,
      arguments: {
        "firstName": _firstNameController.text.trim(),
        "middleName": _middleNameController.text.trim(),
        "lastName": _lastNameController.text.trim(),
        "phoneNumber": phoneNumber,
      },
    );
  }
}
