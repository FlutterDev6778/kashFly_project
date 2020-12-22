import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keicy_text_form_field/keicy_text_form_field.dart';
import 'package:money_transfer_app/Pages/Components/index.dart';
import 'package:money_transfer_app/Pages/ConfrimTransferPage/index.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'package:keicy_inkwell/keicy_inkwell.dart';
import 'package:keicy_avatar_image/keicy_avatar_image.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';
import 'package:keicy_dropdown_form_field/keicy_dropdown_form_field.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Providers/index.dart';
import 'package:money_transfer_app/Pages/AmountPage/index.dart';
import 'package:money_transfer_app/Pages/CreditCardPage/index.dart';
import 'package:money_transfer_app/Pages/RecipientViewPage/recipient_view_page.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';

import 'index.dart';

class TransferView extends StatefulWidget {
  final TransferPageStyles transferPageStyles;
  final double amount;

  const TransferView({
    Key key,
    this.transferPageStyles,
    this.amount,
  }) : super(key: key);

  @override
  _TransferViewState createState() => _TransferViewState();
}

class _TransferViewState extends State<TransferView> {
  UserProvider _userProvider;
  SettingsDataProvider _settingsDataProvider;
  RecipientProvider _recipientProvider;
  TransferProvider _transferProvider;

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _settingsDataProvider = SettingsDataProvider.of(context);
    _userProvider = UserProvider.of(context);
    _transferProvider = TransferProvider.of(context);
    _recipientProvider = RecipientProvider.of(context);

