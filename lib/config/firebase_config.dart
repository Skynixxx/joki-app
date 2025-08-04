import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  // Firebase config - Use environment variables in production
  static const Map<String, dynamic> firebaseOptions = {
    'apiKey': String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'AIzaSyCFAdmX0OJNiwkQjqWoqcQtP_l7sXn35OQ'),
    'authDomain': String.fromEnvironment('FIREBASE_AUTH_DOMAIN', defaultValue: 'joki-tugas-app.firebaseapp.com'),
    'projectId': String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'joki-tugas-app'),
    'storageBucket': String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 'joki-tugas-app.firebasestorage.app'),
    'messagingSenderId': String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '885605446677'),
    'appId': String.fromEnvironment('FIREBASE_APP_ID', defaultValue: '1:885605446677:web:6c0cc43108c08b17020a1c'),
    'measurementId': String.fromEnvironment('FIREBASE_MEASUREMENT_ID', defaultValue: 'G-VXT5MCXVXJ'),
  };

  static const String googleSignInClientId = String.fromEnvironment(
    'GOOGLE_SIGNIN_CLIENT_ID', 
    defaultValue: '885605446677-qcmg6nkdampn2a8sdhtrcj2o44pf907v.apps.googleusercontent.com',
  );

  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'AIzaSyCFAdmX0OJNiwkQjqWoqcQtP_l7sXn35OQ'),
      authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN', defaultValue: 'joki-tugas-app.firebaseapp.com'),
      projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'joki-tugas-app'),
      storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 'joki-tugas-app.firebasestorage.app'),
      messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '885605446677'),
      appId: String.fromEnvironment('FIREBASE_APP_ID', defaultValue: '1:885605446677:web:6c0cc43108c08b17020a1c'),
      measurementId: String.fromEnvironment('FIREBASE_MEASUREMENT_ID', defaultValue: 'G-VXT5MCXVXJ'),
    );
  }
}
