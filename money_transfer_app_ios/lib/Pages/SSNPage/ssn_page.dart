import 'package:flutter/material.dart';

import 'index.dart';

class SSNPage extends StatelessWidget {
  final Map<String, dynamic> documentType;

  SSNPage({
    @required this.documentType,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SSNPageStyles _ssnPageStyles = SSNPageMobileStyles(context);

    return SSNView(ssnPageStyles: _ssnPageStyles, documentType: documentType);
  }
}
