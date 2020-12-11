import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keicy_dropdown_form_field/keicy_dropdown_form_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:money_transfer_app/Pages/Components/index.dart';
import 'package:money_transfer_app/Pages/Components/searchable_dropdown.dart';
import 'package:money_transfer_app/Providers/PinCodeProvider/index.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import 'package:keicy_utils/date_time_convert.dart';

import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';
import 'package:keicy_inkwell/keicy_inkwell.dart';
import 'package:keicy_text_form_field/keicy_text_form_field.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';
import 'package:keicy_utils/validators.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class MyInfoView extends StatefulWidget {
  final MyInfoPageStyles myInfoPageStyles;
  // final String newPinCode;
  // final String firstName;
  // final String middleName;
  // final String lastName;
  // final String phoneNumber;
  final UserModel userModel;
  final bool isNewInfo;
  final bool haveNavbar;

  const MyInfoView({
    Key key,
    @required this.myInfoPageStyles,
    // @required this.newPinCode,
    // @required this.firstName,
    // @required this.middleName,
    // @required this.lastName,
    // @required this.phoneNumber,
    @required this.userModel,
    @required this.isNewInfo,
    @required this.haveNavbar,
  }) : super(key: key);

  @override
  _MyInfoViewState createState() => _MyInfoViewState();
}

