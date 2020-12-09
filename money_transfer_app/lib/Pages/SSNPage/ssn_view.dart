import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keicy_dropdown_form_field/keicy_dropdown_form_field.dart';
import 'package:keicy_text_form_field/keicy_text_form_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:money_transfer_app/Pages/Components/header_widget.dart';
import 'package:money_transfer_app/Pages/Components/index.dart';
import 'package:money_transfer_framework/Models/document_model.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:status_alert/status_alert.dart';

import 'package:keicy_network_image/keicy_network_image.dart';
import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';

import 'package:money_transfer_app/Providers/index.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:money_transfer_app/Pages/App/index.dart';

import 'index.dart';

class SSNView extends StatefulWidget {
  final Map<String, dynamic> documentType;
  final SSNPageStyles ssnPageStyles;

  const SSNView({
    Key key,
    this.documentType,
    this.ssnPageStyles,
  }) : super(key: key);

  @override
  _SSNViewState createState() => _SSNViewState();
}

class _SSNViewState extends State<SSNView> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DocumentModel _documentModel;

  UserProvider _userProvider;
  KeicyProgressDialog _keicyProgressDialog;

  TextEditingController _textEditingController = TextEditingController();

  bool isPresessed;

  @override
  void initState() {
    super.initState();

    isPresessed = false;

    _userProvider = UserProvider.of(context);

    _userProvider.setUserState(
      _userProvider.userState.update(
        progressState: 0,
        errorString: "",
      ),
      isNotifiable: false,
    );

    _documentModel =
        DocumentModel.fromJson(_userProvider.userState.userModel.documents[widget.documentType["category"]]);
    _documentModel.subCategory = "ssn";
    _documentModel.title = "SSN";
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userProvider.addListener(_userProviderListener);

      _keicyProgressDialog = KeicyProgressDialog.of(
        context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        layout: Layout.Column,
        padding: EdgeInsets.zero,
        width: widget.ssnPageStyles.widthDp * 120,
        height: widget.ssnPageStyles.widthDp * 120,
        progressWidget: Container(
          width: widget.ssnPageStyles.widthDp * 120,
          height: widget.ssnPageStyles.widthDp * 120,
          padding: EdgeInsets.all(widget.ssnPageStyles.widthDp * 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.ssnPageStyles.widthDp * 10),
          ),
          child: SpinKitFadingCircle(
            color: AppColors.primaryColor,
            size: widget.ssnPageStyles.widthDp * 80,
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
          blurPower: 3,
          backgroundColor: Colors.white,
          title: 'SSN Successfully uploaded',
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.ssnPageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.ssnPageStyles.widthDp * 80),
          padding: EdgeInsets.all(widget.ssnPageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.check_circle_outline,
            color: AppColors.primaryColor,
            size: widget.ssnPageStyles.widthDp * 80,
          ),
        );

        Navigator.of(context).pop();
        break;
      case -1:
        isPresessed = false;
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: _userProvider.userState.errorString,
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.ssnPageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.ssnPageStyles.widthDp * 80),
          padding: EdgeInsets.all(widget.ssnPageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.error_outline,
            color: Colors.redAccent,
            size: widget.ssnPageStyles.widthDp * 80,
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
      body: Container(
        height: widget.ssnPageStyles.mainHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(
              title: SSNPageString.title,
              widthDp: widget.ssnPageStyles.widthDp,
              fontSp: widget.ssnPageStyles.fontSp,
              haveBackIcon: true,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: widget.ssnPageStyles.primaryHorizontalPadding),
                child: Column(
                  children: [
                    SizedBox(height: widget.ssnPageStyles.primaryVerticalPadding),
                    _containerDocumentContent(context),
                  ],
                ),
              ),
            ),
            CustomNumberKeyboard(
              backColor: Colors.transparent,
              foreColor: AppColors.blackColor,
              fontSize: widget.ssnPageStyles.fontSp * 24,
              iconSize: widget.ssnPageStyles.widthDp * 24,
              keyHorizontalPadding: widget.ssnPageStyles.widthDp * 45,
              keyVerticalPadding: widget.ssnPageStyles.widthDp * 20,
              type: -1,
              onPress: (value) {
                if (value.length > 9) return;
                _textEditingController.text = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _containerDocumentContent(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KeicyTextFormField(
            initialValue: _documentModel.imagePath,
            width: null,
            controller: _textEditingController,
            height: widget.ssnPageStyles.formFieldHeight,
            widthDp: widget.ssnPageStyles.widthDp,
            fillColor: Colors.white,
            borderRadius: widget.ssnPageStyles.textFieldBorderRadius,
            border: Border.all(color: Colors.transparent),
            errorBorder: Border.all(color: Colors.redAccent),
            contentHorizontalPadding: widget.ssnPageStyles.widthDp * 20,
            autofocus: true,
            textStyle: widget.ssnPageStyles.textFormFieldTextStyle,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              MaskTextInputFormatter(mask: '#########', filter: {'0': RegExp(r'[0-9]')}),
            ],
            readOnly: true,
            hintText: SSNPageString.ssnHint,
            hintStyle: widget.ssnPageStyles.hintTextStyle,
            validatorHandler: (input) =>
                (input.length != 9) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "9") : null,
            onSaveHandler: (input) => _documentModel.imagePath = input.trim(),
            onFieldSubmittedHandler: (input) {},
          ),
          SizedBox(height: widget.ssnPageStyles.widthDp * 30),
          KeicyRaisedButton(
            height: widget.ssnPageStyles.widthDp * 50,
            color: AppColors.secondaryColor,
            borderRadius: widget.ssnPageStyles.widthDp * 25,
            child: Text(
              SSNPageString.buttonText,
              style: widget.ssnPageStyles.buttonStyle,
            ),
            elevation: 0,
            onPressed: () {
              _saveHandler(context);
            },
          ),
        ],
      ),
    );
  }

  void _saveHandler(BuildContext context) async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    await _keicyProgressDialog.show();

    _userProvider.setUserState(_userProvider.userState.update(progressState: 1), isNotifiable: false);

    _userProvider.saveDocument(
      userModel: UserModel.fromJson(_userProvider.userState.userModel.toJson()),
      documentType: widget.documentType["category"],
      documentData: _documentModel.toJson(),
      imageFile: null,
      imageFile1: null,
      isSSN: true,
    );
  }
}
