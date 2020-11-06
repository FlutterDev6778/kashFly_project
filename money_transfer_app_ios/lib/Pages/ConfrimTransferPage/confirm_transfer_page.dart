import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class ConfirmTransferPage extends StatelessWidget {
  final TransferProvider transferProvider;
  ConfirmTransferPage({
    Key key,
    this.transferProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConfirmTransferPageStyles _confirmTransferPageStyles = ConfirmTransferPageMobileStyles(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransferProvider()),
        ChangeNotifierProvider(create: (_) => RecipientProvider()),
      ],
      child: ConfirmTransferView(confirmTransferPageStyles: _confirmTransferPageStyles, transferProvider: transferProvider),
    );
  }
}
