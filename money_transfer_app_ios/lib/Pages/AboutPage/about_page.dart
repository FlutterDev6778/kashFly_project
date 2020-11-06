import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class AboutPage extends StatelessWidget {
  AboutPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AboutPageStyles _aboutPageStyles = AboutPageMobileStyles(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransferProvider()),
        ChangeNotifierProvider(create: (_) => RecipientProvider()),
      ],
      child: AboutView(aboutPageStyles: _aboutPageStyles),
    );
  }
}
