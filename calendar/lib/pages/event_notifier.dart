import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

class EventNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  EventNotifier() {
    _initializeNotification();
  }

  void _initializeNotification() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    tz.initializeTimeZones();
  }

  Future<void> checkEventsForToday() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    await _checkCollection('Events', startOfDay, endOfDay, false);
    await _checkCollection('AdminEvents', startOfDay, endOfDay, true);
  }

  Future<void> _checkCollection(String collectionName, DateTime startOfDay,
      DateTime endOfDay, bool isGlobal) async {
    final querySnapshot = await _firestore
        .collection(collectionName)
        .where('Date', isGreaterThanOrEqualTo: startOfDay)
        .where('Date', isLessThanOrEqualTo: endOfDay)
        .get();

    for (var doc in querySnapshot.docs) {
      final event = doc.data();
      final title = event['EventTitle'] ?? 'No Title';
      final description = event['EventDescription'] ?? 'No Description';
      await _showNotification(title, description, isGlobal);
    }
  }

  Future<void> _showNotification(
      String title, String description, bool isGlobal) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'BOA',
      'BOA CALENDAR',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      isGlobal ? 'Global Event: $title' : 'Your Event: $title',
      description,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
