# 📱 Architecture Documentation

## Overview
Aplikasi Joki Tugas menggunakan arsitektur Flutter yang modular dengan pattern separation of concerns untuk maintainability dan scalability yang optimal.

## Project Structure

```
joki_app/
├── lib/
│   ├── main.dart                 # Entry point aplikasi
│   ├── config/
│   │   └── theme.dart           # Theme configuration
│   ├── models/
│   │   ├── user.dart            # User data model
│   │   └── order.dart           # Order data model
│   ├── screens/
│   │   ├── splash_screen.dart   # Landing screen
│   │   ├── auth_screen.dart     # Authentication UI
│   │   ├── home_screen.dart     # Main dashboard
│   │   └── forgot_password_screen.dart
│   ├── services/
│   │   ├── auth_service.dart    # Authentication logic
│   │   ├── firestore_service.dart # Database operations
│   │   └── password_reset_service.dart
│   ├── widgets/
│   │   └── common/              # Reusable UI components
│   └── utils/
│       ├── constants.dart       # App constants
│       ├── helpers.dart         # Helper functions
│       └── validators.dart      # Input validation
├── docs/                        # Documentation
├── android/                     # Android-specific code
├── ios/                         # iOS-specific code
├── web/                         # Web-specific code
└── test/                        # Unit & widget tests
```

## Architectural Patterns

### 1. Service Layer Pattern
```dart
// Service classes handle business logic
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
  
  // Core authentication methods
  Future<User?> signInWithEmail(String email, String password) async { ... }
  Future<User?> registerWithEmail(String email, String password) async { ... }
  Future<void> signOut() async { ... }
}
```

**Benefits:**
- Single responsibility principle
- Testable business logic
- Consistent API across app
- Easy to mock for testing

### 2. State Management
```dart
// StatefulWidget dengan proper state handling
class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> 
    with TickerProviderStateMixin {
  // State variables dengan proper typing
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;
  
  // Lifecycle management
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

**State Management Principles:**
- Minimal state scope
- Immutable data where possible
- Proper disposal of resources
- Clear state updates

### 3. Navigation Architecture
```dart
// Route-based navigation dengan named routes
class AppRoutes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String forgotPassword = '/forgot-password';
}

// Navigation helpers
class NavigationHelper {
  static void pushReplacement(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, route);
  }
  
  static void pushAndRemoveUntil(BuildContext context, String route) {
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }
}
```

## Data Flow Architecture

### 1. Authentication Flow
```
User Input → UI Validation → Service Layer → Firebase Auth → State Update → UI Response
```

**Detailed Flow:**
1. **User Input**: Form submission dengan email/password
2. **UI Validation**: Client-side validation (email format, password length)
3. **Service Layer**: AuthService.signInWithEmail()
4. **Firebase Auth**: Actual authentication dengan Firebase
5. **State Update**: Update loading states, error handling
6. **UI Response**: Navigation atau error display

### 2. Session Management Flow
```
App Start → Session Check → Auto Login/Logout → Activity Monitoring → Timeout Handling
```

**Components:**
- **SessionManager**: Handles persistent login state
- **ActivityDetector**: Monitors user interaction
- **TimeoutService**: Manages 10-minute idle timeout
- **DraftService**: Saves unsaved work before logout

### 3. Data Persistence Flow
```
User Action → Local Validation → Service Layer → Firestore → Local Cache → UI Update
```

## Security Architecture

### 1. Authentication Security
```dart
class SecurityManager {
  // Password requirements
  static bool isValidPassword(String password) {
    return password.length >= 8 &&
           password.contains(RegExp(r'[A-Z]')) &&
           password.contains(RegExp(r'[a-z]')) &&
           password.contains(RegExp(r'[0-9]'));
  }
  
  // Session validation
  static bool isValidSession() {
    final lastActivity = PreferenceHelper.getLastActivity();
    final sessionTimeout = Duration(minutes: 10);
    return DateTime.now().difference(lastActivity) < sessionTimeout;
  }
}
```

### 2. Data Validation Layers
```dart
// Multiple validation layers
class ValidationLayers {
  // 1. UI Layer - Immediate feedback
  static String? emailValidator(String? value) { ... }
  
  // 2. Service Layer - Business logic validation
  static bool isValidBusinessEmail(String email) { ... }
  
  // 3. Server Layer - Firebase security rules
  // Handled by Firestore security rules
}
```

### 3. Error Handling Strategy
```dart
class ErrorHandler {
  static void handleError(dynamic error, StackTrace stackTrace) {
    // Log error untuk debugging
    debugPrint('Error: $error');
    debugPrint('StackTrace: $stackTrace');
    
    // Show user-friendly message
    if (error is FirebaseAuthException) {
      _handleAuthError(error);
    } else if (error is FirebaseException) {
      _handleFirestoreError(error);
    } else {
      _handleGenericError(error);
    }
  }
}
```

## Firebase Integration Architecture

### 1. Firebase Services Setup
```dart
// Firebase initialization
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

### 2. Firestore Data Model
```dart
// User model dengan Firestore integration
class User {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  
  // Firestore serialization
  Map<String, dynamic> toFirestore() { ... }
  factory User.fromFirestore(DocumentSnapshot doc) { ... }
}
```

### 3. Real-time Data Sync
```dart
class FirestoreService {
  // Stream-based data updates
  Stream<List<Order>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Order.fromFirestore(doc))
            .toList());
  }
}
```

## Performance Architecture

### 1. Code Optimization
```dart
// Efficient widget building
class OptimizedListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      cacheExtent: 500, // Pre-cache items
      itemBuilder: (context, index) {
        return RepaintBoundary( // Isolate repaints
          child: ItemWidget(items[index]),
        );
      },
    );
  }
}
```

