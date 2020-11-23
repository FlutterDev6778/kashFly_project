import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:status_alert/status_alert.dart';
import 'package:provider/provider.dart';

import 'package:keicy_raised_button/keicy_raised_button.dart';
import 'package:keicy_inkwell/keicy_inkwell.dart';
import 'package:keicy_utils/date_time_convert.dart';
import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';
import 'package:keicy_utils/validators.dart';

import 'package:money_transfer_app/Pages/Components/searchable_dropdown.dart';
import 'package:money_transfer_app/Pages/PersonalDetailPage/Components/address_detail_widgets.dart';
import 'package:money_transfer_app/Pages/PersonalDetailPage/Components/personal_detail_widgets.dart';
import 'package:money_transfer_framework/Constants/constants.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class PersonalDetailView extends StatefulWidget {
  final PersonalDetailPageStyles personalDetailPageStyles;

  const PersonalDetailView({
    Key key,
    this.personalDetailPageStyles,
  }) : super(key: key);

  @override
  _PersonalDetailViewState createState() => _PersonalDetailViewState();
}

class _PersonalDetailViewState extends State<PersonalDetailView> with TickerProviderStateMixin {
  GlobalKey<FormState> _personalFormKey = GlobalKey<FormState>();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _middleNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _birthDayFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _zipCodeFocusNode = FocusNode();
  final FocusNode _aptFocusNode = FocusNode();
  final FocusNode _streetFocusNode = FocusNode();

  TextEditingController _firstNameController;
  TextEditingController _middleNameController;
  TextEditingController _lastNameController;
  TextEditingController _birthDayController;
  TextEditingController _emailController;
  TextEditingController _phoneController;
  TextEditingController _addressController;
  TextEditingController _zipCodeController;
  TextEditingController _aptController;
  TextEditingController _streetController;

  int _gender;
  String _state;
  String _city;

  UserProvider _userProvider;
  KeicyProgressDialog _keicyProgressDialog;
  bool validateStarted;

