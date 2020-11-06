import 'package:flutter/material.dart';
import 'package:keicy_card_detect_provider/keicy_card_detect_provider.dart';
import 'package:money_transfer_app/Providers/index.dart';
import 'package:provider/provider.dart';

import 'index.dart';

class MyBankPage extends StatelessWidget {
  final bool isNewInfo;

  MyBankPage({
    Key key,
    this.isNewInfo= true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyBankPageStyles _myBankPageStyles = MyBankPageMobileStyles(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KeicyCardDetectProvider()),
        ChangeNotifierProvider(create: (_) => PaymentMethodProvider()),
      ],
      child: MyBankView(
        myBankPageStyles: _myBankPageStyles,
        isNewInfo: isNewInfo,
      ),
    );
  }
}
