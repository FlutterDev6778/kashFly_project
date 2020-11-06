import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:keicy_text_form_field/keicy_text_form_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:money_transfer_app/Pages/Components/index.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';

import 'package:keicy_inkwell/keicy_inkwell.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';
import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Providers/index.dart';
import 'package:money_transfer_framework/Models/recipient_model.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';

import 'Styles/index.dart';

class RecipientViewPage extends StatefulWidget {
  RecipientViewPage({
    @required this.recipientProvider,
    this.recipientModel,
  });

  RecipientModel recipientModel;
  RecipientProvider recipientProvider;

  @override
  _RecipientViewPageState createState() => _RecipientViewPageState();
}

class _RecipientViewPageState extends State<RecipientViewPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  KeicyProgressDialog _keicyProgressDialog;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _middleNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _cityController = TextEditingController();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _middleNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  RecipientViewPageStyles _recipientViewPageStyles;
  PhoneNumber _phoneNumber;

  @override
  void initState() {
    super.initState();

    _firstNameController.text = widget.recipientModel.firstName;
    _middleNameController.text = widget.recipientModel.middleName;
    _lastNameController.text = widget.recipientModel.lastName;
    _cityController.text = widget.recipientModel.city;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      widget.recipientProvider.addListener(_recipientProviderListener);

      _keicyProgressDialog = KeicyProgressDialog.of(
        context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        layout: Layout.Column,
        padding: EdgeInsets.zero,
        width: _recipientViewPageStyles.widthDp * 120,
        height: _recipientViewPageStyles.widthDp * 120,
        progressWidget: Container(
          width: _recipientViewPageStyles.widthDp * 120,
          height: _recipientViewPageStyles.widthDp * 120,
          padding: EdgeInsets.all(_recipientViewPageStyles.widthDp * 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_recipientViewPageStyles.widthDp * 10),
          ),
          child: SpinKitFadingCircle(
            color: AppColors.primaryColor,
            size: _recipientViewPageStyles.widthDp * 80,
          ),
        ),
        message: "",
      );

      if (widget.recipientModel.phoneNumber != "") {
        _phoneNumber = await PhoneNumber.getRegionInfoFromPhoneNumber(widget.recipientModel.phoneNumber);
        setState(() {});
      } else {
        _phoneNumber = PhoneNumber(isoCode: "SO", dialCode: "+252");
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    widget.recipientProvider.removeListener(_recipientProviderListener);

    super.dispose();
  }

  void _recipientProviderListener() async {
    if (widget.recipientProvider.recipientState.progressState != 1 && _keicyProgressDialog.isShowing()) {
      await _keicyProgressDialog.hide();
    }

    switch (widget.recipientProvider.recipientState.progressState) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          blurPower: 3,
          backgroundColor: Colors.white,
          title: (widget.recipientModel.id == "") ? 'Added New Recipient' : 'Updated Recipient',
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: _recipientViewPageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(_recipientViewPageStyles.widthDp * 80),
          padding: EdgeInsets.all(_recipientViewPageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.check_circle_outline,
            color: AppColors.primaryColor,
            size: _recipientViewPageStyles.widthDp * 80,
          ),
        );

        Navigator.of(context).pop();

        break;
      case -1:
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: widget.recipientProvider.recipientState.errorString,
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: _recipientViewPageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(_recipientViewPageStyles.widthDp * 80),
          padding: EdgeInsets.all(_recipientViewPageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.error_outline,
            color: Colors.redAccent,
            size: _recipientViewPageStyles.widthDp * 80,
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
    _recipientViewPageStyles = RecipientViewPageMobileStyles(context);
    print(widget.recipientModel == null);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackColor2,
      body: Container(
        height: _recipientViewPageStyles.mainHeight,
        child: Column(
          children: [
            HeaderWidget(
              title: (widget.recipientModel.id == "") ? RecipientViewPageString.addTitle : RecipientViewPageString.updateTitle,
              widthDp: _recipientViewPageStyles.widthDp,
              fontSp: _recipientViewPageStyles.fontSp,
              haveBackIcon: true,
            ),
            Expanded(child: _containerBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _containerBody(BuildContext context) {
    List<String> africaCountryList = [];

    for (var i = 0; i < AppConstants.africaCountries.length; i++) {
      africaCountryList.add(AppConstants.africaCountries[i]["alpha_2_code"]);
    }

    return SingleChildScrollView(
      child: KeicyInkWell(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _recipientViewPageStyles.primaryHorizontalPadding,
            vertical: _recipientViewPageStyles.primaryVerticalPadding,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// first name
                KeicyTextFormField(
                  width: null,
                  height: _recipientViewPageStyles.formFieldHeight,
                  widthDp: _recipientViewPageStyles.widthDp,
                  controller: _firstNameController,
                  focusNode: _firstNameFocusNode,
                  labelSpacing: _recipientViewPageStyles.widthDp * 14,
                  fillColor: Colors.white,
                  borderRadius: _recipientViewPageStyles.formFieldBorderRadius,
                  border: Border.all(color: Colors.transparent),
                  errorBorder: Border.all(color: Colors.redAccent),
                  contentHorizontalPadding: _recipientViewPageStyles.widthDp * 13,
                  prefixIcons: [
                    Icon(Icons.person_outline, color: AppColors.secondaryColor, size: _recipientViewPageStyles.iconSize),
                  ],
                  textStyle: _recipientViewPageStyles.textStyle,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  hintText: RecipientViewPageString.fistNameHint,
                  hintStyle: _recipientViewPageStyles.hintStyle,
                  validatorHandler: (input) => (input.length < 3) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3") : null,
                  onFieldSubmittedHandler: (input) {
                    FocusScope.of(context).requestFocus(_middleNameFocusNode);
                  },
                ),

                /// middle name
                SizedBox(height: _recipientViewPageStyles.heightDp * 5),
                KeicyTextFormField(
                  width: null,
                  height: _recipientViewPageStyles.formFieldHeight,
                  widthDp: _recipientViewPageStyles.widthDp,
                  controller: _middleNameController,
                  focusNode: _middleNameFocusNode,
                  labelSpacing: _recipientViewPageStyles.widthDp * 14,
                  fillColor: Colors.white,
                  borderRadius: _recipientViewPageStyles.formFieldBorderRadius,
                  border: Border.all(color: Colors.transparent),
                  errorBorder: Border.all(color: Colors.redAccent),
                  contentHorizontalPadding: _recipientViewPageStyles.widthDp * 13,
                  prefixIcons: [
                    Icon(Icons.person_outline, color: AppColors.secondaryColor, size: _recipientViewPageStyles.iconSize),
                  ],
                  textStyle: _recipientViewPageStyles.textStyle,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  hintText: RecipientViewPageString.middleNameHint,
                  hintStyle: _recipientViewPageStyles.hintStyle,
                  validatorHandler: (input) => (input.length < 3) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3") : null,
                  onFieldSubmittedHandler: (input) {
                    FocusScope.of(context).requestFocus(_lastNameFocusNode);
                  },
                ),

                /// last name
                SizedBox(height: _recipientViewPageStyles.heightDp * 5),
                KeicyTextFormField(
                  width: null,
                  height: _recipientViewPageStyles.formFieldHeight,
                  widthDp: _recipientViewPageStyles.widthDp,
                  controller: _lastNameController,
                  focusNode: _lastNameFocusNode,
                  labelSpacing: _recipientViewPageStyles.widthDp * 14,
                  fillColor: Colors.white,
                  borderRadius: _recipientViewPageStyles.formFieldBorderRadius,
                  border: Border.all(color: Colors.transparent),
                  errorBorder: Border.all(color: Colors.redAccent),
                  contentHorizontalPadding: _recipientViewPageStyles.widthDp * 13,
                  prefixIcons: [
                    Icon(Icons.person_outline, color: AppColors.secondaryColor, size: _recipientViewPageStyles.iconSize),
                  ],
                  textStyle: _recipientViewPageStyles.textStyle,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  hintText: RecipientViewPageString.lastNameHint,
                  hintStyle: _recipientViewPageStyles.hintStyle,
                  validatorHandler: (input) => (input.length < 3) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3") : null,
                  onFieldSubmittedHandler: (input) {
                    FocusScope.of(context).requestFocus(_phoneFocusNode);
                  },
                ),

                /// phone number
                SizedBox(height: _recipientViewPageStyles.heightDp * 5),
                InternationalPhoneNumberInput(
                  textFieldController: _phoneController,
                  focusNode: _phoneFocusNode,
                  initialValue: _phoneNumber,
                  countries: africaCountryList,
                  selectorType: PhoneInputSelectorType.DIALOG,
                  onInputChanged: (PhoneNumber number) {
                    _phoneNumber = number;
                    if (_phoneController.text.trim() != "") {
                      _phoneController.selection = TextSelection(
                        baseOffset: _phoneController.text.trim().length,
                        extentOffset: _phoneController.text.trim().length,
                      );
                    }
                  },
                  ignoreBlank: false,
                  autoValidate: false,
                  selectorTextStyle: TextStyle(color: Colors.black),
                  textStyle: _recipientViewPageStyles.textStyle,
                  inputDecoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: RecipientViewPageString.phoneHint,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: _recipientViewPageStyles.widthDp * 15,
                      vertical: _recipientViewPageStyles.widthDp * 17,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(_recipientViewPageStyles.formFieldBorderRadius),
                    ),
                    errorStyle: TextStyle(height: 0.5),
                    hintStyle: _recipientViewPageStyles.hintStyle,
                    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red)),
                  ),
                  inputBorder: OutlineInputBorder(),
                  onSubmit: () {
                    FocusScope.of(context).requestFocus(_cityFocusNode);
                  },
                ),

                /// city
                SizedBox(height: _recipientViewPageStyles.heightDp * 30),
                KeicyTextFormField(
                  width: null,
                  height: _recipientViewPageStyles.formFieldHeight,
                  widthDp: _recipientViewPageStyles.widthDp,
                  controller: _cityController,
                  focusNode: _cityFocusNode,
                  labelSpacing: _recipientViewPageStyles.widthDp * 14,
                  fillColor: Colors.white,
                  borderRadius: _recipientViewPageStyles.formFieldBorderRadius,
                  border: Border.all(color: Colors.transparent),
                  errorBorder: Border.all(color: Colors.redAccent),
                  contentHorizontalPadding: _recipientViewPageStyles.widthDp * 15,
                  prefixIcons: [
                    SvgPicture.asset(
                      AppAssets.cityIcon,
                      width: _recipientViewPageStyles.iconSize,
                      height: _recipientViewPageStyles.iconSize,
                      fit: BoxFit.cover,
                    ),
                  ],
                  textStyle: _recipientViewPageStyles.textStyle,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  hintText: RecipientViewPageString.cityHint,
                  hintStyle: _recipientViewPageStyles.hintStyle,
                  validatorHandler: (input) => (input.length < 3) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3") : null,
                  onFieldSubmittedHandler: (input) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                ),

                SizedBox(height: _recipientViewPageStyles.heightDp * 30),
                KeicyRaisedButton(
                  height: _recipientViewPageStyles.buttonHeight,
                  color: AppColors.secondaryColor,
                  borderRadius: _recipientViewPageStyles.formFieldBorderRadius,
                  child: Text(
                    (widget.recipientModel.id == "") ? RecipientViewPageString.addButton : RecipientViewPageString.updateButton,
                    style: _recipientViewPageStyles.buttonTextStyle,
                  ),
                  elevation: 0,
                  onPressed: () {
                    _saveHandler(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveHandler(BuildContext context) async {
    if (!_formKey.currentState.validate()) return;

    await _keicyProgressDialog.show();

    RecipientModel _recipientModel = RecipientModel.fromJson(widget.recipientModel.toJson());
    _recipientModel.senderID = UserProvider.of(context).userState.userModel.id;
    _recipientModel.firstName = _firstNameController.text.trim();
    _recipientModel.middleName = _middleNameController.text.trim();
    _recipientModel.lastName = _lastNameController.text.trim();
    _recipientModel.phoneNumber = _phoneNumber.phoneNumber;
    for (var i = 0; i < AppConstants.africaCountries.length; i++) {
      if (AppConstants.africaCountries[i]["dial_code"] == _phoneNumber.dialCode) {
        _recipientModel.country = AppConstants.africaCountries[i]["en_short_name"];
        break;
      }
    }
    _recipientModel.city = _cityController.text.trim();
    _recipientModel.ts = DateTime.now().millisecondsSinceEpoch;
    _recipientModel.createdDateTs = (_recipientModel.createdDateTs != 0) ? _recipientModel.createdDateTs : DateTime.now().millisecondsSinceEpoch;

    widget.recipientProvider.setRecipientState(
      widget.recipientProvider.recipientState.update(progressState: 1),
      isNotifiable: false,
    );

    widget.recipientProvider.saveRecipientData(_recipientModel);
  }
}
