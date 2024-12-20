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
    apiKey: 'AIzaSyAx2i8pAXVYI2302Y4aiWRcaLY0e-TpPYk',
    appId: '1:1019450086083:web:02ca8727243248aea1c876',
    messagingSenderId: '1019450086083',
    projectId: 'n6-tp3-projet',
    authDomain: 'n6-tp3-projet.firebaseapp.com',
    storageBucket: 'n6-tp3-projet.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyATJIYudpKYS23J7j0XA1HiK-cMEHAAN7I',
    appId: '1:1019450086083:android:551150b31f10dbbba1c876',
    messagingSenderId: '1019450086083',
    projectId: 'n6-tp3-projet',
    storageBucket: 'n6-tp3-projet.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCdcsq1jzvQtLBU-nUVK5qvx2eT8czfhbQ',
    appId: '1:1019450086083:ios:cc372f6ad4d812cea1c876',
    messagingSenderId: '1019450086083',
    projectId: 'n6-tp3-projet',
    storageBucket: 'n6-tp3-projet.firebasestorage.app',
    iosBundleId: 'com.example.tp3',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCdcsq1jzvQtLBU-nUVK5qvx2eT8czfhbQ',
    appId: '1:1019450086083:ios:cc372f6ad4d812cea1c876',
    messagingSenderId: '1019450086083',
    projectId: 'n6-tp3-projet',
    storageBucket: 'n6-tp3-projet.firebasestorage.app',
    iosBundleId: 'com.example.tp3',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAx2i8pAXVYI2302Y4aiWRcaLY0e-TpPYk',
    appId: '1:1019450086083:web:2499294a9edfce1ea1c876',
    messagingSenderId: '1019450086083',
    projectId: 'n6-tp3-projet',
    authDomain: 'n6-tp3-projet.firebaseapp.com',
    storageBucket: 'n6-tp3-projet.firebasestorage.app',
  );
}
