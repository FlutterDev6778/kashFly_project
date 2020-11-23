import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RegisterPageStyles _registerPageStyles = RegisterPageMobileStyles(context);

    return RegisterView(registerPageStyles: _registerPageStyles);
  }
}
