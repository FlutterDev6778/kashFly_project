import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class VerificationPage extends StatelessWidget {
  final String firstName;
  final String middleName;
  final String lastName;
  final String phoneNumber;

  VerificationPage({
    this.firstName = "",
    this.middleName = "",
    this.lastName = "",
    this.phoneNumber,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VerificationPageStyles _verificationPageStyles = VerificationPageMobileStyles(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PhoneVerificationProvider()),
      ],
      child: VerificationView(
        verificationPageStyles: _verificationPageStyles,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      ),
    );
  }
}
