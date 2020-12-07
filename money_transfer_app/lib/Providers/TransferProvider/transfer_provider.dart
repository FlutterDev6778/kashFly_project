import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keicy_stripe_payment/keicy_stripe_payment.dart';
import 'package:money_transfer_app/DataProviders/index.dart';
import 'package:money_transfer_app/Providers/index.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:provider/provider.dart';

import 'index.dart';

class TransferProvider extends ChangeNotifier {
  static TransferProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<TransferProvider>(context, listen: listen);

  TransferState _transferState = TransferState.init();
  TransferState get transferState => _transferState;

  void setTransferState(TransferState transferState, {bool isNotifiable = true}) {
    if (_transferState != transferState) {
      _transferState = transferState;
      if (isNotifiable) notifyListeners();
    }
  }

  void makeTransaction(UserProvider userProvider) async {
    var result = await KeicyStripePayment.payViaPaymentMethod(
      paymentMethod: _transferState.paymentMethod,
      amount: (((_transferState.amount + _transferState.fee) * 100).toInt()).toString(),
      currency: "card",
    );

    TransactionModel transactionModel = TransactionModel();
    transactionModel.amount = (_transferState.amount).toStringAsFixed(2);
    transactionModel.fee = (_transferState.fee).toStringAsFixed(2);
    transactionModel.paymentIntent = result["paymentIntent"];
    transactionModel.senderID = userProvider.userState.userModel.id;
    transactionModel.recipientID = _transferState.recipientModel.id;
    transactionModel.ts = DateTime.now().millisecondsSinceEpoch;
    transactionModel.state = 0;

    print(base64Encode(result["paymentIntent"]["id"].toString().codeUnits));

    /// payment successs
    if (result["success"]) {
      JubaTransactionModel jubaTransactionModel = JubaTransactionModel();
      jubaTransactionModel.senderCode = JubaConfig.senderAgentCode;
      jubaTransactionModel.nominatedCode = JubaConfig.nominatedAgentCode;
      jubaTransactionModel.customerReferenceNo = userProvider.userState.userModel.customerReferenceNo;
      jubaTransactionModel.beneficiaryReferenceNo = _transferState.recipientModel.customerReferenceNo;
      jubaTransactionModel.purpose = _transferState.purpose;
      jubaTransactionModel.payoutCurrency = "USD";
      jubaTransactionModel.payoutAmount = _transferState.amount;
      jubaTransactionModel.senderModeOfPayment = 1;
      jubaTransactionModel.receiverModeOfPayment = 1;
      jubaTransactionModel.sendingCity = "MGQ";
      jubaTransactionModel.partnerReferenceNum = base64Encode(result["paymentIntent"]["id"].toString().codeUnits);
      jubaTransactionModel.settlementCurrencyCode = "USD";
      jubaTransactionModel.jubaCommisionInSettlement = "0.9";
      // data["PurposeDescription"] = "PurposeDescription";
      // data["TotalCommission"] = 15;
      // data["TotalCommissionInSettlmentCurrency"] = 0.09;
      // data["Remarks"] = "sdfsdf";

      try {
        var jubaResult = await SendTransactionDataProvider.sendTransaction(jubaTransactionModel: jubaTransactionModel);
        if (jubaResult["Response"].runtimeType == List<dynamic>().runtimeType &&
            jubaResult["Response"][0]["Code"] != "001") {
          transactionModel.state = 0;
          transactionModel.transactioinErrorString = jubaResult["Response"][0]["Message"];
        } else if (jubaResult["Response"]["Code"] != "001") {
          transactionModel.state = 0;
          transactionModel.transactioinErrorString = jubaResult["Response"]["Message"];
        } else {
          transactionModel.state = 1;
          transactionModel.transactioinErrorString = jubaResult["Response"]["Message"];
          transactionModel.jubaReferenceNum = jubaResult["Data"]["ReferenceNum"];
        }
      } catch (e) {
        print(e);
      }

      var transactionResult = await TransactionRepository.addTransaction(transactionModel);

      /// transaction history successs
      if (transactionResult["success"]) {
        UserModel userModel = UserModel.fromJson(userProvider.userState.userModel.toJson());
        userModel.day = DateTime.now().day;
        userModel.month = DateTime.now().month;
        userModel.dailyCount = userModel.dailyCount + 1;
        userModel.monthlyCount = userModel.monthlyCount + 1;
        userModel.ts = DateTime.now().millisecondsSinceEpoch;
        userModel.totalAmount = userModel.totalAmount + (_transferState.amount + _transferState.fee);
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
