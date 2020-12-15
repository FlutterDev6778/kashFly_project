import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keicy_dropdown_form_field/keicy_dropdown_form_field.dart';
import 'package:keicy_text_form_field/keicy_text_form_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:money_transfer_app/Pages/Components/header_widget.dart';
import 'package:money_transfer_framework/Models/document_model.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:status_alert/status_alert.dart';

import 'package:keicy_network_image/keicy_network_image.dart';
import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';
import 'package:keicy_utils/date_time_convert.dart';

import 'package:money_transfer_app/Pages/UploadDocumentPage/photo_view.dart';
import 'package:money_transfer_app/Providers/index.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:money_transfer_app/Pages/App/index.dart';

import 'index.dart';

class UploadDocumentView extends StatefulWidget {
  final Map<String, dynamic> documentType;
  final UploadDocumentPageStyles uploadDocumentPageStyles;
  final bool fullScreen;

  const UploadDocumentView({
    Key key,
    this.documentType,
    this.uploadDocumentPageStyles,
    this.fullScreen,
  }) : super(key: key);

  @override
  _UploadDocumentViewState createState() => _UploadDocumentViewState();
}

class _UploadDocumentViewState extends State<UploadDocumentView> {
  ImagePicker _picker = ImagePicker();
  File _imageFile;
  String _imagePath;
  File _imageFile1;
  String _imagePath1;

  DocumentModel _documentModel;

  UserProvider _userProvider;
  KeicyProgressDialog _keicyProgressDialog;

  TextEditingController _numberController = TextEditingController();
  TextEditingController _expireDateController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

    _documentModel =
        DocumentModel.fromJson(_userProvider.userState.userModel.documents[widget.documentType["category"]]);
    _imagePath = _documentModel.imagePath;
    _imagePath1 = _documentModel.imagePath1;

    _numberController.text = _documentModel.documentNumber;
    _expireDateController.text = _documentModel.expireDateTs != 0
        ? KeicyDateTime.convertMillisecondsToDateString(ms: _documentModel.expireDateTs)
        : "";

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userProvider.addListener(_userProviderListener);

      _keicyProgressDialog = KeicyProgressDialog.of(
        context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        layout: Layout.Column,
        padding: EdgeInsets.zero,
        width: widget.uploadDocumentPageStyles.widthDp * 120,
        height: widget.uploadDocumentPageStyles.widthDp * 120,
        progressWidget: Container(
          width: widget.uploadDocumentPageStyles.widthDp * 120,
          height: widget.uploadDocumentPageStyles.widthDp * 120,
          padding: EdgeInsets.all(widget.uploadDocumentPageStyles.widthDp * 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.uploadDocumentPageStyles.widthDp * 10),
          ),
          child: SpinKitFadingCircle(
            color: AppColors.primaryColor,
            size: widget.uploadDocumentPageStyles.widthDp * 80,
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
        Navigator.of(context).pop();

        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          blurPower: 3,
          backgroundColor: Colors.white,
          title: '${_documentModel.title} Successfully uploaded',
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.uploadDocumentPageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.uploadDocumentPageStyles.widthDp * 80),
          padding: EdgeInsets.all(widget.uploadDocumentPageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.check_circle_outline,
            color: AppColors.primaryColor,
            size: widget.uploadDocumentPageStyles.widthDp * 80,
          ),
        );

