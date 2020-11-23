import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keicy_cookie_provider/keicy_cookie_provider.dart';

import '../App/index.dart';
import '../LoadingPage/index.dart';

import 'index.dart';

class ConfigurationPage extends StatefulWidget {
  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
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
        ConfigurationPageStyles _configurationPageStyles;

        return Builder(builder: (context) {
          if (MediaQuery.of(context).size.width >= ResponsiveDesignSettings.desktopMaxWidth) {
            ///
            _configurationPageStyles = ConfigurationPageLargeDesktopStyles(context);
          } else if (MediaQuery.of(context).size.width < ResponsiveDesignSettings.desktopMaxWidth &&
              MediaQuery.of(context).size.width >= ResponsiveDesignSettings.tableteMaxWidth) {
            ///
            _configurationPageStyles = ConfigurationPageDesktopStyles(context);
          } else if (MediaQuery.of(context).size.width < ResponsiveDesignSettings.tableteMaxWidth &&
              MediaQuery.of(context).size.width >= ResponsiveDesignSettings.mobileMaxWidth) {
            ///
            _configurationPageStyles = ConfigurationPageTabletStyles(context);
          } else if (MediaQuery.of(context).size.width < ResponsiveDesignSettings.mobileMaxWidth) {
            ///
            _configurationPageStyles = ConfigurationPageMobileStyles(context);
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return ConfigurationView(configurationPageStyles: _configurationPageStyles);
            },
          );
        });
      }
      return LoadingPage();
    });
  }
}
