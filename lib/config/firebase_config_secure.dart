import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Secure Firebase Configuration
/// 
/// SECURITY NOTE: This file uses environment variables for all sensitive data.
/// Never commit actual API keys to version control.
/// 
/// To use this configuration:
/// 1. Set environment variables in your deployment environment
/// 2. For local development, create a .env file (not committed)
/// 3. Use flutter run --dart-define=FIREBASE_API_KEY=your_key_here
class FirebaseConfig {
  // Firebase configuration from environment variables
  static const Map<String, dynamic> firebaseOptions = {
    'apiKey': String.fromEnvironment(
      'FIREBASE_API_KEY',
      defaultValue: 'PLACEHOLDER_API_KEY_SET_ENV_VAR',
    ),
    'authDomain': String.fromEnvironment(
      'FIREBASE_AUTH_DOMAIN',
      defaultValue: 'your-project.firebaseapp.com',
    ),
    'projectId': String.fromEnvironment(
      'FIREBASE_PROJECT_ID',
      defaultValue: 'your-project-id',
    ),
    'storageBucket': String.fromEnvironment(
      'FIREBASE_STORAGE_BUCKET',
      defaultValue: 'your-project.firebasestorage.app',
    ),
    'messagingSenderId': String.fromEnvironment(
      'FIREBASE_MESSAGING_SENDER_ID',
      defaultValue: '000000000000',
    ),
    'appId': String.fromEnvironment(
      'FIREBASE_APP_ID',
      defaultValue: '1:000000000000:web:placeholder',
    ),
    'measurementId': String.fromEnvironment(
      'FIREBASE_MEASUREMENT_ID',
      defaultValue: 'G-PLACEHOLDER',
    ),
  };

  static const String googleSignInClientId = String.fromEnvironment(
    'GOOGLE_SIGNIN_CLIENT_ID',
    defaultValue: 'PLACEHOLDER_CLIENT_ID_SET_ENV_VAR',
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

  // Security validation
  static bool get isConfigured {
    return firebaseOptions['apiKey'] != 'PLACEHOLDER_API_KEY_SET_ENV_VAR' &&
           firebaseOptions['projectId'] != 'your-project-id' &&
           !firebaseOptions['apiKey']!.contains('PLACEHOLDER');
  }

  static void validateConfiguration() {
    if (!isConfigured) {
      throw Exception(
        '🔒 SECURITY: Firebase configuration not properly set!\n'
        'Please set environment variables:\n'
        '- FIREBASE_API_KEY\n'
        '- FIREBASE_AUTH_DOMAIN\n'
        '- FIREBASE_PROJECT_ID\n'
        '- FIREBASE_STORAGE_BUCKET\n'
        '- FIREBASE_MESSAGING_SENDER_ID\n'
        '- FIREBASE_APP_ID\n'
        '- FIREBASE_MEASUREMENT_ID\n'
        '- GOOGLE_SIGNIN_CLIENT_ID\n\n'
        'Example: flutter run --dart-define=FIREBASE_API_KEY=your_key_here',
      );
    }
  }

  // Development helper (DO NOT USE IN PRODUCTION)
  static void printConfiguration() {
    if (kDebugMode) {
      if (isConfigured) {
        debugPrint('✅ Firebase configuration is valid');
        debugPrint('📱 Project ID: ${firebaseOptions['projectId']}');
        debugPrint('🔐 API Key: ${firebaseOptions['apiKey']!.substring(0, 10)}...');
      } else {
        debugPrint('❌ Firebase configuration is NOT valid');
        debugPrint('💡 Set environment variables for proper configuration');
      }
    }
  }
}
