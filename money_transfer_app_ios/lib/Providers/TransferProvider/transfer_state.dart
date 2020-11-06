import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stripe_payment/stripe_payment.dart';

class TransferState extends Equatable {
  final int progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String errorString;
  final int deliveryOption;
  final PaymentMethod paymentMethod;
  final RecipientModel recipientModel;
  final String reason;
  final double amount;

  TransferState({
    @required this.errorString,
    @required this.progressState,
    @required this.deliveryOption,
    @required this.paymentMethod,
    @required this.recipientModel,
    @required this.reason,
    @required this.amount,
  });

  factory TransferState.init() {
    return TransferState(
      progressState: 0,
      errorString: "",
      deliveryOption: -1,
      paymentMethod: null,
      recipientModel: RecipientModel(),
      reason: "",
      amount: 0.0,
    );
  }

  TransferState copyWith({
    int progressState,
    String errorString,
    int deliveryOption,
    PaymentMethod paymentMethod,
    RecipientModel recipientModel,
    String reason,
    double amount,
  }) {
    return TransferState(
      progressState: progressState ?? this.progressState,
      errorString: errorString ?? this.errorString,
      deliveryOption: deliveryOption ?? this.deliveryOption,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      recipientModel: recipientModel ?? this.recipientModel,
      reason: reason ?? this.reason,
      amount: amount ?? this.amount,
    );
  }

  TransferState update({
    int progressState,
    String errorString,
    int deliveryOption,
    PaymentMethod paymentMethod,
    RecipientModel recipientModel,
    String reason,
    double amount,
  }) {
    return copyWith(
      progressState: progressState,
      errorString: errorString,
      deliveryOption: deliveryOption,
      paymentMethod: paymentMethod,
      recipientModel: recipientModel,
      reason: reason,
      amount: amount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "errorString": errorString,
      "deliveryOption": deliveryOption,
      "paymentMethod": paymentMethod.toJson(),
      "recipientModel": recipientModel.toJson(),
      "reason": reason,
      "amount": amount,
    };
  }

  @override
  List<Object> get props => [
        progressState,
        errorString,
        deliveryOption,
        paymentMethod != null ? paymentMethod.toJson().toString() : null,
        recipientModel,
        reason,
        amount,
      ];

  @override
  bool get stringify => true;
}
