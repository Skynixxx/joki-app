import '../models/user.dart';
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'persistent_login_service.dart';

class AuthService {
  static User? _currentUser;
  static final firebase_auth.FirebaseAuth _auth =
      firebase_auth.FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Avatar styles untuk avatar gratis
  static const List<String> _avatarStyles = [
    'adventurer',
    'avataaars',
    'big-ears',
    'big-smile',
    'croodles',
    'fun-emoji',
    'icons',
    'identicon',
    'initials',
    'lorelei',
    'micah',
    'miniavs',
    'open-peeps',
    'personas',
    'pixel-art',
  ];

  // Initialize and check if user is already logged in
  static Future<void> initialize() async {
    try {
      // First check if there's a persisted login
      final isPersistedLogin = await PersistentLoginService.isLoggedIn();

      if (isPersistedLogin) {
        final savedUserData = await PersistentLoginService.getSavedUserData();

        if (savedUserData['userId'] != null) {
          // Try to restore user session
          final firebaseUser = _auth.currentUser;

          if (firebaseUser != null &&
              firebaseUser.uid == savedUserData['userId']) {
            // Firebase user still logged in, restore from Firestore
            final doc =
                await _firestore
                    .collection('users')
                    .doc(firebaseUser.uid)
                    .get();

            if (doc.exists) {
              final userData = UserModel.fromFirestore(doc);
              String? profileImageUrl =
                  userData.photoUrl.isNotEmpty ? userData.photoUrl : null;

              if (profileImageUrl == null || profileImageUrl.isEmpty) {
                profileImageUrl = getDefaultProfileImage(
                  userData.uid,
                  email: userData.email,
                );
                await _firestore
                    .collection('users')
                    .doc(firebaseUser.uid)
                    .update({'photoUrl': profileImageUrl});
              }

              _currentUser = User(
                id: userData.uid,
                name: userData.name,
                email: userData.email,
                profileImage: profileImageUrl,
                createdAt: userData.createdAt,
                updatedAt: userData.updatedAt ?? userData.createdAt,
              );

              if (kDebugMode) {
                debugPrint('User session restored from persistence');
              }
              return;
            }
          } else {
            // Create user from saved data (fallback)
            _currentUser = User(
              id: savedUserData['userId']!,
              name: savedUserData['name'] ?? 'User',
              email: savedUserData['email'] ?? '',
              profileImage: savedUserData['profileImage'],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            if (kDebugMode) {
              debugPrint('User session restored from saved data');
            }
            return;
          }
        }
      }

      // Fallback to Firebase check
      final firebaseUser = _auth.currentUser;

      if (firebaseUser != null) {
        final doc =
            await _firestore.collection('users').doc(firebaseUser.uid).get();

        if (doc.exists) {
          final userData = UserModel.fromFirestore(doc);
          String? profileImageUrl =
              userData.photoUrl.isNotEmpty ? userData.photoUrl : null;

          if (profileImageUrl == null || profileImageUrl.isEmpty) {
            profileImageUrl = getDefaultProfileImage(
              userData.uid,
              email: userData.email,
            );
            await _firestore.collection('users').doc(firebaseUser.uid).update({
              'photoUrl': profileImageUrl,
            });
          }

          _currentUser = User(
            id: userData.uid,
            name: userData.name,
            email: userData.email,
            profileImage: profileImageUrl,
            createdAt: userData.createdAt,
            updatedAt: userData.updatedAt ?? userData.createdAt,
          );

          // Save login state for persistence
          await PersistentLoginService.saveLoginState(
            userId: userData.uid,
            email: userData.email,
            name: userData.name,
            profileImage: profileImageUrl,
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error in initialize: $e');
      }
      // Clear invalid login state on error
      await PersistentLoginService.clearLoginState();
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
        // Generate default avatar untuk user baru
        final defaultAvatar = getDefaultProfileImage(
          credential.user!.uid,
          email: credential.user!.email,
        );

        // Create user document in Firestore
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'name': name,
          'email': credential.user!.email,
          'photoUrl': defaultAvatar,
          'isVerified': false,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Update display name
        await credential.user!.updateDisplayName(name);

        _currentUser = User(
          id: credential.user!.uid,
          name: name,
          email: credential.user!.email!,
          profileImage: defaultAvatar,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Save login state for persistence
        await PersistentLoginService.saveLoginState(
          userId: credential.user!.uid,
          email: credential.user!.email!,
          name: name,
          profileImage: defaultAvatar,
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
      await PersistentLoginService.clearLoginState();
      _currentUser = null;

      if (kDebugMode) {
        debugPrint('User logged out successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error during logout: $e');
      }
    }
  }

  // Update profile with Firebase
  static Future<User?> updateProfile({
    required String name,
    String? profileImage,
    String? phoneNumber,
  }) async {
    if (_currentUser == null || _auth.currentUser == null) return null;

    try {
      final userId = _auth.currentUser!.uid;

      // Prepare update data
      final updateData = {
        'name': name,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add optional fields if provided
      if (profileImage != null) {
        updateData['photoUrl'] = profileImage;
      }
      if (phoneNumber != null) {
        updateData['phoneNumber'] = phoneNumber;
      }

      // Update Firestore document
      await _firestore.collection('users').doc(userId).update(updateData);

      // Update Firebase Auth display name
      await _auth.currentUser!.updateDisplayName(name);

      // Update profile photo if provided
      if (profileImage != null && profileImage.isNotEmpty) {
        await _auth.currentUser!.updatePhotoURL(profileImage);
      }

      // Update local user object
      _currentUser = _currentUser!.copyWith(
        name: name,
        profileImage: profileImage,
        updatedAt: DateTime.now(),
      );

      return _currentUser;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error updating profile: $e');
      }
      return null;
    }
  }

  // Update email (requires re-authentication)
  static Future<bool> updateEmail(
    String newEmail,
    String currentPassword,
  ) async {
    if (_auth.currentUser == null) return false;

    try {
      final user = _auth.currentUser!;

      // Re-authenticate user before email change
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update email
      await user.updateEmail(newEmail);

      // Update email in Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'email': newEmail,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update local user object
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          email: newEmail,
          updatedAt: DateTime.now(),
        );
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error updating email: $e');
      }
      return false;
    }
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

  // Social login with Google (Simplified)
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
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Generate default avatar jika tidak ada photo dari Google
        String profileImageUrl = firebaseUser.photoURL ?? '';
        if (profileImageUrl.isEmpty) {
          profileImageUrl = getDefaultProfileImage(
            firebaseUser.uid,
            email: firebaseUser.email,
          );
        }

        // Use Firebase User data directly (no People API needed)
        final userData = {
          'uid': firebaseUser.uid,
          'name':
              firebaseUser.displayName ??
              googleUser.displayName ??
              'Google User',
          'email': firebaseUser.email ?? googleUser.email,
          'photoUrl': profileImageUrl,
          'isVerified': firebaseUser.emailVerified,
          'provider': 'google',
          'createdAt': FieldValue.serverTimestamp(),
        };

        // Save to Firestore if new user
        if (userCredential.additionalUserInfo?.isNewUser == true) {
          await _firestore
              .collection('users')
              .doc(firebaseUser.uid)
              .set(userData);
        } else {
          // Update existing user data
          await _firestore.collection('users').doc(firebaseUser.uid).update({
            'name': userData['name'],
            'photoUrl': userData['photoUrl'],
            'lastSignIn': FieldValue.serverTimestamp(),
          });
        }

        _currentUser = User(
          id: firebaseUser.uid,
          name: userData['name'] as String,
          email: userData['email'] as String,
          profileImage: profileImageUrl,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Save login state for persistence
        await PersistentLoginService.saveLoginState(
          userId: firebaseUser.uid,
          email: userData['email'] as String,
          name: userData['name'] as String,
          profileImage: profileImageUrl,
        );

        return _currentUser;
      }
      return null;
    } catch (e) {
      // Log error for debugging in development
      if (kDebugMode) {
        debugPrint('Error signing in with Google: $e');
      }
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

  // Avatar colors untuk variasi
  static const List<String> _avatarColors = [
    '6B73FF', // Primary blue
    'FF6B6B', // Red
    '4ECDC4', // Teal
    '45B7D1', // Light blue
    '96CEB4', // Green
    'FFEAA7', // Yellow
    'DDA0DD', // Plum
    'FF9F43', // Orange
    'A0A0A0', // Gray
    '74B9FF', // Blue
  ];

  // Generate avatar URL gratis menggunakan UI Avatars (lebih stabil)
  static String generateAvatarUrl(String seed, {String style = 'avataaars'}) {
    // Extract nama dari seed atau gunakan default
    String name = 'US'; // Default

    // Coba extract nama dari user atau generate yang lebih menarik
    if (_currentUser != null && _currentUser!.name.isNotEmpty) {
      final userName = _currentUser!.name.trim();
      final words = userName.split(' ');
      if (words.length >= 2) {
        // Ambil initial dari nama depan dan belakang
        name = '${words[0][0]}${words[1][0]}'.toUpperCase();
      } else if (words.isNotEmpty && words[0].length >= 2) {
        // Ambil 2 huruf pertama dari nama tunggal
        name = words[0].substring(0, 2).toUpperCase();
      }
    } else {
      // Fallback ke seed processing
      final cleanSeed = seed.replaceAll(RegExp(r'[^a-zA-Z]'), '');
      if (cleanSeed.length >= 2) {
        name = cleanSeed.substring(0, 2).toUpperCase();
      }
    }

    // Pick color based on seed
    final colorIndex = seed.hashCode.abs() % _avatarColors.length;
    final backgroundColor = _avatarColors[colorIndex];
    return 'https://ui-avatars.com/api/?name=$name&size=200&background=$backgroundColor&color=ffffff&bold=true&rounded=true';
  }

  // Generate Gravatar URL sebagai fallback
  static String generateGravatarUrl(String email) {
    final hash =
        md5.convert(utf8.encode(email.toLowerCase().trim())).toString();
    return 'https://www.gravatar.com/avatar/$hash?s=200&d=identicon';
  }

  // Get random avatar style
  static String getRandomAvatarStyle() {
    return _avatarStyles[DateTime.now().millisecondsSinceEpoch %
        _avatarStyles.length];
  }

  // Generate default profile image untuk user
  static String getDefaultProfileImage(String identifier, {String? email}) {
    String avatarUrl;
    if (email != null && email.isNotEmpty) {
      // Gunakan Gravatar jika ada email
      avatarUrl = generateGravatarUrl(email);
    } else {
      // Gunakan DiceBear dengan random style
      final style = getRandomAvatarStyle();
      avatarUrl = generateAvatarUrl(identifier, style: style);
    }

    if (kDebugMode) {
      debugPrint('Generated avatar URL: $avatarUrl');
    }

    return avatarUrl;
  }

  // Update profile picture dengan avatar gratis baru
  static Future<String> generateNewAvatar() {
    final user = _auth.currentUser;
    if (user == null) return Future.value('');

    // Generate avatar baru dengan timestamp untuk uniqueness
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Generate nama random yang lebih bervariasi
    final randomNames = [
      'AX',
      'BY',
      'CZ',
      'DW',
      'EV',
      'FU',
      'GT',
      'HS',
      'IR',
      'JQ',
    ];
    final nameIndex = timestamp % randomNames.length;
    final name = randomNames[nameIndex];

    // Pick warna random
    final colorIndex = timestamp % _avatarColors.length;
    final backgroundColor = _avatarColors[colorIndex];

    final avatarUrl =
        'https://ui-avatars.com/api/?name=$name&size=200&background=$backgroundColor&color=ffffff&bold=true&rounded=true';

    return Future.value(avatarUrl);
  }

  // Pilih dari berbagai style avatar
  static List<String> getAvatarOptions(String identifier) {
    final List<String> avatarUrls = [];

    // Generate 15 avatar yang berbeda dengan seed yang bervariasi
    for (int i = 0; i < _avatarStyles.length; i++) {
      // Buat seed yang berbeda untuk setiap style
      final seed = '${identifier}_style_$i';
      final name = _generateNameFromSeed(seed, i);
      final colorIndex = (identifier.hashCode + i) % _avatarColors.length;
      final backgroundColor = _avatarColors[colorIndex];

      final avatarUrl =
          'https://ui-avatars.com/api/?name=$name&size=200&background=$backgroundColor&color=ffffff&bold=true&rounded=true';
      avatarUrls.add(avatarUrl);
    }

    return avatarUrls;
  }

  // Helper method untuk generate nama yang bervariasi
  static String _generateNameFromSeed(String seed, int index) {
    final names = [
      'AB',
      'CD',
      'EF',
      'GH',
      'IJ',
      'KL',
      'MN',
      'OP',
      'QR',
      'ST',
      'UV',
      'WX',
      'YZ',
      'AA',
      'BB',
    ];

    // Kombinasi antara hash seed dan index untuk variasi
    final nameIndex = (seed.hashCode + index).abs() % names.length;
    return names[nameIndex];
  }
}
