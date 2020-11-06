// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
// import 'package:equatable/equatable.dart';
// import 'package:money_transfer_framework/money_transfer_framework.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// enum AuthStatement {
//   IsInitial,
//   IsLogin,
//   IsNotLogin,
// }

// class AuthState extends Equatable {
//   final int progressState; // 0: init, 1: progressing, 2: success, 3: failed
//   final String errorString;
//   final AuthStatement authStatement;
//   final UserModel userModel;
//   final User firebaseUser;
//   final String verificationId;
//   final int forceResendingToken;

//   AuthState({
//     @required this.errorString,
//     @required this.progressState,
//     @required this.authStatement,
//     @required this.userModel,
//     @required this.firebaseUser,
//     @required this.verificationId,
//     @required this.forceResendingToken,
//   });

//   factory AuthState.init() {
//     return AuthState(
//       progressState: 0,
//       authStatement: AuthStatement.IsInitial,
//       errorString: "",
//       userModel: UserModel(),
//       firebaseUser: null,
//       verificationId: "",
//       forceResendingToken: 0,
//     );
//   }

//   AuthState copyWith({
//     int progressState,
//     AuthStatement authStatement,
//     String errorString,
//     UserModel userModel,
//     User firebaseUser,
//     String verificationId,
//     int forceResendingToken,
//   }) {
//     return AuthState(
//       progressState: progressState ?? this.progressState,
//       authStatement: authStatement ?? this.authStatement,
//       errorString: errorString ?? this.errorString,
//       userModel: userModel ?? this.userModel,
//       firebaseUser: firebaseUser ?? this.firebaseUser,
//       verificationId: verificationId ?? this.verificationId,
//       forceResendingToken: forceResendingToken ?? this.forceResendingToken,
//     );
//   }

//   AuthState update({
//     int progressState,
//     AuthStatement authStatement,
//     String errorString,
//     UserModel userModel,
//     User firebaseUser,
//     String verificationId,
//     int forceResendingToken,
//   }) {
//     return copyWith(
//       progressState: progressState,
//       authStatement: authStatement,
//       errorString: errorString,
//       userModel: userModel,
//       firebaseUser: firebaseUser,
//       verificationId: verificationId,
//       forceResendingToken: forceResendingToken,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "progressState": progressState,
//       "authStatement": authStatement,
//       "errorString": errorString,
//       "userModel": userModel,
//       "firebaseUser": firebaseUser,
//       "verificationId": verificationId,
//       "forceResendingToken": forceResendingToken,
//     };
//   }

//   @override
//   List<Object> get props => [
//         progressState,
//         authStatement,
//         errorString,
//         userModel.toJson(),
//         firebaseUser?.uid,
//         verificationId,
//         forceResendingToken,
//       ];

//   @override
//   bool get stringify => true;
// }
