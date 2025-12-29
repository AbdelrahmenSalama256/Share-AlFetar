
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

//! DefaultFirebaseOptions
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAU4a8uGe7HCpbp9kronyq0exIU3TlphHQ',
    appId: '1:1002937750051:android:00341c1e18270311409796',
    messagingSenderId: '1002937750051',
    projectId: 'cozyhome-sa',
    storageBucket: 'cozyhome-sa.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDAtClO5FpJ9FXMRu0KxFtzdcUKAd9Z5Uw',
    appId: '1:1002937750051:ios:244dbfbfff380355409796',
    messagingSenderId: '1002937750051',
    projectId: 'cozyhome-sa',
    storageBucket: 'cozyhome-sa.firebasestorage.app',
    iosBundleId: 'com.cangrow.cozy',
  );

}