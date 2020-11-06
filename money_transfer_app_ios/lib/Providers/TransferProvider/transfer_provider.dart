import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keicy_stripe_payment/keicy_stripe_payment.dart';
import 'package:money_transfer_app/Providers/index.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:provider/provider.dart';

import 'index.dart';

class TransferProvider extends ChangeNotifier {
  static TransferProvider of(BuildContext context, {bool listen = false}) => Provider.of<TransferProvider>(context, listen: listen);

  TransferState _transferState = TransferState.init();
  TransferState get transferState => _transferState;

  void setTransferState(TransferState transferState, {bool isNotifiable = true}) {
    if (_transferState != transferState) {
      _transferState = transferState;
      if (isNotifiable) notifyListeners();
    }
  }

  void makeTransaction(double amount, UserProvider userProvider) async {
    var result = await KeicyStripePayment.payViaPaymentMethod(
      paymentMethod: _transferState.paymentMethod,
      amount: ((amount * 100).toInt()).toString(),
      currency: "card",
    );

    /// payment successs
    if (result["success"]) {
      TransactionModel transactionModel = TransactionModel();
      transactionModel.amount = amount.toStringAsFixed(2);
      transactionModel.paymentIntent = result["paymentIntent"];
      transactionModel.senderID = userProvider.userState.userModel.id;
      transactionModel.recipientID = _transferState.recipientModel.id;
      transactionModel.ts = DateTime.now().millisecondsSinceEpoch;

      var transactionResult = await TransactionRepository.addTransaction(transactionModel);

      /// transaction history successs
      if (transactionResult["success"]) {
        UserModel userModel = UserModel.fromJson(userProvider.userState.userModel.toJson());
        userModel.day = DateTime.now().day;
        userModel.month = DateTime.now().month;
        userModel.dailyCount = userModel.dailyCount + 1;
        userModel.monthlyCount = userModel.monthlyCount + 1;
        userModel.ts = DateTime.now().millisecondsSinceEpoch;
        userModel.totalAmount = userModel.totalAmount + amount;
        var userResult = await UserRepository.updateUser(userModel.id, userModel.toJson());

        /// userdata update successs
        if (userResult["success"]) {
          setTransferState(
            _transferState.update(
              progressState: 2,
              errorString: result["message"],
            ),
          );
          userProvider.setUserState(
            userProvider.userState.update(
              userModel: userModel,
            ),
          );
        } else {
          setTransferState(
            _transferState.update(
              progressState: -1,
              errorString: userResult["errorString"],
            ),
          );
        }
      } else {
        setTransferState(
          _transferState.update(
            progressState: -1,
            errorString: transactionResult["errorString"],
          ),
        );
      }
    } else {
      setTransferState(
        _transferState.update(
          progressState: -1,
          errorString: result["code"],
        ),
      );
    }
  }
}
