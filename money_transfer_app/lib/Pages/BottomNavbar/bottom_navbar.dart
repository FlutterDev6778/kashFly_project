import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keicy_navigator/keicy_navigator.dart';
import 'package:money_transfer_app/Pages/AmountPage/index.dart';
import 'package:money_transfer_app/Pages/HomePage/index.dart';
import 'package:money_transfer_app/Pages/LandingPage/landing_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import 'package:keicy_cupertino_indicator/keicy_cupertino_indicator.dart';
import 'package:keicy_utils/date_time_convert.dart';

import 'package:money_transfer_app/Pages/PinCodePage/pin_code_page.dart';
import 'package:money_transfer_app/Pages/RegisterPage/register_page.dart';
import 'package:money_transfer_app/Pages/SettingsPage/index.dart';
import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Pages/TransactionHistoryPage/index.dart';
import 'package:money_transfer_app/Pages/LoginPage/index.dart';
import 'package:money_transfer_app/Pages/TransferPage/index.dart';
import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class BottomNavbar extends StatefulWidget {
  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> with TickerProviderStateMixin {
  BottomNavbarStyles _bottomNavbarStyles;
  PersistentTabController _controller;
  bool isShown;

  @override
  void initState() {
    super.initState();

    _controller = PersistentTabController(initialIndex: 1);
    isShown = true;
  }

  @override
  void dispose() {
    try {
      _controller.dispose();
    } catch (e) {}

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _bottomNavbarStyles = BottomNavbarMobileStyles(context);

    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      if (authProvider.authState.authStatement == AuthStatement.IsNotLogin) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (authProvider.authState.firebaseUser == null) {
            KeicyNavigator.pushReplacement(context, AppRoutes.LandingPage, LandingPage());
          } else {
            KeicyNavigator.pushReplacement(context, AppRoutes.PinCodePage, PinCodePage(isNewPinCode: false));
          }
          // if (UserProvider.of(context).userState.userModel.pinCode == "") {
          //   KeicyNavigator.pushReplacement(context, AppRoutes.LandingPage, LandingPage());
          // } else {
          //   KeicyNavigator.pushReplacement(context, AppRoutes.PinCodePage, PinCodePage(isNewPinCode: false));
          // }
        });

        return Scaffold(body: SizedBox());
      }

      return Consumer2<SettingsDataProvider, BottomNavbarProvider>(builder: (context, settingsDataProvider, bottomNavbarProvider, _) {
        if (settingsDataProvider.settingsDataState.progressState == 0) {
          settingsDataProvider.getSettingsData();
          return Scaffold(
            body: Center(child: KeicyCupertinoIndicator(size: 30)),
          );
        } else if (settingsDataProvider.settingsDataState.progressState == -1) {
          return Scaffold(
            body: Center(
              child: Text("Reading Initial Data From Firebase Failed"),
            ),
          );
        } else if (settingsDataProvider.settingsDataState.progressState == 1) {
          return Scaffold(
            body: Center(child: KeicyCupertinoIndicator(size: 30)),
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            checkDocumentExpireDate(context);
          });
          return PersistentTabView(
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(bottomNavbarProvider),
            navBarHeight: _bottomNavbarStyles.widthDp * 80,
            confineInSafeArea: true,
            backgroundColor: bottomNavbarProvider.bottomNavbarState.type == 0 ? Colors.white : AppColors.primaryColor,
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            stateManagement: true,
            iconSize: _bottomNavbarStyles.widthDp * 30,
            hideNavigationBarWhenKeyboardShows: true,
            hideNavigationBar: false,
            decoration: NavBarDecoration(
              colorBehindNavBar: Colors.transparent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(_bottomNavbarStyles.widthDp * 35)),
              boxShadow: bottomNavbarProvider.bottomNavbarState.type == 0
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            itemAnimationProperties: ItemAnimationProperties(
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimation(
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle.simple,
          );
        }
      });
    });
  }

  void checkDocumentExpireDate(BuildContext context) {
    if (isShown && UserProvider.of(context).userState.userModel.documents != null) {
      if (UserProvider.of(context).userState.userModel.totalAmount < 3000 &&
          UserProvider.of(context).userState.userModel.documents["category1"] != null &&
          DateTime.now().isAfter(
            DateTime.fromMillisecondsSinceEpoch(
              UserProvider.of(context).userState.userModel.documents["category1"]["expireDateTs"],
            ),
          )) {
        isShown = false;
        StatusAlert.show(
          context,
          duration: Duration(seconds: 2),
          title: "Document expired Date is over. Please upload other document",
          titleOptions: StatusAlertTextConfiguration(
            style: TextStyle(fontSize: _bottomNavbarStyles.fontSp * 16, color: AppColors.blackColor),
          ),
          margin: EdgeInsets.all(_bottomNavbarStyles.widthDp * 80),
          padding: EdgeInsets.all(_bottomNavbarStyles.widthDp * 20),
          configuration: IconConfiguration(
            icon: Icons.error_outline,
            color: Colors.redAccent,
            size: _bottomNavbarStyles.widthDp * 80,
          ),
          blurPower: 3,
          backgroundColor: Colors.white,
        );
      }
    }
  }

  List<PersistentBottomNavBarItem> _navBarsItems(BottomNavbarProvider bottomNavbarProvider) {
    return BottomNavbarString.navbarItemList.map((items) {
      Color activeColor = bottomNavbarProvider.bottomNavbarState.type == 0 ? items["activeColor"] : AppColors.whiteColor;
      Color inactiveColor = bottomNavbarProvider.bottomNavbarState.type == 0 ? items["inactiveColor"] : Colors.white.withOpacity(0.6);
      return PersistentBottomNavBarItem(
        contentPadding: 0,
        icon: Center(
          child: SvgPicture.asset(
            items["icon"],
            width: 50,
            height: 50,
            color: _controller.index == BottomNavbarString.navbarItemList.indexOf(items) ? activeColor : inactiveColor,
            fit: BoxFit.cover,
          ),
        ),
        onPressed: () {
          bottomNavbarProvider.setBottomNavbarState(
            bottomNavbarProvider.bottomNavbarState.update(type: (BottomNavbarString.navbarItemList.indexOf(items) == 1) ? 1 : 0),
          );
          onPressHandler(BottomNavbarString.navbarItemList.indexOf(items));
        },
      );
    }).toList();
  }

  List<Widget> _buildScreens() {
    return [
      HomePage(onNavItemPressHandler: onPressHandler),
      AmountPage(),
      TransactionHistoryPage(),
      SettingsPage(),
    ];
  }

  void onPressHandler(int index) {
    _controller.jumpToTab(index);
    setState(() {});
  }
}
