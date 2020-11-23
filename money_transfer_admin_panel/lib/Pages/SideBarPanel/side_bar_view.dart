import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:status_alert/status_alert.dart';
import 'package:provider/provider.dart';

import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';
import 'package:keicy_text_form_field/keicy_text_form_field.dart';
import 'package:keicy_cookie_provider/keicy_cookie_provider.dart';
import 'package:keicy_utils/validators.dart';
import 'package:keicy_navigator/keicy_navigator.dart';

import 'package:money_transfer_framework/money_transfer_framework.dart';

import '../../Providers/index.dart';
import '../App/index.dart';
import '../DashboardPage/dashboard_page.dart';
import '../ConfigurationPage/index.dart';
import 'index.dart';

class SideBarView extends StatefulWidget {
  final SideBarPanelStyles sideBarPageStyles;
  final int index;

  const SideBarView({
    this.sideBarPageStyles,
    this.index,
  });

  @override
  _SideBarViewState createState() => _SideBarViewState();
}

class _SideBarViewState extends State<SideBarView> {
  AuthProvider _authProvider;
  KeicyProgressDialog _keicyProgressDialog;

  @override
  void initState() {
    super.initState();

    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(
      context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      layout: Layout.Column,
      padding: EdgeInsets.zero,
      width: widget.sideBarPageStyles.widthDp * 120,
      height: widget.sideBarPageStyles.widthDp * 120,
      progressWidget: Container(
        width: widget.sideBarPageStyles.widthDp * 120,
        height: widget.sideBarPageStyles.widthDp * 120,
        padding: EdgeInsets.all(widget.sideBarPageStyles.widthDp * 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.sideBarPageStyles.widthDp * 10),
        ),
        child: SpinKitFadingCircle(
          color: AppColors.primaryColor,
          size: widget.sideBarPageStyles.widthDp * 80,
        ),
      ),
      message: "",
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _authProvider.addListener(_authProviderListener);
    });
  }

  @override
  void dispose() {
    _authProvider.removeListener(_authProviderListener);

    super.dispose();
  }

  void _authProviderListener() async {
    if (_authProvider.authState.progressState != 1 && _keicyProgressDialog.isShowing()) {
      await _keicyProgressDialog.hide();
    }

    switch (_authProvider.authState.progressState) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case -1:
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: widget.sideBarPageStyles.sideBarWidth,
        height: widget.sideBarPageStyles.mainHeight,
        padding: EdgeInsets.symmetric(
          vertical: widget.sideBarPageStyles.primaryVerticalPadding,
        ),
        decoration: BoxDecoration(color: SideBarPanelColors.backColor),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.sideBarPageStyles.primaryHorizontalPadding,
              ),
              child: Center(
                child: Image.asset(AppAssets.logoImage, width: double.infinity, fit: BoxFit.fitHeight),
              ),
            ),
            SizedBox(height: widget.sideBarPageStyles.widthDp * 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: SideBarPanelString.itemList.map((item) {
                return GestureDetector(
                  child: Container(
                    height: widget.sideBarPageStyles.itemHeight,
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.sideBarPageStyles.primaryHorizontalPadding,
                    ),
                    color: widget.index == item["index"] ? Colors.white.withAlpha(20) : Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          item["text"],
                          style: widget.index == item["index"] ? widget.sideBarPageStyles.selectStyle : widget.sideBarPageStyles.unSelectStyle,
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    if (item["index"] != widget.index) {
                      switch (item["index"]) {
                        case 0:
                          KeicyNavigator.push(context, AppRoutes.DashboardPage, DashboardPage());
                          break;
                        case 1:
                          KeicyNavigator.push(context, AppRoutes.ConfigurationPage, ConfigurationPage());
                          break;
                        default:
                      }
                    }
                  },
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
