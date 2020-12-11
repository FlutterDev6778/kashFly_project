import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:keicy_stripe_payment/keicy_stripe_payment.dart';
import 'package:money_transfer_app/Providers/index.dart';
import 'package:provider/provider.dart';

import 'package:keicy_fcm_for_mobile_7_0/keicy_fcm_for_mobile_7_0.dart';
import 'package:keicy_utils/local_storage.dart';

import 'package:money_transfer_framework/money_transfer_framework.dart';

import 'index.dart';

class PhoneVerificationProvider extends ChangeNotifier {
  static PhoneVerificationProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<PhoneVerificationProvider>(context, listen: listen);

  PhoneVerificationState _phoneVerificationState = PhoneVerificationState.init();
  PhoneVerificationState get phoneVerificationState => _phoneVerificationState;

  void setPhoneVerificationState(PhoneVerificationState phoneVerificationState, {bool isNotifiable = true}) {
    if (_phoneVerificationState != phoneVerificationState) {
      _phoneVerificationState = phoneVerificationState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> confirmPhoneVerification({
    @required AuthProvider authProvider,
    String firstName,
  }) async {
    var result = await UserRepository.getUserByUID(authProvider.authState.firebaseUser.uid);

    if (!result["success"]) {
      _phoneVerificationState = _phoneVerificationState.update(
        progressState: -1,
        errorString: result["errorString"],
      );
      notifyListeners();
      return;
    } else {
      if (firstName != "" && result["data"].length != 0) {
        _phoneVerificationState = _phoneVerificationState.update(
          progressState: -1,
          errorString: "This phone number already registerd.",
        );
        notifyListeners();
        return;
      }
      if (firstName == "" && result["data"].length == 0) {
        _phoneVerificationState = _phoneVerificationState.update(
          progressState: -1,
          errorString: "This phone number didn't register.",
        );
        KeicyAuthentication.instance.signOut();
        notifyListeners();
        return;
      }
    }

    _phoneVerificationState = _phoneVerificationState.update(
      progressState: 2,
      errorString: "",
    );
    notifyListeners();
    return;
  }
}
