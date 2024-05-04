import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationSender{
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> showNotification() async {
    if(kIsWeb || defaultTargetPlatform == TargetPlatform.android){

    }
  }
}