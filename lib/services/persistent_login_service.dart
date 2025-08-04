import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class PersistentLoginService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserName = 'user_name';
  static const String _keyProfileImage = 'profile_image';
  static const String _keyLastActivity = 'last_activity';

  // Save login state
  static Future<void> saveLoginState({
    required String userId,
    required String email,
    required String name,
    String? profileImage,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUserId, userId);
      await prefs.setString(_keyUserEmail, email);
      await prefs.setString(_keyUserName, name);
      await prefs.setString(_keyProfileImage, profileImage ?? '');
      await prefs.setString(_keyLastActivity, DateTime.now().toIso8601String());

      if (kDebugMode) {
        debugPrint('Login state saved for user: $name');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error saving login state: $e');
      }
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;

      if (!isLoggedIn) return false;

      // Check if session is still valid (not older than 24 hours)
      final lastActivityStr = prefs.getString(_keyLastActivity);
      if (lastActivityStr != null) {
        final lastActivity = DateTime.parse(lastActivityStr);
        final now = DateTime.now();
        final hoursDiff = now.difference(lastActivity).inHours;

        // If more than 24 hours, clear login state
        if (hoursDiff > 24) {
          await clearLoginState();
          return false;
        }
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error checking login state: $e');
      }
      return false;
    }
  }

  // Get saved user data
  static Future<Map<String, String?>> getSavedUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      return {
        'userId': prefs.getString(_keyUserId),
        'email': prefs.getString(_keyUserEmail),
        'name': prefs.getString(_keyUserName),
        'profileImage': prefs.getString(_keyProfileImage),
      };
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting saved user data: $e');
      }
      return {};
    }
  }

  // Update last activity
  static Future<void> updateLastActivity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyLastActivity, DateTime.now().toIso8601String());
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error updating last activity: $e');
      }
    }
  }

  // Clear login state
  static Future<void> clearLoginState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(_keyIsLoggedIn);
      await prefs.remove(_keyUserId);
      await prefs.remove(_keyUserEmail);
      await prefs.remove(_keyUserName);
      await prefs.remove(_keyProfileImage);
      await prefs.remove(_keyLastActivity);

      if (kDebugMode) {
        debugPrint('Login state cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error clearing login state: $e');
      }
    }
  }

  // Save draft data
  static Future<void> saveDraft(Map<String, dynamic> draftData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('draft_data', draftData.toString());
      await prefs.setString(
        'draft_timestamp',
        DateTime.now().toIso8601String(),
      );

      if (kDebugMode) {
        debugPrint('Draft saved');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error saving draft: $e');
      }
    }
  }

  // Get saved draft
  static Future<Map<String, dynamic>?> getSavedDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftData = prefs.getString('draft_data');
      final draftTimestamp = prefs.getString('draft_timestamp');

      if (draftData != null && draftTimestamp != null) {
        final timestamp = DateTime.parse(draftTimestamp);
        final now = DateTime.now();

        // Draft expires after 7 days
        if (now.difference(timestamp).inDays < 7) {
          return {'data': draftData, 'timestamp': timestamp};
        } else {
          // Remove expired draft
          await clearDraft();
        }
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting saved draft: $e');
      }
      return null;
    }
  }

  // Clear draft
  static Future<void> clearDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('draft_data');
      await prefs.remove('draft_timestamp');

      if (kDebugMode) {
        debugPrint('Draft cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error clearing draft: $e');
      }
    }
  }
}
