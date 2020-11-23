import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class PaymentMethodState extends Equatable {
  final int progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String errorString;
  final Stream<List<dynamic>> paymentMethodListStream;

  PaymentMethodState({
    @required this.errorString,
    @required this.progressState,
    @required this.paymentMethodListStream,
  });

  factory PaymentMethodState.init() {
    return PaymentMethodState(
      progressState: 0,
      errorString: "",
      paymentMethodListStream: null,
    );
  }

  PaymentMethodState copyWith({
    int progressState,
    String errorString,
    Stream<List<dynamic>> paymentMethodListStream,
  }) {
    return PaymentMethodState(
      progressState: progressState ?? this.progressState,
      errorString: errorString ?? this.errorString,
      paymentMethodListStream: paymentMethodListStream ?? this.paymentMethodListStream,
    );
  }

  PaymentMethodState update({
    int progressState,
    String errorString,
    Stream<List<dynamic>> paymentMethodListStream,
  }) {
    return copyWith(
      progressState: progressState,
      errorString: errorString,
      paymentMethodListStream: paymentMethodListStream,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "errorString": errorString,
      "paymentMethodListStream": paymentMethodListStream,
    };
  }

  @override
  List<Object> get props => [
        progressState,
        errorString,
        paymentMethodListStream,
      ];

  @override
  bool get stringify => true;
}
