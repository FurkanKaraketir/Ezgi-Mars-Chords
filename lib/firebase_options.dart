import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBcRMlBqZUfSJv5dT2V5XZcTqX5xonsTWc',
    appId: '1:1047885870282:web:41e95b3ff09fccd8467033',
    messagingSenderId: '1047885870282',
    projectId: 'testproject-23ee9',
    authDomain: 'testproject-23ee9.firebaseapp.com',
    storageBucket: 'testproject-23ee9.appspot.com',
    measurementId: 'G-1ZKPMLTLYG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNb83E5ZXI7FW_-qD03w4C5Os4GdK3JOM',
    appId: '1:1047885870282:android:9859a2e33feab683467033',
    messagingSenderId: '1047885870282',
    projectId: 'testproject-23ee9',
    storageBucket: 'testproject-23ee9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBBMiotrxtuEe3I8wc9w8XCYPnlsSEjVlc',
    appId: '1:1047885870282:ios:93810120acc75337467033',
    messagingSenderId: '1047885870282',
    projectId: 'testproject-23ee9',
    storageBucket: 'testproject-23ee9.appspot.com',
    iosBundleId: 'com.ezgiler.marslar.ezgi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBBMiotrxtuEe3I8wc9w8XCYPnlsSEjVlc',
    appId: '1:1047885870282:ios:ea835af6c99a2586467033',
    messagingSenderId: '1047885870282',
    projectId: 'testproject-23ee9',
    storageBucket: 'testproject-23ee9.appspot.com',
    iosBundleId: 'com.ezgiler.marslar.ezgi.RunnerTests',
  );
}
