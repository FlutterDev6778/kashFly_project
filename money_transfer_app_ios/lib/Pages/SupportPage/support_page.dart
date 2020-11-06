import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class SupportPage extends StatelessWidget {
  SupportPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SupportPageStyles _supportPageStyles = SupportPageMobileStyles(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransferProvider()),
        ChangeNotifierProvider(create: (_) => RecipientProvider()),
      ],
      child: SupportView(supportPageStyles: _supportPageStyles),
    );
  }
}
