import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatement {
  IsInitial,
  IsLogin,
  IsNotLogin,
}

class AuthState extends Equatable {
  final AuthStatement authStatement;
  final User firebaseUser;
  final String verificationId;
  final int forceResendingToken;
  final String errorString;
  final int progressState;

  AuthState({
    @required this.authStatement,
    @required this.firebaseUser,
    @required this.verificationId,
    @required this.forceResendingToken,
    @required this.errorString,
    @required this.progressState,
  });

  factory AuthState.init() {
    return AuthState(
      authStatement: AuthStatement.IsInitial,
      firebaseUser: null,
      verificationId: "",
      forceResendingToken: 0,
      errorString: "",
      progressState: 0,
    );
  }

  AuthState copyWith({
    AuthStatement authStatement,
    dynamic firebaseUser,
    String verificationId,
    int forceResendingToken,
    String errorString,
    int progressState,
  }) {
    return AuthState(
      authStatement: authStatement ?? this.authStatement,
      firebaseUser: firebaseUser != "empty" ? firebaseUser : this.firebaseUser,
      verificationId: verificationId ?? this.verificationId,
      forceResendingToken: forceResendingToken ?? this.forceResendingToken,
      errorString: errorString ?? this.errorString,
      progressState: progressState ?? this.progressState,
    );
  }

  AuthState update({
    AuthStatement authStatement,
    dynamic firebaseUser = "empty",
    String verificationId,
    int forceResendingToken,
    String errorString,
    int progressState,
  }) {
    return copyWith(
      authStatement: authStatement,
      firebaseUser: firebaseUser,
      verificationId: verificationId,
      forceResendingToken: forceResendingToken,
      errorString: errorString,
      progressState: progressState,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "authStatement": authStatement,
      "firebaseUser": firebaseUser,
      "verificationId": verificationId,
      "forceResendingToken": forceResendingToken,
      "errorString": errorString,
      "progressState": progressState,
    };
  }

  @override
  List<Object> get props => [
        authStatement,
        firebaseUser?.uid,
        verificationId,
        forceResendingToken,
        errorString,
        progressState,
      ];

  @override
  bool get stringify => true;
}
