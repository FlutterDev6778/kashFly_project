import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keicy_cookie_provider/keicy_cookie_provider.dart';

import '../App/index.dart';
import '../LoadingPage/index.dart';

import 'index.dart';

class SideBarPanel extends StatefulWidget {
  int index;

  SideBarPanel({@required this.index});

  @override
  _SideBarPanelState createState() => _SideBarPanelState();
}

class _SideBarPanelState extends State<SideBarPanel> {
  @override
  Widget build(BuildContext context) {
    SideBarPanelStyles _sideBarPageStyles;

    return Builder(builder: (context) {
      if (MediaQuery.of(context).size.width >= ResponsiveDesignSettings.desktopMaxWidth) {
        ///
        _sideBarPageStyles = SideBarPanelLargeDesktopStyles(context);
      } else if (MediaQuery.of(context).size.width < ResponsiveDesignSettings.desktopMaxWidth &&
          MediaQuery.of(context).size.width >= ResponsiveDesignSettings.tableteMaxWidth) {
        ///
        _sideBarPageStyles = SideBarPanelDesktopStyles(context);
      } else if (MediaQuery.of(context).size.width < ResponsiveDesignSettings.tableteMaxWidth &&
          MediaQuery.of(context).size.width >= ResponsiveDesignSettings.mobileMaxWidth) {
        ///
        _sideBarPageStyles = SideBarPanelTabletStyles(context);
      } else if (MediaQuery.of(context).size.width < ResponsiveDesignSettings.mobileMaxWidth) {
        ///
        _sideBarPageStyles = SideBarPanelMobileStyles(context);
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          return SideBarView(sideBarPageStyles: _sideBarPageStyles, index: widget.index);
        },
      );
    });
  }
}
