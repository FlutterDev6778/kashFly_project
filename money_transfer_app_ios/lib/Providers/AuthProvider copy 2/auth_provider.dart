// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:keicy_stripe_payment/keicy_stripe_payment.dart';
// import 'package:provider/provider.dart';

// import 'package:keicy_firebase_auth_0_18/keicy_firebase_auth_0_18.dart';
// import 'package:keicy_fcm_for_mobile_7_0/keicy_fcm_for_mobile_7_0.dart';
// import 'package:keicy_storage_for_mobile_4_0/keicy_storage_for_mobile_4_0.dart';
// import 'package:keicy_utils/local_storage.dart';

// import 'package:money_transfer_framework/money_transfer_framework.dart';

// import 'index.dart';

// class AuthProvider extends ChangeNotifier {
//   static AuthProvider of(BuildContext context, {bool listen = false}) => Provider.of<AuthProvider>(context, listen: listen);

//   AuthState _authState = AuthState.init();
//   AuthState get authState => _authState;

//   void setAuthState(AuthState authState, {bool isNotifiable = true}) {
//     if (_authState != authState) {
//       _authState = authState;
//       if (isNotifiable) notifyListeners();
//     }
//   }

//   Future<void> init(User user) async {
//     await LocalStorage.instance.init();
//     await KeicyFCMForMobile.instance.getToken();
//     KeicyStripePayment.init(
//       publicKey: Config.stripePublicKey,
//       secretKey: Config.stripeSecretKey,
//     );

//     if (user == null) {
//       _authState = _authState.update(
//         firebaseUser: user,
//         userModel: UserModel(),
//         authStatement: AuthStatement.IsNotLogin,
//       );
//     } else {
//       try {
//         await user.reload();
//         var result = await UserRepository.getUserByUID(user.uid);

//         if (result["success"]) {
//           _authState = _authState.update(
//             firebaseUser: user,
//             userModel: UserModel.fromJson(result["data"][0]),
//             authStatement: AuthStatement.IsNotLogin,
//           );
//         } else {
//           _authState = _authState.update(
//             firebaseUser: user,
//             userModel: UserModel(),
//             authStatement: AuthStatement.IsNotLogin,
//           );
//         }
//       } catch (e) {
//         _authState = _authState.update(
//           firebaseUser: user,
//           userModel: UserModel(),
//           authStatement: AuthStatement.IsNotLogin,
//         );
//       }
//     }

//     notifyListeners();
//   }

//   void _setAuthResult(Map<String, dynamic> userData, User firebaseUser) {
//     if (!userData["success"]) {
//       _authState = _authState.update(
//         progressState: -1,
//         authStatement: AuthStatement.IsNotLogin,
//         errorString: userData["errorString"],
//         userModel: UserModel(),
//         firebaseUser: firebaseUser,
//       );
//     } else {
//       _authState = _authState.update(
//         progressState: 2,
//         authStatement: AuthStatement.IsLogin,
//         errorString: "",
//         userModel: UserModel.fromJson(userData["data"][0]),
//         firebaseUser: firebaseUser,
//       );
//     }

//     notifyListeners();
//   }

//   Future<Map<String, dynamic>> updateUserData(
//     User user,
//     Map<String, dynamic> userData, {
//     String firstName,
//     String lastName,
//     String middleName,
//     String email,
//     String phoneNumber,
//     String pinCode,
//   }) async {
//     if (userData["data"].length == 0) {
//       String firstName1 = "";
//       String middleName1 = "";
//       String lastName1 = "";

//       if (user.displayName != "" && user.displayName != null) {
//         List<String> userNameList = user.displayName.split(' ');
//         firstName1 = (userNameList.length >= 1) ? userNameList.first : "";
//         lastName1 = (userNameList.length > 1) ? userNameList.last : "";
//         middleName1 = (userNameList.length > 3) ? userNameList[1] : "";
//       }

