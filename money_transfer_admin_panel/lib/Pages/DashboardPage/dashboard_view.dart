import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:money_transfer_admin_panel/Pages/SideBarPanel/side_bar_panel.dart';
import 'package:status_alert/status_alert.dart';
import 'package:provider/provider.dart';

import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';
import 'package:keicy_text_form_field/keicy_text_form_field.dart';
import 'package:keicy_cookie_provider/keicy_cookie_provider.dart';
import 'package:keicy_utils/validators.dart';
import 'package:keicy_navigator/keicy_navigator.dart';

import 'package:money_transfer_framework/money_transfer_framework.dart';

import '../App/index.dart';
import '../../Providers/AuthProvider/auth_provider.dart';

import 'index.dart';

class DashboardView extends StatefulWidget {
  final DashboardPageStyles dashboardPageStyles;

  const DashboardView({
    this.dashboardPageStyles,
  });

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
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
      width: widget.dashboardPageStyles.widthDp * 120,
      height: widget.dashboardPageStyles.widthDp * 120,
      progressWidget: Container(
        width: widget.dashboardPageStyles.widthDp * 120,
        height: widget.dashboardPageStyles.widthDp * 120,
        padding: EdgeInsets.all(widget.dashboardPageStyles.widthDp * 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.dashboardPageStyles.widthDp * 10),
        ),
        child: SpinKitFadingCircle(
          color: AppColors.primaryColor,
          size: widget.dashboardPageStyles.widthDp * 80,
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
    return Scaffold(
      body: Container(
        width: widget.dashboardPageStyles.deviceWidth,
        height: widget.dashboardPageStyles.mainHeight,
        child: Row(
          children: [
            SideBarPanel(index: 0),
            Expanded(
              child: Container(
                height: widget.dashboardPageStyles.mainHeight,
                child: SingleChildScrollView(
                  child: _containerMain(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _containerMain(BuildContext context) {
    return SizedBox();
  }
}
