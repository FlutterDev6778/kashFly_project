import 'package:equatable/equatable.dart';

class StripeTransactionModel extends Equatable {
  String id;
  String senderID;
  String recipientID;
  String amount;
  Map<String, dynamic> paymentIntent;
  int state;
  int ts;

  StripeTransactionModel({
    this.id = "",
    this.senderID = "",
    this.recipientID = "",
    this.amount = "",
    this.paymentIntent,
    this.state = 0,
    this.ts = 0,
  });

  factory StripeTransactionModel.fromJson(Map<String, dynamic> map) {
    return StripeTransactionModel(
      id: map['id'] ?? "",
      senderID: map['senderID'] ?? "",
      recipientID: map['recipientID'] ?? "",
      amount: map['amount'] ?? "",
      paymentIntent: map['paymentIntent'] ?? Map<String, dynamic>(),
      state: map['state'] ?? 0,
      ts: map['ts'] ?? 0,
    );
  }

  StripeTransactionModel update(Map<String, dynamic> map) {
    return StripeTransactionModel(
      id: map['id'] ?? id ?? "",
      senderID: map['senderID'] ?? senderID ?? "",
      recipientID: map['recipientID'] ?? recipientID ?? "",
      amount: map['amount'] ?? amount ?? "",
      paymentIntent: map['paymentIntent'] ?? paymentIntent ?? Map<String, dynamic>(),
      state: map['state'] ?? state ?? 0,
      ts: map['ts'] ?? ts ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id ?? "",
      "senderID": senderID ?? "",
      "recipientID": recipientID ?? "",
      "amount": amount ?? "",
      "paymentIntent": paymentIntent ?? 0,
      "state": state ?? 0,
      "ts": ts ?? 0,
    };
  }

  @override
  List<Object> get props => [
        id,
        senderID,
        recipientID,
        amount,
        paymentIntent,
        state,
        ts,
      ];

  @override
  bool get stringify => true;
}
