import 'package:flutter/material.dart';
import 'package:money_transfer_app/Providers/TransactionHistoryProvider/index.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class TransactionHistoryPage extends StatelessWidget {
  TransactionHistoryPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransactionHistoryPageStyles _transactionHistoryPageStyles = TransactionHistoryPageMobileStyles(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionHistoryProvider()),
        ChangeNotifierProvider(create: (_) => TransferProvider()),
      ],
      child: TransactionHistoryView(transactionHistoryPageStyles: _transactionHistoryPageStyles),
    );
  }
}
