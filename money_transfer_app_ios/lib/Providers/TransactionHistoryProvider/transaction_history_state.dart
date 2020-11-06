import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stripe_payment/stripe_payment.dart';

class TransactionHistoryState extends Equatable {
  final int progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String errorString;
  final Stream<List<Stream<Map<String, dynamic>>>> transactionListStream;
  final Stream<double> totalTransactionAmountStream;

  TransactionHistoryState({
    @required this.errorString,
    @required this.progressState,
    @required this.transactionListStream,
    @required this.totalTransactionAmountStream,
  });

  factory TransactionHistoryState.init() {
    return TransactionHistoryState(
      progressState: 0,
      errorString: "",
      transactionListStream: null,
      totalTransactionAmountStream: null,
    );
  }

  TransactionHistoryState copyWith({
    int progressState,
    String errorString,
    Stream<List<Stream<Map<String, dynamic>>>> transactionListStream,
    Stream<double> totalTransactionAmountStream,
  }) {
    return TransactionHistoryState(
      progressState: progressState ?? this.progressState,
      errorString: errorString ?? this.errorString,
      transactionListStream: transactionListStream ?? this.transactionListStream,
      totalTransactionAmountStream: totalTransactionAmountStream ?? this.totalTransactionAmountStream,
    );
  }

  TransactionHistoryState update({
    int progressState,
    String errorString,
    Stream<List<Stream<Map<String, dynamic>>>> transactionListStream,
    Stream<double> totalTransactionAmountStream,
  }) {
    return copyWith(
      progressState: progressState,
      errorString: errorString,
      transactionListStream: transactionListStream,
      totalTransactionAmountStream: totalTransactionAmountStream,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "errorString": errorString,
      "transactionListStream": transactionListStream,
      "totalTransactionAmountStream": totalTransactionAmountStream,
    };
  }

  @override
  List<Object> get props => [
        progressState,
        errorString,
        transactionListStream,
        totalTransactionAmountStream,
      ];

  @override
  bool get stringify => true;
}