  @override
  void initState() {
    super.initState();
    _userProvider = UserProvider.of(context);

    _userProvider.setUserState(
      _userProvider.userState.update(
        progressState: 0,
        errorString: "",
      ),
      isNotifiable: false,
    );

    _firstNameController = TextEditingController(text: _userProvider.userState.userModel.firstName);
    _middleNameController = TextEditingController(text: _userProvider.userState.userModel.middleName);
    _lastNameController = TextEditingController(text: _userProvider.userState.userModel.lastName);
    _birthDayController = TextEditingController(
        text: _userProvider.userState.userModel.dobTs != 0
            ? KeicyDateTime.convertMillisecondsToDateString(ms: _userProvider.userState.userModel.dobTs)
            : "");
    _emailController = TextEditingController(text: _userProvider.userState.userModel.email);
    _phoneController = TextEditingController(text: _userProvider.userState.userModel.phoneNumber);
    _addressController = TextEditingController(text: _userProvider.userState.userModel.address);
    _zipCodeController = TextEditingController(text: _userProvider.userState.userModel.zipCode);
    _aptController = TextEditingController(text: _userProvider.userState.userModel.apt);
    _streetController = TextEditingController(text: _userProvider.userState.userModel.street);

    _state = _userProvider.userState.userModel.state;
    _city = _userProvider.userState.userModel.city;
    _gender = _userProvider.userState.userModel.gender;

    validateStarted = false;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userProvider.addListener(_userProviderListener);

      _keicyProgressDialog = KeicyProgressDialog.of(
        context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        layout: Layout.Column,
        padding: EdgeInsets.zero,
        width: widget.personalDetailPageStyles.widthDp * 120,
        height: widget.personalDetailPageStyles.widthDp * 120,
        progressWidget: Container(
          width: widget.personalDetailPageStyles.widthDp * 120,
          height: widget.personalDetailPageStyles.widthDp * 120,
          padding: EdgeInsets.all(widget.personalDetailPageStyles.widthDp * 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.personalDetailPageStyles.widthDp * 10),
          ),
          child: SpinKitFadingCircle(
            color: AppColors.primaryColor,
            size: widget.personalDetailPageStyles.widthDp * 80,
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
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          blurPower: 3,
          backgroundColor: Colors.white,
          title: 'Successfully saved',
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.personalDetailPageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.personalDetailPageStyles.widthDp * 80),
          padding: EdgeInsets.all(widget.personalDetailPageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.check_circle_outline,
            color: AppColors.primaryColor,
            size: widget.personalDetailPageStyles.widthDp * 80,
          ),
        );

        Navigator.of(context).pop();
        break;
      case -1:
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: _userProvider.userState.errorString,
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.personalDetailPageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.personalDetailPageStyles.widthDp * 80),
          padding: EdgeInsets.all(widget.personalDetailPageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.error_outline,
            color: Colors.redAccent,
            size: widget.personalDetailPageStyles.widthDp * 80,
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
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: AppColors.blackColor,
        title: Text(PersonalDetailPageString.title, style: widget.personalDetailPageStyles.title2Style),
      ),
      body: KeicyInkWell(
        child: Container(
          child: Column(
            children: [
              // SizedBox(height: widget.personalDetailPageStyles.statusbarHeight),
              // _containerHeader(context),
              SizedBox(height: widget.personalDetailPageStyles.widthDp * 20),
              Expanded(child: _containerPersonalDetails(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _containerHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.personalDetailPageStyles.primaryHorizontalPadding,
        vertical: widget.personalDetailPageStyles.primaryVerticalPadding,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: EdgeInsets.all(widget.personalDetailPageStyles.widthDp * 8),
              child: Icon(
                Icons.arrow_back_ios,
                size: widget.personalDetailPageStyles.widthDp * 20,
                color: AppColors.blackColor,
              ),
            ),
          ),
          SizedBox(width: widget.personalDetailPageStyles.widthDp * 20),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(text: PersonalDetailPageString.title.substring(0, 1), style: widget.personalDetailPageStyles.title1Style),
                TextSpan(text: PersonalDetailPageString.title.substring(1), style: widget.personalDetailPageStyles.title2Style),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _containerPersonalDetails(BuildContext context) {
    List<DropdownMenuItem<String>> stateItemList = [];
    List<DropdownMenuItem<String>> cityItemList = [];
    stateItemList = AppConstants.usStatesCities.keys
        .toList()
        .map((item) => DropdownMenuItem(
              child: new Text(item, style: widget.personalDetailPageStyles.textFormFieldTextStyle),
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
                child: new Text(item.toString(), style: widget.personalDetailPageStyles.textFormFieldTextStyle),
                value: item.toString(),
              ))
          .toList();
    }

    return SingleChildScrollView(
      child: Form(
        key: _personalFormKey,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.personalDetailPageStyles.primaryHorizontalPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PersonalDetails(
                personalDetailPageStyles: widget.personalDetailPageStyles,
                firstNameController: _firstNameController,
                firstNameFocusNode: _firstNameFocusNode,
                middleNameController: _middleNameController,
                middleNameFocusNode: _middleNameFocusNode,
                lastNameController: _lastNameController,
                lastNameFocusNode: _lastNameFocusNode,
                birthDayController: _birthDayController,
                birthDayFocusNode: _birthDayFocusNode,
                emailController: _emailController,
                emailFocusNode: _emailFocusNode,
                phoneController: _phoneController,
                phoneFocusNode: _phoneFocusNode,
                onGenderChanged: (value) {
                  _gender = value;
                },
                gender: _gender,
              ),

              ///
              AddressDetails(
                personalDetailPageStyles: widget.personalDetailPageStyles,
                stateItemList: stateItemList,
                cityItemList: cityItemList,
                state: _state,
                city: _city,
                onstateChanged: (value) {
                  setState(() {
                    _state = value;
                  });
                },
                oncityChanged: (value) {
                  _city = value;
                },
                validateStarted: validateStarted,
                addressController: _addressController,
                addressFocusNode: _addressFocusNode,
                streetController: _streetController,
                streetFocusNode: _streetFocusNode,
                aptController: _aptController,
                aptFocusNode: _aptFocusNode,
                zipCodeController: _zipCodeController,
                zipCodeFocusNode: _zipCodeFocusNode,
              ),

              /// button
              SizedBox(height: widget.personalDetailPageStyles.widthDp * 30),
              KeicyRaisedButton(
                height: widget.personalDetailPageStyles.widthDp * 50,
                color: AppColors.primaryColor,
                borderRadius: widget.personalDetailPageStyles.textFieldBorderRadius,
                child: Text(
                  PersonalDetailPageString.savePersonalDataButton,
                  style: widget.personalDetailPageStyles.buttonTextStyle,
                ),
                onPressed: () {
                  _savePersonalHandler(context);
                },
              ),
              SizedBox(height: widget.personalDetailPageStyles.primaryVerticalPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: widget.personalDetailPageStyles.widthDp * 216,
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
    if (!_personalFormKey.currentState.validate()) {
      setState(() {
        validateStarted = true;
      });
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    await _keicyProgressDialog.show();

    _userProvider.setUserState(_userProvider.userState.update(progressState: 1), isNotifiable: false);
    String phoneNumber = _phoneController.text.trim().replaceAll(RegExp(r'[( )-]'), "");

    UserModel userModel = UserModel.fromJson(_userProvider.userState.userModel.toJson());
    userModel.firstName = _firstNameController.text.trim();
    userModel.middleName = _middleNameController.text.trim();
    userModel.lastName = _lastNameController.text.trim();
    userModel.dobTs = KeicyDateTime.convertDateStringToMilliseconds(dateString: _birthDayController.text.trim());
    userModel.gender = _gender;
    userModel.email = _emailController.text.trim();
    userModel.phoneNumber = phoneNumber;
    userModel.country = AppConstants.countryList[0]["text"];
    userModel.state = _state;
    userModel.city = _city;
    userModel.address = _addressController.text.trim();
    userModel.apt = _aptController.text.trim();
    userModel.zipCode = _zipCodeController.text.trim();
    userModel.street = _streetController.text.trim();
    userModel.ts = DateTime.now().millisecondsSinceEpoch;

    _userProvider.saveUserData(userID: userModel.id, data: userModel.toJson());
  }
}
