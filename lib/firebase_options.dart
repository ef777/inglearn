// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCyvjGthR4kOFyZW9IS5PdX5NHQMcoF66I',
    appId: '1:726418846270:web:bf780baa6dcb55b8c0576f',
    messagingSenderId: '726418846270',
    projectId: 'vocopus',
    authDomain: 'vocopus.firebaseapp.com',
    storageBucket: 'vocopus.appspot.com',
    measurementId: 'G-4MDGLYG0YV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA41AQO3UXmXaUppv3myODBG5vznC4wKgE',
    appId: '1:726418846270:android:74b2979fe1a9a253c0576f',
    messagingSenderId: '726418846270',
    projectId: 'vocopus',
    storageBucket: 'vocopus.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDkpy1V6l5-JUGkBc8jiBu6Z7_bCGyzH64',
    appId: '1:726418846270:ios:93618b97be8d7886c0576f',
    messagingSenderId: '726418846270',
    projectId: 'vocopus',
    storageBucket: 'vocopus.appspot.com',
    iosClientId: '726418846270-nljagevh0rjuh2s11eec6vas2bfvmbn2.apps.googleusercontent.com',
    iosBundleId: 'com.example.englishLearn',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDkpy1V6l5-JUGkBc8jiBu6Z7_bCGyzH64',
    appId: '1:726418846270:ios:93618b97be8d7886c0576f',
    messagingSenderId: '726418846270',
    projectId: 'vocopus',
    storageBucket: 'vocopus.appspot.com',
    iosClientId: '726418846270-nljagevh0rjuh2s11eec6vas2bfvmbn2.apps.googleusercontent.com',
    iosBundleId: 'com.example.englishLearn',
  );
}