//       UserModel _userModel = UserModel();
//       _userModel.uid = user.uid;
//       _userModel.firstName = firstName ?? firstName1;
//       _userModel.middleName = middleName ?? middleName1;
//       _userModel.lastName = lastName ?? lastName1;
//       _userModel.email = email ?? user.email ?? "";
//       _userModel.phoneNumber = phoneNumber ?? user.phoneNumber ?? "";
//       _userModel.avatarUrl = user.photoURL ?? "";
//       _userModel.pinCode = pinCode ?? "";
//       _userModel.tokenIDList = _getFCMToken();
//       _userModel.ts = DateTime.now().millisecondsSinceEpoch;
//       _userModel.createdDateTs = DateTime.now().millisecondsSinceEpoch;

//       return await UserRepository.addUser(_userModel);
//     }

//     /// if the user already exist, get the User document
//     else {
//       List<dynamic> tokenIDList = userData["data"][0]["tokenIDList"] ?? [];
//       String fcmToken = KeicyFCMForMobile.instance.token;

//       bool isNewToken = true;
//       for (var i = 0; i < tokenIDList.length; i++) {
//         if (fcmToken == tokenIDList[i]["token"]) {
//           isNewToken = false;
//           break;
//         }
//       }

//       if (isNewToken) {
//         userData["data"][0]["tokenIDList"] = _getFCMToken(tokenIDList: userData["data"][0]["tokenIDList"]);
//       }

//       bool isNewPinCode = false;
//       if (userData["data"][0]["pinCode"] != pinCode) {
//         userData["data"][0]["pinCode"] = pinCode;
//         isNewPinCode = false;
//       }

//       bool initCashLimit = false;
//       if (userData["data"][0]["cashLimit"]["day"] != DateTime.now().day) {
//         userData["data"][0]["cashLimit"]["day"] = DateTime.now().day;
//         userData["data"][0]["cashLimit"]["dailyCount"] = 0;
//         initCashLimit = true;
//       }

//       if (userData["data"][0]["cashLimit"]["month"] != DateTime.now().month) {
//         userData["data"][0]["cashLimit"]["day"] = DateTime.now().day;
//         userData["data"][0]["cashLimit"]["dailyCount"] = 0;
//         userData["data"][0]["cashLimit"]["month"] = DateTime.now().month;
//         userData["data"][0]["cashLimit"]["monthlyCount"] = 0;
//         initCashLimit = true;
//       }

//       if (isNewToken || isNewPinCode || initCashLimit) {
//         var result = await UserRepository.updateUser(userData["data"][0]["id"], userData["data"][0]);
//         if (result["success"]) {
//           result["data"] = [result["data"]];
//         }
//         return result;
//       } else {
//         return userData;
//       }
//     }
//   }

//   List<dynamic> _getFCMToken({List<dynamic> tokenIDList}) {
//     tokenIDList = tokenIDList ?? [];
//     tokenIDList.add({
//       "createdAt": DateTime.now().millisecondsSinceEpoch,
//       "token": KeicyFCMForMobile.instance.token,
//     });

//     return tokenIDList;
//   }

//   Future<void> loginWithPinCode(String pinCode, {bool isNewPinCode = false}) async {
//     if (_authState.firebaseUser != null) {
//       try {
//         await _authState.firebaseUser.reload();
//         var result = await UserRepository.getUserByUID(_authState.firebaseUser.uid);
//         if (result["success"]) {
//           if (isNewPinCode) {
//             var userData = await updateUserData(_authState.firebaseUser, result, pinCode: pinCode);
//             _setAuthResult(userData, _authState.firebaseUser);
//             return;
//           } else {
//             if (result["data"][0]["pinCode"] == pinCode) {
//               var userData = await updateUserData(_authState.firebaseUser, result, pinCode: pinCode);
//               _setAuthResult(userData, _authState.firebaseUser);
//               return;
//             } else {
//               _authState = _authState.update(
//                 progressState: -1,
//                 errorString: "Pin Number Not Match. Please try again.",
//               );
//             }
//           }
//         } else {
//           _authState = _authState.update(
//             progressState: -1,
//             errorString: "Login Error. Please try again.",
//           );
//         }
//       } catch (e) {
//         _authState = _authState.update(
//           progressState: -1,
//           errorString: "Login Error. Please try again.",
//         );
//       }
//     } else {
//       _authState = _authState.update(
//         progressState: -1,
//         errorString: "You didn't register on this phone. Please register.",
//       );
//     }
//     notifyListeners();
//   }

