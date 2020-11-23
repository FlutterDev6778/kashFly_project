import 'package:flutter/material.dart';
import 'package:money_transfer_admin_panel/Pages/App/resposible_settings.dart';
import 'package:provider/provider.dart';

import './index.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SplashPageStyles _splashPageStyles;

    return Builder(builder: (context) {
      if (MediaQuery.of(context).size.width >= ResponsiveDesignSettings.desktopMaxWidth) {
        ///
        _splashPageStyles = SplashPageLargeDesktopStyles(context);
      } else if (MediaQuery.of(context).size.width < ResponsiveDesignSettings.desktopMaxWidth &&
          MediaQuery.of(context).size.width >= ResponsiveDesignSettings.tableteMaxWidth) {
        ///
        _splashPageStyles = SplashPageDesktopStyles(context);
      } else if (MediaQuery.of(context).size.width < ResponsiveDesignSettings.tableteMaxWidth &&
          MediaQuery.of(context).size.width >= ResponsiveDesignSettings.mobileMaxWidth) {
        ///
        _splashPageStyles = SplashPageTabletStyles(context);
      } else if (MediaQuery.of(context).size.width < ResponsiveDesignSettings.mobileMaxWidth) {
        ///
        _splashPageStyles = SplashPageMobileStyles(context);
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          return SplashView(splashPageStyles: _splashPageStyles);
        },
      );
    });
  }
}
