import 'package:equatable/equatable.dart';

class JubaTransactionModel extends Equatable {
  String senderCode;
  String nominatedCode;
  String customerReferenceNo;
  String beneficiaryReferenceNo;
  int purpose;
  String payoutCurrency;
  double payoutAmount;
  int senderModeOfPayment;
  int receiverModeOfPayment;
  String remarks;
  String sendingCity;
  String partnerReferenceNum;
  String settlementCurrencyCode;
  String jubaCommisionInSettlement;
  String purposeDescription;
  double totalCommission;
  double totalCommissionInSettlmentCurrency;

  JubaTransactionModel({
    this.senderCode = "",
    this.nominatedCode = "",
    this.customerReferenceNo = "",
    this.beneficiaryReferenceNo = "",
    this.purpose = 0,
    this.payoutCurrency = "USD",
    this.payoutAmount = 0.0,
    this.senderModeOfPayment = 2,
    this.receiverModeOfPayment = 1,
    this.remarks = "Send Remittance from Partner",
    this.sendingCity = "",
    this.partnerReferenceNum = "",
    this.settlementCurrencyCode = "",
    this.jubaCommisionInSettlement = "",
    this.purposeDescription = "Purpose Description",
    this.totalCommission = 1.0,
    this.totalCommissionInSettlmentCurrency = 0.09,
  });

  factory JubaTransactionModel.fromJson(Map<String, dynamic> map) {
    return JubaTransactionModel(
      senderCode: map["SenderCode"] ?? "",
      nominatedCode: map["NominatedCode"] ?? "",
      customerReferenceNo: map["CustomerReferenceNo"] ?? "",
      beneficiaryReferenceNo: map["BeneficiaryReferenceNo"] ?? "",
      purpose: map["Purpose"] ?? 0,
      payoutCurrency: map["PayoutCurrency"] ?? "USD",
      payoutAmount: map['PayoutAmount'] ?? 0.0,
      senderModeOfPayment: map["SenderModeOfPayment"] ?? 2,
      receiverModeOfPayment: map["ReceiverModeOfPayment"] ?? 1,
      remarks: map["Remarks"] ?? "Send Remittance from Partner",
      sendingCity: map["SendingCity"] ?? "",
      partnerReferenceNum: map["PartnerReferenceNum"] ?? "",
      settlementCurrencyCode: map["SettlementCurrencyCode"] ?? "",
      jubaCommisionInSettlement: map["JubaCommisionInSettlement"] ?? "",
      purposeDescription: map["PurposeDescription"] ?? "Purpose Description",
      totalCommission: map["TotalCommission"] ?? 1.0,
      totalCommissionInSettlmentCurrency: map["TotalCommissionInSettlmentCurrency"] ?? 0.09,
    );
  }

  JubaTransactionModel update(Map<String, dynamic> map) {
    return JubaTransactionModel(
      senderCode: map["SenderCode"] ?? senderCode ?? "",
      nominatedCode: map["NominatedCode"] ?? nominatedCode ?? "",
      customerReferenceNo: map["CustomerReferenceNo"] ?? customerReferenceNo ?? "",
      beneficiaryReferenceNo: map["BeneficiaryReferenceNo"] ?? beneficiaryReferenceNo ?? "",
      purpose: map["Purpose"] ?? purpose ?? 0,
      payoutCurrency: map["PayoutCurrency"] ?? payoutCurrency ?? "USD",
      payoutAmount: map['PayoutAmount'] ?? payoutAmount ?? 0.0,
      senderModeOfPayment: map["SenderModeOfPayment"] ?? senderModeOfPayment ?? 2,
      receiverModeOfPayment: map["ReceiverModeOfPayment"] ?? receiverModeOfPayment ?? 1,
      remarks: map["Remarks"] ?? remarks ?? "Send Remittance from Partner",
      sendingCity: map["SendingCity"] ?? sendingCity ?? "",
      partnerReferenceNum: map["PartnerReferenceNum"] ?? partnerReferenceNum ?? "",
      settlementCurrencyCode: map["SettlementCurrencyCode"] ?? settlementCurrencyCode ?? "",
      jubaCommisionInSettlement: map["JubaCommisionInSettlement"] ?? jubaCommisionInSettlement ?? "",
      purposeDescription: map["PurposeDescription"] ?? purposeDescription ?? "Purpose Description",
      totalCommission: map["TotalCommission"] ?? totalCommission ?? 1.0,
      totalCommissionInSettlmentCurrency: map["TotalCommissionInSettlmentCurrency"] ?? totalCommissionInSettlmentCurrency ?? 0.09,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "SenderCode": senderCode ?? "",
      "NominatedCode": nominatedCode ?? "",
      "CustomerReferenceNo": customerReferenceNo ?? "",
      "BeneficiaryReferenceNo": beneficiaryReferenceNo ?? "",
      "Purpose": purpose ?? 0,
      "PayoutCurrency": payoutCurrency ?? "USD",
      "PayoutAmount": payoutAmount ?? 0,
      "SenderModeOfPayment": senderModeOfPayment ?? 2,
      "ReceiverModeOfPayment": receiverModeOfPayment ?? 1,
      "Remarks": remarks ?? "Send Remittance from Partner",
      "SendingCity": sendingCity ?? "",
      "PartnerReferenceNum": partnerReferenceNum ?? "",
      "SettlementCurrencyCode": settlementCurrencyCode ?? "",
      "JubaCommisionInSettlement": jubaCommisionInSettlement ?? "",
      "PurposeDescription": purposeDescription ?? "Purpose Description",
      "TotalCommission": totalCommission ?? 1.0,
      "TotalCommissionInSettlmentCurrency": totalCommissionInSettlmentCurrency ?? 0.09,
    };
  }

  @override
  List<Object> get props => [
        senderCode,
        nominatedCode,
        customerReferenceNo,
        beneficiaryReferenceNo,
        purpose,
        payoutCurrency,
        payoutAmount,
        senderModeOfPayment,
        receiverModeOfPayment,
        remarks,
        sendingCity,
        partnerReferenceNum,
        settlementCurrencyCode,
        jubaCommisionInSettlement,
        purposeDescription,
        totalCommission,
        totalCommissionInSettlmentCurrency,
      ];

  @override
  bool get stringify => true;
}