//   Future<void> phoneVerification(String phoneNumber, {int forceResendingToken}) async {
//     await KeicyAuthentication.instance.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: verificationCompleted,
//       verificationFailed: verificationFailed,
//       codeSent: codeSent,
//       codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//       // forceResendingToken: forceResendingToken,
//     );
//   }

//   Future<void> confirmPhoneVerification({
//     @required String smsCode,
//     String firstName,
//     String middleName,
//     String lastName,
//     String email,
//     String phoneNumber,
//   }) async {
//     try {
//       var authResult = await KeicyAuthentication.instance.confirmPhoneVerification(
//         smsCode: smsCode,
//         verificationId: _authState.verificationId,
//       );

//       if (!authResult["success"]) {
//         _authState = _authState.update(
//           progressState: -1,
//           authStatement: AuthStatement.IsNotLogin,
//           errorString: authResult["errorCode"],
//           userModel: UserModel(),
//           firebaseUser: null,
//         );
//         notifyListeners();
//         return;
//       }

//       var result = await UserRepository.getUserByUID(authResult["data"].user.uid);

//       if (!result["success"]) {
//         _authState = _authState.update(
//           progressState: -1,
//           authStatement: AuthStatement.IsNotLogin,
//           errorString: result["errorString"],
//           userModel: UserModel(),
//           firebaseUser: null,
//         );
//         notifyListeners();
//         return;
//       } else {
//         if (firstName != "" && result["data"].length != 0) {
//           _authState = _authState.update(
//             progressState: -1,
//             authStatement: AuthStatement.IsNotLogin,
//             errorString: "This phone number already registerd.",
//             userModel: UserModel(),
//             firebaseUser: null,
//           );
//           notifyListeners();
//           return;
//         }
//         if (firstName == "" && result["data"].length == 0) {
//           _authState = _authState.update(
//             progressState: -1,
//             authStatement: AuthStatement.IsNotLogin,
//             errorString: "This phone number didn't register.",
//             userModel: UserModel(),
//             firebaseUser: null,
//           );
//           notifyListeners();
//           return;
//         }
//       }

//       var userData = await updateUserData(
//         authResult["data"].user,
//         result,
//         firstName: firstName,
//         middleName: middleName,
//         lastName: lastName,
//         email: email,
//         phoneNumber: phoneNumber,
//         pinCode: "",
//       );

//       if (!userData["success"]) {
//         _authState = _authState.update(
//           progressState: -1,
//           authStatement: AuthStatement.IsNotLogin,
//           errorString: userData["errorString"],
//           userModel: UserModel(),
//           firebaseUser: authResult["data"].user,
//         );
//       } else {
//         _authState = _authState.update(
//           progressState: 2,
//           authStatement: AuthStatement.IsNotLogin,
//           errorString: "",
//           userModel: UserModel.fromJson(userData["data"][0]),
//           firebaseUser: authResult["data"].user,
//         );
//       }
//       notifyListeners();

//       // _setAuthResult(userData, authResult["data"].user);
//       return;
//     } on PlatformException catch (e) {
//       _authState = _authState.update(
//         progressState: -1,
//         authStatement: AuthStatement.IsNotLogin,
//         errorString: e.message,
//         userModel: UserModel(),
//         firebaseUser: null,
//       );
//       notifyListeners();
//       return;
//     } catch (e) {
//       _authState = _authState.update(
//         progressState: -1,
//         authStatement: AuthStatement.IsNotLogin,
//         errorString: "Confirm PhoneVerification Failed",
//         userModel: UserModel(),
//         firebaseUser: null,
//       );
//       notifyListeners();
//       return;
//     }
//   }

//   dynamic verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
//     if (_authState.verificationId == null) {
//       var authResult = await KeicyAuthentication.instance.signInWithPhoneAuthCredential(phoneAuthCredential: phoneAuthCredential);

