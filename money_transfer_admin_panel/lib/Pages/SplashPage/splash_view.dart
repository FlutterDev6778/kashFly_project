import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:money_transfer_framework/Widgets/status_alert/lib/status_alert.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:keicy_firebase_auth_0_18/keicy_firebase_auth_0_18.dart';
import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';
import 'package:keicy_navigator/keicy_navigator.dart';

import '../App/index.dart';
import '../LoginPage/login_page.dart';
import '../../Providers/index.dart';

import 'index.dart';

class SplashView extends StatefulWidget {
  final SplashPageStyles splashPageStyles;

  const SplashView({
    Key key,
    this.splashPageStyles,
  }) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
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
      width: widget.splashPageStyles.widthDp * 120,
      height: widget.splashPageStyles.widthDp * 120,
      progressWidget: Container(
        width: widget.splashPageStyles.widthDp * 120,
        height: widget.splashPageStyles.widthDp * 120,
        padding: EdgeInsets.all(widget.splashPageStyles.widthDp * 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.splashPageStyles.widthDp * 10),
        ),
        child: SpinKitFadingCircle(
          color: AppColors.primaryColor,
          size: widget.splashPageStyles.widthDp * 80,
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
        if (_authProvider.authState.authStatement == AuthStatement.IsNotLogin) {
          KeicyNavigator.pushReplacement(context, AppRoutes.LoginPage, LoginPage());
        } else if (_authProvider.authState.authStatement == AuthStatement.IsLogin) {
          KeicyNavigator.pushReplacement(context, AppRoutes.DashboardPage, LoginPage());
        }
        break;
      case -1:
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<User>(
          stream: KeicyAuthentication.instance.firebaseAuth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              ///
            }
            if (snapshot.connectionState == ConnectionState.done) {
              ///
            }
            if (snapshot.connectionState == ConnectionState.active) {
              if (_authProvider.authState.progressState == 0) {
                _authProvider.setAuthState(_authProvider.authState.update(progressState: 1), isNotifiable: false);
                _authProvider.init(snapshot.data);
              }
            }

            return Container(
              height: widget.splashPageStyles.mainHeight,
              child: Center(
                child: SpinKitFadingCircle(
                  color: AppColors.primaryColor,
                  size: widget.splashPageStyles.widthDp * 80,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
