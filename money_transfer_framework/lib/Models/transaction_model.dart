import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  String id;
  String jubaReferenceNum;
  String senderID;
  String recipientID;
  String amount;
  String fee;
  Map<String, dynamic> paymentIntent;
  int state;
  String transactioinErrorString;
  int ts;

  TransactionModel({
    this.id = "",
    this.jubaReferenceNum = "",
    this.senderID = "",
    this.recipientID = "",
    this.amount = "",
    this.fee = "",
    this.paymentIntent,
    this.state = 0,
    this.transactioinErrorString = "",
    this.ts = 0,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? "",
      jubaReferenceNum: map['ReferenceNum'] ?? "",
      senderID: map['senderID'] ?? "",
      recipientID: map['recipientID'] ?? "",
      amount: map['amount'] ?? "",
      fee: map['fee'] ?? "",
      paymentIntent: map['paymentIntent'] ?? Map<String, dynamic>(),
      state: map['state'] ?? 0,
      transactioinErrorString: map['transactioinErrorString'] ?? "",
      ts: map['ts'] ?? 0,
    );
  }

  TransactionModel update(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? id ?? "",
      jubaReferenceNum: map['ReferenceNum'] ?? jubaReferenceNum ?? "",
      senderID: map['senderID'] ?? senderID ?? "",
      recipientID: map['recipientID'] ?? recipientID ?? "",
      amount: map['amount'] ?? amount ?? "",
      fee: map['fee'] ?? fee ?? "",
      paymentIntent: map['paymentIntent'] ?? paymentIntent ?? Map<String, dynamic>(),
      state: map['state'] ?? state ?? 0,
      transactioinErrorString: map['transactioinErrorString'] ?? transactioinErrorString ?? "",
      ts: map['ts'] ?? ts ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id ?? "",
      "ReferenceNum": jubaReferenceNum ?? "",
      "senderID": senderID ?? "",
      "recipientID": recipientID ?? "",
      "amount": amount ?? "",
      "fee": fee ?? "",
      "paymentIntent": paymentIntent ?? 0,
      "state": state ?? 0,
      "transactioinErrorString": transactioinErrorString ?? "",
      "ts": ts ?? 0,
    };
  }

  @override
  List<Object> get props => [
        id,
        jubaReferenceNum,
        senderID,
        recipientID,
        amount,
        fee,
        paymentIntent,
        state,
        transactioinErrorString,
        ts,
      ];

  @override
  bool get stringify => true;
}
