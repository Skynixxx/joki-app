import '../models/user.dart';
import '../models/user_model.dart';
import 'firebase_auth_service.dart';

class AuthService {
  static User? _currentUser;
  static final FirebaseAuthService _firebaseAuth = FirebaseAuthService();

  // Initialize and check if user is already logged in
  static Future<void> initialize() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;

      if (firebaseUser != null) {
        // Get user data from Firestore
        UserModel? userData = await _firebaseAuth.getCurrentUserData();

        if (userData != null) {
          _currentUser = User(
            id: userData.uid,
            name: userData.name,
            email: userData.email,
            profileImage:
                userData.photoUrl.isNotEmpty ? userData.photoUrl : null,
            createdAt: userData.createdAt,
            updatedAt: userData.updatedAt ?? userData.createdAt,
          );
        }
      }
    } catch (e) {
      // Handle error silently in production
    }
  }

  // Login with Firebase
  static Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email,
        password,
      );

      if (userCredential != null) {
        final firebaseUser = await _firebaseAuth.getCurrentUserData();
        if (firebaseUser != null) {
          _currentUser = User(
            id: firebaseUser.uid,
            name: firebaseUser.name,
            email: firebaseUser.email,
            profileImage:
                firebaseUser.photoUrl.isNotEmpty ? firebaseUser.photoUrl : null,
            createdAt: firebaseUser.createdAt,
            updatedAt: firebaseUser.updatedAt ?? firebaseUser.createdAt,
          );
          return _currentUser;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Register with Firebase
  static Future<User?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.registerWithEmailAndPassword(
        email,
        password,
      );

      if (userCredential != null) {
        // Update user profile with display name
        await _firebaseAuth.updateUserProfile(displayName: name);

        final firebaseUser = await _firebaseAuth.getCurrentUserData();
        if (firebaseUser != null) {
          _currentUser = User(
            id: firebaseUser.uid,
            name: firebaseUser.name.isNotEmpty ? firebaseUser.name : name,
            email: firebaseUser.email,
            profileImage:
                firebaseUser.photoUrl.isNotEmpty ? firebaseUser.photoUrl : null,
            createdAt: firebaseUser.createdAt,
            updatedAt: firebaseUser.updatedAt ?? firebaseUser.createdAt,
          );
          return _currentUser;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get current user
  static User? get currentUser => _currentUser;

  // Check if user is logged in
  static bool get isLoggedIn => _currentUser != null;

  // Logout with Firebase
  static Future<void> logout() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
  }

  // Update profile
  static Future<User?> updateProfile({
    required String name,
    String? profileImage,
  }) async {
    if (_currentUser == null) return null;

    await Future.delayed(const Duration(seconds: 1));

    _currentUser = _currentUser!.copyWith(
      name: name,
      profileImage: profileImage,
      updatedAt: DateTime.now(),
    );

    return _currentUser;
  }

  // Change password
  static Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    // Simple validation for demo
    if (currentPassword.length >= 6 && newPassword.length >= 6) {
      return true;
    }
    return false;
  }

  // Reset password with Firebase
  static Future<bool> resetPassword(String email) async {
    return await _firebaseAuth.sendPasswordResetEmail(email);
  }

  // Social login with Google
  static Future<User?> loginWithGoogle() async {
    try {
      final userCredential = await _firebaseAuth.signInWithGoogle();

      if (userCredential?.user != null) {
        final firebaseUser = await _firebaseAuth.getCurrentUserData();
        if (firebaseUser != null) {
          _currentUser = User(
            id: firebaseUser.uid,
            name: firebaseUser.name,
            email: firebaseUser.email,
            profileImage:
                firebaseUser.photoUrl.isNotEmpty ? firebaseUser.photoUrl : null,
            createdAt: firebaseUser.createdAt,
            updatedAt: firebaseUser.updatedAt ?? firebaseUser.createdAt,
          );
          return _currentUser;
        }
      }
      return null;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  static Future<User?> loginWithFacebook() async {
    await Future.delayed(const Duration(seconds: 2));

    _currentUser = User(
      id: 'facebook_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Facebook User',
      email: 'user@facebook.com',
      profileImage: 'https://example.com/avatar.jpg',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return _currentUser;
  }
}
