import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    tz.initializeTimeZones();
    final String currentTimeZone = await tz.local.name;

    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request exact alarm permission if Android 12 or above
    if (Platform.isAndroid && await _isAndroid12OrAbove()) {
      await _requestExactAlarmPermission();
    }

    // Schedule daily notifications at 8 AM and 2 PM
    await scheduleDailyNotifications();
  }

  Future<bool> _isAndroid12OrAbove() async {
    return (await Permission.scheduleExactAlarm.isGranted) == false;
  }

  Future<void> _requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  Future<void> scheduleDailyNotifications() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Check for Events',
      'It\'s time to check for events!',
      _nextInstanceOfTime(8, 0),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'id#1',
          'BOA',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Check for Events',
      'It\'s time to check for events!',
      _nextInstanceOfTime(14, 0),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'id#1',
          'BOA Calendar',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> checkAndScheduleNotifications(String userId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final eventsQuery = await FirebaseFirestore.instance
        .collection('Events')
        .where('ID', isEqualTo: userId)
        .where('Date', isEqualTo: today)
        .get();

    if (eventsQuery.docs.isNotEmpty) {
      await scheduleDailyNotifications();
    }
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'id#1',
      'BOA Calendar',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
