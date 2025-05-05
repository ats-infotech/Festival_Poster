import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService {
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static Future<void> initialize() async {
    await Firebase.initializeApp();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  }

  static Future<void> _backgroundHandler(RemoteMessage message) async {
    print('Handling background message: ${message.messageId}');
  }

  static void requestPermission() {
    FirebaseMessaging.instance.requestPermission();
  }

  static void configureForegroundMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        _showNotification(message.notification!);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked! ${message.messageId}');
    });
  }

  static Future<void> _showNotification(RemoteNotification notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '1',
      'push_notification',
      channelDescription: 'firebase_notification',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}

// import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;

// class FirebaseService {
//   static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//   static Future<void> initialize() async {
//     await Firebase.initializeApp();

//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
//   }

//   static Future<void> _backgroundHandler(RemoteMessage message) async {
//     print('Handling background message: ${message.messageId}');
//     if (message.notification != null && message.notification!.android != null) {
//       _showNotification(message.notification!);
//     }
//   }

//   static void requestPermission() {
//     FirebaseMessaging.instance.requestPermission();
//   }

//   static void configureForegroundMessaging() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Foreground message data: ${message.data}');
//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//         _showNotification(message.notification!);
//       }
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('Message clicked! ${message.messageId}');
//     });
//   }

//   static Future<void> _showNotification(RemoteNotification notification) async {
//     String? imageUrl = notification.android?.imageUrl;

//     // final bigPictureStyle = BigPictureStyleInformation(
//     //   DrawableResourceAndroidBitmap(
//     //       '@mipmap/ic_launcher'), // Default app icon or replace it
//     //   largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
//     //   contentTitle: notification.title,
//     //   summaryText: notification.body,
//     //   htmlFormatContentTitle: true,
//     //   htmlFormatSummaryText: true,
//     // );

//     final http.Response response = await http.get(Uri.parse(imageUrl!));
//     BigPictureStyleInformation bigPictureStyleInformation =
//         BigPictureStyleInformation(ByteArrayAndroidBitmap.fromBase64String(
//             base64Encode(response.bodyBytes)));

//     AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       '1',
//       'notification',
//       channelDescription: 'push_notification',
//       importance: Importance.high,
//       priority: Priority.high,
//       ticker: 'ticker',
//       styleInformation: bigPictureStyleInformation,
//     );

//     NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       notification.title,
//       notification.body,
//       platformChannelSpecifics,
//       payload: 'item x',
//     );
//   }
// }
