import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class SettingsDataState extends Equatable {
  final int progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String errorString;
  final double minAmount;
  final List<dynamic> ratesInfo;
  final Map<String, dynamic> cashLimits;
  final String aboutText;
  final String supportText;
  final List<dynamic> promoCodes;

  SettingsDataState({
    @required this.progressState,
    @required this.errorString,
    @required this.minAmount,
    @required this.ratesInfo,
    @required this.cashLimits,
    @required this.aboutText,
    @required this.supportText,
    @required this.promoCodes,
  });

  factory SettingsDataState.init() {
    return SettingsDataState(
      progressState: 0,
      errorString: "",
      minAmount: 0,
      ratesInfo: null,
      cashLimits: null,
      aboutText: "",
      supportText: "",
      promoCodes: null,
    );
  }

  SettingsDataState copyWith({
    int progressState,
    String errorString,
    double minAmount,
    List<dynamic> ratesInfo,
    Map<String, dynamic> cashLimits,
    String aboutText,
    String supportText,
    List<dynamic> promoCodes,
  }) {
    return SettingsDataState(
      progressState: progressState ?? this.progressState,
      errorString: errorString ?? this.errorString,
      minAmount: minAmount ?? this.minAmount,
      ratesInfo: ratesInfo ?? this.ratesInfo,
      cashLimits: cashLimits ?? this.cashLimits,
      aboutText: aboutText ?? this.aboutText,
      supportText: supportText ?? this.supportText,
      promoCodes: promoCodes ?? this.promoCodes,
    );
  }

  SettingsDataState update({
    int progressState,
    String errorString,
    double minAmount,
    List<dynamic> ratesInfo,
    Map<String, dynamic> cashLimits,
    String aboutText,
    String supportText,
    List<dynamic> promoCodes,
  }) {
    return copyWith(
      progressState: progressState,
      errorString: errorString,
      minAmount: minAmount,
      ratesInfo: ratesInfo,
      cashLimits: cashLimits,
      aboutText: aboutText,
      supportText: supportText,
      promoCodes: promoCodes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "errorString": errorString,
      "minAmount": minAmount,
      "ratesInfo": ratesInfo,
      "cashLimits": cashLimits,
      "aboutText": aboutText,
      "supportText": supportText,
      "promoCodes": promoCodes,
    };
  }

  @override
  List<Object> get props => [
        progressState,
        errorString,
        minAmount,
        ratesInfo,
        cashLimits,
        aboutText,
        supportText,
        promoCodes,
      ];

  @override
  bool get stringify => true;
}
