import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_notifications/services/local_notification_service.dart';

class PushNotificationServices {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future init() async {
    await messaging.requestPermission();
    await messaging.getToken().then((value) {
      sendTokenToServer(value!);
    });
    messaging.onTokenRefresh.listen(sendTokenToServer);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    handleForegroundMessage();
    messaging.subscribeToTopic("all").then((val) {
      log("Subscribed to all");
    });
    messaging.unsubscribeFromTopic("all").then((val) {
      log("Unsubscribed from all");
    });
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log('Handling a background message ${message.notification?.title}');
  }

  static void handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.showBasicNotification(
        message,
      );
    });
  }

  static void sendTokenToServer(String token) {
    messaging.getToken().then((token) {
      print('Token: $token');
    });
  }
}
