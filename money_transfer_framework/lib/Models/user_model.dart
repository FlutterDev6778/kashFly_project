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
  int gender;
  int dobTs;
  String avatarUrl;
  String address;
  String zipCode;
  String apt;
  String street;
  String city;
  String state;
  String country;
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
    this.gender = 0,
    this.dobTs = 0,
    this.avatarUrl = "",
    this.address = "",
    this.zipCode = "",
    this.apt = "",
    this.street = "",
    this.city = "",
    this.state = "",
    this.country = "",
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
      firstName: (map['personal'] != null && map['personal']['firstName'] != null) ? map['personal']['firstName'] : "",
      middleName: (map['personal'] != null && map['personal']['middleName'] != null) ? map['personal']['middleName'] : "",
      lastName: (map['personal'] != null && map['personal']['lastName'] != null) ? map['personal']['lastName'] : "",
      email: (map['personal'] != null && map['personal']['email'] != null) ? map['personal']['email'] : "",
      phoneNumber: (map['personal'] != null && map['personal']['phoneNumber'] != null) ? map['personal']['phoneNumber'] : "",
      gender: (map['personal'] != null && map['personal']['gender'] != null) ? map['personal']['gender'] : 0,
      dobTs: (map['personal'] != null && map['personal']['dobTs'] != null) ? map['personal']['dobTs'] : 0,
      avatarUrl: (map['personal'] != null && map['personal']['avatarUrl'] != null) ? map['personal']['avatarUrl'] : "",
      address: (map['address'] != null && map['address']['address'] != null) ? map['address']['address'] : "",
      zipCode: (map['address'] != null && map['address']['zipCode'] != null) ? map['address']['zipCode'] : "",
      apt: (map['address'] != null && map['address']['apt'] != null) ? map['address']['apt'] : "",
      street: (map['address'] != null && map['address']['street'] != null) ? map['address']['street'] : "",
      city: (map['address'] != null && map['address']['city'] != null) ? map['address']['city'] : "",
      state: (map['address'] != null && map['address']['state'] != null) ? map['address']['state'] : "",
      country: (map['address'] != null && map['address']['country'] != null) ? map['address']['country'] : "",
      tokenIDList: map['tokenIDList'] ?? [],
      paymentMethodList: map['paymentMethodList'] ?? [],
      seledtedPaymentMethod: map['seledtedPaymentMethod'] ?? "",
      pinCode: map['pinCode'] ?? "",
      emailPermission: (map['permissions'] != null && map['permissions']['emailPermission'] != null) ? map['permissions']['emailPermission'] : true,
      notificaitonPermission:
          (map['permissions'] != null && map['permissions']['notificaitonPermission'] != null) ? map['permissions']['notificaitonPermission'] : true,
      documents: map['documents'] ?? Map<String, dynamic>(),
      day: (map['cashLimit'] != null && map['cashLimit']['day'] != null) ? map['cashLimit']['day'] : 0,
      month: (map['cashLimit'] != null && map['cashLimit']['month'] != null) ? map['cashLimit']['month'] : 0,
      dailyCount: (map['cashLimit'] != null && map['cashLimit']['dailyCount'] != null) ? map['cashLimit']['dailyCount'] : 0,
      monthlyCount: (map['cashLimit'] != null && map['cashLimit']['monthlyCount'] != null) ? map['cashLimit']['monthlyCount'] : 0,
      totalAmount: map['totalAmount'] ?? 0.0,
      createdDateTs: map['createdDateTs'] ?? 0,
      ts: map['ts'] ?? 0,
    );
  }

  UserModel update(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? id ?? "",
      uid: map['uid'] ?? uid ?? "",
      firstName: (map['personal'] != null && map['personal']['firstName'] != null) ? map['personal']['firstName'] : firstName ?? "",
      middleName: (map['personal'] != null && map['personal']['middleName'] != null) ? map['personal']['middleName'] : middleName ?? "",
      lastName: (map['personal'] != null && map['personal']['lastName'] != null) ? map['personal']['lastName'] : lastName ?? "",
      email: (map['personal'] != null && map['personal']['email'] != null) ? map['personal']['email'] : email ?? "",
      phoneNumber: (map['personal'] != null && map['personal']['phoneNumber'] != null) ? map['personal']['phoneNumber'] : phoneNumber ?? "",
      gender: (map['personal'] != null && map['personal']['gender'] != null) ? map['personal']['gender'] : gender ?? 0,
      dobTs: (map['personal'] != null && map['personal']['dobTs'] != null) ? map['personal']['dobTs'] : dobTs ?? 0,
      avatarUrl: (map['personal'] != null && map['personal']['avatarUrl'] != null) ? map['personal']['avatarUrl'] : avatarUrl ?? "",
      address: (map['address'] != null && map['address']['address'] != null) ? map['address']['address'] : address ?? "",
      zipCode: (map['address'] != null && map['address']['zipCode'] != null) ? map['address']['zipCode'] : zipCode ?? "",
      apt: (map['address'] != null && map['address']['apt'] != null) ? map['address']['apt'] : apt ?? "",
      street: (map['address'] != null && map['address']['street'] != null) ? map['address']['street'] : street ?? "",
      city: (map['address'] != null && map['address']['city'] != null) ? map['address']['city'] : city ?? "",
      state: (map['address'] != null && map['address']['state'] != null) ? map['address']['state'] : state ?? "",
      country: (map['address'] != null && map['address']['country'] != null) ? map['address']['country'] : country ?? "",
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
      dailyCount: (map['cashLimit'] != null && map['cashLimit']['dailyCount'] != null) ? map['cashLimit']['dailyCount'] : dailyCount ?? 0,
      monthlyCount: (map['cashLimit'] != null && map['cashLimit']['monthlyCount'] != null) ? map['cashLimit']['monthlyCount'] : monthlyCount ?? 0,
      totalAmount: map['totalAmount'] ?? totalAmount ?? 0.0,
      createdDateTs: map['createdDateTs'] ?? createdDateTs ?? 0,
      ts: map['ts'] ?? ts ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id ?? "",
      "uid": uid ?? "",
      "personal": {
        "firstName": firstName ?? "",
        "middleName": middleName ?? "",
        "lastName": lastName ?? "",
        "email": email ?? "",
        "phoneNumber": phoneNumber ?? "",
        "gender": gender ?? 0,
        "dobTs": dobTs ?? 0,
        "avatarUrl": avatarUrl ?? "",
      },
      "address": {
        "address": address ?? "",
        "zipCode": zipCode ?? "",
        "apt": apt ?? "",
        "street": street ?? "",
        "city": city ?? "",
        "state": state ?? "",
        "country": country ?? "",
      },
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
        gender,
        dobTs,
        avatarUrl,
        address,
        zipCode,
        apt,
        street,
        city,
        state,
        country,
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
