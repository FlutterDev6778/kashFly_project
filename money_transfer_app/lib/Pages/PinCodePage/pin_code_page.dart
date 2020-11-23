import 'package:flutter/material.dart';
import 'package:money_transfer_app/Providers/PinCodeProvider/index.dart';
import 'package:provider/provider.dart';

import 'index.dart';

class PinCodePage extends StatelessWidget {
  final bool isNewPinCode;
  final String firstName;
  final String middleName;
  final String lastName;
  final String phoneNumber;

  PinCodePage({
    this.isNewPinCode = false,
    this.firstName,
    this.middleName,
    this.lastName,
    this.phoneNumber,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PinCodePageStyles _pinCodePageStyles = PinCodePageMobileStyles(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PinCodeProvider()),
      ],
      child: PinCodeView(
        pinCodePageStyles: _pinCodePageStyles,
        isNewPinCode: isNewPinCode,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      ),
    );
  }
}
