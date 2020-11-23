import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class PaymentInfoPage extends StatelessWidget {
  PaymentInfoPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PaymentInfoPageStyles _paymentInfoPageStyles = PaymentInfoPageMobileStyles(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransferProvider()),
        ChangeNotifierProvider(create: (_) => RecipientProvider()),
      ],
      child: PaymentInfoView(paymentInfoPageStyles: _paymentInfoPageStyles),
    );
  }
}
