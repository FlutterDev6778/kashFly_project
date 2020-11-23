import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class PersonalDetailPage extends StatelessWidget {
  PersonalDetailPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PersonalDetailPageStyles _personalDetailPageStyles = PersonalDetailPageMobileStyles(context);

    return PersonalDetailView(personalDetailPageStyles: _personalDetailPageStyles);
  }
}
