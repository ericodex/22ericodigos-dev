
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      // Web
      return const FirebaseOptions(
      apiKey: "AIzaSyBrC0MVawF3VdbzEph2flyqRrgcl2QT3_0",
      authDomain: "ericodigos.firebaseapp.com",
      databaseURL: "https://ericodigos.firebaseio.com",
      projectId: "ericodigos",
      storageBucket: "ericodigos.appspot.com",
      messagingSenderId: "177512589026",
      appId: "1:177512589026:web:a88f50924daf90833de0bb"
      );
    } else {
      // Android
      return const FirebaseOptions(
        apiKey: 'AIzaSyCsp3PeV9f9ZJ5nb1JvxajJNLnO2MsJGN8',
        appId: '1:177512589026:android:83378967281696c43de0bb',
        messagingSenderId: '177512589026',
        projectId: 'ericodigos',
        authDomain: "ericodigos.firebaseapp.com",
        databaseURL: "https://ericodigos.firebaseio.com",
        androidClientId:
            '448618578101-qd7qb4i251kmq2ju79bl7sif96si0ve3.apps.googleusercontent.com',
      );
    }
  }
}
