import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class CreditCardPage extends StatelessWidget {
  bool isSelectable;
  CreditCardPage({
    Key key,
    this.isSelectable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreditCardPageStyles _creditCardPageStyles = CreditCardPageMobileStyles(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PaymentMethodProvider()),
      ],
      child: CreditCardView(
        creditCardPageStyles: _creditCardPageStyles,
        isSelectable: isSelectable,
      ),
    );
  }
}
