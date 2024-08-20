import 'package:calendar/firebase_options.dart';
// import 'package:calendar/pages/local_notification_ios.dart';
import 'package:calendar/services/FireStore/fire_store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

import 'pages/event_notifier.dart';
import 'pages/flutter_local_notifications.dart';
import 'services/auth/auth_services.dart';
import 'services/auth/home_gate.dart';

Map timezoneNames = {
  -43200000: 'Etc/GMT+12',
  -39600000: 'Pacific/Midway',
  -36000000: 'Pacific/Honolulu',
  -32400000: 'America/Anchorage',
  -28800000: 'America/Los_Angeles',
  -25200000: 'America/Denver',
  -21600000: 'America/Chicago',
  -18000000: 'America/New_York',
  -10800000: 'America/Sao_Paulo',
  -7200000: 'Atlantic/South_Georgia',
  -3600000: 'Atlantic/Azores',
  0: 'UTC',
  3600000: 'Europe/Berlin',
  7200000: 'Europe/Kiev',
  10800000: 'Europe/Moscow',
  14400000: 'Asia/Dubai',
  18000000: 'Asia/Karachi',
  19800000: 'Asia/Kolkata',
  20700000: 'Asia/Kathmandu',
  21600000: 'Asia/Dhaka',
  25200000: 'Asia/Bangkok',
  28800000: 'Asia/Hong_Kong',
  32400000: 'Asia/Tokyo',
  36000000: 'Australia/Sydney',
  39600000: 'Pacific/Noumea',
  43200000: 'Pacific/Auckland',
};

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Timezone Data
  //tz.initializeTimeZones();

  //init hive
  await Hive.initFlutter();
  //opening the box
  var box = await Hive.openBox('Events');

  // Get the local timezone
  // final String currentTimeZones = await FlutterTimezone.getLocalTimezone();
  // final String currentTimeZone =
  //     timezoneNames[DateTime.now().timeZoneOffset.inMilliseconds] ?? 'UTC';
  // print('$currentTimeZone ${DateTime.now().timeZoneOffset}');

  // Set the local timezone for tz
  // tz.setLocalLocation(tz.getLocation(currentTimeZones));
  // print(currentTimeZones);

  // Initialize Notifications
  //await NotificationService().initNotification();
  //await NotificationServiceIOS.initNotification();
  await FireStoreServices().initNotification();

  // Event Notifier
  // final EventNotifier eventNotifier = EventNotifier();
  // eventNotifier.checkEventsForToday();

  runApp(ChangeNotifierProvider(
    create: (context) => AuthServices(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeGate(),
    );
  }
}
