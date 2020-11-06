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
    this.tokenIDList = const [],
    this.createdDateTs = 0,
    this.ts = 0,
  });

  factory RecipientModel.fromJson(Map<String, dynamic> map) {
    return RecipientModel(
      id: map['id'] ?? "",
      uid: map['uid'] ?? "",
      senderID: map['senderID'] ?? "",
      firstName: (map['personal'] != null && map['personal']['firstName'] != null) ? map['personal']['firstName'] : "",
      middleName: (map['personal'] != null && map['personal']['middleName'] != null) ? map['personal']['middleName'] : "",
      lastName: (map['personal'] != null && map['personal']['lastName'] != null) ? map['personal']['lastName'] : "",
      phoneNumber: (map['personal'] != null && map['personal']['phoneNumber'] != null) ? map['personal']['phoneNumber'] : "",
      avatarUrl: (map['personal'] != null && map['personal']['avatarUrl'] != null) ? map['personal']['avatarUrl'] : "",
      country: (map['personal'] != null && map['personal']['country'] != null) ? map['personal']['country'] : "",
      city: (map['personal'] != null && map['personal']['city'] != null) ? map['personal']['city'] : "",
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
      "personal": {
        "firstName": firstName ?? "",
        "middleName": middleName ?? "",
        "lastName": lastName ?? "",
        "phoneNumber": phoneNumber ?? "",
        "avatarUrl": avatarUrl ?? "",
        "country": country ?? "",
        "city": city ?? "",
      },
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
      firstName: (map['personal'] != null && map['personal']['firstName'] != null) ? map['personal']['firstName'] : firstName ?? "",
      middleName: (map['personal'] != null && map['personal']['middleName'] != null) ? map['personal']['middleName'] : middleName ?? "",
      lastName: (map['personal'] != null && map['personal']['lastName'] != null) ? map['personal']['lastName'] : lastName ?? "",
      phoneNumber: (map['personal'] != null && map['personal']['phoneNumber'] != null) ? map['personal']['phoneNumber'] : phoneNumber ?? "",
      avatarUrl: (map['personal'] != null && map['personal']['avatarUrl'] != null) ? map['personal']['avatarUrl'] : avatarUrl ?? "",
      country: (map['personal'] != null && map['personal']['country'] != null) ? map['personal']['country'] : country ?? "",
      city: (map['personal'] != null && map['personal']['city'] != null) ? map['personal']['city'] : city ?? "",
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
        tokenIDList,
        createdDateTs,
        ts,
      ];

  @override
  bool get stringify => true;
}
