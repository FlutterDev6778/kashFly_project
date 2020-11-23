import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserState extends Equatable {
  final int progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String errorString;
  final UserModel userModel;

  UserState({
    @required this.progressState,
    @required this.errorString,
    @required this.userModel,
  });

  factory UserState.init() {
    return UserState(
      progressState: 0,
      errorString: "",
      userModel: UserModel(),
    );
  }

  UserState copyWith({
    int progressState,
    String errorString,
    UserModel userModel,
  }) {
    return UserState(
      progressState: progressState ?? this.progressState,
      errorString: errorString ?? this.errorString,
      userModel: userModel ?? this.userModel,
    );
  }

  UserState update({
    int progressState,
    String errorString,
    UserModel userModel,
  }) {
    return copyWith(
      progressState: progressState,
      errorString: errorString,
      userModel: userModel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "errorString": errorString,
      "userModel": userModel,
    };
  }

  @override
  List<Object> get props => [
        progressState,
        errorString,
        userModel.toJson(),
      ];

  @override
  bool get stringify => true;
}
