import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  String id;
  String uid;
  String firstName;
  String middleName;
  String lastName;
  String email;
  String phoneNumber;
  // String telephone;
  int gender;
  int dobTs;
  String avatarUrl;
  String address;
  String zipCode;
  String apt;
  // String street;
  String city;
  String state;
  String country;
  // String nationality;
  // String placeofBirth;
  // String occupation;
  // String remarks;
  String customerReferenceNo;
  bool isBeneficiary;
  List<dynamic> tokenIDList;
  List<dynamic> paymentMethodList;
  String seledtedPaymentMethod;
  bool emailPermission;
  bool notificaitonPermission;
  String pinCode;
  Map<String, dynamic> documents;
  int day;
  int month;
  int dailyCount;
  int monthlyCount;
  double totalAmount;
  int createdDateTs;
  int ts;

  UserModel({
    this.id = "",
    this.uid = "",
    this.firstName = "",
    this.middleName = "",
    this.lastName = "",
    this.email = "",
    this.phoneNumber = "",
    // this.telephone = "",
    this.gender = 0,
    this.dobTs = 0,
    this.avatarUrl = "",
    this.address = "",
    this.zipCode = "",
    this.apt = "",
    // this.street = "",
    this.city = "",
    this.state = "",
    this.country = "",
    // this.nationality = "",
    // this.placeofBirth = "",
    // this.occupation = "",
    // this.remarks = "",
    this.customerReferenceNo = "",
    this.isBeneficiary = false,
    this.tokenIDList = const [],
    this.paymentMethodList = const [],
    this.seledtedPaymentMethod = "",
    this.pinCode = "",
    this.emailPermission = true,
    this.notificaitonPermission = true,
    this.documents,
    this.day,
    this.month,
    this.dailyCount = 0,
    this.monthlyCount = 0,
    this.totalAmount = 0.0,
    this.createdDateTs = 0,
    this.ts = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? "",
      uid: map['uid'] ?? "",
      firstName: (map["FirstName"] != null) ? map["FirstName"] : "",
      middleName: (map["MiddleName"] != null) ? map["MiddleName"] : "",
      lastName: (map["LastName"] != null) ? map["LastName"] : "",
      email: (map["Email"] != null) ? map["Email"] : "",
      phoneNumber: (map["Mobile"] != null) ? map["Mobile"] : "",
      // telephone: (map["Telephone"] != null) ? map["Telephone"] : "",
      gender: (map['gender'] != null) ? map['gender'] : 0,
      dobTs: (map["DateOfBirth"] != null) ? map["DateOfBirth"] : 0,
      avatarUrl: (map['avatarUrl'] != null) ? map['avatarUrl'] : "",
      address: (map["House"] != null) ? map["House"] : "",
      zipCode: (map["PostalCode"] != null) ? map["PostalCode"] : "",
      apt: (map['apt'] != null) ? map['apt'] : "",
      // street: (map["StreetNo"] != null) ? map["StreetNo"] : "",
      city: (map["City"] != null) ? map["City"] : "",
      state: (map["Province"] != null) ? map["Province"] : "",
      country: (map['State'] != null) ? map['State'] : "",
      // nationality: (map["Nationality"] != null) ? map["Nationality"] : "",
      // placeofBirth: (map["PlaceOfBirth"] != null) ? map["PlaceOfBirth"] : "",
      // occupation: (map["Occupation"] != null) ? map["Occupation"] : "",
      // remarks: (map["Remarks"] != null) ? map["Remarks"] : "",
      customerReferenceNo: (map["CustomerReferenceNo"] != null) ? map["CustomerReferenceNo"] : "",
      isBeneficiary: (map["IsBeneficiary"] != null) ? map["IsBeneficiary"] : false,
      tokenIDList: map['tokenIDList'] ?? [],
      paymentMethodList: map['paymentMethodList'] ?? [],
      seledtedPaymentMethod: map['seledtedPaymentMethod'] ?? "",
      pinCode: map['pinCode'] ?? "",
      emailPermission: (map['permissions'] != null && map['permissions']['emailPermission'] != null)
          ? map['permissions']['emailPermission']
          : true,
      notificaitonPermission: (map['permissions'] != null && map['permissions']['notificaitonPermission'] != null)
          ? map['permissions']['notificaitonPermission']
          : true,
      documents: map['documents'] ?? Map<String, dynamic>(),
      day: (map['cashLimit'] != null && map['cashLimit']['day'] != null) ? map['cashLimit']['day'] : 0,
      month: (map['cashLimit'] != null && map['cashLimit']['month'] != null) ? map['cashLimit']['month'] : 0,
      dailyCount:
          (map['cashLimit'] != null && map['cashLimit']['dailyCount'] != null) ? map['cashLimit']['dailyCount'] : 0,
      monthlyCount:
          (map['cashLimit'] != null && map['cashLimit']['monthlyCount'] != null) ? map['cashLimit']['monthlyCount'] : 0,
      totalAmount: double.parse(map['totalAmount'].toString()) ?? 0.0,
      createdDateTs: map['createdDateTs'] ?? 0,
      ts: map['ts'] ?? 0,
    );
  }

  UserModel update(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? id ?? "",
      uid: map['uid'] ?? uid ?? "",
      firstName: (map["FirstName"] != null) ? map["FirstName"] : firstName ?? "",
      middleName: (map["MiddleName"] != null) ? map["MiddleName"] : middleName ?? "",
      lastName: (map["LastName"] != null) ? map["LastName"] : lastName ?? "",
      email: (map["Email"] != null) ? map["Email"] : email ?? "",
      phoneNumber: (map["Mobile"] != null) ? map["Mobile"] : phoneNumber ?? "",
      // telephone: (map["Telephone"] != null) ? map["Telephone"] : telephone ?? "",
      gender: (map['gender'] != null) ? map['gender'] : gender ?? 0,
      dobTs: (map["DateOfBirth"] != null) ? map["DateOfBirth"] : dobTs ?? 0,
      avatarUrl: (map['avatarUrl'] != null) ? map['avatarUrl'] : avatarUrl ?? "",
      address: (map['House'] != null) ? map['House'] : address ?? "",
      zipCode: (map["PostalCode"] != null) ? map["PostalCode"] : zipCode ?? "",
      apt: (map['apt'] != null) ? map['apt'] : apt ?? "",
      // street: (map["StreetNo"] != null) ? map["StreetNo"] : street ?? "",
      city: (map["City"] != null) ? map["City"] : city ?? "",
      state: (map["Province"] != null) ? map["Province"] : state ?? "",
      country: (map['State'] != null) ? map['State'] : country ?? "",
      // nationality: (map["Nationality"] != null) ? map["Nationality"] : nationality ?? "",
      // placeofBirth: (map["PlaceOfBirth"] != null) ? map["PlaceOfBirth"] : placeofBirth ?? "",
      // occupation: (map["Occupation"] != null) ? map["Occupation"] : occupation ?? "",
      // remarks: (map["Remarks"] != null) ? map["Remarks"] : remarks ?? "",
      customerReferenceNo:
          (map["CustomerReferenceNo"] != null) ? map["CustomerReferenceNo"] : customerReferenceNo ?? "",
      isBeneficiary: (map["IsBeneficiary"] != null) ? map["IsBeneficiary"] : isBeneficiary ?? false,
      tokenIDList: map['tokenIDList'] ?? tokenIDList ?? [],
      paymentMethodList: map['paymentMethodList'] ?? paymentMethodList ?? [],
      seledtedPaymentMethod: map['seledtedPaymentMethod'] ?? seledtedPaymentMethod ?? "",
      pinCode: map['pinCode'] ?? pinCode ?? "",
      emailPermission: (map['permissions'] != null && map['permissions']['emailPermission'] != null)
          ? map['permissions']['emailPermission']
          : emailPermission ?? true,
      notificaitonPermission: (map['permissions'] != null && map['permissions']['notificaitonPermission'] != null)
          ? map['permissions']['notificaitonPermission']
          : notificaitonPermission ?? true,
      documents: map['documents'] ?? documents ?? Map<String, dynamic>(),
      day: (map['cashLimit'] != null && map['cashLimit']['day'] != null) ? map['cashLimit']['day'] : day ?? 0,
      month: (map['cashLimit'] != null && map['cashLimit']['month'] != null) ? map['cashLimit']['month'] : month ?? 0,
      dailyCount: (map['cashLimit'] != null && map['cashLimit']['dailyCount'] != null)
          ? map['cashLimit']['dailyCount']
          : dailyCount ?? 0,
      monthlyCount: (map['cashLimit'] != null && map['cashLimit']['monthlyCount'] != null)
          ? map['cashLimit']['monthlyCount']
          : monthlyCount ?? 0,
      totalAmount: map['totalAmount'] ?? totalAmount ?? 0.0,
      createdDateTs: map['createdDateTs'] ?? createdDateTs ?? 0,
      ts: map['ts'] ?? ts ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id ?? "",
      "uid": uid ?? "",
      "FirstName": firstName ?? "",
      "MiddleName": middleName ?? "",
      "LastName": lastName ?? "",
      "Email": email ?? "",
      "Mobile": phoneNumber ?? "",
      // "Telephone": telephone ?? "",
      "gender": gender ?? 0,
      "DateOfBirth": dobTs ?? 0,
      "avatarUrl": avatarUrl ?? "",
      "House": address ?? "",
      "PostalCode": zipCode ?? "",
      "apt": apt ?? "",
      // "StreetNo": street ?? "",
      "City": city ?? "",
      "Province": state ?? "",
      "State": country ?? "",
      // "Nationality": nationality ?? "",
      // "PlaceOfBirth": placeofBirth ?? "",
      // "Occupation": occupation ?? "",
      // "Remarks": remarks ?? "",
      "CustomerReferenceNo": customerReferenceNo ?? "",
      "IsBeneficiary": isBeneficiary ?? false,
      "tokenIDList": tokenIDList ?? [],
      "paymentMethodList": paymentMethodList ?? [],
      "seledtedPaymentMethod": seledtedPaymentMethod ?? "",
      "pinCode": pinCode ?? "",
      "permissions": {
        "emailPermission": emailPermission ?? true,
        "notificaitonPermission": notificaitonPermission ?? true,
      },
      "documents": documents ?? Map<String, dynamic>(),
      "cashLimit": {
        "day": day ?? 0,
        "month": month ?? 0,
        "dailyCount": dailyCount ?? 0,
        "monthlyCount": monthlyCount ?? 0,
      },
      "totalAmount": totalAmount ?? 0.0,
      "createdDateTs": createdDateTs ?? 0,
      "ts": ts ?? 0,
    };
  }

  @override
  List<Object> get props => [
        id,
        uid,
        firstName,
        middleName,
        lastName,
        email,
        phoneNumber,
        // telephone,
        gender,
        dobTs,
        avatarUrl,
        address,
        zipCode,
        apt,
        // street,
        city,
        state,
        country,
        // nationality,
        // placeofBirth,
        // occupation,
        // remarks,
        customerReferenceNo,
        isBeneficiary,
        tokenIDList,
        paymentMethodList,
        seledtedPaymentMethod,
        pinCode,
        emailPermission,
        notificaitonPermission,
        documents,
        day,
        month,
        dailyCount,
        monthlyCount,
        totalAmount,
        createdDateTs,
        ts,
      ];

  @override
  bool get stringify => true;
}
