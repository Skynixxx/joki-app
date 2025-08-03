import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  // Firebase config from your Firebase Console
  static const Map<String, dynamic> firebaseOptions = {
    'apiKey': 'AIzaSyCFAdmX0OJNiwkQjqWoqcQtP_l7sXn35OQ',
    'authDomain': 'joki-tugas-app.firebaseapp.com',
    'projectId': 'joki-tugas-app',
    'storageBucket': 'joki-tugas-app.firebasestorage.app',
    'messagingSenderId': '885605446677',
    'appId': '1:885605446677:web:6c0cc43108c08b17020a1c',
    'measurementId': 'G-VXT5MCXVXJ',
  };

  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyCFAdmX0OJNiwkQjqWoqcQtP_l7sXn35OQ',
      authDomain: 'joki-tugas-app.firebaseapp.com',
      projectId: 'joki-tugas-app',
      storageBucket: 'joki-tugas-app.firebasestorage.app',
      messagingSenderId: '885605446677',
      appId: '1:885605446677:web:6c0cc43108c08b17020a1c',
      measurementId: 'G-VXT5MCXVXJ',
    );
  }
}
