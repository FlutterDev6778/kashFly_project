import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keicy_cookie_provider/keicy_cookie_provider.dart';

import '../App/index.dart';
import '../LoadingPage/index.dart';

import 'index.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
        DashboardPageStyles _dashboardPageStyles;

        return Builder(builder: (context) {
          if (MediaQuery.of(context).size.width >= ResponsiveDesignSettings.desktopMaxWidth) {
            ///
            _dashboardPageStyles = DashboardPageLargeDesktopStyles(context);
          } else if (MediaQuery.of(context).size.width < ResponsiveDesignSettings.desktopMaxWidth &&
              MediaQuery.of(context).size.width >= ResponsiveDesignSettings.tableteMaxWidth) {
            ///
            _dashboardPageStyles = DashboardPageDesktopStyles(context);
          } else if (MediaQuery.of(context).size.width < ResponsiveDesignSettings.tableteMaxWidth &&
              MediaQuery.of(context).size.width >= ResponsiveDesignSettings.mobileMaxWidth) {
            ///
            _dashboardPageStyles = DashboardPageTabletStyles(context);
          } else if (MediaQuery.of(context).size.width < ResponsiveDesignSettings.mobileMaxWidth) {
            ///
            _dashboardPageStyles = DashboardPageMobileStyles(context);
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return DashboardView(dashboardPageStyles: _dashboardPageStyles);
            },
          );
        });
      }
      return LoadingPage();
    });
  }
}
