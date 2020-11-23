import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class LoginPage extends StatelessWidget {
  final int selectedTap;

  LoginPage({
    Key key,
    @required this.selectedTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginPageStyles _loginPageStyles = LoginPageMobileStyles(context);

    return LoginView(loginPageStyles: _loginPageStyles, selectedTap: selectedTap);
  }
}
