import '../models/user.dart';
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static User? _currentUser;
  static final firebase_auth.FirebaseAuth _auth =
      firebase_auth.FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Initialize and check if user is already logged in
  static Future<void> initialize() async {
    try {
      final firebaseUser = _auth.currentUser;

      if (firebaseUser != null) {
        // Get user data from Firestore
        final doc =
            await _firestore.collection('users').doc(firebaseUser.uid).get();

        if (doc.exists) {
          final userData = UserModel.fromFirestore(doc);
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
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final doc =
            await _firestore
                .collection('users')
                .doc(credential.user!.uid)
                .get();

        if (doc.exists) {
          final userData = UserModel.fromFirestore(doc);
          _currentUser = User(
            id: userData.uid,
            name: userData.name,
            email: userData.email,
            profileImage:
                userData.photoUrl.isNotEmpty ? userData.photoUrl : null,
            createdAt: userData.createdAt,
            updatedAt: userData.updatedAt ?? userData.createdAt,
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
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Create user document in Firestore
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'name': name,
          'email': credential.user!.email,
          'photoUrl': '',
          'isVerified': false,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Update display name
        await credential.user!.updateDisplayName(name);

        _currentUser = User(
          id: credential.user!.uid,
          name: name,
          email: credential.user!.email!,
          profileImage: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        return _currentUser;
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
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      _currentUser = null;
    } catch (e) {
      // Handle silently
    }
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
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Social login with Google
  static Future<User?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Save user data to Firestore if it's a new user
        if (userCredential.additionalUserInfo?.isNewUser == true) {
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
                'uid': userCredential.user!.uid,
                'name': userCredential.user!.displayName ?? 'Google User',
                'email': userCredential.user!.email,
                'photoUrl': userCredential.user!.photoURL ?? '',
                'isVerified': true,
                'createdAt': FieldValue.serverTimestamp(),
                'provider': 'google',
              });
        }

        _currentUser = User(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? 'Google User',
          email: userCredential.user!.email!,
          profileImage: userCredential.user!.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        return _currentUser;
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
