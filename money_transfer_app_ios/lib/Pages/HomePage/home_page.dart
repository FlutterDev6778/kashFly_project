import 'package:flutter/material.dart';
import 'package:money_transfer_app/Providers/TransactionHistoryProvider/index.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class HomePage extends StatelessWidget {
  final Function(int) onNavItemPressHandler;
  HomePage({Key key, this.onNavItemPressHandler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomePageStyles _homePageStyles = HomePageMobileStyles(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionHistoryProvider()),
        ChangeNotifierProvider(create: (_) => TransferProvider()),
        ChangeNotifierProvider(create: (_) => RecipientProvider()),
      ],
      child: HomeView(homePageStyles: _homePageStyles, onNavItemPressHandler: onNavItemPressHandler),
    );
  }
}
