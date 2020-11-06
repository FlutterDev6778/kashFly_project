import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class PersonalInfoPage extends StatelessWidget {
  PersonalInfoPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PersonalInfoPageStyles _personalInfoPageStyles = PersonalInfoPageMobileStyles(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransferProvider()),
        ChangeNotifierProvider(create: (_) => RecipientProvider()),
      ],
      child: PersonalInfoView(personalInfoPageStyles: _personalInfoPageStyles),
    );
  }
}
