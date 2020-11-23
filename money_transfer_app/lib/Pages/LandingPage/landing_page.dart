import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class LandingPage extends StatelessWidget {
  LandingPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LandingPageStyles _landingPageStyles = LandingPageMobileStyles(context);

    return LandingView(landingPageStyles: _landingPageStyles);
  }
}
