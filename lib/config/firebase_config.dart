import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  // Firebase config - Use environment variables in production
  static const Map<String, dynamic> firebaseOptions = {
    'apiKey': String.fromEnvironment('FIREBASE_API_KEY', defaultValue: ''),
    'authDomain': String.fromEnvironment('FIREBASE_AUTH_DOMAIN', defaultValue: ''),
    'projectId': String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: ''),
    'storageBucket': String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: ''),
    'messagingSenderId': String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: ''),
    'appId': String.fromEnvironment('FIREBASE_APP_ID', defaultValue: ''),
    'measurementId': String.fromEnvironment('FIREBASE_MEASUREMENT_ID', defaultValue: ''),
  };

  static const String googleSignInClientId = String.fromEnvironment(
    'GOOGLE_SIGNIN_CLIENT_ID', 
    defaultValue: '',
  );

  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: ''),
      authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN', defaultValue: ''),
      projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: ''),
      storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: ''),
      messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: ''),
      appId: String.fromEnvironment('FIREBASE_APP_ID', defaultValue: ''),
      measurementId: String.fromEnvironment('FIREBASE_MEASUREMENT_ID', defaultValue: ''),
    );
  }
}
