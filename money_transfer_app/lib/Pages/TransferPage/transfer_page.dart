import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class TransferPage extends StatelessWidget {
  final double amount;
  TransferPage({
    Key key,
    this.amount = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransferPageStyles _transferPageStyles = TransferPageMobileStyles(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransferProvider()),
        ChangeNotifierProvider(create: (_) => RecipientProvider()),
      ],
      child: TransferView(
        transferPageStyles: _transferPageStyles,
        amount: amount,
      ),
    );
  }
}
