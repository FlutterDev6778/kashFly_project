import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:keicy_firebase_auth_0_18/keicy_firebase_auth_0_18.dart';
import 'package:keicy_fcm_for_web/keicy_fcm_for_web.dart';
import 'package:keicy_utils/local_storage.dart';

import 'package:money_transfer_framework/money_transfer_framework.dart';

import 'index.dart';

class AuthProvider extends ChangeNotifier {
  static AuthProvider of(BuildContext context, {bool listen = false}) => Provider.of<AuthProvider>(context, listen: listen);

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
    KeicyFCMForWeb.instance.getToken();

    UserModel _userModel = UserModel();

    if (user == null) {
      _authState = _authState.update(
        firebaseUser: null,
        authStatement: AuthStatement.IsNotLogin,
        progressState: 2,
        errorString: "",
      );
    } else {
      try {
        await user.reload();
        var result = await UserRepository.getUserByUID(user.uid);

        if (result["success"]) {
          _authState = _authState.update(
            firebaseUser: user,
            authStatement: AuthStatement.IsLogin,
            progressState: 2,
            errorString: "",
          );
          _userModel = UserModel.fromJson(result["data"][0]);
        } else {
          _authState = _authState.update(
            firebaseUser: null,
            authStatement: AuthStatement.IsNotLogin,
            progressState: 2,
            errorString: "",
          );
        }
      } catch (e) {
        _authState = _authState.update(
          firebaseUser: null,
          authStatement: AuthStatement.IsNotLogin,
          progressState: 2,
          errorString: "",
        );
      }
    }

    notifyListeners();
    return _userModel;
  }

  void login({@required String email, @required String password}) async {
    var result = await KeicyAuthentication.instance.signInWidthEmailAndPassword(email: email, password: password);
    if (result["success"]) {
      _authState = _authState.update(
        authStatement: AuthStatement.IsLogin,
        errorString: "",
        progressState: 2,
        firebaseUser: result["data"].user,
      );
    } else {
      _authState = _authState.update(
        authStatement: AuthStatement.IsNotLogin,
        errorString: result["errorString"],
        progressState: -1,
        firebaseUser: null,
      );
    }
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await KeicyAuthentication.instance.signOut();
      _authState = _authState.update(
        authStatement: AuthStatement.IsNotLogin,
        errorString: "",
        progressState: 0,
        firebaseUser: null,
      );
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
