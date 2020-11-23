import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'Pages/App/app.dart';

void main() async {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }
  await Firebase.initializeApp();
  runApp(App());
}