### 2. Memory Management
```dart
// Proper resource disposal
class ResourceManager {
  final List<StreamSubscription> _subscriptions = [];
  final List<TextEditingController> _controllers = [];
  
  void dispose() {
    // Cancel all subscriptions
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    
    // Dispose controllers
    for (final controller in _controllers) {
      controller.dispose();
    }
  }
}
```

### 3. Network Optimization
```dart
class NetworkManager {
  // Connection status monitoring
  static Stream<ConnectivityResult> get connectivityStream =>
      Connectivity().onConnectivityChanged;
  
  // Offline capability
  static bool get isOffline => _currentConnectivity == ConnectivityResult.none;
  
  // Request caching strategy
  static Future<T> cachedRequest<T>(String key, Future<T> request) async {
    if (isOffline) {
      return CacheManager.get<T>(key);
    }
    
    final result = await request;
    CacheManager.set(key, result);
    return result;
  }
}
```

## Testing Architecture

### 1. Unit Testing Structure
```dart
// Service layer testing
group('AuthService Tests', () {
  late AuthService authService;
  
  setUp(() {
    authService = AuthService();
  });
  
  test('should validate email format correctly', () {
    expect(authService.isValidEmail('test@example.com'), true);
    expect(authService.isValidEmail('invalid-email'), false);
  });
});
```

### 2. Widget Testing Approach
```dart
// Widget testing dengan mock dependencies
testWidgets('AuthScreen should display error on invalid login', (tester) async {
  // Arrange
  await tester.pumpWidget(TestApp(child: AuthScreen()));
  
  // Act
  await tester.enterText(find.byKey(emailFieldKey), 'invalid@email.com');
  await tester.enterText(find.byKey(passwordFieldKey), 'wrong-password');
  await tester.tap(find.byKey(loginButtonKey));
  await tester.pump();
  
  // Assert
  expect(find.text('Invalid credentials'), findsOneWidget);
});
```

### 3. Integration Testing Strategy
```dart
// End-to-end flow testing
void main() {
  group('Authentication Flow', () {
    testWidgets('Complete login flow', (tester) async {
      // Start from splash screen
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate through auth flow
      await tester.tap(find.text('Login'));
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      // ... continue flow testing
    });
  });
}
```

## Scalability Considerations

### 1. Modular Architecture
```
features/
├── authentication/
│   ├── models/
│   ├── services/
│   ├── screens/
│   └── widgets/
├── dashboard/
│   ├── models/
│   ├── services/
│   ├── screens/
│   └── widgets/
└── orders/
    ├── models/
    ├── services/
    ├── screens/
    └── widgets/
```

### 2. Dependency Injection
```dart
// Service locator pattern
class ServiceLocator {
  static final GetIt _instance = GetIt.instance;
  
  static void setup() {
    _instance.registerSingleton<AuthService>(AuthService());
    _instance.registerSingleton<FirestoreService>(FirestoreService());
    _instance.registerFactory<PasswordResetService>(() => PasswordResetService());
  }
  
  static T get<T extends Object>() => _instance.get<T>();
}
```

### 3. Configuration Management
```dart
// Environment-based configuration
class AppConfig {
  static const String environment = String.fromEnvironment('ENV', defaultValue: 'dev');
  
  static String get apiBaseUrl {
    switch (environment) {
      case 'prod':
        return 'https://api.jokitugas.com';
      case 'staging':
        return 'https://staging-api.jokitugas.com';
      default:
        return 'https://dev-api.jokitugas.com';
    }
  }
}
```

## Platform-Specific Architecture

### 1. Android Configuration
```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        multiDexEnabled true
    }
}
```

### 2. iOS Configuration
```swift
// ios/Runner/Info.plist
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>firebase.auth</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>$(REVERSED_CLIENT_ID)</string>
        </array>
    </dict>
</array>
```

### 3. Web Configuration
```html
<!-- web/index.html -->
<script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-auth.js"></script>
<script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-firestore.js"></script>
```

## Monitoring dan Analytics

### 1. Performance Monitoring
```dart
class PerformanceMonitor {
  static void trackScreenTime(String screenName) {
    final stopwatch = Stopwatch()..start();
    
    // Track when user leaves screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stopwatch.stop();
      FirebaseAnalytics.instance.logEvent(
        name: 'screen_time',
        parameters: {
          'screen_name': screenName,
          'duration_ms': stopwatch.elapsedMilliseconds,
        },
      );
    });
  }
}
```

### 2. Error Tracking
```dart
class ErrorTracker {
  static void reportError(dynamic error, StackTrace stackTrace) {
    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      fatal: false,
    );
  }
  
  static void setUserContext(String userId) {
    FirebaseCrashlytics.instance.setUserIdentifier(userId);
  }
}
```

## Build dan Deployment

### 1. Build Configuration
```yaml
# pubspec.yaml
flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
  
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
```

### 2. CI/CD Pipeline
```yaml
# .github/workflows/build.yml
name: Build and Test
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
      - run: flutter build apk
```

## Future Architecture Enhancements

### 1. Microservices Integration
- RESTful API integration
- GraphQL untuk complex queries
- WebSocket untuk real-time features

### 2. Advanced State Management
- Provider/Riverpod untuk complex state
- Redux pattern untuk predictable state
- BLoC pattern untuk enterprise applications

### 3. Advanced Security
- Certificate pinning
- Runtime application self-protection (RASP)
- Advanced encryption untuk sensitive data

### 4. Offline-First Architecture
- Local database dengan Hive/SQLite
- Sync manager untuk data consistency
- Conflict resolution strategies
