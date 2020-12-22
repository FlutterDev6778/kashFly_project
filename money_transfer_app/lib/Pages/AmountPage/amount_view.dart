import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:money_transfer_app/Pages/Components/index.dart';
import 'package:money_transfer_app/Pages/DocumentCategoryPage/index.dart';
import 'package:money_transfer_app/Pages/SSNPage/index.dart';
import 'package:money_transfer_app/Pages/TransferPage/index.dart';
import 'package:money_transfer_app/Pages/UploadDocumentPage/index.dart';
import 'package:status_alert/status_alert.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:keicy_inkwell/keicy_inkwell.dart';
import 'package:keicy_avatar_image/keicy_avatar_image.dart';
import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';

import 'package:money_transfer_app/Pages/ConfrimTransferPage/confirm_transfer_page.dart';
import 'package:money_transfer_app/Pages/CreditCardPage/index.dart';
import 'package:money_transfer_app/Pages/RecipientViewPage/recipient_view_page.dart';
import 'package:provider/provider.dart';
import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class AmountView extends StatefulWidget {
  final AmountPageStyles amountPageStyles;

  const AmountView({
    Key key,
    this.amountPageStyles,
  }) : super(key: key);

  @override
  _AmountViewState createState() => _AmountViewState();
}

class _AmountViewState extends State<AmountView> {
  MoneyMaskedTextController _amountController;
  FocusNode _amountFocusNode = FocusNode();

  UserProvider _userProvider;
  SettingsDataProvider _settingsDataProvider;

