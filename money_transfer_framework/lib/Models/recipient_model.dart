import 'package:equatable/equatable.dart';

class RecipientModel extends Equatable {
  String id;
  String uid;
  String senderID;
  String firstName;
  String middleName;
  String lastName;
  String phoneNumber;
  String avatarUrl;
  String country;
  String city;
  String customerReferenceNo;
  bool isBeneficiary;
  List<dynamic> tokenIDList;
  int createdDateTs;
  int ts;

  RecipientModel({
    this.id = "",
    this.uid = "",
    this.senderID = "",
    this.firstName = "",
    this.middleName = "",
    this.lastName = "",
    this.phoneNumber = "",
    this.avatarUrl = "",
    this.country = "",
    this.city = "",
    this.customerReferenceNo = "",
    this.isBeneficiary = true,
    this.tokenIDList = const [],
    this.createdDateTs = 0,
    this.ts = 0,
  });

  factory RecipientModel.fromJson(Map<String, dynamic> map) {
    return RecipientModel(
      id: map['id'] ?? "",
      uid: map['uid'] ?? "",
      senderID: map['senderID'] ?? "",
      firstName: (map["FirstName"] != null) ? map["FirstName"] : "",
      middleName: (map["MiddleName"] != null) ? map["MiddleName"] : "",
      lastName: (map["LastName"] != null) ? map["LastName"] : "",
      phoneNumber: (map["Mobile"] != null) ? map["Mobile"] : "",
      avatarUrl: (map['avatarUrl'] != null) ? map['avatarUrl'] : "",
      country: (map["State"] != null) ? map["State"] : "",
      city: (map["City"] != null) ? map["City"] : "",
      customerReferenceNo: (map["CustomerReferenceNo"] != null) ? map["CustomerReferenceNo"] : "",
      isBeneficiary: (map["IsBeneficiary"] != null) ? map["IsBeneficiary"] : true,
      tokenIDList: map['tokenIDList'] ?? [],
      createdDateTs: map['createdDateTs'] ?? 0,
      ts: map['ts'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id ?? "",
      "uid": uid ?? "",
      "senderID": senderID ?? "",
      "FirstName": firstName ?? "",
      "MiddleName": middleName ?? "",
      "LastName": lastName ?? "",
      "Mobile": phoneNumber ?? "",
      "avatarUrl": avatarUrl ?? "",
      "State": country ?? "",
      "City": city ?? "",
      "CustomerReferenceNo": customerReferenceNo ?? "",
      "IsBeneficiary": isBeneficiary ?? true,
      "tokenIDList": tokenIDList ?? [],
      "createdDateTs": createdDateTs ?? 0,
      "ts": ts ?? 0,
    };
  }

  RecipientModel update(Map<String, dynamic> map) {
    return RecipientModel(
      id: map['id'] ?? id ?? "",
      uid: map['uid'] ?? uid ?? "",
      senderID: map['senderID'] ?? senderID ?? "",
      firstName: (map["FirstName"] != null) ? map["FirstName"] : firstName ?? "",
      middleName: (map["MiddleName"] != null) ? map["MiddleName"] : middleName ?? "",
      lastName: (map["LastName"] != null) ? map["LastName"] : lastName ?? "",
      phoneNumber: (map["Mobile"] != null) ? map["Mobile"] : phoneNumber ?? "",
      avatarUrl: (map['avatarUrl'] != null) ? map['avatarUrl'] : avatarUrl ?? "",
      country: (map["State"] != null) ? map["State"] : country ?? "",
      city: (map["City"] != null) ? map["City"] : city ?? "",
      customerReferenceNo: (map["CustomerReferenceNo"] != null) ? map["CustomerReferenceNo"] : customerReferenceNo ?? "",
      isBeneficiary: (map["IsBeneficiary"] != null) ? map["IsBeneficiary"] : isBeneficiary ?? true,
      tokenIDList: map['tokenIDList'] ?? tokenIDList ?? [],
      createdDateTs: map['createdDateTs'] ?? createdDateTs ?? 0,
      ts: map['ts'] ?? ts ?? 0,
    );
  }

  @override
  List<Object> get props => [
        id,
        uid,
        senderID,
        firstName,
        middleName,
        lastName,
        phoneNumber,
        avatarUrl,
        country,
        city,
        customerReferenceNo,
        isBeneficiary,
        tokenIDList,
        createdDateTs,
        ts,
      ];

  @override
  bool get stringify => true;
}