class _MyInfoViewState extends State<MyInfoView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _middleNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _birthDayController;
  TextEditingController _phoneNumberController = TextEditingController();
  // TextEditingController _telephoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  // TextEditingController _streetController = TextEditingController();
  TextEditingController _aptController = TextEditingController();
  TextEditingController _zipcodeController = TextEditingController();
  // TextEditingController _nationalityController = TextEditingController();
  // TextEditingController _occupationController = TextEditingController();
  // TextEditingController _placeOfBirthController = TextEditingController();
  // TextEditingController _remarksController = TextEditingController();
  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _middleNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _genderFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _birthDayFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();
  FocusNode _telephoneFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  // FocusNode _streetFocusNode = FocusNode();
  FocusNode _aptFocusNode = FocusNode();
  FocusNode _zipCodeFocusNode = FocusNode();
  FocusNode _placeOfBirthFocusNode = FocusNode();
  // FocusNode _nationalityFocusNode = FocusNode();
  FocusNode _occupationFocusNode = FocusNode();
  // FocusNode _remarksFocusNode = FocusNode();

  int _gender;
  String _state;
  String _city;
  String _nationality;
  bool validateStarted;
  List<Map<String, dynamic>> countryList;

  KeicyProgressDialog _keicyProgressDialog;

  AuthProvider _authProvider;
  UserProvider _userProvider;

  @override
  void initState() {
    super.initState();

    _firstNameController.text = widget.userModel?.firstName ?? "";
    _middleNameController.text = widget.userModel?.middleName ?? "";
    _lastNameController.text = widget.userModel?.lastName ?? "";
    _birthDayController = TextEditingController(
        text: widget.userModel?.dobTs != 0
            ? KeicyDateTime.convertMillisecondsToDateString(ms: widget.userModel?.dobTs)
            : "");
    _gender = widget.userModel?.gender;
    _emailController.text = widget.userModel?.email ?? "";
    _phoneNumberController.text = widget.userModel?.phoneNumber;
    // _telephoneController.text = widget.userModel?.telephone;
    _state = widget.userModel?.state;
    _city = widget.userModel?.city;
    _addressController.text = widget.userModel?.address;
    // _streetController.text = widget.userModel?.street;
    _aptController.text = widget.userModel?.apt;
    _zipcodeController.text = widget.userModel?.zipCode;
    // _nationalityController.text = widget.userModel?.nationality;
    // _nationality = widget.userModel?.nationality;
    // _remarksController.text = widget.userModel?.remarks;

    _userProvider = UserProvider.of(context);
    _authProvider = AuthProvider.of(context);
    _authProvider.setAuthState(
      _authProvider.authState.update(progressState: 0, errorString: ""),
      isNotifiable: false,
    );

    validateStarted = false;
    countryList = [];
    for (var i = 0; i < Countries.countryList.length; i++) {
      countryList.add({
        "text": Countries.countryList[i]["nationality"],
        "value": Countries.countryList[i]["nationality"],
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userProvider.addListener(_userProviderListener);

      _keicyProgressDialog = KeicyProgressDialog.of(
        context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        layout: Layout.Column,
        padding: EdgeInsets.zero,
        width: widget.myInfoPageStyles.widthDp * 120,
        height: widget.myInfoPageStyles.widthDp * 120,
        progressWidget: Container(
          width: widget.myInfoPageStyles.widthDp * 120,
          height: widget.myInfoPageStyles.widthDp * 120,
          padding: EdgeInsets.all(widget.myInfoPageStyles.widthDp * 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.myInfoPageStyles.widthDp * 10),
          ),
          child: SpinKitFadingCircle(
            color: AppColors.primaryColor,
            size: widget.myInfoPageStyles.widthDp * 80,
          ),
        ),
        message: "",
      );
    });
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
        if (widget.isNewInfo)
          Navigator.of(context).pushNamed(AppRoutes.MyBankPage);
        else {
          StatusAlert.show(
            context,
            duration: Duration(seconds: 2),
            title: 'Your information Successfully saved',
            titleOptions: StatusAlertTextConfiguration(
              style: TextStyle(fontSize: widget.myInfoPageStyles.fontSp * 16, color: AppColors.blackColor),
            ),
            margin: EdgeInsets.all(widget.myInfoPageStyles.widthDp * 80),
            padding: EdgeInsets.all(widget.myInfoPageStyles.widthDp * 20),
            configuration: IconConfiguration(
              icon: Icons.check_circle_outline,
              color: AppColors.primaryColor,
              size: widget.myInfoPageStyles.widthDp * 80,
            ),
            blurPower: 3,
            backgroundColor: Colors.white,
          );
          Navigator.of(context).pop();
        }
        break;
      case -1:
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: _userProvider.userState.errorString,
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.myInfoPageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.myInfoPageStyles.widthDp * 80),
          padding: EdgeInsets.all(widget.myInfoPageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.error_outline,
            color: Colors.redAccent,
            size: widget.myInfoPageStyles.widthDp * 80,
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
    _userProvider.removeListener(_userProviderListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.scaffoldBackColor2,
      body: Container(
        height: widget.myInfoPageStyles.mainHeight - (widget.haveNavbar ? 93 : 0),
        child: KeicyInkWell(
          onTap: () {},
          child: Column(
            children: [
              HeaderWidget(
                title: (widget.isNewInfo) ? MyInfoPageString.title1 : MyInfoPageString.title,
                widthDp: widget.myInfoPageStyles.widthDp,
                fontSp: widget.myInfoPageStyles.fontSp,
                haveBackIcon: (!widget.isNewInfo),
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
    List<DropdownMenuItem<String>> stateItemList = [];
    List<DropdownMenuItem<String>> cityItemList = [];
    stateItemList = AppConstants.usStatesCities.keys
        .toList()
        .map((item) => DropdownMenuItem(
              child: new Text(item, style: widget.myInfoPageStyles.formFieldTextStyle),
              value: item,
            ))
        .toList();
    if (_state != "" && _state != null) {
      List<String> _list = [];
      for (var i = 0; i < AppConstants.usStatesCities[_state].length; i++) {
        _list.add(AppConstants.usStatesCities[_state][i].toString());
      }

      cityItemList = _list
          .map((item) => DropdownMenuItem(
                child: new Text(item.toString(), style: widget.myInfoPageStyles.formFieldTextStyle),
                value: item.toString(),
              ))
          .toList();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.myInfoPageStyles.widthDp * 20,
        vertical: widget.myInfoPageStyles.widthDp * 30,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// First Name
            KeicyTextFormField(
              width: null,
              height: widget.myInfoPageStyles.formFieldHeight,
              controller: _firstNameController,
              focusNode: _firstNameFocusNode,
              labelSpacing: widget.myInfoPageStyles.widthDp * 14,
              fillColor: Colors.white,
              borderRadius: widget.myInfoPageStyles.borderRadius,
              border: Border.all(color: Colors.transparent),
              errorBorder: Border.all(color: Colors.redAccent),
              contentHorizontalPadding: widget.myInfoPageStyles.widthDp * 13,
              prefixIcons: [
                Icon(Icons.person_outline, color: AppColors.secondaryColor, size: widget.myInfoPageStyles.iconSize),
              ],
              textStyle: widget.myInfoPageStyles.formFieldTextStyle,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter(RegExp("[a-zA-Z]"), allow: true),
              ],
              hintText: MyInfoPageString.firstNameHint,
              hintStyle: widget.myInfoPageStyles.formFieldHintStyle,
              validatorHandler: (input) =>
                  (input.length < 3) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3") : null,
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(_middleNameFocusNode);
              },
            ),

            /// Middle Name
            SizedBox(height: widget.myInfoPageStyles.widthDp * 5),
            KeicyTextFormField(
              width: null,
              height: widget.myInfoPageStyles.formFieldHeight,

              controller: _middleNameController,
              focusNode: _middleNameFocusNode,
              labelSpacing: widget.myInfoPageStyles.widthDp * 14,
              fillColor: Colors.white,
              borderRadius: widget.myInfoPageStyles.borderRadius,
              border: Border.all(color: Colors.transparent),
              errorBorder: Border.all(color: Colors.redAccent),
              contentHorizontalPadding: widget.myInfoPageStyles.widthDp * 13,
              prefixIcons: [
                Icon(Icons.person_outline, color: AppColors.secondaryColor, size: widget.myInfoPageStyles.iconSize),
              ],
              textStyle: widget.myInfoPageStyles.formFieldTextStyle,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter(RegExp("[a-zA-Z]"), allow: true),
              ],
              hintText: MyInfoPageString.middleNameHint,
              hintStyle: widget.myInfoPageStyles.formFieldHintStyle,
              // validatorHandler: (input) => (input.length < 3) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3") : null,
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(_lastNameFocusNode);
              },
            ),

            /// Last Name
            SizedBox(height: widget.myInfoPageStyles.widthDp * 5),
            KeicyTextFormField(
              width: null,
              height: widget.myInfoPageStyles.formFieldHeight,
              controller: _lastNameController,
              focusNode: _lastNameFocusNode,
              labelSpacing: widget.myInfoPageStyles.widthDp * 14,
              fillColor: Colors.white,
              borderRadius: widget.myInfoPageStyles.borderRadius,
              border: Border.all(color: Colors.transparent),
              errorBorder: Border.all(color: Colors.redAccent),
              contentHorizontalPadding: widget.myInfoPageStyles.widthDp * 13,
              prefixIcons: [
                Icon(Icons.person_outline, color: AppColors.secondaryColor, size: widget.myInfoPageStyles.iconSize),
              ],
              textStyle: widget.myInfoPageStyles.formFieldTextStyle,
              keyboardType: TextInputType.name,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter(RegExp("[a-zA-Z]"), allow: true),
              ],
              textInputAction: TextInputAction.next,
              hintText: MyInfoPageString.lastNameHint,
              hintStyle: widget.myInfoPageStyles.formFieldHintStyle,
              validatorHandler: (input) =>
                  (input.length < 3) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3") : null,
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(_birthDayFocusNode);
              },
            ),

            /// birthday
            SizedBox(height: widget.myInfoPageStyles.widthDp * 5),
            KeicyTextFormField(
              width: null,
              height: widget.myInfoPageStyles.formFieldHeight,
              controller: _birthDayController,
              focusNode: _birthDayFocusNode,
              labelSpacing: widget.myInfoPageStyles.widthDp * 14,
              fillColor: Colors.white,
              borderRadius: widget.myInfoPageStyles.borderRadius,
              border: Border.all(color: Colors.transparent),
              errorBorder: Border.all(color: Colors.redAccent),
              contentHorizontalPadding: widget.myInfoPageStyles.widthDp * 13,
              prefixIcons: [
                Icon(Icons.date_range, color: AppColors.secondaryColor, size: widget.myInfoPageStyles.iconSize),
              ],
              suffixIcons: [
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.blackColor,
                  size: widget.myInfoPageStyles.iconSize,
                )
              ],
              textStyle: widget.myInfoPageStyles.formFieldTextStyle,
              readOnly: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              hintText: MyInfoPageString.birthDayHint,
              hintStyle: widget.myInfoPageStyles.formFieldHintStyle,
              validatorHandler: (input) {
                if (input.isEmpty) return ValidateErrorString.textEmptyErrorText.replaceAll("{}", "Birth Day");

                DateTime dateTime = KeicyDateTime.convertDateStringToDateTime(dateString: input);

                if (DateTime.now().year - dateTime.year < 18) return ValidateErrorString.birthDayErrorText;

                return null;
              },
              onFieldSubmittedHandler: (input) {},
              onTapHandler: () {
                showCupertinoModalPopup<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildBottomPicker(
                      CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime:
                            KeicyDateTime.convertDateStringToDateTime(dateString: _birthDayController.text.trim()),
                        minimumYear: 1950,
                        maximumYear: DateTime.now().year,
                        onDateTimeChanged: (DateTime newDateTime) {
                          _birthDayController.text = KeicyDateTime.convertDateTimeToDateString(dateTime: newDateTime);
                        },
                      ),
                    );
                  },
                );
              },
            ),

            /// Gender
            SizedBox(height: widget.myInfoPageStyles.widthDp * 5),
            KeicyDropDownFormField(
              width: null,
              height: widget.myInfoPageStyles.widthDp * 55,
              focusNode: _genderFocusNode,
              menuItems: AppConstants.genderList,
              border: Border.all(color: Colors.transparent),
              errorBorder: Border.all(color: Colors.redAccent),
              borderRadius: widget.myInfoPageStyles.borderRadius,
              selectedItemStyle: widget.myInfoPageStyles.formFieldTextStyle,
              hintText: MyInfoPageString.genderHint,
              hintStyle: widget.myInfoPageStyles.formFieldHintStyle,
              fillColor: Colors.white,
              value: _gender,
              prefixIcons: [
                Icon(
                  Icons.people_outline,
                  color: Color(0xFFF7A000),
                  size: widget.myInfoPageStyles.iconSize,
                )
              ],
              contentHorizontalPadding: widget.myInfoPageStyles.widthDp * 13,
              onValidateHandler: (value) => (_gender == null) ? ValidateErrorString.dropdownItemErrorText : null,
              onChangeHandler: (value) {
                _gender = value;
                FocusScope.of(context).requestFocus(_emailFocusNode);
              },
            ),

            /// Email
            SizedBox(height: widget.myInfoPageStyles.widthDp * 5),
            KeicyTextFormField(
              width: null,
              height: widget.myInfoPageStyles.formFieldHeight,
              controller: _emailController,
              focusNode: _emailFocusNode,
              labelSpacing: widget.myInfoPageStyles.widthDp * 14,
              fillColor: Colors.white,
              borderRadius: widget.myInfoPageStyles.borderRadius,
              border: Border.all(color: Colors.transparent),
              errorBorder: Border.all(color: Colors.redAccent),
              contentHorizontalPadding: widget.myInfoPageStyles.widthDp * 13,
              prefixIcons: [
                Icon(Icons.email, color: Color(0xFFF7A000), size: widget.myInfoPageStyles.iconSize),
              ],
              textStyle: widget.myInfoPageStyles.formFieldTextStyle,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              hintText: MyInfoPageString.emailHint,
              hintStyle: widget.myInfoPageStyles.formFieldHintStyle,
              validatorHandler: (input) =>
                  (input != "") && !KeicyValidators.isValidEmail(input) ? ValidateErrorString.emailErrorText : null,
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),

            /// Phone Number
            SizedBox(height: widget.myInfoPageStyles.widthDp * 5),
            KeicyTextFormField(
              width: null,
              height: widget.myInfoPageStyles.formFieldHeight,
              controller: _phoneNumberController,
              focusNode: _phoneNumberFocusNode,
              labelSpacing: widget.myInfoPageStyles.widthDp * 14,
              fillColor: Colors.white,
              borderRadius: widget.myInfoPageStyles.borderRadius,
              border: Border.all(color: Colors.transparent),
              errorBorder: Border.all(color: Colors.redAccent),
              contentHorizontalPadding: widget.myInfoPageStyles.widthDp * 13,
              readOnly: true,
              inputFormatters: [
                MaskTextInputFormatter(mask: AppConstants.maskString, filter: {'0': RegExp(r'[0-9]')}),
              ],
              prefixIcons: [
                Container(
                  child: Row(
                    children: [
                      Icon(Icons.phone_iphone, color: Color(0xFFF7A000), size: widget.myInfoPageStyles.iconSize),
                    ],
                  ),
                ),
              ],
              textStyle: widget.myInfoPageStyles.formFieldTextStyle,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              hintText: MyInfoPageString.phoneHint,
              hintStyle: widget.myInfoPageStyles.formFieldHintStyle,
              validatorHandler: (input) =>
                  (input.length < 9) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "9") : null,
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(_telephoneFocusNode);
              },
            ),

            // /// nationality
            // SizedBox(height: widget.myInfoPageStyles.widthDp * 5),
            // KeicyDropDownFormField(
            //   width: null,
            //   height: widget.myInfoPageStyles.widthDp * 55,
            //   focusNode: _nationalityFocusNode,
            //   menuItems: countryList,
            //   border: Border.all(color: Colors.transparent),
            //   errorBorder: Border.all(color: Colors.redAccent),
            //   borderRadius: widget.myInfoPageStyles.borderRadius,
            //   selectedItemStyle: widget.myInfoPageStyles.formFieldTextStyle,
            //   hintText: MyInfoPageString.nationalityHint,
            //   hintStyle: widget.myInfoPageStyles.formFieldHintStyle,
            //   fillColor: Colors.white,
            //   value: _nationality == "" ? null : _nationality,
            //   prefixIcons: [
            //     Icon(
            //       Icons.language,
            //       color: Color(0xFFF7A000),
            //       size: widget.myInfoPageStyles.iconSize,
            //     )
            //   ],
            //   contentHorizontalPadding: widget.myInfoPageStyles.widthDp * 13,
            //   onChangeHandler: (value) {
            //     _nationality = value;
            //     FocusScope.of(context).requestFocus(FocusNode());
            //   },
            // ),

            // /// telephone Number
            // SizedBox(height: widget.myInfoPageStyles.widthDp * 5),
            // KeicyTextFormField(
            //   width: null,
            //   height: widget.myInfoPageStyles.formFieldHeight,
            //
            //   controller: _telephoneController,
            //   focusNode: _telephoneFocusNode,
            //   labelSpacing: widget.myInfoPageStyles.widthDp * 14,
            //   fillColor: Colors.white,
            //   borderRadius: widget.myInfoPageStyles.borderRadius,
            //   border: Border.all(color: Colors.transparent),
            //   errorBorder: Border.all(color: Colors.redAccent),
            //   contentHorizontalPadding: widget.myInfoPageStyles.widthDp * 13,
            //   readOnly: false,
            //   // inputFormatters: [
            //   //   MaskTextInputFormatter(mask: AppConstants.maskString, filter: {'0': RegExp(r'[0-9]')}),
            //   // ],
            //   prefixIcons: [
            //     Container(
            //       child: Row(
            //         children: [
            //           Icon(Icons.phone, color: Color(0xFFF7A000), size: widget.myInfoPageStyles.iconSize),
            //         ],
            //       ),
            //     ),
            //   ],
            //   textStyle: widget.myInfoPageStyles.formFieldTextStyle,
            //   keyboardType: TextInputType.phone,
            //   textInputAction: TextInputAction.next,
            //   hintText: MyInfoPageString.telephoneHint,
            //   hintStyle: widget.myInfoPageStyles.formFieldHintStyle,
            //   validatorHandler: (input) =>
            //       (input != "" && input.length < 9) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "9") : null,
            //   onFieldSubmittedHandler: (input) {
            //     FocusScope.of(context).requestFocus(_genderFocusNode);
            //   },
            // ),

            ///
            SizedBox(height: widget.myInfoPageStyles.widthDp * 15),
            Text(MyInfoPageString.detailLabel, style: widget.myInfoPageStyles.detailLabelStyle),
            SizedBox(height: widget.myInfoPageStyles.widthDp * 15),

            /// Country Name
            SizedBox(height: widget.myInfoPageStyles.widthDp * 5),
            KeicyTextFormField(
              initialValue: AppConstants.countryList[0]['text'],
              width: null,
              height: widget.myInfoPageStyles.formFieldHeight,
              labelSpacing: widget.myInfoPageStyles.widthDp * 14,
              fillColor: Colors.white,
              borderRadius: widget.myInfoPageStyles.borderRadius,
              border: Border.all(color: Colors.transparent),
              errorBorder: Border.all(color: Colors.redAccent),
              contentHorizontalPadding: widget.myInfoPageStyles.widthDp * 13,
              readOnly: true,
              prefixIcons: [
                Container(
                  child: Row(
                    children: [
                      Icon(Icons.language, color: Color(0xFFF7A000), size: widget.myInfoPageStyles.iconSize),
                    ],
                  ),
                ),
              ],
              textStyle: widget.myInfoPageStyles.formFieldTextStyle,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              hintStyle: widget.myInfoPageStyles.formFieldHintStyle,
            ),

            /// state Name
            SizedBox(height: widget.myInfoPageStyles.widthDp * 5),
            SearchChoices.single(
              items: stateItemList,
              value: _state,
              hint: Text(MyInfoPageString.stateHint, style: widget.myInfoPageStyles.formFieldHintStyle),
              selectedValueWidgetFn: (value) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(value, style: widget.myInfoPageStyles.formFieldTextStyle),
                  ],
                );
              },
              searchHint: null,
              style: widget.myInfoPageStyles.formFieldTextStyle,
              height: widget.myInfoPageStyles.formFieldHeight,
              prefixIcon: SvgPicture.asset(
                AppAssets.stateIcon,
                width: widget.myInfoPageStyles.iconSize,
                height: widget.myInfoPageStyles.iconSize,
                fit: BoxFit.fill,
              ),
              padding: EdgeInsets.symmetric(horizontal: widget.myInfoPageStyles.widthDp * 20, vertical: 0),
              borderRadius: widget.myInfoPageStyles.borderRadius,
              borderColor: Colors.transparent,
              fillColor: Colors.white,
              iconSize: widget.myInfoPageStyles.iconSize,
              onChanged: (value) {
                _state = value;
              },
              dialogBox: true,
              isExpanded: true,
              validator: (value) =>
                  (validateStarted && value == null) ? ValidateErrorString.dropdownItemErrorText : null,
            ),

            /// city Name
            SizedBox(height: widget.myInfoPageStyles.widthDp * 5),
            SearchChoices.single(
              items: cityItemList,
              value: _city,
              hint: Text(MyInfoPageString.cityHint, style: widget.myInfoPageStyles.formFieldHintStyle),
              selectedValueWidgetFn: (value) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(value, style: widget.myInfoPageStyles.formFieldTextStyle),
                  ],
                );
              },
              searchHint: null,
              style: widget.myInfoPageStyles.formFieldTextStyle,
              height: widget.myInfoPageStyles.formFieldHeight,
              prefixIcon: SvgPicture.asset(
                AppAssets.cityIcon,
                width: widget.myInfoPageStyles.iconSize,
                height: widget.myInfoPageStyles.iconSize,
                fit: BoxFit.cover,
              ),
              padding: EdgeInsets.symmetric(horizontal: widget.myInfoPageStyles.widthDp * 20, vertical: 0),
              borderRadius: widget.myInfoPageStyles.borderRadius,
              borderColor: Colors.transparent,
              fillColor: Colors.white,
              iconSize: widget.myInfoPageStyles.iconSize,
              onChanged: (value) {
                _city = value;
                FocusScope.of(context).requestFocus(_addressFocusNode);
              },
              dialogBox: true,
              isExpanded: true,
              validator: (value) =>
                  (validateStarted && value == null) ? ValidateErrorString.dropdownItemErrorText : null,
            ),

            /// Address
            SizedBox(height: widget.myInfoPageStyles.widthDp * 5),
            KeicyTextFormField(
              width: null,
              height: widget.myInfoPageStyles.formFieldHeight,
              controller: _addressController,
              focusNode: _addressFocusNode,
              labelSpacing: widget.myInfoPageStyles.widthDp * 14,
              fillColor: Colors.white,
              borderRadius: widget.myInfoPageStyles.borderRadius,
              border: Border.all(color: Colors.transparent),
              errorBorder: Border.all(color: Colors.redAccent),
              contentHorizontalPadding: widget.myInfoPageStyles.widthDp * 13,
              prefixIcons: [
                Icon(Icons.location_on, color: Color(0xFFF7A000), size: widget.myInfoPageStyles.iconSize),
              ],
              textStyle: widget.myInfoPageStyles.formFieldTextStyle,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              hintText: MyInfoPageString.addressHint,
              hintStyle: widget.myInfoPageStyles.formFieldHintStyle,
              validatorHandler: (input) =>
                  (input.length < 3) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3") : null,
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(_aptFocusNode);
              },
            ),

            // /// Street
            // SizedBox(height: widget.myInfoPageStyles.widthDp * 5),
            // KeicyTextFormField(
            //   width: null,
            //   height: widget.myInfoPageStyles.formFieldHeight,

            //   controller: _streetController,
            //   focusNode: _streetFocusNode,
            //   labelSpacing: widget.myInfoPageStyles.widthDp * 14,
            //   fillColor: Colors.white,
            //   borderRadius: widget.myInfoPageStyles.borderRadius,
            //   border: Border.all(color: Colors.transparent),
            //   errorBorder: Border.all(color: Colors.redAccent),
            //   contentHorizontalPadding: widget.myInfoPageStyles.widthDp * 13,
            //   prefixIcons: [
            //     SvgPicture.asset(
            //       AppAssets.streetIcon,
            //       width: widget.myInfoPageStyles.iconSize,
            //       height: widget.myInfoPageStyles.iconSize,
            //       fit: BoxFit.fill,
            //     )
            //   ],
            //   textStyle: widget.myInfoPageStyles.formFieldTextStyle,
            //   keyboardType: TextInputType.text,
            //   textInputAction: TextInputAction.next,
            //   hintText: MyInfoPageString.streetHint,
            //   hintStyle: widget.myInfoPageStyles.formFieldHintStyle,
            //   // validatorHandler: (input) =>
            //   //     (input.length < 3) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3") : null,
            //   onFieldSubmittedHandler: (input) {
            //     FocusScope.of(context).requestFocus(_aptFocusNode);
            //   },
            // ),

            /// Apt
            SizedBox(height: widget.myInfoPageStyles.widthDp * 5),
            KeicyTextFormField(
              width: null,
              height: widget.myInfoPageStyles.formFieldHeight,
              controller: _aptController,
              focusNode: _aptFocusNode,
              labelSpacing: widget.myInfoPageStyles.widthDp * 14,
              fillColor: Colors.white,
              borderRadius: widget.myInfoPageStyles.borderRadius,
              border: Border.all(color: Colors.transparent),
              errorBorder: Border.all(color: Colors.redAccent),
              contentHorizontalPadding: widget.myInfoPageStyles.widthDp * 13,
              prefixIcons: [
                Icon(Icons.location_city, color: Color(0xFFF7A000), size: widget.myInfoPageStyles.iconSize),
              ],
              textStyle: widget.myInfoPageStyles.formFieldTextStyle,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              hintText: MyInfoPageString.aptHint,
              hintStyle: widget.myInfoPageStyles.formFieldHintStyle,
              validatorHandler: (input) => (input != "" && input.length < 3)
                  ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3")
                  : null,
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(_zipCodeFocusNode);
              },
            ),

            /// Zip Code
            SizedBox(height: widget.myInfoPageStyles.widthDp * 5),
            KeicyTextFormField(
              width: null,
              height: widget.myInfoPageStyles.formFieldHeight,
              controller: _zipcodeController,
              focusNode: _zipCodeFocusNode,
              labelSpacing: widget.myInfoPageStyles.widthDp * 14,
              fillColor: Colors.white,
              borderRadius: widget.myInfoPageStyles.borderRadius,
              border: Border.all(color: Colors.transparent),
              errorBorder: Border.all(color: Colors.redAccent),
              contentHorizontalPadding: widget.myInfoPageStyles.widthDp * 13,
              prefixIcons: [
                Icon(Icons.code, color: Color(0xFFF7A000), size: widget.myInfoPageStyles.iconSize),
              ],
              textStyle: widget.myInfoPageStyles.formFieldTextStyle,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              hintText: MyInfoPageString.zipCodeHint,
              hintStyle: widget.myInfoPageStyles.formFieldHintStyle,
              validatorHandler: (input) => (input != "" && input.length < 3)
                  ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3")
                  : null,
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),

            // KeicyTextFormField(
            //   width: null,
            //   height: widget.myInfoPageStyles.formFieldHeight,
            //
            //   controller: _nationalityController,
            //   focusNode: _nationalityFocusNode,
            //   labelSpacing: widget.myInfoPageStyles.widthDp * 14,
            //   fillColor: Colors.white,
            //   borderRadius: widget.myInfoPageStyles.borderRadius,
            //   border: Border.all(color: Colors.transparent),
            //   errorBorder: Border.all(color: Colors.redAccent),
            //   contentHorizontalPadding: widget.myInfoPageStyles.widthDp * 13,
            //   prefixIcons: [
            //     Icon(Icons.code, color: Color(0xFFF7A000), size: widget.myInfoPageStyles.iconSize),
            //   ],
            //   textStyle: widget.myInfoPageStyles.formFieldTextStyle,
            //   keyboardType: TextInputType.text,
            //   textInputAction: TextInputAction.next,
            //   hintText: MyInfoPageString.nationalityHint,
            //   hintStyle: widget.myInfoPageStyles.formFieldHintStyle,
            //   validatorHandler: (input) => (input != "" && input.length < 3)
            //       ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3")
            //       : null,
            //   onFieldSubmittedHandler: (input) {
            //     FocusScope.of(context).requestFocus(_remarksFocusNode);
            //   },
            // ),

            // /// placeOfBirth
            // SizedBox(height: widget.myInfoPageStyles.widthDp * 5),
            // KeicyTextFormField(
            //   width: null,
            //   height: widget.myInfoPageStyles.formFieldHeight,
            //
            //   controller: _placeOfBirthController,
            //   focusNode: _placeOfBirthFocusNode,
            //   labelSpacing: widget.myInfoPageStyles.widthDp * 14,
            //   fillColor: Colors.white,
            //   borderRadius: widget.myInfoPageStyles.borderRadius,
            //   border: Border.all(color: Colors.transparent),
            //   errorBorder: Border.all(color: Colors.redAccent),
            //   contentHorizontalPadding: widget.myInfoPageStyles.widthDp * 13,
            //   prefixIcons: [
            //     Icon(Icons.code, color: Color(0xFFF7A000), size: widget.myInfoPageStyles.iconSize),
            //   ],
            //   textStyle: widget.myInfoPageStyles.formFieldTextStyle,
            //   keyboardType: TextInputType.text,
            //   textInputAction: TextInputAction.next,
            //   hintText: MyInfoPageString.placeOfBirthHint,
            //   hintStyle: widget.myInfoPageStyles.formFieldHintStyle,
            //   validatorHandler: (input) =>
            //       (input != "" && input.length < 3) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3") : null,
            //   onFieldSubmittedHandler: (input) {
            //     FocusScope.of(context).requestFocus(_nationalityFocusNode);
            //   },
            // ),

            // /// Occupation
            // SizedBox(height: widget.myInfoPageStyles.widthDp * 5),
            // KeicyTextFormField(
            //   width: null,
            //   height: widget.myInfoPageStyles.formFieldHeight,
            //
            //   controller: _occupationController,
            //   focusNode: _occupationFocusNode,
            //   labelSpacing: widget.myInfoPageStyles.widthDp * 14,
            //   fillColor: Colors.white,
            //   borderRadius: widget.myInfoPageStyles.borderRadius,
            //   border: Border.all(color: Colors.transparent),
            //   errorBorder: Border.all(color: Colors.redAccent),
            //   contentHorizontalPadding: widget.myInfoPageStyles.widthDp * 13,
            //   prefixIcons: [
            //     Icon(Icons.code, color: Color(0xFFF7A000), size: widget.myInfoPageStyles.iconSize),
            //   ],
            //   textStyle: widget.myInfoPageStyles.formFieldTextStyle,
            //   keyboardType: TextInputType.text,
            //   textInputAction: TextInputAction.next,
            //   hintText: MyInfoPageString.occupationHint,
            //   hintStyle: widget.myInfoPageStyles.formFieldHintStyle,
            //   validatorHandler: (input) =>
            //       (input != "" && input.length < 3) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3") : null,
            //   onFieldSubmittedHandler: (input) {
            //     FocusScope.of(context).requestFocus(_remarksFocusNode);
            //   },
            // ),

            /// remarks
            // SizedBox(height: widget.myInfoPageStyles.widthDp * 5),
            // KeicyTextFormField(
            //   width: null,
            //   height: widget.myInfoPageStyles.formFieldHeight,
            //   controller: _remarksController,
            //   focusNode: _remarksFocusNode,
            //   labelSpacing: widget.myInfoPageStyles.widthDp * 14,
            //   fillColor: Colors.white,
            //   borderRadius: widget.myInfoPageStyles.borderRadius,
            //   border: Border.all(color: Colors.transparent),
            //   errorBorder: Border.all(color: Colors.redAccent),
            //   contentHorizontalPadding: widget.myInfoPageStyles.widthDp * 13,
            //   prefixIcons: [
            //     Icon(Icons.code, color: Color(0xFFF7A000), size: widget.myInfoPageStyles.iconSize),
            //   ],
            //   textStyle: widget.myInfoPageStyles.formFieldTextStyle,
            //   keyboardType: TextInputType.text,
            //   textInputAction: TextInputAction.next,
            //   hintText: MyInfoPageString.remaksHint,
            //   hintStyle: widget.myInfoPageStyles.formFieldHintStyle,
            //   validatorHandler: (input) => (input != "" && input.length < 3)
            //       ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3")
            //       : null,
            //   onFieldSubmittedHandler: (input) {
            //     FocusScope.of(context).requestFocus(FocusNode());
            //   },
            // ),

            SizedBox(height: widget.myInfoPageStyles.widthDp * 20),
            KeicyRaisedButton(
              height: widget.myInfoPageStyles.formFieldHeight,
              color: Color(0xFFF7A000),
              elevation: 0,
              borderRadius: widget.myInfoPageStyles.borderRadius,
              child: Text(
                MyInfoPageString.saveButton,
                style: widget.myInfoPageStyles.buttonTextStyle,
              ),
              onPressed: () {
                _savePersonalHandler(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: widget.myInfoPageStyles.widthDp * 216,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  void _savePersonalHandler(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      StatusAlert.show(
        context,
        duration: Duration(seconds: 2),
        title: "Sorry, there was a problem. please complete all your information",
        titleOptions: StatusAlertTextConfiguration(
          style: TextStyle(fontSize: widget.myInfoPageStyles.fontSp * 16, color: AppColors.blackColor),
        ),
        margin: EdgeInsets.all(widget.myInfoPageStyles.widthDp * 80),
        padding: EdgeInsets.all(widget.myInfoPageStyles.widthDp * 20),
        configuration: IconConfiguration(
          icon: Icons.error_outline,
          color: Colors.redAccent,
          size: widget.myInfoPageStyles.widthDp * 80,
        ),
        blurPower: 3,
        backgroundColor: Colors.white,
      );

      setState(() {
        validateStarted = true;
      });
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());
    await _keicyProgressDialog.show();

    _userProvider.setUserState(_userProvider.userState.update(progressState: 1), isNotifiable: false);
    String phoneNumber = _phoneNumberController.text.trim().replaceAll(RegExp(r'[( )-]'), "");
    // String telephone = _telephoneController.text.trim().replaceAll(RegExp(r'[( )-]'), "");

    UserModel userModel = UserModel.fromJson(_userProvider.userState.userModel.toJson());
    userModel.uid = _authProvider.authState.firebaseUser.uid;
    userModel.firstName = _firstNameController.text.trim();
    userModel.middleName = _middleNameController.text.trim();
    userModel.lastName = _lastNameController.text.trim();
    userModel.dobTs = KeicyDateTime.convertDateStringToMilliseconds(dateString: _birthDayController.text.trim());
    userModel.gender = _gender;
    userModel.email = _emailController.text.trim();
    userModel.phoneNumber = phoneNumber;
    // userModel.telephone = telephone;
    userModel.country = AppConstants.countryList[0]["text"];
    userModel.state = _state;
    userModel.city = _city;
    userModel.address = _addressController.text.trim();
    userModel.apt = _aptController.text.trim();
    userModel.zipCode = _zipcodeController.text.trim();
    // userModel.street = _streetController.text.trim();
    // userModel.nationality = _nationality;
    // userModel.nationality = _nationalityController.text.trim();
    // userModel.placeofBirth = _placeOfBirthController.text.trim();
    // userModel.occupation = _occupationController.text.trim();
    // userModel.remarks = _remarksController.text.trim();
    userModel.isBeneficiary = false;
    userModel.pinCode = widget.userModel.pinCode;
    userModel.ts = DateTime.now().millisecondsSinceEpoch;

    print(userModel.toJson());

    if (widget.isNewInfo)
      _userProvider.registerUserData(
        userModel: userModel,
      );
    else {
      int day = DateTime.now().day;
      int month = DateTime.now().month;
      if (day != userModel.day) {
        userModel.dailyCount = 0;
        userModel.day = DateTime.now().day;
      }
      if (month != userModel.month) {
        userModel.monthlyCount = 0;
        userModel.month = DateTime.now().month;
      }
      _userProvider.saveUserData(
        userID: userModel.id,
        userModel: userModel,
        updateJuba: true,
      );
    }
  }
}
