import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../main.dart';

void setupNotifications() {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      // Handle the notification if the app was terminated
      print('Initial message: ${message.notification?.title}');
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      // Display the notification
      showNotification(message.notification!);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Message clicked!');
  });
}

void showNotification(RemoteNotification notification) {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'chat_notifications',
    'Chat Notifications',
    channelDescription: 'Notifications for new chat messages',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  flutterLocalNotificationsPlugin.show(
    0,
    notification.title,
    notification.body,
    notificationDetails,
  );
}
