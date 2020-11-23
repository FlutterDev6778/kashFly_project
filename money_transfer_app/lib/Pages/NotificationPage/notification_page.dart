import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotificationPageStyles _notificationPageStyles = NotificationPageMobileStyles(context);

    return NotificationView(notificationPageStyles: _notificationPageStyles);
  }
}
