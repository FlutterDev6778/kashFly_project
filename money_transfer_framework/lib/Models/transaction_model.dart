import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  String id;
  String senderID;
  String recipientID;
  String amount;
  String fee;
  int status;
  Map<String, dynamic> stripePayment;
  Map<String, dynamic> jubaPayment;
  int ts;

  TransactionModel({
    this.id = "",
    this.senderID = "",
    this.recipientID = "",
    this.amount = "",
    this.fee = "",
    this.status = 0,
    this.stripePayment,
    this.jubaPayment,
    this.ts = 0,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? "",
      senderID: map['senderID'] ?? "",
      recipientID: map['recipientID'] ?? "",
      amount: map['amount'] ?? "",
      fee: map['fee'] ?? "",
      status: map['status'] ?? 0,
      stripePayment: map['stripePayment'] ?? Map<String, dynamic>(),
      jubaPayment: map['jubaPayment'] ?? Map<String, dynamic>(),
      ts: map['ts'] ?? 0,
    );
  }

  TransactionModel update(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? id ?? "",
      senderID: map['senderID'] ?? senderID ?? "",
      recipientID: map['recipientID'] ?? recipientID ?? "",
      amount: map['amount'] ?? amount ?? "",
      fee: map['fee'] ?? fee ?? "",
      status: map['status'] ?? status ?? 0,
      stripePayment: map['stripePayment'] ?? stripePayment ?? Map<String, dynamic>(),
      jubaPayment: map['jubaPayment'] ?? jubaPayment ?? Map<String, dynamic>(),
      ts: map['ts'] ?? ts ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id ?? "",
      "senderID": senderID ?? "",
      "recipientID": recipientID ?? "",
      "amount": amount ?? "",
      "fee": fee ?? "",
      "status": status ?? 0,
      "stripePayment": stripePayment ?? Map<String, dynamic>(),
      "jubaPayment": jubaPayment ?? Map<String, dynamic>(),
      "ts": ts ?? 0,
    };
  }

  @override
  List<Object> get props => [
        id,
        senderID,
        recipientID,
        amount,
        fee,
        status,
        stripePayment,
        jubaPayment,
        ts,
      ];

  @override
  bool get stringify => true;
}
