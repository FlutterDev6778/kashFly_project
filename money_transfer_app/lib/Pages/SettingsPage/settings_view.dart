import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_transfer_app/Pages/Components/index.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
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
import 'package:money_transfer_app/Pages/AboutPage/index.dart';
import 'package:money_transfer_app/Pages/ChangePinCodePage/change_pin_code_page.dart';
import 'package:money_transfer_app/Pages/DocumentCategoryPage/index.dart';
import 'package:money_transfer_app/Pages/HomePage/index.dart';
import 'package:money_transfer_app/Pages/NotificationPage/index.dart';
import 'package:money_transfer_app/Pages/SupportPage/index.dart';
import 'package:money_transfer_app/Pages/PaymentInfoPage/payment_info_page.dart';
import 'package:money_transfer_app/Pages/PersonalInfoPage/index.dart';

import 'index.dart';

class SettingsView extends StatefulWidget {
  final SettingsPageStyles settingsPageStyles;

  const SettingsView({
    Key key,
    this.settingsPageStyles,
  }) : super(key: key);

  @override
  _TransferViewState createState() => _TransferViewState();
}

class _TransferViewState extends State<SettingsView> {
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
      body: Container(
        height: widget.settingsPageStyles.mainHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(
              title: SettingsPageString.title,
              widthDp: widget.settingsPageStyles.widthDp,
              fontSp: widget.settingsPageStyles.fontSp,
              haveBackIcon: false,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.settingsPageStyles.primaryHorizontalPadding,
                  vertical: widget.settingsPageStyles.primaryVerticalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _containerIDs(context),
                    SizedBox(height: widget.settingsPageStyles.widthDp * 5),
                    Expanded(child: _containerItems(context)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _containerHeader(BuildContext context) {
    return Container(
      height: widget.settingsPageStyles.widthDp * 160,
      decoration: BoxDecoration(
        gradient: AppColors.mainGradient,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(widget.settingsPageStyles.widthDp * 40)),
      ),
      padding: EdgeInsets.symmetric(vertical: widget.settingsPageStyles.widthDp * 25),
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget.settingsPageStyles.widthDp * 25,
            ),
            child: Text(
              SettingsPageString.title,
              style: widget.settingsPageStyles.titleStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _containerIDs(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            UserProvider.of(context).userState.userModel.firstName +
                " " +
                UserProvider.of(context).userState.userModel.middleName +
                " " +
                UserProvider.of(context).userState.userModel.lastName,
            style: widget.settingsPageStyles.userNameStyle),
        SizedBox(height: widget.settingsPageStyles.widthDp * 5),
        Text(
          "kashflyID: KF${UserProvider.of(context).userState.userModel.uid.hashCode}",
          style: widget.settingsPageStyles.idStyle,
        ),
      ],
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
            icon = FaIcon(FontAwesomeIcons.userEdit,
                size: widget.settingsPageStyles.widthDp * 25, color: AppColors.secondaryColor);
            _onTapHandler = () {
              pushNewScreen(
                context,
                screen: PersonalInfoPage(),
                withNavBar: false,
              );
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (BuildContext context) => PersonalInfoPage()),
              // );
            };
            break;
          case 1:
            icon =
                Icon(Icons.credit_card, size: widget.settingsPageStyles.widthDp * 30, color: AppColors.secondaryColor);
            _onTapHandler = () {
              pushNewScreen(
                context,
                screen: CreditCardPage(),
                withNavBar: false,
              );
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (BuildContext context) => CreditCardPage()),
              // );
            };
            break;
          case 2:
            icon = Icon(Icons.notifications,
                size: widget.settingsPageStyles.widthDp * 30, color: AppColors.secondaryColor);
            _onTapHandler = () {
              pushNewScreen(
                context,
                screen: NotificationPage(),
                withNavBar: false,
              );
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (BuildContext context) => NotificationPage()),
              // );
            };
            break;
          case 3:
            icon = Container(
              padding: EdgeInsets.symmetric(horizontal: widget.settingsPageStyles.widthDp * 5),
              child: FaIcon(FontAwesomeIcons.fileAlt,
                  size: widget.settingsPageStyles.widthDp * 25, color: AppColors.secondaryColor),
            );
            _onTapHandler = () {
              pushNewScreen(
                context,
                screen: AboutPage(),
                withNavBar: false,
              );
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (BuildContext context) => AboutPage()),
              // );
            };
            break;
          case 4:
            icon =
                Icon(Icons.help_outline, size: widget.settingsPageStyles.widthDp * 30, color: AppColors.secondaryColor);
            _onTapHandler = () {
              pushNewScreen(
                context,
                screen: SupportPage(),
                withNavBar: false,
              );
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (BuildContext context) => SupportPage()),
              // );
            };
            break;
          case 5:
            icon = FaIcon(FontAwesomeIcons.signOutAlt,
                size: widget.settingsPageStyles.widthDp * 25, color: AppColors.secondaryColor);
            _onTapHandler = () {
              Alert(
                context: context,
                type: AlertType.warning,
                title: "Are you sure to sign out?",
                style: AlertStyle(
                  titleStyle: TextStyle(color: Colors.black, fontSize: widget.settingsPageStyles.fontSp * 20),
                ),
                buttons: [
                  DialogButton(
                    color: AppColors.primaryColor,
                    child: Text(
                      "Yes",
                      style: TextStyle(color: Colors.white, fontSize: widget.settingsPageStyles.fontSp * 18),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      AuthProvider.of(context).logout();
                    },
                  ),
                  DialogButton(
                    child: Text(
                      "No",
                      style: TextStyle(color: Colors.white, fontSize: widget.settingsPageStyles.fontSp * 18),
                    ),
                    onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                    color: Colors.grey,
                  )
                ],
              ).show();
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
                SizedBox(height: widget.settingsPageStyles.widthDp * 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        icon,
                        SizedBox(width: widget.settingsPageStyles.widthDp * 10),
                        Text(SettingsPageString.itemList[index], style: widget.settingsPageStyles.labelStyle),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: widget.settingsPageStyles.iconSize,
                        color: (index == 5) ? Colors.transparent : AppColors.blackColor),
                  ],
                ),
                SizedBox(height: widget.settingsPageStyles.widthDp * 20),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(height: 1, thickness: 1, color: Colors.grey.withAlpha(100));
      },
      itemCount: SettingsPageString.itemList.length,
    );
  }
}
