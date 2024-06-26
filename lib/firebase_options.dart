// // File generated by FlutterFire CLI.
// // ignore_for_file: type=lint
// import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
// import 'package:flutter/foundation.dart'
//     show defaultTargetPlatform, kIsWeb, TargetPlatform;

// /// Default [FirebaseOptions] for use with your Firebase apps.
// ///
// /// Example:
// /// ```dart
// /// import 'firebase_options.dart';
// /// // ...
// /// await Firebase.initializeApp(
// ///   options: DefaultFirebaseOptions.currentPlatform,
// /// );
// /// ```
// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     if (kIsWeb) {
//       return web;
//     }
//     switch (defaultTargetPlatform) {
//       case TargetPlatform.android:
//         return android;
//       case TargetPlatform.iOS:
//         return ios;
//       case TargetPlatform.macOS:
//         return macos;
//       case TargetPlatform.windows:
//         return windows;
//       case TargetPlatform.linux:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for linux - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       default:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions are not supported for this platform.',
//         );
//     }
//   }

//   static const FirebaseOptions web = FirebaseOptions(
//     apiKey: 'AIzaSyDfPDsXrWbarwOgCn7h7yzMQHVGL7QH2zQ',
//     appId: '1:731565404720:web:1b5d9baa91dc7865ebf3f5',
//     messagingSenderId: '731565404720',
//     projectId: 'pink-car-20282',
//     authDomain: 'pink-car-20282.firebaseapp.com',
//     storageBucket: 'pink-car-20282.appspot.com',
//     measurementId: 'G-TE98C1B46P',
//   );

//   static const FirebaseOptions ios = FirebaseOptions(
//     apiKey: 'AIzaSyCyiaKwf_G9AxVNsPYL0fyfs-1IbcjdtPs',
//     appId: '1:731565404720:ios:ff961c73752cce9aebf3f5',
//     messagingSenderId: '731565404720',
//     projectId: 'pink-car-20282',
//     storageBucket: 'pink-car-20282.appspot.com',
//     iosBundleId: 'com.example.pinkCar',
//   );

//   static const FirebaseOptions macos = FirebaseOptions(
//     apiKey: 'AIzaSyCyiaKwf_G9AxVNsPYL0fyfs-1IbcjdtPs',
//     appId: '1:731565404720:ios:ff961c73752cce9aebf3f5',
//     messagingSenderId: '731565404720',
//     projectId: 'pink-car-20282',
//     storageBucket: 'pink-car-20282.appspot.com',
//     iosBundleId: 'com.example.pinkCar',
//   );

//   static const FirebaseOptions windows = FirebaseOptions(
//     apiKey: 'AIzaSyDfPDsXrWbarwOgCn7h7yzMQHVGL7QH2zQ',
//     appId: '1:731565404720:web:1b5d9baa91dc7865ebf3f5',
//     messagingSenderId: '731565404720',
//     projectId: 'pink-car-20282',
//     authDomain: 'pink-car-20282.firebaseapp.com',
//     storageBucket: 'pink-car-20282.appspot.com',
//     measurementId: 'G-TE98C1B46P',
//   );

//   static const FirebaseOptions android = FirebaseOptions(
//     apiKey: 'AIzaSyBUlMBCfmQFftNXL16jXBL0r5PrCYpZz94',
//     appId: '1:731565404720:android:5f12c63ef7061b06ebf3f5',
//     messagingSenderId: '731565404720',
//     projectId: 'pink-car-20282',
//     storageBucket: 'pink-car-20282.appspot.com',
//   );

// }