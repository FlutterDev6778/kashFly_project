import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:keicy_firebase_auth_0_18/keicy_firebase_auth_0_18.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class SplashView extends StatefulWidget {
  const SplashView({
    Key key,
    this.splashPageStyles,
  }) : super(key: key);

  final SplashPageStyles splashPageStyles;

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = AuthProvider.of(context);

    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Firebase Init Error"),
              ),
            );
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder<User>(
              stream: KeicyAuthentication.instance.firebaseAuth.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  ///
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  ///
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  _authProvider.init(snapshot.data).then((userModel) async {
                    UserProvider.of(context).setUserState(
                      UserProvider.of(context).userState.update(userModel: userModel),
                    );
                    Navigator.of(context).pushReplacementNamed(AppRoutes.BottomNavbar);
                  });
                }
                return Scaffold(
                  body: Container(
                    height: widget.splashPageStyles.mainHeight,
                  ),
                );
              },
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Scaffold(
            body: Center(child: CupertinoActivityIndicator()),
          );
        });
  }
}
