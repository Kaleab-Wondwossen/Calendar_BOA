// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationServiceIOS {
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
//     FlutterLocalNotificationsPlugin();

//   static Future<void> initNotification() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');

//     // Use DarwinInitializationSettings instead of IOSInitializationSettings
//     final DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//             requestAlertPermission: true,
//             requestBadgePermission: true,
//             requestSoundPermission: true,
//             onDidReceiveLocalNotification: onDidReceiveLocalNotification);

//     final InitializationSettings initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid,
//         iOS: initializationSettingsIOS);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: selectNotification);
//   }

//   static Future<void> selectNotification(NotificationResponse notificationResponse) async {
//     // Handle notification tapped logic here
//   }

//   static Future<void> onDidReceiveLocalNotification(
//       int id, String? title, String? body, String? payload) async {
//     // Handle iOS notification received while app is in the foreground
//   }
// }
