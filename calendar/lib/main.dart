import 'package:calendar/firebase_options.dart';
import 'package:calendar/services/FireStore/fire_store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/event_notifier.dart';
import 'services/auth/auth_services.dart';
import 'services/auth/home_gate.dart';
//import 'pages/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await NotificationService().initNotification();
  await FireStoreServices().initNotification();
  final EventNotifier eventNotifier = EventNotifier();
  eventNotifier.checkEventsForToday();
  runApp(ChangeNotifierProvider(
    create: (create) => AuthServices(),
    child: const MyApp(),
  ));
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeGate(),
    );
  }
}