import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'package:keicy_stripe_payment/keicy_stripe_payment.dart';

import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:money_transfer_app/Providers/index.dart';
import 'index.dart';

class BottomNavbarProvider extends ChangeNotifier {
  static BottomNavbarProvider of(BuildContext context, {bool listen = false}) => Provider.of<BottomNavbarProvider>(context, listen: listen);

  BottomNavbarState _bottomNavbarState = BottomNavbarState.init();
  BottomNavbarState get bottomNavbarState => _bottomNavbarState;

  void setBottomNavbarState(BottomNavbarState bottomNavbarState, {bool isNotifiable = true}) {
    if (_bottomNavbarState.toJson().toString() != bottomNavbarState.toJson().toString()) {
      _bottomNavbarState = bottomNavbarState;
      if (isNotifiable) notifyListeners();
    }
  }
}
