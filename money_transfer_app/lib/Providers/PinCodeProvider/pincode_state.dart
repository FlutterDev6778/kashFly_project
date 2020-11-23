import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PinCodeState extends Equatable {
  final int progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String errorString;

  PinCodeState({
    @required this.errorString,
    @required this.progressState,
  });

  factory PinCodeState.init() {
    return PinCodeState(
      progressState: 0,
      errorString: "",
    );
  }

  PinCodeState copyWith({
    int progressState,
    String errorString,
  }) {
    return PinCodeState(
      progressState: progressState ?? this.progressState,
      errorString: errorString ?? this.errorString,
    );
  }

  PinCodeState update({
    int progressState,
    String errorString,
  }) {
    return copyWith(
      progressState: progressState,
      errorString: errorString,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "errorString": errorString,
    };
  }

  @override
  List<Object> get props => [
        progressState,
        errorString,
      ];

  @override
  bool get stringify => true;
}
