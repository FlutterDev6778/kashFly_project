import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => SettingsDataProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavbarProvider()),
      ],
      child: MaterialApp(
        theme: buildThemeData(context),
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
