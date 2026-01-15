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
    apiKey: "AIzaSyCwsJuAMB4q77MBRNJMTGSj0Nj_hyO6fOM",
    appId: "1:230454851456:web:6bd0e0dae657a1faf0f365",
    messagingSenderId: "230454851456",
    projectId: "contactlist-b1d2a",
    authDomain: "contactlist-b1d2a.firebaseapp.com",
    storageBucket: "contactlist-b1d2a.firebasestorage.app",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfj_lipJGPveV3OU6pban_ZtuMcgWfzd4',
    appId: '1:230454851456:android:993888ca00325190f0f365',
    messagingSenderId: '230454851456',
    projectId: 'contactlist-b1d2a',
    storageBucket: 'contactlist-b1d2a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'TODO-REPLACE-WITH-YOUR-API-KEY',
    appId: 'TODO-REPLACE-WITH-YOUR-APP-ID',
    messagingSenderId: 'TODO-REPLACE-WITH-YOUR-SENDER-ID',
    projectId: 'TODO-REPLACE-WITH-YOUR-PROJECT-ID',
    storageBucket: 'TODO-REPLACE-WITH-YOUR-STORAGE-BUCKET',
    iosClientId: 'TODO-REPLACE-WITH-YOUR-IOS-CLIENT-ID',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'TODO-REPLACE-WITH-YOUR-API-KEY',
    appId: 'TODO-REPLACE-WITH-YOUR-APP-ID',
    messagingSenderId: 'TODO-REPLACE-WITH-YOUR-SENDER-ID',
    projectId: 'TODO-REPLACE-WITH-YOUR-PROJECT-ID',
    storageBucket: 'TODO-REPLACE-WITH-YOUR-STORAGE-BUCKET',
    iosClientId: 'TODO-REPLACE-WITH-YOUR-IOS-CLIENT-ID',
    iosBundleId: 'com.example.app',
  );
}
