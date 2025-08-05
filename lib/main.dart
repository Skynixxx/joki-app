import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/help_support_screen.dart';
import 'config/firebase_config_secure.dart';
import 'services/auth_service.dart';
import 'services/session_manager.dart';
import 'widgets/activity_detector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Validate Firebase configuration
    FirebaseConfig.validateConfiguration();
    
    // Initialize Firebase
    await Firebase.initializeApp(options: FirebaseConfig.currentPlatform);

    // Initialize AuthService to check for existing user
    await AuthService.initialize();
    
    if (kDebugMode) {
      FirebaseConfig.printConfiguration();
    }
  } catch (e) {
    // Handle Firebase initialization error gracefully
    if (kDebugMode) {
      debugPrint('Firebase initialization error: $e');
    }
  }

  runApp(const JokiApp());
}

class JokiApp extends StatelessWidget {
  const JokiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joki Tugas App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B73FF),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => _SessionManagedHome(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/help-support': (context) => const HelpSupportScreen(),
      },
      initialRoute: '/',
    );
  }
}

// Wrapper widget untuk HomeScreen dengan session management
class _SessionManagedHome extends StatefulWidget {
  @override
  State<_SessionManagedHome> createState() => _SessionManagedHomeState();
}

class _SessionManagedHomeState extends State<_SessionManagedHome> {
  @override
  void initState() {
    super.initState();
    // Initialize session manager ketika masuk ke home
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SessionManager.initialize(context);
    });
  }

  @override
  void dispose() {
    SessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ActivityDetector(child: const HomeScreen());
  }
}
