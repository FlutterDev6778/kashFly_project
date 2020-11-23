import 'package:flutter/material.dart';
import 'package:money_transfer_app/Providers/PincodeProvider/index.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:provider/provider.dart';

import 'index.dart';

class MyInfoPage extends StatelessWidget {
  // final String newPinCode;
  // final String firstName;
  // final String middleName;
  // final String lastName;
  // final String phoneNumber;
  final UserModel userModel;
  final bool isNewInfo;
  final bool haveNavbar;

  MyInfoPage({
    // this.newPinCode,
    // this.firstName,
    // this.middleName,
    // this.lastName,
    // this.phoneNumber,
    this.userModel,
    this.isNewInfo = true,
    this.haveNavbar = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyInfoPageStyles _myInfoPageStyles = MyInfoPageMobileStyles(context);

    return MyInfoView(
      myInfoPageStyles: _myInfoPageStyles,
      // newPinCode: newPinCode,
      // firstName: firstName,
      // middleName: middleName,
      // lastName: lastName,
      // phoneNumber: phoneNumber,
      userModel: userModel,
      isNewInfo: isNewInfo,
      haveNavbar: haveNavbar,
    );
  }
}
