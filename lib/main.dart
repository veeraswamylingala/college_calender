import 'package:clg_calender/firebase_options.dart';
import 'package:clg_calender/views/splashscree.dart';
import 'package:clg_calender/views/students_list_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> _backgroundHandler(RemoteMessage message) async {
  print("Handling background message: ${message.data}");
  // Process the incoming message and perform appropriate actions
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(
      _backgroundHandler); // Set the background handler

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ClgCalender',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: const SplashScreen(),
    );
  }
}
