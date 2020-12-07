import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:keicy_stripe_payment/keicy_stripe_payment.dart';
import 'package:money_transfer_app/Providers/index.dart';
import 'package:provider/provider.dart';

import 'package:keicy_firebase_auth_0_18/keicy_firebase_auth_0_18.dart';
import 'package:keicy_fcm_for_mobile_7_0/keicy_fcm_for_mobile_7_0.dart';
import 'package:keicy_storage_for_mobile_4_0/keicy_storage_for_mobile_4_0.dart';
import 'package:keicy_utils/local_storage.dart';

import 'package:money_transfer_framework/money_transfer_framework.dart';

import 'index.dart';

class PinCodeProvider extends ChangeNotifier {
  static PinCodeProvider of(BuildContext context, {bool listen = false}) => Provider.of<PinCodeProvider>(context, listen: listen);

  PinCodeState _pinCodeState = PinCodeState.init();
  PinCodeState get pinCodeState => _pinCodeState;

  void setPinCodeState(PinCodeState pinCodeState, {bool isNotifiable = true}) {
    if (_pinCodeState != pinCodeState) {
      _pinCodeState = pinCodeState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> loginWithPinCode({
    @required AuthProvider authProvider,
    @required UserProvider userProvider,
    @required String pinCode,
    bool isNewPinCode = false,
  }) async {
    print("___________________");
    print(pinCode);
    print("___________________");
    var result = await UserRepository.getUserByUID(authProvider.authState.firebaseUser.uid);
    if (result["success"]) {
      if (isNewPinCode) {
        UserModel _userModel = UserModel.fromJson(result["data"][0]);
        _userModel.pinCode = pinCode;
        int day = DateTime.now().day;
        int month = DateTime.now().month;
        if (day != _userModel.day) {
          _userModel.dailyCount = 0;
          _userModel.day = DateTime.now().day;
        }
        if (month != _userModel.month) {
          _userModel.monthlyCount = 0;
          _userModel.month = DateTime.now().month;
        }
        var newResult = await UserRepository.updateUser(_userModel.id, _userModel.toJson());
        if (newResult["success"]) {
          authProvider.setAuthState(
            authProvider.authState.update(authStatement: AuthStatement.IsLogin, errorString: ""),
            isNotifiable: false,
          );

          userProvider.setUserState(
            userProvider.userState.update(userModel: _userModel),
            isNotifiable: false,
          );

          _pinCodeState = _pinCodeState.update(progressState: 2, errorString: "");
        } else {
          _pinCodeState = _pinCodeState.update(
            progressState: -1,
            errorString: "Login Error. Please try again.",
          );
        }
      } else {
        if (result["data"][0]["pinCode"] == pinCode) {
          authProvider.setAuthState(
            authProvider.authState.update(authStatement: AuthStatement.IsLogin, errorString: ""),
            isNotifiable: false,
          );

          UserModel _userModel = UserModel.fromJson(result["data"][0]);

          int day = DateTime.now().day;
          int month = DateTime.now().month;
          if (day != _userModel.day) {
            _userModel.dailyCount = 0;
            _userModel.day = DateTime.now().day;
          }
          if (month != _userModel.month) {
            _userModel.monthlyCount = 0;
            _userModel.month = DateTime.now().month;
          }

          userProvider.saveUserData(userID: _userModel.id, userModel: _userModel);
          userProvider.setUserState(
            userProvider.userState.update(userModel: _userModel),
            isNotifiable: false,
          );

          _pinCodeState = _pinCodeState.update(progressState: 2, errorString: "");
        } else {
          _pinCodeState = _pinCodeState.update(
            progressState: -1,
            errorString: "Pin Number Not Match. Please try again.",
          );
        }
      }
    } else {
      _pinCodeState = _pinCodeState.update(
        progressState: -1,
        errorString: "Login Error. Please try again.",
      );
    }

    notifyListeners();
  }

  // Future<void> loginWithPinCode({
  //   @required AuthProvider authProvider,
  //   @required UserProvider userProvider,
  //   @required String firstName,
  //   @required String lastName,
  //   @required String middleName,
  //   @required String phoneNumber,
  //   @required String pinCode,
  //   bool isNewPinCode = false,
  // }) async {
  //   var result = await UserRepository.getUserByUID(authProvider.authState.firebaseUser.uid);
  //   if (result["success"]) {
  //     if (isNewPinCode) {
  //       var userData = await updateUserData(
  //         authProvider.authState.firebaseUser,
  //         result,
  //         firstName,
  //         lastName,
  //         middleName,
  //         phoneNumber,
  //         pinCode,
  //       );
  //       if (userData["success"]) {
  //         authProvider.setAuthState(
  //           authProvider.authState.update(authStatement: AuthStatement.IsLogin, errorString: ""),
  //           isNotifiable: false,
  //         );

  //         userProvider.setUserState(
  //           userProvider.userState.update(userModel: UserModel.fromJson(userData["data"][0])),
  //           isNotifiable: false,
  //         );

  //         _pinCodeState = _pinCodeState.update(progressState: 2, errorString: "");
  //       } else {
  //         _pinCodeState = _pinCodeState.update(progressState: -1, errorString: userData["errorString"]);
  //       }
  //     } else {
  //       if (result["data"][0]["pinCode"] == pinCode) {
  //         var userData = await updateUserData(
  //           authProvider.authState.firebaseUser,
  //           result,
  //           firstName,
  //           lastName,
  //           middleName,
  //           phoneNumber,
  //           pinCode,
  //         );

  //         if (userData["success"]) {
  //           authProvider.setAuthState(
  //             authProvider.authState.update(authStatement: AuthStatement.IsLogin, errorString: ""),
  //             isNotifiable: false,
  //           );

  //           userProvider.setUserState(
  //             userProvider.userState.update(userModel: UserModel.fromJson(userData["data"][0])),
  //             isNotifiable: false,
  //           );

  //           _pinCodeState = _pinCodeState.update(progressState: 2, errorString: "");
  //         } else {
  //           _pinCodeState = _pinCodeState.update(progressState: -1, errorString: userData["errorString"]);
  //         }
  //       } else {
  //         _pinCodeState = _pinCodeState.update(
  //           progressState: -1,
  //           errorString: "Pin Number Not Match. Please try again.",
  //         );
  //       }
  //     }
  //   } else {
  //     _pinCodeState = _pinCodeState.update(
  //       progressState: -1,
  //       errorString: "Login Error. Please try again.",
  //     );
  //   }

  //   notifyListeners();
  // }

}