  @override
  void initState() {
    super.initState();

    _amountController = new MoneyMaskedTextController(
      leftSymbol: '\$',
      decimalSeparator: '.',
      thousandSeparator: '',
    );

    _amountController.text = "0.00";

    _userProvider = UserProvider.of(context);
    _settingsDataProvider = SettingsDataProvider.of(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeicyInkWell(
        child: Container(
          height: widget.amountPageStyles.mainHeight,
          decoration: BoxDecoration(color: AppColors.primaryColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HeaderWidget(
              //   title: AmountPageString.title,
              //   widthDp: widget.amountPageStyles.widthDp,
              //   fontSp: widget.amountPageStyles.fontSp,
              //   haveBackIcon: false,
              // ),
              Expanded(
                child: Center(child: _containerAmount(context)),
              ),
              CustomNumberKeyboard(
                backColor: Colors.transparent,
                foreColor: AppColors.whiteColor,
                fontSize: widget.amountPageStyles.fontSp * 24,
                iconSize: widget.amountPageStyles.widthDp * 24,
                keyHorizontalPadding: widget.amountPageStyles.widthDp * 45,
                keyVerticalPadding: widget.amountPageStyles.widthDp * 20,
                type: -1,
                onPress: (value) {
                  print(value);
                  if (value == "") {
                    _amountController.text = "0.00";
                  } else if (value.length == 1) {
                    _amountController.text = "0.0" + value;
                  } else {
                    _amountController.text = value;
                  }
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: widget.amountPageStyles.widthDp * 20),
                child: _containerNextButton(context),
              ),
              SizedBox(height: 93 - kBottomNavigationBarHeight + 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _containerAmount(BuildContext context) {
    return TextFormField(
      focusNode: _amountFocusNode,
      controller: _amountController,
      style: widget.amountPageStyles.amountTextStyle,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide.none),
      ),
      keyboardType: TextInputType.number,
      autofocus: true,
      textAlign: TextAlign.center,
      readOnly: true,
    );
  }

  Widget _containerNextButton(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      int monthlyAvailableAmount = _settingsDataProvider.settingsDataState.cashLimits['monthly'] - userProvider.userState.userModel.monthlyCount;

      int dailyAvailableAmount = (monthlyAvailableAmount < 5)
          ? monthlyAvailableAmount - userProvider.userState.userModel.dailyCount
          : _settingsDataProvider.settingsDataState.cashLimits['daily'] - userProvider.userState.userModel.dailyCount;

      String str = (monthlyAvailableAmount <= 0) ? "Montly  Limit is over" : (dailyAvailableAmount <= 0) ? "Daily Limit is over" : "";

      return Column(
        children: [
          (monthlyAvailableAmount <= 0)
              ? Text("Montly  Limit is over", style: widget.amountPageStyles.limitErrorTextStyle)
              : (dailyAvailableAmount <= 0)
                  ? Text("Daily Limit is over", style: widget.amountPageStyles.limitErrorTextStyle)
                  : Text("You can transfer $dailyAvailableAmount times", style: widget.amountPageStyles.limitTextStyle),
          SizedBox(height: widget.amountPageStyles.widthDp * 5),
          Center(
            child: KeicyRaisedButton(
              width: widget.amountPageStyles.widthDp * 200,
              height: widget.amountPageStyles.widthDp * 50,
              color: AppColors.whiteColor.withOpacity(0.2),
              borderRadius: widget.amountPageStyles.widthDp * 25,
              elevation: 0,
              child: Text(
                AmountPageString.nextButton,
                style: widget.amountPageStyles.buttonTextStyle,
              ),
              disabledColor: Colors.grey,
              onPressed: (str != "")
                  ? null
                  : () {
                      _sendHandler(context);
                    },
            ),
          ),
        ],
      );
    });
  }

  void _sendHandler(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    double amount = double.parse(_amountController.text.trim().replaceAll("\$", "").trim());

    ///
    /// Check amount validation
    ///
    if (amount < SettingsDataProvider.of(context).settingsDataState.minAmount) {
      StatusAlert.show(
        context,
        duration: Duration(seconds: 2),
        title: AmountPageString.amountValidateString + SettingsDataProvider.of(context).settingsDataState.minAmount.toString(),
        titleOptions: StatusAlertTextConfiguration(
          style: TextStyle(fontSize: widget.amountPageStyles.fontSp * 16, color: AppColors.blackColor),
        ),
        margin: EdgeInsets.all(widget.amountPageStyles.widthDp * 60),
        padding: EdgeInsets.all(widget.amountPageStyles.widthDp * 20),
        configuration: IconConfiguration(
          icon: Icons.error_outline,
          color: Colors.redAccent,
          size: widget.amountPageStyles.widthDp * 80,
        ),
        blurPower: 3,
        backgroundColor: Colors.white,
      );
      Future.delayed(Duration(seconds: 2), () {
        FocusScope.of(context).requestFocus(_amountFocusNode);
      });
      return;
    } else if (amount >= 10000) {
      StatusAlert.show(
        context,
        duration: Duration(seconds: 2),
        title: AmountPageString.amountValidateString1 + "10000",
        titleOptions: StatusAlertTextConfiguration(
          style: TextStyle(fontSize: widget.amountPageStyles.fontSp * 16, color: AppColors.blackColor),
        ),
        margin: EdgeInsets.all(widget.amountPageStyles.widthDp * 60),
        padding: EdgeInsets.all(widget.amountPageStyles.widthDp * 20),
        configuration: IconConfiguration(
          icon: Icons.error_outline,
          color: Colors.redAccent,
          size: widget.amountPageStyles.widthDp * 80,
        ),
        blurPower: 3,
        backgroundColor: Colors.white,
      );
      Future.delayed(Duration(seconds: 2), () {
        FocusScope.of(context).requestFocus(_amountFocusNode);
      });
      return;
    }

    ///
    ////  Check document validation
    ///

    if (_userProvider.userState.userModel.totalAmount + amount < 3000 &&
        (_userProvider.userState.userModel.documents == null ||
            _userProvider.userState.userModel.documents.length == 0 ||
            _userProvider.userState.userModel.documents["category1"] == null)) {
      await pushNewScreen(
        context,
        screen: UploadDocumentPage(documentType: DocumentCategoryPageString.itemList[0], fullScreen: true),
        withNavBar: false,
      );
      setState(() {
        FocusScope.of(context).requestFocus(_amountFocusNode);
      });
      return;
    } else if (_userProvider.userState.userModel.totalAmount + amount >= 3000 &&
        (_userProvider.userState.userModel.documents == null ||
            _userProvider.userState.userModel.documents.length == 0 ||
            _userProvider.userState.userModel.documents["category2"] == null)) {
      await pushNewScreen(
        context,
        screen: SSNPage(documentType: DocumentCategoryPageString.itemList[1]),
        withNavBar: false,
      );
      setState(() {
        FocusScope.of(context).requestFocus(_amountFocusNode);
      });
      return;
    }

    ///   --------------------------------------------

    BottomNavbarProvider.of(context).setBottomNavbarState(BottomNavbarProvider.of(context).bottomNavbarState.update(type: 0));
    await pushNewScreen(
      context,
      screen: TransferPage(amount: amount),
      withNavBar: false,
    );
    // await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TransferPage(amount: amount)));
    setState(() {
      _amountController.clear();
      _amountController.text = "0.00";
    });
    BottomNavbarProvider.of(context).setBottomNavbarState(BottomNavbarProvider.of(context).bottomNavbarState.update(type: 1));
  }
}
