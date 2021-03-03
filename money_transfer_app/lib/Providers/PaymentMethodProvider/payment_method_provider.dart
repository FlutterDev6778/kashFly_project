import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'package:keicy_stripe_payment/keicy_stripe_payment.dart';

import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:money_transfer_app/Providers/index.dart';
import 'index.dart';

class PaymentMethodProvider extends ChangeNotifier {
  static PaymentMethodProvider of(BuildContext context, {bool listen = false}) => Provider.of<PaymentMethodProvider>(context, listen: listen);

  PaymentMethodState _paymentMethodState = PaymentMethodState.init();
  PaymentMethodState get paymentMethodState => _paymentMethodState;

  void setPaymentMethodState(PaymentMethodState paymentMethodState, {bool isNotifiable = true}) {
    if (_paymentMethodState.toJson().toString() != paymentMethodState.toJson().toString()) {
      _paymentMethodState = paymentMethodState;
      if (isNotifiable) notifyListeners();
    }
  }

  void getPaymentMethodDataStream(String userID) {
    _paymentMethodState = _paymentMethodState.update(
      paymentMethodListStream: UserRepository.getUserModelListStreamByID(userID).map((list) {
        return list.map((userModel) => userModel.paymentMethodList).toList()[0];
      }),
    );
    notifyListeners();
  }

  void savePaymentMethod(UserProvider userProvider, CreditCard creditCard, bool isAddCard, int index) async {
    try {
      var result = await KeicyStripePayment.getPaymentMethodFromExistingCard(
        card: creditCard,
      );
      if (result["success"]) {
        UserModel userModel = UserModel.fromJson(userProvider.userState.userModel.toJson());
        if (userModel.paymentMethodList.length == 0) {
          userModel.paymentMethodList = [];
        }
        PaymentMethod paymentMethod = result["data"];
        paymentMethod.card.cvc = creditCard.cvc;
        if (isAddCard) {
          userModel.paymentMethodList.add(paymentMethod.toJson());
        } else {
          userModel.paymentMethodList[index] = paymentMethod.toJson();
        }

        userModel.seledtedPaymentMethod = paymentMethod.id;

        result = await UserRepository.updateUser(userModel.id, userModel.toJson());
        if (result["success"]) {
          userProvider.setUserState(userProvider.userState.update(userModel: userModel), isNotifiable: false);
          _paymentMethodState = _paymentMethodState.update(
            progressState: 2,
            errorString: "",
          );
        } else {
          _paymentMethodState = _paymentMethodState.update(
            progressState: -1,
            errorString: "saving card failed",
          );
        }
      } else {
        _paymentMethodState = _paymentMethodState.update(
          progressState: -1,
          errorString: result["message"],
        );
      }
    } catch (e) {
      _paymentMethodState = _paymentMethodState.update(
        progressState: -1,
        errorString: "saving card failed",
      );
    }
    userProvider.notifyListeners();
    notifyListeners();
  }

  Future<void> deleteCreditCard(
    UserProvider userProvider,
    Map<String, dynamic> creditCard,
    int index,
  ) async {
    try {
      UserModel userModel = UserModel.fromJson(userProvider.userState.userModel.toJson());
      userModel.seledtedPaymentMethod = (userModel.seledtedPaymentMethod == userModel.paymentMethodList[index]["id"])
          ? userModel.paymentMethodList.length == 0 ? "" : userModel.paymentMethodList[0]["id"]
          : userModel.seledtedPaymentMethod;

      userModel.paymentMethodList.removeAt(index);
      var result = await UserRepository.updateUser(userModel.id, userModel.toJson());
      if (result["success"]) {
        userProvider.setUserState(userProvider.userState.update(userModel: userModel), isNotifiable: false);
        _paymentMethodState = _paymentMethodState.update(
          progressState: 2,
          errorString: "",
        );
      } else {
        _paymentMethodState = _paymentMethodState.update(
          progressState: -1,
          errorString: "deleting Card failed",
        );
      }
    } catch (e) {
      _paymentMethodState = _paymentMethodState.update(
        progressState: -1,
        errorString: "deleting Card failed",
      );
    }

    notifyListeners();
  }
}
