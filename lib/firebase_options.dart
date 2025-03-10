// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDeERn4lmtKPP_-jDOVLxWCs7ONXN2Ab18',
    appId: '1:78217257668:web:2d20a8745ad0461a465f91',
    messagingSenderId: '78217257668',
    projectId: 'clgcalender',
    authDomain: 'clgcalender.firebaseapp.com',
    storageBucket: 'clgcalender.appspot.com',
    measurementId: 'G-NJJ47WE3T2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDvUC1zCuqNRGd6MVLkSIdlRSPK8JrgtNM',
    appId: '1:78217257668:android:0476850dc0c1a15c465f91',
    messagingSenderId: '78217257668',
    projectId: 'clgcalender',
    storageBucket: 'clgcalender.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAF50ORedzBhlVuc2KmLO8oU63Tnr_yrQk',
    appId: '1:78217257668:ios:a2b804af41829655465f91',
    messagingSenderId: '78217257668',
    projectId: 'clgcalender',
    storageBucket: 'clgcalender.appspot.com',
    iosBundleId: 'com.example.clgCalender',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAF50ORedzBhlVuc2KmLO8oU63Tnr_yrQk',
    appId: '1:78217257668:ios:a2b804af41829655465f91',
    messagingSenderId: '78217257668',
    projectId: 'clgcalender',
    storageBucket: 'clgcalender.appspot.com',
    iosBundleId: 'com.example.clgCalender',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDeERn4lmtKPP_-jDOVLxWCs7ONXN2Ab18',
    appId: '1:78217257668:web:694b69d053e9437a465f91',
    messagingSenderId: '78217257668',
    projectId: 'clgcalender',
    authDomain: 'clgcalender.firebaseapp.com',
    storageBucket: 'clgcalender.appspot.com',
    measurementId: 'G-RHM3E2P0QB',
  );
}
