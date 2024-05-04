import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logs/routes/auth_route.dart';
import 'package:logs/routes/home_route.dart';
import 'package:logs/routes/redirect_route.dart';
import 'package:logs/themes/theme.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken(
    vapidKey: 'BBwijUfziSNto3r8vGsjznc4Hhk-NhT-9_OYlDO1z8YPAMd4XNI4wH9erL9FlevSbZebYiqFs66xnkJAumlT7wE',
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  print("FCMToken $fcmToken");

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  runApp(const App());
}


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: '/redirect',
      routes: {
        '/redirect': (context) => const RedirectRoute(),
        '/auth': (context) => const AuthRoute(),
        '/home': (context) => const HomeRoute(),
      },
    );
  }
}