        break;
      case -1:
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: _userProvider.userState.errorString,
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.uploadDocumentPageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.uploadDocumentPageStyles.widthDp * 80),
          padding: EdgeInsets.all(widget.uploadDocumentPageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.error_outline,
            color: Colors.redAccent,
            size: widget.uploadDocumentPageStyles.widthDp * 80,
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
        height: widget.uploadDocumentPageStyles.deviceHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(
              title: UploadDocumentPageString.title,
              widthDp: widget.uploadDocumentPageStyles.widthDp,
              fontSp: widget.uploadDocumentPageStyles.fontSp,
              haveBackIcon: true,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.uploadDocumentPageStyles.primaryHorizontalPadding,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: widget.uploadDocumentPageStyles.primaryVerticalPadding),
                      _containerDocumentType(context),
                      _documentModel.subCategory == "driverLicense" ? _containerDocument1Content(context) : SizedBox(),
                      _containerDocumentContent(context),
                      SizedBox(height: widget.uploadDocumentPageStyles.widthDp * 30),
                      KeicyRaisedButton(
                        height: widget.uploadDocumentPageStyles.widthDp * 50,
                        color: AppColors.secondaryColor,
                        borderRadius: widget.uploadDocumentPageStyles.widthDp * 25,
                        child: Text(
                          UploadDocumentPageString.buttonText,
                          style: widget.uploadDocumentPageStyles.buttonStyle,
                        ),
                        elevation: 0,
                        onPressed: () {
                          _saveHandler(context);
                        },
                      ),
                      SizedBox(height: widget.uploadDocumentPageStyles.primaryVerticalPadding),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _containerDocumentType(BuildContext context) {
    List<Map<String, dynamic>> menuItems = [];
    UploadDocumentPageString.descriptionList[widget.documentType["category"]].forEach((key, value) {
      menuItems.add(
        {
          "text": UploadDocumentPageString.descriptionList[widget.documentType["category"]][key]["title"],
          "value": key,
        },
      );
    });

    if (_documentModel.subCategory == "") {
      _documentModel.subCategory = menuItems[0]["value"];
      _documentModel.title = menuItems[0]["text"];
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          KeicyDropDownFormField(
            width: null,
            height: widget.uploadDocumentPageStyles.widthDp * 50,
            menuItems: menuItems,
            border: Border.all(color: Colors.grey),
            iconSize: widget.uploadDocumentPageStyles.widthDp * 30,
            contentHorizontalPadding: widget.uploadDocumentPageStyles.widthDp * 10,
            contentVerticalPadding: widget.uploadDocumentPageStyles.widthDp * 0,
            selectedItemStyle: TextStyle(
              fontSize: widget.uploadDocumentPageStyles.widthDp * 24,
              color: Color(0xFF353942),
              fontFamily: "Exo-SemiBold",
            ),
            value: _documentModel.subCategory,
            onChangeHandler: (value) {
              setState(() {
                _documentModel.subCategory = value;
                for (var i = 0; i < menuItems.length; i++) {
                  if (menuItems[i]["value"] == value) {
                    _documentModel.title = menuItems[i]["text"];
                    break;
                  }
                }
                _imagePath = "";
                _imagePath1 = "";
                _numberController.text = "";
                _expireDateController.text = "";
              });
            },
          ),
          (widget.documentType["category"] != "category1")
              ? SizedBox()
              : KeicyTextFormField(
                  width: null,
                  height: widget.uploadDocumentPageStyles.widthDp * 50,
                  // labelSpacing: widget.uploadDocumentPageStyles.widthDp * 14,
                  // label: LoginPageString.phoneLabel,
                  // labelStyle: widget.uploadDocumentPageStyles.labelStyle,
                  // fillColor: Color(0xFFF2F5FA),
                  borderRadius: 0,
                  border: Border.all(color: Colors.grey),
                  errorBorder: Border.all(color: Colors.redAccent),
                  contentHorizontalPadding: widget.uploadDocumentPageStyles.widthDp * 10,
                  textStyle: TextStyle(
                    fontSize: widget.uploadDocumentPageStyles.widthDp * 22,
                    color: Color(0xFF353942),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  hintText: UploadDocumentPageString.numberHint,
                  hintStyle: TextStyle(
                    fontSize: widget.uploadDocumentPageStyles.widthDp * 22,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  validatorHandler: (input) =>
                      (input.length < 3) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "3") : null,
                  onSaveHandler: (input) => _documentModel.documentNumber = input.trim(),
                  onFieldSubmittedHandler: (input) {},
                ),
          (widget.documentType["category"] != "category1")
              ? SizedBox()
              : KeicyTextFormField(
                  width: null,
                  height: widget.uploadDocumentPageStyles.widthDp * 50,
                  controller: _expireDateController,
                  borderRadius: 0,
                  border: Border.all(color: Colors.grey),
                  errorBorder: Border.all(color: Colors.redAccent),
                  contentHorizontalPadding: widget.uploadDocumentPageStyles.widthDp * 10,
                  textStyle: TextStyle(
                    fontSize: widget.uploadDocumentPageStyles.widthDp * 22,
                    color: Color(0xFF353942),
                  ),
                  readOnly: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  hintText: UploadDocumentPageString.expireDateHint,
                  hintStyle: TextStyle(
                    fontSize: widget.uploadDocumentPageStyles.widthDp * 22,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  validatorHandler: (input) {
                    if (input.isEmpty) return ValidateErrorString.textEmptyErrorText.replaceAll("{}", "Birth Day");

                    DateTime dateTime = KeicyDateTime.convertDateStringToDateTime(dateString: input);

                    if (DateTime.now().difference(dateTime).inDays > 0) return "Please correct date";

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
                            initialDateTime: KeicyDateTime.convertDateStringToDateTime(
                                dateString: _expireDateController.text.trim()),
                            minimumYear: DateTime.now().year,
                            maximumYear: DateTime.now().year + 100,
                            onDateTimeChanged: (DateTime newDateTime) {
                              _expireDateController.text =
                                  KeicyDateTime.convertDateTimeToDateString(dateTime: newDateTime);
                            },
                          ),
                        );
                      },
                    );
                  },
                  onSaveHandler: (input) => _documentModel.expireDateTs = KeicyDateTime.convertDateStringToMilliseconds(
                    dateString: _expireDateController.text.trim(),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: widget.uploadDocumentPageStyles.widthDp * 216,
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

  Widget _containerDocumentContent(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            UploadDocumentPageString.descriptionList[widget.documentType["category"]][_documentModel.subCategory]
                ["desc1"],
            style: widget.uploadDocumentPageStyles.textStyle,
          ),
          SizedBox(height: widget.uploadDocumentPageStyles.widthDp * 15),
          Container(
            height: widget.uploadDocumentPageStyles.widthDp * 250,
            child: (_imageFile == null && (_imagePath == ""))
                ? GestureDetector(
                    onTap: () {
                      _getImage(context);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(border: Border.all()),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_camera, size: widget.uploadDocumentPageStyles.iconSize),
                          SizedBox(height: widget.uploadDocumentPageStyles.widthDp * 10),
                          Text("Add " + _documentModel.title, style: widget.uploadDocumentPageStyles.textStyle),
                        ],
                      ),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    decoration: BoxDecoration(border: Border.all()),
                    child: GestureDetector(
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: PhotoViewRouteWrapper(
                            imageProvider: (_imageFile != null)
                                ? FileImage(_imageFile)
                                : NetworkImage(
                                    _imagePath,
                                  ),
                          ),
                          withNavBar: false,
                        );
                      },
                      child: Hero(
                        tag: "someTag",
                        child: (_imageFile != null)
                            ? Image.file(_imageFile, fit: BoxFit.cover)
                            : KeicyNetworkImage(
                                url: _imagePath,
                                width: null,
                                height: null,
                                indicatorSize: widget.uploadDocumentPageStyles.widthDp * 30,
                              ),
                      ),
                    ),
                  ),
          ),
          (_imageFile != null || _imagePath != "")
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _imageFile = null;
                      _imagePath = "";
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: widget.uploadDocumentPageStyles.widthDp * 5),
                        Icon(Icons.delete, size: widget.uploadDocumentPageStyles.widthDp * 30),
                      ],
                    ),
                  ),
                )
              : SizedBox(height: widget.uploadDocumentPageStyles.widthDp * 15),
          Text(
            UploadDocumentPageString.descriptionList[widget.documentType["category"]][_documentModel.subCategory]
                ["desc2"],
            style: widget.uploadDocumentPageStyles.textStyle,
          ),
        ],
      ),
    );
  }

  Widget _containerDocument1Content(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            UploadDocumentPageString.descriptionList[widget.documentType["category"]][_documentModel.subCategory]
                ["desc3"],
            style: widget.uploadDocumentPageStyles.textStyle,
          ),
          SizedBox(height: widget.uploadDocumentPageStyles.widthDp * 15),
          Container(
            height: widget.uploadDocumentPageStyles.widthDp * 250,
            child: (_imageFile1 == null && (_imagePath1 == ""))
                ? GestureDetector(
                    onTap: () {
                      _getImage1(context);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(border: Border.all()),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_camera, size: widget.uploadDocumentPageStyles.iconSize),
                          SizedBox(height: widget.uploadDocumentPageStyles.widthDp * 10),
                          Text("Add " + _documentModel.title, style: widget.uploadDocumentPageStyles.textStyle),
                        ],
                      ),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    decoration: BoxDecoration(border: Border.all()),
                    child: GestureDetector(
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: PhotoViewRouteWrapper(
                            imageProvider: (_imageFile1 != null)
                                ? FileImage(_imageFile1)
                                : NetworkImage(
                                    _imagePath1,
                                  ),
                          ),
                          withNavBar: false,
                        );
                      },
                      child: Hero(
                        tag: "someTag1",
                        child: (_imageFile1 != null)
                            ? Image.file(_imageFile1, fit: BoxFit.cover)
                            : KeicyNetworkImage(
                                url: _imagePath1,
                                width: null,
                                height: null,
                                indicatorSize: widget.uploadDocumentPageStyles.widthDp * 30,
                              ),
                      ),
                    ),
                  ),
          ),
          (_imageFile1 != null || _imagePath1 != "")
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _imageFile1 = null;
                      _imagePath1 = "";
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: widget.uploadDocumentPageStyles.widthDp * 5),
                        Icon(Icons.delete, size: widget.uploadDocumentPageStyles.widthDp * 30),
                      ],
                    ),
                  ),
                )
              : SizedBox(height: widget.uploadDocumentPageStyles.widthDp * 15),
        ],
      ),
    );
  }

  void _getImage(BuildContext context) async {
    PickedFile _pickedFile = await _picker.getImage(source: ImageSource.camera);
    if (_pickedFile != null) {
      setState(() {
        _imageFile = File(_pickedFile.path);
      });
    }
  }

  void _getImage1(BuildContext context) async {
    PickedFile _pickedFile = await _picker.getImage(source: ImageSource.camera);
    if (_pickedFile != null) {
      setState(() {
        _imageFile1 = File(_pickedFile.path);
      });
    }
  }

  void _saveHandler(BuildContext context) async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();

    bool _validate = true;
    Map<String, dynamic> _documents = _userProvider.userState.userModel.documents;
    if (_imageFile == null && _imagePath == "") {
      _validate = false;
    }

    if (_documentModel.subCategory == "driverLicense" && _imageFile1 == null && _imagePath1 == "") {
      _validate = false;
    }

    if (!_validate) {
      StatusAlert.show(
        context,
        duration: Duration(seconds: 2),
        title: "Please take a picture to upload the document",
        titleOptions: StatusAlertTextConfiguration(
          style: TextStyle(fontSize: widget.uploadDocumentPageStyles.fontSp * 16, color: AppColors.blackColor),
        ),
        margin: EdgeInsets.all(widget.uploadDocumentPageStyles.widthDp * 80),
        padding: EdgeInsets.all(widget.uploadDocumentPageStyles.widthDp * 20),
        configuration: IconConfiguration(
          icon: Icons.error_outline,
          color: Colors.redAccent,
          size: widget.uploadDocumentPageStyles.widthDp * 80,
        ),
        blurPower: 3,
        backgroundColor: Colors.white,
      );

      return;
    }
    await _keicyProgressDialog.show();

    _userProvider.setUserState(_userProvider.userState.update(progressState: 1), isNotifiable: false);

    _userProvider.saveDocument(
      userModel: UserModel.fromJson(_userProvider.userState.userModel.toJson()),
      documentType: widget.documentType["category"],
      documentData: _documentModel.toJson(),
      imageFile: _imageFile,
      imageFile1: _imageFile1,
    );
  }
}
