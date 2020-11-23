import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import './index.dart';

class SplashPage extends StatelessWidget {
  SplashPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SplashPageStyles _splashPageStyles = SplashPageMobileStyles(context);

    return SplashView(splashPageStyles: _splashPageStyles);
  }
}
