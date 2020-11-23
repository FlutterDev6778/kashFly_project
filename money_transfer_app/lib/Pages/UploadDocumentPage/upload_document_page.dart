import 'package:flutter/material.dart';

import 'index.dart';

class UploadDocumentPage extends StatelessWidget {
  final Map<String, dynamic> documentType;

  UploadDocumentPage({
    @required this.documentType,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UploadDocumentPageStyles _uploadDocumentPageStyles = UploadDocumentPageMobileStyles(context);

    return UploadDocumentView(uploadDocumentPageStyles: _uploadDocumentPageStyles, documentType: documentType);
  }
}
