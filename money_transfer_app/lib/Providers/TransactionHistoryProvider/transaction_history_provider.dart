import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keicy_stripe_payment/keicy_stripe_payment.dart';
import 'package:money_transfer_app/DataProviders/index.dart';
import 'package:money_transfer_app/Providers/index.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:provider/provider.dart';

import 'index.dart';

class TransactionHistoryProvider extends ChangeNotifier {
  static TransactionHistoryProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<TransactionHistoryProvider>(context, listen: listen);

  TransactionHistoryState _transactionHistoryState = TransactionHistoryState.init();
  TransactionHistoryState get transactionHistoryState => _transactionHistoryState;

  void setTransactionHistoryState(TransactionHistoryState transactionHistoryState, {bool isNotifiable = true}) {
    if (_transactionHistoryState != transactionHistoryState) {
      _transactionHistoryState = transactionHistoryState;
      if (isNotifiable) notifyListeners();
    }
  }

  void getTransactioinListStream(String userID, String referenceNum, int limit) async {
    setTransactionHistoryState(
      _transactionHistoryState.update(
        transactionListStream: TransactionRepository.getTransactionModelListStream(
          wheres: [
            {"key": "senderID", "val": userID},
            // {"key": "state", "val": 0}
          ],
          orderby: [
            {"key": "ts", "desc": true}
          ],
          limit: limit,
        ).map(
          (list) {
            return list.map(
              (transactionModel) {
                return RecipientRepository.getRecipientModelStreamByID(transactionModel.recipientID).map(
                  (recipientModel) => {"transactionModel": transactionModel, "recipientModel": recipientModel},
                );
              },
            ).toList();
          },
        ),
      ),
    );
  }

  void getSuccessTransactioinListStream(String userID, String referenceNum, int limit) async {
    setTransactionHistoryState(
      _transactionHistoryState.update(
        transactionListStream: TransactionRepository.getTransactionModelListStream(
          wheres: [
            {"key": "senderID", "val": userID},
            {"key": "state", "val": 1}
          ],
          orderby: [
            {"key": "ts", "desc": true}
          ],
          limit: limit,
        ).map(
          (list) {
            return list.map(
              (transactionModel) {
                return RecipientRepository.getRecipientModelStreamByID(transactionModel.recipientID).map(
                  (recipientModel) => {"transactionModel": transactionModel, "recipientModel": recipientModel},
                );
              },
            ).toList();
          },
        ),
      ),
    );
  }

  void getTotalTransactionAmountStream(String userID) {
    setTransactionHistoryState(
      _transactionHistoryState.update(
        totalTransactionAmountStream: TransactionRepository.getTransactionModelListStream(
          wheres: [
            {"key": "senderID", "val": userID},
            // {"key": "state", "val": 0}
          ],
          orderby: [
            {"key": "ts", "desc": true}
          ],
        ).map(
          (list) {
            double amount = 0;
            for (var i = 0; i < list.length; i++) {
              amount += double.parse(list[i].amount);
            }
            return amount;
          },
        ),
      ),
    );
  }
}
