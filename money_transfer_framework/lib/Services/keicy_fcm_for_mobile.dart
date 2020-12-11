library keicy_fcm_for_mobile_7_0;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KeicyFCMForMobile {
  static final KeicyFCMForMobile _instance = KeicyFCMForMobile();
  static KeicyFCMForMobile get instance => _instance;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _serverToken;
  String token;

  StreamController<Map<String, dynamic>> _controller = StreamController<Map<String, dynamic>>.broadcast();
  StreamController<Map<String, dynamic>> get controller => _controller;
  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void close() {
    _controller?.close();
  }

  Future<void> init({@required String serverToken}) async {
    _serverToken = serverToken;
    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
      _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
    }
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _controller.add(message);
      },
      onBackgroundMessage: Platform.isIOS ? null : _myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) async {
        _controller.add(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        _controller.add(message);
      },
    );
  }

  static Future<dynamic> _myBackgroundMessageHandler(Map<String, dynamic> message) async {
    _instance._controller.add(message);
    if (message.containsKey('data')) {
      final dynamic data = message['data'];
    } else if (message.containsKey('notification')) {
      final dynamic notification = message['notification'];
    } else {}
  }

  Future<void> getToken() async {
    try {
      token = await _firebaseMessaging.getToken();
      return;
    } catch (e) {
      return;
    }
  }

  Future<Map<String, dynamic>> sendMessage(String body, String title, String partnerToken) async {
    http.Response response = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$_serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': body, 'title': title},
          'priority': 'high',
          'data': <String, dynamic>{'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'id': '1', 'status': 'done'},
          'to': partnerToken,
        },
      ),
    );
    return json.decode(response.body);
  }
}
