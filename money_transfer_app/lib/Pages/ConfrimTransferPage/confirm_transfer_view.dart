import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:money_transfer_app/Pages/Components/header_widget.dart';
import 'package:money_transfer_app/Pages/TransferPage/index.dart';
import 'package:status_alert/status_alert.dart';

import 'package:keicy_inkwell/keicy_inkwell.dart';
import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Providers/index.dart';

import 'package:money_transfer_framework/money_transfer_framework.dart';

import 'index.dart';

class ConfirmTransferView extends StatefulWidget {
  final ConfirmTransferPageStyles confirmTransferPageStyles;
  final TransferProvider transferProvider;

  const ConfirmTransferView({
    Key key,
    this.confirmTransferPageStyles,
    this.transferProvider,
  }) : super(key: key);

  @override
  _ConfirmTransferViewState createState() => _ConfirmTransferViewState();
}

class _ConfirmTransferViewState extends State<ConfirmTransferView> {
  KeicyProgressDialog _keicyProgressDialog;

  @override
  void initState() {
    super.initState();

    widget.transferProvider.setTransferState(
      widget.transferProvider.transferState.update(progressState: 0, errorString: ""),
      isNotifiable: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.transferProvider.addListener(_transferProviderListener);

      _keicyProgressDialog = KeicyProgressDialog.of(
        context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        layout: Layout.Column,
        padding: EdgeInsets.zero,
        width: widget.confirmTransferPageStyles.widthDp * 120,
        height: widget.confirmTransferPageStyles.widthDp * 120,
        progressWidget: Container(
          width: widget.confirmTransferPageStyles.widthDp * 120,
          height: widget.confirmTransferPageStyles.widthDp * 120,
          padding: EdgeInsets.all(widget.confirmTransferPageStyles.widthDp * 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.confirmTransferPageStyles.widthDp * 10),
          ),
          child: SpinKitFadingCircle(
            color: AppColors.primaryColor,
            size: widget.confirmTransferPageStyles.widthDp * 80,
          ),
        ),
        message: "",
      );
    });
  }

  @override
  void dispose() {
    widget.transferProvider.removeListener(_transferProviderListener);

    super.dispose();
  }

  void _transferProviderListener() async {
    if (widget.transferProvider.transferState.progressState != 1 && _keicyProgressDialog.isShowing()) {
      await _keicyProgressDialog.hide();
    }

    switch (widget.transferProvider.transferState.progressState) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        widget.transferProvider.setTransferState(
          widget.transferProvider.transferState.update(progressState: 0, errorString: ""),
          isNotifiable: false,
        );
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: "Transaction Success",
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.confirmTransferPageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.confirmTransferPageStyles.widthDp * 80),
          padding: EdgeInsets.all(widget.confirmTransferPageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.check_circle_outline,
            color: AppColors.primaryColor,
            size: widget.confirmTransferPageStyles.widthDp * 80,
          ),
          blurPower: 3,
          backgroundColor: Colors.white,
        );

        widget.transferProvider.setTransferState(TransferState.init());
        Navigator.of(context).pop();
        Navigator.of(context).pop();

        break;
      case -1:
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: widget.transferProvider.transferState.errorString,
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: widget.confirmTransferPageStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(widget.confirmTransferPageStyles.widthDp * 80),
          padding: EdgeInsets.all(widget.confirmTransferPageStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.error_outline,
            color: Colors.redAccent,
            size: widget.confirmTransferPageStyles.widthDp * 80,
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
      backgroundColor: AppColors.scaffoldBackColor2,
      body: KeicyInkWell(
        child: Container(
          height: widget.confirmTransferPageStyles.mainHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(
                title: ConfirmTransferPageString.title,
                widthDp: widget.confirmTransferPageStyles.widthDp,
                fontSp: widget.confirmTransferPageStyles.fontSp,
                haveBackIcon: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.confirmTransferPageStyles.widthDp * 20,
                      vertical: widget.confirmTransferPageStyles.widthDp * 25,
                    ),
                    child: Column(
                      children: [
                        _containerRecipient(context),
                        DottedLine(
                          direction: Axis.horizontal,
                          lineLength: widget.confirmTransferPageStyles.deviceWidth -
                              widget.confirmTransferPageStyles.widthDp * 40 -
                              widget.confirmTransferPageStyles.recipientPanelBorderRadius * 1.5,
                          lineThickness: 1.0,
                          dashLength: 8.0,
                          dashColor: Colors.black.withOpacity(0.2),
                          dashRadius: 0.0,
                          dashGapLength: 8.0,
                          dashGapColor: Colors.transparent,
                          dashGapRadius: 0.0,
                        ),
                        _containerDetails(context),
                        _containerTotal(context),
                        SizedBox(height: widget.confirmTransferPageStyles.widthDp * 34),
                        _containerNextButton(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _containerRecipient(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(widget.confirmTransferPageStyles.recipientPanelBorderRadius)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(height: widget.confirmTransferPageStyles.widthDp * 24),
              Text(
                widget.transferProvider.transferState.recipientModel.firstName +
                    " " +
                    widget.transferProvider.transferState.recipientModel.middleName +
                    " " +
                    widget.transferProvider.transferState.recipientModel.lastName,
                style: widget.confirmTransferPageStyles.userNameStyle,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: widget.confirmTransferPageStyles.widthDp * 10),
              Text(
                widget.transferProvider.transferState.recipientModel.phoneNumber,
                style: widget.confirmTransferPageStyles.descriptionStyle,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: widget.confirmTransferPageStyles.widthDp * 31),
            ],
          ),
        ),
        Positioned(
          left: -widget.confirmTransferPageStyles.recipientPanelBorderRadius * 0.75,
          bottom: -widget.confirmTransferPageStyles.recipientPanelBorderRadius * 0.75,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.scaffoldBackColor2),
            width: widget.confirmTransferPageStyles.recipientPanelBorderRadius * 1.5,
            height: widget.confirmTransferPageStyles.recipientPanelBorderRadius * 1.5,
          ),
        ),
        Positioned(
          right: -widget.confirmTransferPageStyles.recipientPanelBorderRadius * 0.75,
          bottom: -widget.confirmTransferPageStyles.recipientPanelBorderRadius * 0.75,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.scaffoldBackColor2),
            width: widget.confirmTransferPageStyles.recipientPanelBorderRadius * 1.5,
            height: widget.confirmTransferPageStyles.recipientPanelBorderRadius * 1.5,
          ),
        ),
      ],
    );
  }

  Widget _containerDetails(BuildContext context) {
    // print(SettingsDataProvider.of(context).settingsDataState.ratesInfo);
    // for (var i = 0; i < SettingsDataProvider.of(context).settingsDataState.ratesInfo.length; i++) {
    //   if (widget.transferProvider.transferState.amount >= SettingsDataProvider.of(context).settingsDataState.ratesInfo[i]["min"] &&
    //       widget.transferProvider.transferState.amount <=
    //           (SettingsDataProvider.of(context).settingsDataState.ratesInfo[i]["max"] == -1
    //               ? 9999999999
    //               : SettingsDataProvider.of(context).settingsDataState.ratesInfo[i]["max"])) {
    //     break;
    //   }
    // }

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: widget.confirmTransferPageStyles.widthDp * 20,
            vertical: widget.confirmTransferPageStyles.widthDp * 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(widget.confirmTransferPageStyles.recipientPanelBorderRadius)),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ConfirmTransferPageString.detailsLabel, style: widget.confirmTransferPageStyles.detailLabelTextStyle),
              SizedBox(height: widget.confirmTransferPageStyles.widthDp * 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(ConfirmTransferPageString.fromLabel, style: widget.confirmTransferPageStyles.descriptionStyle),
                  Row(
                    children: [
                      Image.asset(
                        "lib/Assets/Images/Cards/${widget.transferProvider.transferState.paymentMethod.card.brand}.png",
                        height: widget.confirmTransferPageStyles.widthDp * 30,
                        fit: BoxFit.fitHeight,
                      ),
                      SizedBox(width: widget.confirmTransferPageStyles.widthDp * 5),
                      Text(
                        "xxxx-xxxx-xxxx-${widget.transferProvider.transferState.paymentMethod.card.last4}",
                        style: widget.confirmTransferPageStyles.detailBoldTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: widget.confirmTransferPageStyles.widthDp * 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(ConfirmTransferPageString.toLabel, style: widget.confirmTransferPageStyles.descriptionStyle),
                  Text(widget.transferProvider.transferState.recipientModel.firstName, style: widget.confirmTransferPageStyles.detailBoldTextStyle),
                ],
              ),
              SizedBox(height: widget.confirmTransferPageStyles.widthDp * 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(ConfirmTransferPageString.amountLabel, style: widget.confirmTransferPageStyles.descriptionStyle),
                  Text(
                    "\$${widget.transferProvider.transferState.amount.toStringAsFixed(2)}",
                    style: widget.confirmTransferPageStyles.detailBoldTextStyle,
                  ),
                ],
              ),
              SizedBox(height: widget.confirmTransferPageStyles.widthDp * 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(ConfirmTransferPageString.messageLabel, style: widget.confirmTransferPageStyles.descriptionStyle),
                  Text(AppConstants.reasonList[widget.transferProvider.transferState.purpose - 1],
                      style: widget.confirmTransferPageStyles.detailBoldTextStyle),
                ],
              ),
              SizedBox(height: widget.confirmTransferPageStyles.widthDp * 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(ConfirmTransferPageString.feeLabel, style: widget.confirmTransferPageStyles.descriptionStyle),
                  Text(
                    widget.transferProvider.transferState.fee.toStringAsFixed(1),
                    style: widget.confirmTransferPageStyles.detailBoldTextStyle,
                  ),
                ],
              ),
              SizedBox(height: widget.confirmTransferPageStyles.widthDp * 10),
            ],
          ),
        ),
        Positioned(
          left: -widget.confirmTransferPageStyles.recipientPanelBorderRadius * 0.75,
          top: -widget.confirmTransferPageStyles.recipientPanelBorderRadius * 0.75,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.scaffoldBackColor2),
            width: widget.confirmTransferPageStyles.recipientPanelBorderRadius * 1.5,
            height: widget.confirmTransferPageStyles.recipientPanelBorderRadius * 1.5,
          ),
        ),
        Positioned(
          right: -widget.confirmTransferPageStyles.recipientPanelBorderRadius * 0.75,
          top: -widget.confirmTransferPageStyles.recipientPanelBorderRadius * 0.75,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.scaffoldBackColor2),
            width: widget.confirmTransferPageStyles.recipientPanelBorderRadius * 1.5,
            height: widget.confirmTransferPageStyles.recipientPanelBorderRadius * 1.5,
          ),
        ),
        Positioned(
          left: -widget.confirmTransferPageStyles.recipientPanelBorderRadius * 0.75,
          bottom: -widget.confirmTransferPageStyles.recipientPanelBorderRadius * 0.75,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.scaffoldBackColor2),
            width: widget.confirmTransferPageStyles.recipientPanelBorderRadius * 1.5,
            height: widget.confirmTransferPageStyles.recipientPanelBorderRadius * 1.5,
          ),
        ),
        Positioned(
          right: -widget.confirmTransferPageStyles.recipientPanelBorderRadius * 0.75,
          bottom: -widget.confirmTransferPageStyles.recipientPanelBorderRadius * 0.75,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.scaffoldBackColor2),
            width: widget.confirmTransferPageStyles.recipientPanelBorderRadius * 1.5,
            height: widget.confirmTransferPageStyles.recipientPanelBorderRadius * 1.5,
          ),
        ),
      ],
    );
  }

  Widget _containerTotal(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.confirmTransferPageStyles.widthDp * 20,
            vertical: widget.confirmTransferPageStyles.widthDp * 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(widget.confirmTransferPageStyles.recipientPanelBorderRadius)),
            // borderRadius: BorderRadius.vertical(bottom: Radius.circular(widget.confirmTransferPageStyles.recipientPanelBorderRadius)),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF5780F2), Color(0xFF0BA4F2)],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ConfirmTransferPageString.totalAmountLabel, style: widget.confirmTransferPageStyles.totalLabeltextStyle),
              Text(
                "\$" + (widget.transferProvider.transferState.fee + widget.transferProvider.transferState.amount).toStringAsFixed(2),
                style: widget.confirmTransferPageStyles.totalAmounttextStyle,
              ),
            ],
          ),
        ),
        Positioned(
          left: -widget.confirmTransferPageStyles.recipientPanelBorderRadius * 0.75,
          top: -widget.confirmTransferPageStyles.recipientPanelBorderRadius * 0.75,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.scaffoldBackColor2),
            width: widget.confirmTransferPageStyles.recipientPanelBorderRadius * 1.5,
            height: widget.confirmTransferPageStyles.recipientPanelBorderRadius * 1.5,
          ),
        ),
        Positioned(
          right: -widget.confirmTransferPageStyles.recipientPanelBorderRadius * 0.75,
          top: -widget.confirmTransferPageStyles.recipientPanelBorderRadius * 0.75,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.scaffoldBackColor2),
            width: widget.confirmTransferPageStyles.recipientPanelBorderRadius * 1.5,
            height: widget.confirmTransferPageStyles.recipientPanelBorderRadius * 1.5,
          ),
        ),
      ],
    );
  }

  Widget _containerNextButton(BuildContext context) {
    return KeicyRaisedButton(
      height: widget.confirmTransferPageStyles.widthDp * 52,
      color: AppColors.secondaryColor,
      borderRadius: widget.confirmTransferPageStyles.widthDp * 26,
      elevation: 0,
      child: Text(
        ConfirmTransferPageString.nextButton,
        style: widget.confirmTransferPageStyles.buttonTextStyle,
      ),
      onPressed: () async {
        await _keicyProgressDialog.show();

        widget.transferProvider.setTransferState(
          widget.transferProvider.transferState.update(progressState: 1),
        );
        widget.transferProvider.makeTransaction(UserProvider.of(context));
      },
    );
  }
}
