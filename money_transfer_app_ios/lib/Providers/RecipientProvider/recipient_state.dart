import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipientState extends Equatable {
  final int progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String errorString;
  final Stream<List<RecipientModel>> recipientModelListStream;

  RecipientState({
    @required this.errorString,
    @required this.progressState,
    @required this.recipientModelListStream,
  });

  factory RecipientState.init() {
    return RecipientState(
      progressState: 0,
      errorString: "",
      recipientModelListStream: null,
    );
  }

  RecipientState copyWith({
    int progressState,
    String errorString,
    int selectedType,
    Stream<List<RecipientModel>> recipientModelListStream,
  }) {
    return RecipientState(
      progressState: progressState ?? this.progressState,
      errorString: errorString ?? this.errorString,
      recipientModelListStream: recipientModelListStream ?? this.recipientModelListStream,
    );
  }

  RecipientState update({
    int progressState,
    String errorString,
    Stream<List<RecipientModel>> recipientModelListStream,
  }) {
    return copyWith(
      progressState: progressState,
      errorString: errorString,
      recipientModelListStream: recipientModelListStream,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "errorString": errorString,
      "recipientModelListStream": recipientModelListStream,
    };
  }

  @override
  List<Object> get props => [
        progressState,
        errorString,
        recipientModelListStream,
      ];

  @override
  bool get stringify => true;
}