//       // if (!authResult["success"]) {
//       //   _authState = _authState.update(
//       //     progressState: -1,
//       //     authStatement: AuthStatement.IsNotLogin,
//       //     errorString: authResult["errorString"],
//       //     userModel: UserModel(),
//       //   );
//       //   notifyListeners();
//       //   return;
//       // }

//     }
//   }

//   dynamic verificationFailed(FirebaseAuthException firebaseAuthException) {
//     print(firebaseAuthException.message);
//     _authState = _authState.update(
//       progressState: -1,
//       errorString: firebaseAuthException.code,
//     );
//     notifyListeners();
//   }

//   dynamic codeSent(String verificationId, int forceResendingToken) {
//     _authState = _authState.update(
//       verificationId: verificationId,
//       forceResendingToken: forceResendingToken,
//     );
//     notifyListeners();
//   }

//   dynamic codeAutoRetrievalTimeout(String verificationId) {
//     // _authState = _authState.update(
//     //   progressState: -1,
//     //   verificationId: verificationId,
//     //   errorString: "Timeout",
//     // );
//     // notifyListeners();
//   }

//   Future<void> logout() async {
//     try {
//       // await KeicyAuthentication.instance.signOut();

//       _authState = _authState.update(
//         progressState: 2,
//         authStatement: AuthStatement.IsNotLogin,
//         errorString: "",
//         userModel: UserModel(),
//       );
//     } catch (e) {
//       _authState = _authState.update(
//         progressState: -1,
//         errorString: "Logout Failed",
//       );
//       print(e);
//     }
//     notifyListeners();
//   }

//   Future<void> saveUserData({@required String userID, @required Map<String, dynamic> data, bool isNotifiable = true}) async {
//     try {
//       // if (image != null) {
//       //   try {
//       //     String url = await KeicyStorageForMobile.instance.uploadFileObject(
//       //       path: "/Images/",
//       //       fileName: "${userModel.id}.jpg",
//       //       file: image,
//       //     );
//       //     if (userModel.avatarUrl != "") {
//       //       await KeicyStorageForMobile.instance.deleteFile(path: userModel.avatarUrl);
//       //     }
//       //     userModel.avatarUrl = url;
//       //   } catch (e) {}
//       // }

//       var result = await UserRepository.updateUser(userID, data);

//       if (result["success"]) {
//         _authState = _authState.update(
//           progressState: 2,
//           errorString: "",
//           userModel: _authState.userModel.update(result["data"]),
//         );
//       } else {
//         _authState = _authState.update(
//           progressState: -1,
//           errorString: "Save Profile Error",
//         );
//       }
//     } catch (e) {
//       _authState = _authState.update(
//         progressState: -1,
//         errorString: "Save Profile Error",
//       );
//     }
//     notifyListeners();
//   }

//   Future<void> saveDocument({
//     @required UserModel userModel,
//     @required String documentType,
//     @required File imageFile,
//     @required String imagePath,
//     bool isNotifiable = true,
//   }) async {
//     try {
//       String url = "";
//       if (imageFile != null) {
//         url = await KeicyStorageForMobile.instance.uploadFileObject(
//           path: "/Documents/${userModel.id}/",
//           fileName: "$documentType.jpg",
//           file: imageFile,
//         );
//       }

//       if (imagePath != "") {
//         await KeicyStorageForMobile.instance.deleteFile(path: imagePath);
//       }
//       userModel.documents[documentType] = url;

//       var result = await UserRepository.updateUser(userModel.id, userModel.toJson());

//       if (result["success"]) {
//         _authState = _authState.update(
//           progressState: 2,
//           errorString: "",
//           userModel: _authState.userModel.update(result["data"]),
//         );
//       } else {
//         _authState = _authState.update(
//           progressState: -1,
//           errorString: "Save Profile Error",
//         );
//       }
//     } catch (e) {
//       _authState = _authState.update(
//         progressState: -1,
//         errorString: "Save Profile Error",
//       );
//     }
//     notifyListeners();
//   }
// }
