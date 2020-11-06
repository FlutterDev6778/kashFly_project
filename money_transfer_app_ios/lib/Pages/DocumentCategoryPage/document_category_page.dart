import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class DocumentCategoryPage extends StatelessWidget {
  DocumentCategoryPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DocumentCategoryPageStyles _documentCategoryPageStyles = DocumentCategoryPageMobileStyles(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransferProvider()),
        ChangeNotifierProvider(create: (_) => RecipientProvider()),
      ],
      child: DocumentCategoryView(documentCategoryPageStyles: _documentCategoryPageStyles),
    );
  }
}
