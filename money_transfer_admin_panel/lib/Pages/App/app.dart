import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';

import 'package:keicy_cookie_provider/keicy_cookie_provider.dart';
import 'package:keicy_navigator/keicy_navigator.dart';
import 'package:keicy_firebase_auth_0_18/keicy_firebase_auth_0_18.dart';

import 'package:money_transfer_framework/money_transfer_framework.dart';

import '../../Providers/index.dart';
import '../Error404Page/index.dart';
import '../LoginPage/index.dart';
import '../SplashPage/index.dart';
import '../DashboardPage/index.dart';
import '../ConfigurationPage/configuration_page.dart';

import 'index.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: KeicyAuthentication.instance.firebaseAuth.authStateChanges()),
        ChangeNotifierProvider(create: (_) => KeicyCookieProvider(minutes: Config.cookeTimeMinutes)),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SettingsDataProvider()),
      ],
      child: MaterialApp(
        theme: buildThemeData(context),
        initialRoute: AppRoutes.SplashPage,
        onUnknownRoute: (setting) => KeicyRoute(AppRoutes.Error404Page, Error404Page()),
        routes: {
          AppRoutes.RootPage: (context) => SplashPage(),
          AppRoutes.SplashPage: (context) => SplashPage(),
          AppRoutes.Error404Page: (context) => Error404Page(),
          AppRoutes.LoginPage: (context) => LoginPage(),
          AppRoutes.DashboardPage: (context) => DashboardPage(),
          AppRoutes.ConfigurationPage: (context) => ConfigurationPage(),
        },
        navigatorObservers: [
          KeicyNavigatorObserver(),
        ],
        // builder: (context, child) {
        //   final firebaseUser = context.watch<User>();
        //   AuthProvider.of(context).setAuthState(
        //     AuthProvider.of(context).authState.update(firebaseUser: firebaseUser),
        //     isNotifiable: false,
        //   );

        //   if (firebaseUser != null) {
        //     return child;
        //   } else {
        //     return LoginPage();
        //   }
        // },
      ),
    );
  }
}