    _transferProvider.setTransferState(TransferState.init());

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_recipientProvider.recipientState.recipientModelListStream == null) {
        _recipientProvider.getRecipientModelStream(_userProvider.userState.userModel.id);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < _userProvider.userState.userModel.paymentMethodList.length; i++) {
      if (_userProvider.userState.userModel.paymentMethodList[i]["id"] == _userProvider.userState.userModel.seledtedPaymentMethod) {
        // _selectedPayment = _userProvider.userState.userModel.paymentMethodList[i];
        _transferProvider.setTransferState(
          _transferProvider.transferState.update(
            paymentMethod: PaymentMethod.fromJson(_userProvider.userState.userModel.paymentMethodList[i]),
          ),
          isNotifiable: false,
        );
      }
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: widget.transferPageStyles.mainHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(
                title: TransferPageString.title,
                widthDp: widget.transferPageStyles.widthDp,
                fontSp: widget.transferPageStyles.fontSp,
                haveBackIcon: true,
                iconType: 1,
                height: widget.transferPageStyles.widthDp * 164,
                titleWidget: _containerTitleWidget(context),
              ),
              SizedBox(height: widget.transferPageStyles.widthDp * 14),
              _containerNewRecipient(context),
              SizedBox(height: widget.transferPageStyles.widthDp * 14),
              Divider(height: 1, thickness: 1, color: Colors.black.withAlpha(50)),
              _containerSearchField(context),
              Divider(height: 1, thickness: 1, color: Colors.black.withAlpha(50)),
              _containerComment(context),
              Divider(height: 1, thickness: 1, color: Colors.black.withAlpha(50)),
              SizedBox(height: widget.transferPageStyles.widthDp * 20),
              Expanded(
                child: _containerRecipient(context),
              ),
              // SizedBox(height: widget.transferPageStyles.widthDp * 20),
              // _containerNextButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _containerTitleWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widget.transferPageStyles.widthDp * 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            TransferPageString.title,
            style: TextStyle(
              fontSize: widget.transferPageStyles.widthDp * 20,
              color: AppColors.whiteColor,
              fontFamily: "Exo-SemiBold",
            ),
          ),
          GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => CreditCardPage(),
                ),
              );
              setState(() {});
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "\$" + widget.amount.toString(),
                  style: TextStyle(
                    fontSize: widget.transferPageStyles.fontSp * 20,
                    color: AppColors.whiteColor,
                    fontFamily: "Exo-SemiBold",
                  ),
                ),
                SizedBox(height: widget.transferPageStyles.widthDp * 5),
                Row(
                  children: [
                    Text(
                      _transferProvider.transferState.paymentMethod == null
                          ? "Select card"
                          : _transferProvider.transferState.paymentMethod.card.brand.toUpperCase() +
                              " " +
                              _transferProvider.transferState.paymentMethod.card.last4,
                      style: TextStyle(
                        fontSize: widget.transferPageStyles.fontSp * 12,
                        color: AppColors.whiteColor,
                        fontFamily: "Exo-SemiBold",
                      ),
                    ),
                    SizedBox(width: widget.transferPageStyles.fontSp * 5),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: widget.transferPageStyles.fontSp * 15,
                      color: AppColors.whiteColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              onSendHandler(context);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send, size: widget.transferPageStyles.widthDp * 30, color: AppColors.whiteColor),
                // KeicyRaisedButton(
                //   width: widget.transferPageStyles.widthDp * 85,
                //   height: widget.transferPageStyles.widthDp * 40,
                //   borderRadius: widget.transferPageStyles.widthDp * 15,
                //   borderColor: Colors.transparent,
                //   color: Color(0xFF5BA8F5),
                //   child:
                Text(
                  TransferPageString.sendButton,
                  style: TextStyle(
                    fontSize: widget.transferPageStyles.fontSp * 14,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // ),
              ],
            ),
          ),
          // SizedBox(width: widget.transferPageStyles.widthDp * 10),
        ],
      ),
    );
  }

  Widget _containerNewRecipient(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => RecipientViewPage(
              recipientProvider: _recipientProvider,
              recipientModel: RecipientModel(),
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widget.transferPageStyles.widthDp * 20),
        alignment: Alignment.centerRight,
        child: Container(
          width: widget.transferPageStyles.widthDp * 114,
          height: widget.transferPageStyles.widthDp * 32,
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(widget.transferPageStyles.heightDp * 8),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_add, size: widget.transferPageStyles.widthDp * 20, color: Colors.white),
              SizedBox(width: widget.transferPageStyles.widthDp * 5),
              Text(
                TransferPageString.newRecipient,
                style: TextStyle(
                  fontSize: widget.transferPageStyles.fontSp * 12,
                  color: Colors.white,
                  fontFamily: "Exo-SemiBold",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _containerSearchField(BuildContext context) {
    return KeicyTextFormField(
      width: null,
      height: widget.transferPageStyles.widthDp * 50,
      controller: _searchController,
      fixedHeightState: false,
      border: Border.all(color: Colors.transparent),
      contentHorizontalPadding: widget.transferPageStyles.widthDp * 20,
      prefixIcons: [
        Text("To", style: TextStyle(fontSize: widget.transferPageStyles.fontSp * 14, color: AppColors.blackColor)),
      ],
      suffixIcons: [
        GestureDetector(
          onTap: () {},
          child: Icon(
            Icons.search,
            size: widget.transferPageStyles.widthDp * 24,
            color: Colors.black.withOpacity(0.3),
          ),
        ),
      ],
      hintText: "Name, Phone",
      hintStyle: TextStyle(fontSize: widget.transferPageStyles.fontSp * 14, color: Colors.grey),
      textStyle: TextStyle(fontSize: widget.transferPageStyles.fontSp * 18, color: AppColors.blackColor, fontWeight: FontWeight.bold),
      onChangeHandler: (input) {
        ///
        setState(() {});
      },
    );
  }

  Widget _containerComment(BuildContext context) {
    return Consumer<TransferProvider>(builder: (context, transferProvider, _) {
      return GestureDetector(
        onTap: () {
          showCupertinoModalPopup(
            context: context,
            builder: (context) => _containerCupertinoActionSheet(context),
            useRootNavigator: false,
          );
        },
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: widget.transferPageStyles.widthDp * 20),
          height: widget.transferPageStyles.widthDp * 50,
          alignment: Alignment.center,
          child: Row(
            children: [
              Text(
                TransferPageString.commentLabel,
                style: TextStyle(
                  fontSize: widget.transferPageStyles.fontSp * 14,
                  color: AppColors.blackColor,
                ),
              ),
              SizedBox(width: widget.transferPageStyles.widthDp * 10),
              (transferProvider.transferState.purpose == 0)
                  ? Text(TransferPageString.commentHintLabel, style: widget.transferPageStyles.commentHintTextStyle)
                  : Text(AppConstants.reasonList[transferProvider.transferState.purpose - 1], style: widget.transferPageStyles.textStyle),
            ],
          ),
        ),
      );
    });
  }

  Widget _containerDeliveryOption(BuildContext context) {
    return Consumer<TransferProvider>(builder: (context, transferProvider, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TransferPageString.deliveryOptionLabel, style: widget.transferPageStyles.labelStyle),
          SizedBox(height: widget.transferPageStyles.widthDp * 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: EdgeInsets.all(widget.transferPageStyles.widthDp * 10),
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      transferProvider.setTransferState(
                        transferProvider.transferState.update(
                          deliveryOption: 0,
                        ),
                      );
                    },
                    child: Container(
                      width: widget.transferPageStyles.deliveryOptionWidth,
                      height: widget.transferPageStyles.deliveryOptionHeight,
                      decoration: BoxDecoration(
                        color: (transferProvider.transferState.deliveryOption == 0) ? AppColors.deliveryOptionBackColor : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(widget.transferPageStyles.widthDp * 15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: widget.transferPageStyles.widthDp * 3,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        TransferPageString.deliveryOption1,
                        style: (transferProvider.transferState.deliveryOption == 0)
                            ? widget.transferPageStyles.selectedBigTextStyle
                            : widget.transferPageStyles.bigTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: widget.transferPageStyles.widthDp * 15),
                  GestureDetector(
                    onTap: () {
                      transferProvider.setTransferState(
                        transferProvider.transferState.update(
                          deliveryOption: 1,
                        ),
                      );
                    },
                    child: Container(
                      width: widget.transferPageStyles.deliveryOptionWidth,
                      height: widget.transferPageStyles.deliveryOptionHeight,
                      decoration: BoxDecoration(
                        color: (transferProvider.transferState.deliveryOption == 1) ? AppColors.deliveryOptionBackColor : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(widget.transferPageStyles.widthDp * 15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: widget.transferPageStyles.widthDp * 3,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        TransferPageString.deliveryOption2,
                        style: (transferProvider.transferState.deliveryOption == 1)
                            ? widget.transferPageStyles.selectedBigTextStyle
                            : widget.transferPageStyles.bigTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: widget.transferPageStyles.widthDp * 15),
                  GestureDetector(
                    onTap: () {
                      transferProvider.setTransferState(
                        transferProvider.transferState.update(
                          deliveryOption: 2,
                        ),
                      );
                    },
                    child: Container(
                      width: widget.transferPageStyles.deliveryOptionWidth,
                      height: widget.transferPageStyles.deliveryOptionHeight,
                      decoration: BoxDecoration(
                        color: (transferProvider.transferState.deliveryOption == 2) ? AppColors.deliveryOptionBackColor : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(widget.transferPageStyles.widthDp * 15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: widget.transferPageStyles.widthDp * 3,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        TransferPageString.deliveryOption3,
                        style: (transferProvider.transferState.deliveryOption == 2)
                            ? widget.transferPageStyles.selectedBigTextStyle
                            : widget.transferPageStyles.bigTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _containerRecipient(BuildContext context) {
    return Consumer<RecipientProvider>(builder: (context, recipientProvider, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: widget.transferPageStyles.widthDp * 20),
            child: Text(
              TransferPageString.recipientLabel,
              style: TextStyle(
                fontSize: widget.transferPageStyles.fontSp * 16,
                color: AppColors.blackColor,
                fontFamily: "Exo-SemiBold",
              ),
            ),
          ),
          SizedBox(height: widget.transferPageStyles.widthDp * 13),
          Expanded(
            child: StreamBuilder<List<RecipientModel>>(
              stream: recipientProvider.recipientState.recipientModelListStream,
              builder: (context, snapshot) {
                List<RecipientModel> recipientModelList = [];

                if (snapshot.hasData && snapshot.data.length != 0) {
                  for (var i = 0; i < snapshot.data.length; i++) {
                    if (_searchController.text == "") {
                      recipientModelList.add(snapshot.data[i]);
                    } else {
                      if (snapshot.data[i].firstName.toUpperCase().contains(_searchController.text.toUpperCase()) ||
                          snapshot.data[i].lastName.toUpperCase().contains(_searchController.text.toUpperCase()) ||
                          snapshot.data[i].phoneNumber.toUpperCase().contains(_searchController.text.toUpperCase())) {
                        recipientModelList.add(snapshot.data[i]);
                      }
                    }
                  }
                  // recipientModelList = snapshot.data;
                }

                return Consumer<TransferProvider>(builder: (context, transferProvider, _) {
                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      RecipientModel _recipientModel = recipientModelList[index];

                      return GestureDetector(
                        onTap: () {
                          if (transferProvider.transferState.recipientModel.id != _recipientModel.id) {
                            _searchController.text = _recipientModel.firstName + " " + _recipientModel.lastName;
                            transferProvider.setTransferState(
                              transferProvider.transferState.update(
                                recipientModel: _recipientModel,
                              ),
                            );
                          } else {
                            _searchController.text = "";
                            transferProvider.setTransferState(
                              transferProvider.transferState.update(
                                recipientModel: RecipientModel(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: widget.transferPageStyles.widthDp * 85,
                          margin: EdgeInsets.symmetric(
                            horizontal: widget.transferPageStyles.widthDp * 20,
                            vertical: widget.transferPageStyles.widthDp * 10,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: widget.transferPageStyles.widthDp * 13,
                          ),
                          decoration: BoxDecoration(
                            color: (transferProvider.transferState.recipientModel.id == _recipientModel.id)
                                ? AppColors.deliveryOptionBackColor
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 4, offset: Offset(0, 2)),
                            ],
                            borderRadius: BorderRadius.circular(widget.transferPageStyles.widthDp * 10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: widget.transferPageStyles.widthDp * 20),
                                  KeicyAvatarImage(
                                    url: _recipientModel.avatarUrl,
                                    userName: _recipientModel.firstName,
                                    width: widget.transferPageStyles.widthDp * 45,
                                    height: widget.transferPageStyles.widthDp * 45,
                                    backColor: AppColors.recipientColor[index % AppColors.recipientColor.length]["backColor"],
                                    textColor: AppColors.recipientColor[index % AppColors.recipientColor.length]["textColor"],
                                  ),
                                  SizedBox(width: widget.transferPageStyles.widthDp * 15),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _recipientModel.firstName + " " + _recipientModel.lastName,
                                        style: TextStyle(
                                          fontSize: widget.transferPageStyles.fontSp * 14,
                                          color: AppColors.blackColor,
                                          fontFamily: "Exo-Medium",
                                        ),
                                      ),
                                      Text(
                                        _recipientModel.phoneNumber,
                                        style: TextStyle(
                                          fontSize: widget.transferPageStyles.fontSp * 12,
                                          color: AppColors.blackColor.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: widget.transferPageStyles.fontSp * 14,
                                  color: AppColors.blackColor,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => RecipientViewPage(
                                        recipientProvider: recipientProvider,
                                        recipientModel: _recipientModel,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: widget.transferPageStyles.widthDp * 0);
                    },
                    itemCount: recipientModelList.length,
                  );
                });
              },
            ),
          ),
        ],
      );
    });
  }

  CupertinoActionSheet _containerCupertinoActionSheet(BuildContext context) {
    return CupertinoActionSheet(
      actions: AppConstants.reasonList
          .map(
            (item) => CupertinoButton(
              color: AppColors.scaffoldBackColor,
              borderRadius: BorderRadius.zero,
              child: Text(
                item,
                style: widget.transferPageStyles.textStyle,
              ),
              // isDefaultAction: true,
              // isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
                _transferProvider.setTransferState(
                  _transferProvider.transferState.update(purpose: AppConstants.reasonList.indexOf(item) + 1),
                );
              },
            ),
          )
          .toList(),
      cancelButton: CupertinoButton(
        color: AppColors.scaffoldBackColor,
        child: Text(
          "Cancel",
          style: widget.transferPageStyles.textStyle,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _containerNextButton(BuildContext context) {
    int monthlyAvailableAmount = _settingsDataProvider.settingsDataState.cashLimits['monthly'] - _userProvider.userState.userModel.monthlyCount;

    int dailyAvailableAmount = (monthlyAvailableAmount < 5)
        ? monthlyAvailableAmount - _userProvider.userState.userModel.dailyCount
        : _settingsDataProvider.settingsDataState.cashLimits['daily'] - _userProvider.userState.userModel.dailyCount;

    return Column(
      children: [
        KeicyRaisedButton(
          height: widget.transferPageStyles.widthDp * 50,
          color: AppColors.primaryColor,
          borderRadius: widget.transferPageStyles.widthDp * 25,
          elevation: 0,
          disabledColor: Colors.grey,
          borderColor: Colors.transparent,
          child: Text(
            TransferPageString.sendButton,
            style: widget.transferPageStyles.buttonTextStyle,
          ),
          onPressed: (dailyAvailableAmount <= 0 || monthlyAvailableAmount <= 0)
              ? null
              : () async {
                  if (_transferProvider.transferState.paymentMethod == null) {
                    StatusAlert.show(
                      context,
                      duration: Duration(seconds: 2),
                      title: "Please choose Debit/Credit car",
                      titleOptions: StatusAlertTextConfiguration(
                        style: TextStyle(fontSize: widget.transferPageStyles.fontSp * 16, color: AppColors.blackColor),
                      ),
                      margin: EdgeInsets.all(widget.transferPageStyles.widthDp * 60),
                      padding: EdgeInsets.all(widget.transferPageStyles.widthDp * 20),
                      configuration: IconConfiguration(
                        icon: Icons.error_outline,
                        color: Colors.redAccent,
                        size: widget.transferPageStyles.widthDp * 80,
                      ),
                      blurPower: 3,
                      backgroundColor: Colors.white,
                    );
                    return;
                  }
                  if (_transferProvider.transferState.recipientModel.id == "") {
                    StatusAlert.show(
                      context,
                      duration: Duration(seconds: 2),
                      title: "Please choose recipient",
                      titleOptions: StatusAlertTextConfiguration(
                        style: TextStyle(fontSize: widget.transferPageStyles.fontSp * 16, color: AppColors.blackColor),
                      ),
                      margin: EdgeInsets.all(widget.transferPageStyles.widthDp * 60),
                      padding: EdgeInsets.all(widget.transferPageStyles.widthDp * 20),
                      configuration: IconConfiguration(
                        icon: Icons.error_outline,
                        color: Colors.redAccent,
                        size: widget.transferPageStyles.widthDp * 80,
                      ),
                      blurPower: 3,
                      backgroundColor: Colors.white,
                    );
                    return;
                  }
                  if (_transferProvider.transferState.purpose == 0) {
                    StatusAlert.show(
                      context,
                      duration: Duration(seconds: 2),
                      title: "Please choose reason",
                      titleOptions: StatusAlertTextConfiguration(
                        style: TextStyle(fontSize: widget.transferPageStyles.fontSp * 16, color: AppColors.blackColor),
                      ),
                      margin: EdgeInsets.all(widget.transferPageStyles.widthDp * 60),
                      padding: EdgeInsets.all(widget.transferPageStyles.widthDp * 20),
                      configuration: IconConfiguration(
                        icon: Icons.error_outline,
                        color: Colors.redAccent,
                        size: widget.transferPageStyles.widthDp * 80,
                      ),
                      blurPower: 3,
                      backgroundColor: Colors.white,
                    );
                    return;
                  }

                  pushNewScreen(
                    context,
                    screen: AmountPage(),
                    withNavBar: false,
                  );
                },
        ),
        SizedBox(height: widget.transferPageStyles.widthDp * 10),
        (monthlyAvailableAmount <= 0)
            ? Text("Montly  Limit is over", style: widget.transferPageStyles.limitErrorTextStyle)
            : (dailyAvailableAmount <= 0)
                ? Text("Daily Limit is over", style: widget.transferPageStyles.limitErrorTextStyle)
                : Text("You can transfer $dailyAvailableAmount times", style: widget.transferPageStyles.limitTextStyle),
      ],
    );
  }

  void onSendHandler(BuildContext context) async {
    int monthlyAvailableAmount = _settingsDataProvider.settingsDataState.cashLimits['monthly'] - _userProvider.userState.userModel.monthlyCount;

    int dailyAvailableAmount = (monthlyAvailableAmount < 5)
        ? monthlyAvailableAmount - _userProvider.userState.userModel.dailyCount
        : _settingsDataProvider.settingsDataState.cashLimits['daily'] - _userProvider.userState.userModel.dailyCount;

    if (dailyAvailableAmount <= 0 || monthlyAvailableAmount <= 0) {
      return;
    } else {
      if (_transferProvider.transferState.paymentMethod == null) {
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: "Please choose Debit/Credit car",
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.transferPageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.transferPageStyles.widthDp * 60),
          padding: EdgeInsets.all(widget.transferPageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.error_outline,
            color: Colors.redAccent,
            size: widget.transferPageStyles.widthDp * 80,
          ),
          blurPower: 3,
          backgroundColor: Colors.white,
        );
        return;
      }
      if (_transferProvider.transferState.recipientModel.id == "") {
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: "Please choose recipient",
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.transferPageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.transferPageStyles.widthDp * 60),
          padding: EdgeInsets.all(widget.transferPageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.error_outline,
            color: Colors.redAccent,
            size: widget.transferPageStyles.widthDp * 80,
          ),
          blurPower: 3,
          backgroundColor: Colors.white,
        );
        return;
      }
      if (_transferProvider.transferState.purpose == 0) {
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: "Please choose reason",
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.transferPageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.transferPageStyles.widthDp * 60),
          padding: EdgeInsets.all(widget.transferPageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.error_outline,
            color: Colors.redAccent,
            size: widget.transferPageStyles.widthDp * 80,
          ),
          blurPower: 3,
          backgroundColor: Colors.white,
        );
        return;
      }
      _transferProvider.setTransferState(
        _transferProvider.transferState.update(
          amount: widget.amount,
          fee: ((widget.amount - 1) ~/ 50 + 1) * 1.5,
        ),
        isNotifiable: false,
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => ConfirmTransferPage(transferProvider: _transferProvider),
        ),
      );
    }
  }
}
