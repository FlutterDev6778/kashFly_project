import 'package:flutter/material.dart';
import 'package:money_transfer_app/Pages/AboutPage/index.dart';
import 'package:money_transfer_app/Pages/ChangePinCodePage/change_pin_code_page.dart';
import 'package:money_transfer_app/Pages/DocumentCategoryPage/index.dart';
import 'package:money_transfer_app/Pages/HomePage/index.dart';
import 'package:money_transfer_app/Pages/NotificationPage/index.dart';
import 'package:money_transfer_app/Pages/PersonalDetailPage/index.dart';
import 'package:money_transfer_app/Pages/SupportPage/index.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'package:keicy_inkwell/keicy_inkwell.dart';
import 'package:keicy_avatar_image/keicy_avatar_image.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Providers/index.dart';
import 'package:money_transfer_app/Pages/AmountPage/index.dart';
import 'package:money_transfer_app/Pages/CreditCardPage/index.dart';
import 'package:money_transfer_app/Pages/RecipientViewPage/recipient_view_page.dart';

import 'index.dart';

class PaymentInfoView extends StatefulWidget {
  final PaymentInfoPageStyles paymentInfoPageStyles;

  const PaymentInfoView({
    Key key,
    this.paymentInfoPageStyles,
  }) : super(key: key);

  @override
  _TransferViewState createState() => _TransferViewState();
}

class _TransferViewState extends State<PaymentInfoView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: AppColors.blackColor,
        title: Text(PaymentInfoPageString.title, style: widget.paymentInfoPageStyles.title2Style),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.paymentInfoPageStyles.primaryHorizontalPadding,
          vertical: widget.paymentInfoPageStyles.primaryVerticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: widget.paymentInfoPageStyles.statusbarHeight),
            // _containerHeader(context),
            // SizedBox(height: widget.paymentInfoPageStyles.widthDp * 20),
            Expanded(child: _containerItems(context)),
          ],
        ),
      ),
    );
  }

  Widget _containerHeader(BuildContext context) {
    return Container(
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: EdgeInsets.all(widget.paymentInfoPageStyles.widthDp * 8),
              child: Icon(
                Icons.arrow_back_ios,
                size: widget.paymentInfoPageStyles.widthDp * 20,
                color: AppColors.blackColor,
              ),
            ),
          ),
          SizedBox(width: widget.paymentInfoPageStyles.widthDp * 20),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(text: PaymentInfoPageString.title.substring(0, 1), style: widget.paymentInfoPageStyles.title1Style),
                TextSpan(text: PaymentInfoPageString.title.substring(1), style: widget.paymentInfoPageStyles.title2Style),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _containerItems(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        Function _onTapHandler;
        Widget icon = SizedBox();

        switch (index) {
          case 0:
            _onTapHandler = () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => CreditCardPage()),
              );
            };
            break;
          case 1:
            _onTapHandler = () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => HomePage()),
              );
            };
            break;
          default:
        }

        return GestureDetector(
          onTap: _onTapHandler,
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                SizedBox(height: widget.paymentInfoPageStyles.widthDp * 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        icon,
                        SizedBox(width: widget.paymentInfoPageStyles.widthDp * 10),
                        Text(PaymentInfoPageString.itemList[index], style: widget.paymentInfoPageStyles.labelStyle),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: widget.paymentInfoPageStyles.iconSize,
                        color: (PaymentInfoPageString.itemList[index] == "Sign Out") ? Colors.transparent : AppColors.blackColor),
                  ],
                ),
                SizedBox(height: widget.paymentInfoPageStyles.widthDp * 20),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(height: 1, thickness: 1, color: Colors.grey.withAlpha(100));
      },
      itemCount: PaymentInfoPageString.itemList.length,
    );
  }
}
