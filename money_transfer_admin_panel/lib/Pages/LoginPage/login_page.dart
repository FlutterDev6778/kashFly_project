import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keicy_cookie_provider/keicy_cookie_provider.dart';

import '../App/index.dart';
import '../LoadingPage/index.dart';

import './index.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Map<String, dynamic> arguments;

  @override
  void initState() {
    super.initState();

    KeicyCookieProvider.of(context).setKeicyCookieState(
      KeicyCookieProvider.of(context).keicyCookieState.update(progressState: 0),
      isNotifiable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context)?.settings?.arguments;

    return Consumer<KeicyCookieProvider>(builder: (context, keicyCookieProvider, _) {
      if (keicyCookieProvider.keicyCookieState.progressState == 0) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          KeicyCookieProvider.of(context).checkCookie(
            routeName: AppRoutes.LoginPage,
            arguments: arguments,
          );
        });
      }

      if (keicyCookieProvider.keicyCookieState.progressState == -1) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.RootPage, (route) => false);
        });
      }

      if (keicyCookieProvider.keicyCookieState.progressState == 2) {
        LoginPageStyles _loginPageStyles;

        return Builder(builder: (context) {
          if (MediaQuery.of(context).size.width >= ResponsiveDesignSettings.desktopMaxWidth) {
            ///
            _loginPageStyles = LoginPageLargeDesktopStyles(context);
          } else if (MediaQuery.of(context).size.width < ResponsiveDesignSettings.desktopMaxWidth &&
              MediaQuery.of(context).size.width >= ResponsiveDesignSettings.tableteMaxWidth) {
            ///
            _loginPageStyles = LoginPageDesktopStyles(context);
          } else if (MediaQuery.of(context).size.width < ResponsiveDesignSettings.tableteMaxWidth &&
              MediaQuery.of(context).size.width >= ResponsiveDesignSettings.mobileMaxWidth) {
            ///
            _loginPageStyles = LoginPageTabletStyles(context);
          } else if (MediaQuery.of(context).size.width < ResponsiveDesignSettings.mobileMaxWidth) {
            ///
            _loginPageStyles = LoginPageMobileStyles(context);
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return LoginView(loginPageStyles: _loginPageStyles);
            },
          );
        });
      }
      return LoadingPage();
    });
  }
}
