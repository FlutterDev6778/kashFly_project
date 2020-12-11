import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:money_transfer_app/Providers/index.dart';
import 'package:provider/provider.dart';

import 'package:keicy_utils/local_storage.dart';
import 'package:keicy_stripe_payment/keicy_stripe_payment.dart';

import 'package:money_transfer_framework/money_transfer_framework.dart';

import 'index.dart';

class AuthProvider extends ChangeNotifier {
  static AuthProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<AuthProvider>(context, listen: listen);

  AuthState _authState = AuthState.init();
  AuthState get authState => _authState;

  void setAuthState(AuthState authState, {bool isNotifiable = true}) {
    if (_authState != authState) {
      _authState = authState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<UserModel> init(User user) async {
    await LocalStorage.instance.init();
    await KeicyFCMForMobile.instance.getToken();
    KeicyStripePayment.init(
      publicKey: Config.stripePublicKey,
      secretKey: Config.stripeSecretKey,
    );

    UserModel _userModel = UserModel();

    if (user == null) {
      _authState = _authState.update(
        firebaseUser: null,
        authStatement: AuthStatement.IsNotLogin,
      );
    } else {
      try {
        await user.reload();
        var result = await UserRepository.getUserByUID(user.uid);

        if (result["success"]) {
          _authState = _authState.update(
            firebaseUser: user,
            authStatement: AuthStatement.IsNotLogin,
            errorString: "",
          );
          _userModel = UserModel.fromJson(result["data"][0]);
        } else {
          _authState = _authState.update(
            firebaseUser: null,
            authStatement: AuthStatement.IsNotLogin,
            errorString: "",
          );
        }
      } catch (e) {
        _authState = _authState.update(
          firebaseUser: null,
          authStatement: AuthStatement.IsNotLogin,
          errorString: "",
        );
      }
    }
    notifyListeners();
    return _userModel;
  }

  Future<void> phoneVerification(String phoneNumber, {int forceResendingToken}) async {
    await KeicyAuthentication.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      forceResendingToken: forceResendingToken,
      timeout: Duration(seconds: 60),
    );
  }

  Future<void> confirmPhoneVerification({@required String smsCode}) async {
    Map<String, dynamic> authResult = Map<String, dynamic>();

    authResult = await KeicyAuthentication.instance.confirmPhoneVerification(
      smsCode: smsCode,
      verificationId: _authState.verificationId,
    );

    if (authResult["success"]) {
      _authState = _authState.update(
        authStatement: AuthStatement.IsNotLogin, // AuthStatement.IsLogin,
        firebaseUser: authResult["data"].user,
        errorString: "",
        progressState: 2,
      );
    } else {
      _authState = _authState.update(
        authStatement: AuthStatement.IsNotLogin,
        firebaseUser: null,
        errorString: authResult["errorCode"],
        progressState: -1,
      );
    }

    notifyListeners();
  }

  Future<void> verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
    Map<String, dynamic> authResult = Map<String, dynamic>();
    authResult = await KeicyAuthentication.instance.signInWithPhoneAuthCredential(
      phoneAuthCredential: phoneAuthCredential,
    );

    if (authResult["success"]) {
      _authState = _authState.update(
        authStatement: AuthStatement.IsNotLogin, // AuthStatement.IsLogin,
        firebaseUser: authResult["data"].user,
        errorString: "",
        progressState: 2,
      );
    } else {
      _authState = _authState.update(
        authStatement: AuthStatement.IsNotLogin,
        firebaseUser: null,
        errorString: authResult["errorCode"],
        progressState: -1,
      );
    }

    notifyListeners();
  }

  void verificationFailed(FirebaseAuthException firebaseAuthException) {
    print(firebaseAuthException.message);
    _authState = _authState.update(
      authStatement: AuthStatement.IsNotLogin,
      firebaseUser: null,
      errorString: firebaseAuthException.code,
      progressState: -1,
    );
    notifyListeners();
  }

  void codeSent(String verificationId, int forceResendingToken) {
    _authState = _authState.update(
      verificationId: verificationId,
      forceResendingToken: forceResendingToken,
      errorString: "",
      progressState: 1,
    );
    notifyListeners();
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    // _authState = _authState.update(
    //   verificationId: verificationId,
    //   errorString: "Timeout",
    //   progressState: -1,
    // );
    // notifyListeners();
  }

  Future<void> logout() async {
    try {
      await KeicyAuthentication.instance.signOut();
      _authState = _authState.update(
        authStatement: AuthStatement.IsNotLogin,
        errorString: "",
        firebaseUser: null,
        progressState: 0,
      );
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
