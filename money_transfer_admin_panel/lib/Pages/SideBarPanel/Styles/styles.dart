import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_transfer_admin_panel/Pages/SideBarPanel/Styles/index.dart';
import '../../App/index.dart';

class SideBarPanelStyles {
  double devicePixelRatio;
  double deviceWidth;
  double deviceHeight;
  double statusbarHeight;
  double bottombarHeight;
  double appbarHeight;
  double mainHeight;
  double shareWidth;
  double shareHeight;
  double widthDp;
  double heightDp;
  double fontSp;

  double primaryHorizontalPadding;
  double primaryVerticalPadding;

  double sideBarWidth;
  double logoHeight;
  double itemHeight;

  TextStyle selectStyle;
  TextStyle unSelectStyle;

  SideBarPanelStyles(BuildContext context) {}
}

class SideBarPanelMobileStyles extends SideBarPanelStyles {
  SideBarPanelMobileStyles(BuildContext context) : super(context) {
    ScreenUtil.init(
      context,
      width: ResponsiveDesignSettings.mobileDesignWidth,
      height: ResponsiveDesignSettings.mobileDesignHeight,
      allowFontScaling: false,
    );

    devicePixelRatio = ScreenUtil.pixelRatio;
    deviceWidth = ScreenUtil.screenWidth;
    deviceHeight = ScreenUtil.screenHeight;
    statusbarHeight = ScreenUtil.statusBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    bottombarHeight = ScreenUtil.bottomBarHeight;
    shareWidth = deviceWidth / 100;
    shareHeight = deviceHeight / 100;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1, allowFontScalingSelf: false);
    mainHeight = deviceHeight - bottombarHeight;

    primaryHorizontalPadding = widthDp * 20;
    primaryVerticalPadding = widthDp * 20;

    sideBarWidth = widthDp * 300;
    logoHeight = widthDp * 100;
    itemHeight = widthDp * 50;

    selectStyle = TextStyle(fontSize: fontSp * 20, color: SideBarPanelColors.selectTextColor, fontWeight: FontWeight.bold);
    unSelectStyle = TextStyle(fontSize: fontSp * 20, color: SideBarPanelColors.unSelectTextColor);
  }
}

class SideBarPanelTabletStyles extends SideBarPanelStyles {
  SideBarPanelTabletStyles(BuildContext context) : super(context) {
    ScreenUtil.init(
      context,
      width: ResponsiveDesignSettings.tabletDesignWidth,
      height: ResponsiveDesignSettings.tabletDesignHeight,
      allowFontScaling: false,
    );

    devicePixelRatio = ScreenUtil.pixelRatio;
    deviceWidth = ScreenUtil.screenWidth;
    deviceHeight = ScreenUtil.screenHeight;
    statusbarHeight = ScreenUtil.statusBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    bottombarHeight = ScreenUtil.bottomBarHeight;
    shareWidth = deviceWidth / 100;
    shareHeight = deviceHeight / 100;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1, allowFontScalingSelf: false);
    mainHeight = deviceHeight - bottombarHeight;

    primaryHorizontalPadding = widthDp * 20;
    primaryVerticalPadding = widthDp * 20;

    sideBarWidth = widthDp * 300;
    logoHeight = widthDp * 100;
    itemHeight = widthDp * 50;

    selectStyle = TextStyle(fontSize: fontSp * 20, color: SideBarPanelColors.selectTextColor, fontWeight: FontWeight.bold);
    unSelectStyle = TextStyle(fontSize: fontSp * 20, color: SideBarPanelColors.unSelectTextColor);
  }
}

class SideBarPanelDesktopStyles extends SideBarPanelStyles {
  SideBarPanelDesktopStyles(BuildContext context) : super(context) {
    ScreenUtil.init(
      context,
      width: ResponsiveDesignSettings.desktopDesignWidth,
      height: ResponsiveDesignSettings.desktopDesignWidth,
      allowFontScaling: false,
    );

    devicePixelRatio = ScreenUtil.pixelRatio;
    deviceWidth = ScreenUtil.screenWidth;
    deviceHeight = ScreenUtil.screenHeight;
    statusbarHeight = ScreenUtil.statusBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    bottombarHeight = ScreenUtil.bottomBarHeight;
    shareWidth = deviceWidth / 100;
    shareHeight = deviceHeight / 100;
    widthDp = 1;
    heightDp = 1;
    fontSp = 1;
    mainHeight = deviceHeight - bottombarHeight;

    primaryHorizontalPadding = widthDp * 20;
    primaryVerticalPadding = widthDp * 20;

    sideBarWidth = widthDp * 300;
    logoHeight = widthDp * 100;
    itemHeight = widthDp * 50;

    selectStyle = TextStyle(fontSize: fontSp * 20, color: SideBarPanelColors.selectTextColor, fontWeight: FontWeight.bold);
    unSelectStyle = TextStyle(fontSize: fontSp * 20, color: SideBarPanelColors.unSelectTextColor);
  }
}

class SideBarPanelLargeDesktopStyles extends SideBarPanelStyles {
  SideBarPanelLargeDesktopStyles(BuildContext context) : super(context) {
    ScreenUtil.init(
      context,
      width: ResponsiveDesignSettings.largeDesktopDesignWidth,
      height: ResponsiveDesignSettings.largeDesktopDesignHeight,
      allowFontScaling: false,
    );

    devicePixelRatio = ScreenUtil.pixelRatio;
    deviceWidth = ScreenUtil.screenWidth;
    deviceHeight = ScreenUtil.screenHeight;
    statusbarHeight = ScreenUtil.statusBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    bottombarHeight = ScreenUtil.bottomBarHeight;
    shareWidth = deviceWidth / 100;
    shareHeight = deviceHeight / 100;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1, allowFontScalingSelf: false);
    mainHeight = deviceHeight - bottombarHeight;

    primaryHorizontalPadding = widthDp * 20;
    primaryVerticalPadding = widthDp * 20;

    sideBarWidth = widthDp * 300;
    logoHeight = widthDp * 100;
    itemHeight = widthDp * 50;

    selectStyle = TextStyle(fontSize: fontSp * 20, color: SideBarPanelColors.selectTextColor, fontWeight: FontWeight.bold);
    unSelectStyle = TextStyle(fontSize: fontSp * 20, color: SideBarPanelColors.unSelectTextColor);
  }
}
