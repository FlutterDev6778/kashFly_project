import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class AmountPage extends StatelessWidget {
  AmountPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AmountPageStyles _amountPageStyles = AmountPageMobileStyles(context);

    return AmountView(amountPageStyles: _amountPageStyles);
  }
}
