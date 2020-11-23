import 'package:flutter/material.dart';

import 'package:money_transfer_app/Pages/AmountPage/index.dart';
import 'package:money_transfer_app/Pages/BottomNavbar/index.dart';
import 'package:money_transfer_app/Pages/Error404Page/index.dart';
import 'package:money_transfer_app/Pages/HomePage/home_page.dart';
import 'package:money_transfer_app/Pages/LandingPage/index.dart';
import 'package:money_transfer_app/Pages/LoginPage/index.dart';
import 'package:money_transfer_app/Pages/MyBankPage/index.dart';
import 'package:money_transfer_app/Pages/MyInfoPage/index.dart';
import 'package:money_transfer_app/Pages/PinCodePage/index.dart';
import 'package:money_transfer_app/Pages/RecipientViewPage/recipient_view_page.dart';
import 'package:money_transfer_app/Pages/RegisterPage/index.dart';
import 'package:money_transfer_app/Pages/SettingsPage/index.dart';
import 'package:money_transfer_app/Pages/SplashPage/index.dart';
import 'package:money_transfer_app/Pages/TransactionHistoryPage/index.dart';
import 'package:money_transfer_app/Pages/TransferPage/index.dart';
import 'package:money_transfer_app/Pages/VerificationPage/index.dart';

import 'routes.dart';

_buildPage(_page) {
  return MaterialPageRoute(builder: (_) => _page);
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Map<String, dynamic> args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.RootPage:
        return _buildPage(
          SplashPage(),
        );
        break;
      case AppRoutes.SplashPage:
        return _buildPage(
          SplashPage(),
        );
        break;

      case AppRoutes.LandingPage:
        return _buildPage(
          LandingPage(),
        );
        break;

      case AppRoutes.LoginPage:
        return _buildPage(
          LoginPage(
            selectedTap: args == null ? 0 : args["selectedTap"] ?? 0,
          ),
        );
        break;
      case AppRoutes.RegisterPage:
        return _buildPage(
          RegisterPage(),
        );
        break;

      case AppRoutes.MyInfoPage:
        return _buildPage(
          MyInfoPage(),
        );
        break;

      case AppRoutes.MyBankPage:
        return _buildPage(
          MyBankPage(),
        );
        break;

      case AppRoutes.VerificationPage:
        return _buildPage(
          VerificationPage(
            firstName: args["firstName"] ?? "",
            middleName: args["middleName"] ?? "",
            lastName: args["lastName"] ?? "",
            phoneNumber: args["phoneNumber"] ?? "",
          ),
        );
        break;
      case AppRoutes.PinCodePage:
        return _buildPage(
          PinCodePage(
            isNewPinCode: args != null && args["isNewPinCode"] != null ? args["isNewPinCode"] : false,
          ),
        );
        break;
      case AppRoutes.BottomNavbar:
        return _buildPage(
          BottomNavbar(),
        );
        break;
      case AppRoutes.HomePage:
        return _buildPage(
          HomePage(),
        );
        break;
      case AppRoutes.TransactionHistoryPage:
        return _buildPage(
          TransactionHistoryPage(),
        );
        break;
      case AppRoutes.TransferPage:
        return _buildPage(
          TransferPage(),
        );
        break;
      case AppRoutes.ProfilePage:
        return _buildPage(
          SettingsPage(),
        );
        break;
      case AppRoutes.RecipientViewPage:
        return _buildPage(
          RecipientViewPage(
            recipientProvider: args["recipientProvider"],
            recipientModel: args["recipientModel"],
          ),
        );
        break;
      case AppRoutes.AmountPage:
        return _buildPage(
          AmountPage(),
        );
        break;
      default:
        return _buildPage(Error404Page(
          routeName: settings.name,
        ));
    }
  }
}
