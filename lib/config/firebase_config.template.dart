import 'package:firebase_core/firebase_core.dart';

// Firebase Configuration Template
// Copy this file to firebase_config.dart and fill in your actual values
// NEVER commit firebase_config.dart to version control!

class FirebaseConfig {
  // Firebase config - Use environment variables in production
  // For development, ensure you set environment variables or update defaultValues
  static const Map<String, dynamic> firebaseOptions = {
    'apiKey': String.fromEnvironment(
      'FIREBASE_API_KEY',
      defaultValue: 'YOUR_API_KEY_HERE',
    ),
    'authDomain': String.fromEnvironment(
      'FIREBASE_AUTH_DOMAIN',
      defaultValue: 'YOUR_PROJECT.firebaseapp.com',
    ),
    'projectId': String.fromEnvironment(
      'FIREBASE_PROJECT_ID',
      defaultValue: 'YOUR_PROJECT_ID',
    ),
    'storageBucket': String.fromEnvironment(
      'FIREBASE_STORAGE_BUCKET',
      defaultValue: 'YOUR_PROJECT.firebasestorage.app',
    ),
    'messagingSenderId': String.fromEnvironment(
      'FIREBASE_MESSAGING_SENDER_ID',
      defaultValue: 'YOUR_SENDER_ID',
    ),
    'appId': String.fromEnvironment(
      'FIREBASE_APP_ID',
      defaultValue: 'YOUR_APP_ID',
    ),
    'measurementId': String.fromEnvironment(
      'FIREBASE_MEASUREMENT_ID',
      defaultValue: 'YOUR_MEASUREMENT_ID',
    ),
  };

  static const String googleSignInClientId = String.fromEnvironment(
    'GOOGLE_SIGNIN_CLIENT_ID',
    defaultValue: 'YOUR_GOOGLE_CLIENT_ID',
  );

  static FirebaseOptions get currentPlatform {
    return FirebaseOptions(
      apiKey: firebaseOptions['apiKey']!,
      authDomain: firebaseOptions['authDomain']!,
      projectId: firebaseOptions['projectId']!,
      storageBucket: firebaseOptions['storageBucket']!,
      messagingSenderId: firebaseOptions['messagingSenderId']!,
      appId: firebaseOptions['appId']!,
      measurementId: firebaseOptions['measurementId'],
    );
  }

  // Validation methods
  static bool get isConfigured {
    return firebaseOptions['apiKey'] != 'YOUR_API_KEY_HERE' &&
           firebaseOptions['projectId'] != 'YOUR_PROJECT_ID';
  }

  static void validateConfiguration() {
    if (!isConfigured) {
      throw Exception(
        'Firebase configuration not set up properly. '
        'Please configure your Firebase settings in firebase_config.dart or '
        'set environment variables.',
      );
    }
  }

  // Environment setup instructions
  static const String setupInstructions = '''
To set up Firebase configuration:

1. Development (using local config):
   - Copy lib/config/firebase_config.template.dart to lib/config/firebase_config.dart
   - Fill in your actual Firebase values
   - Do NOT commit firebase_config.dart

2. Production (using environment variables):
   Set these environment variables:
   - FIREBASE_API_KEY
   - FIREBASE_AUTH_DOMAIN
   - FIREBASE_PROJECT_ID
   - FIREBASE_STORAGE_BUCKET
   - FIREBASE_MESSAGING_SENDER_ID
   - FIREBASE_APP_ID
   - FIREBASE_MEASUREMENT_ID
   - GOOGLE_SIGNIN_CLIENT_ID
''';
}
