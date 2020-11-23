import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class ChangePinCodePage extends StatelessWidget {
  ChangePinCodePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChangePinCodePageStyles _changePinCodePageStyles = ChangePinCodePageMobileStyles(context);

    return ChangePinCodeView(changePinCodePageStyles: _changePinCodePageStyles);
  }
}
