import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class PasswordResetService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Mengirim email reset password ke alamat email yang diberikan
  static Future<Map<String, dynamic>> sendPasswordResetEmail(
    String email,
  ) async {
    try {
      // Validasi format email
      if (email.isEmpty) {
        return {'success': false, 'message': 'Email tidak boleh kosong'};
      }

      if (!_isValidEmail(email)) {
        return {'success': false, 'message': 'Format email tidak valid'};
      }

      // Kirim email reset password
      await _auth.sendPasswordResetEmail(email: email.trim());

      return {
        'success': true,
        'message':
            'Email reset password telah dikirim ke $email. Silakan cek inbox atau spam folder Anda.',
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage =
              'Email tidak ditemukan. Pastikan email sudah terdaftar.';
          break;
        case 'invalid-email':
          errorMessage = 'Format email tidak valid.';
          break;
        case 'too-many-requests':
          errorMessage = 'Terlalu banyak permintaan. Silakan coba lagi nanti.';
          break;
        case 'network-request-failed':
          errorMessage = 'Koneksi internet bermasalah. Periksa koneksi Anda.';
          break;
        default:
          errorMessage = 'Terjadi kesalahan: ${e.message}';
      }

      if (kDebugMode) {
        debugPrint('Password reset error: ${e.code} - ${e.message}');
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Unexpected error in password reset: $e');
      }

      return {
        'success': false,
        'message': 'Terjadi kesalahan yang tidak diketahui. Silakan coba lagi.',
      };
    }
  }

  /// Memeriksa apakah email sudah terdaftar di Firebase Auth
  /// Note: Using createUserWithEmailAndPassword untuk check existence karena
  /// fetchSignInMethodsForEmail is deprecated for security reasons
  static Future<bool> checkEmailExists(String email) async {
    try {
      // Alternative method: Try to send password reset email
      // Jika email tidak ada, akan throw error
      await _auth.sendPasswordResetEmail(email: email.trim());
      return true; // Email exists if no exception thrown
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return false; // Email doesn't exist
      }
      // For other errors, assume email exists for security
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error checking email existence: $e');
      }
      return false;
    }
  }

  /// Validasi format email menggunakan regex
  static bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email.trim());
  }

  /// Public method untuk validasi email (bisa digunakan di UI)
  static bool isValidEmail(String email) {
    return _isValidEmail(email);
  }

  /// Mendapatkan pesan error berdasarkan kode Firebase Auth
  static String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Email tidak ditemukan. Pastikan email sudah terdaftar.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'too-many-requests':
        return 'Terlalu banyak permintaan. Silakan coba lagi nanti.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Periksa koneksi Anda.';
      case 'invalid-action-code':
        return 'Kode reset tidak valid atau sudah kedaluwarsa.';
      case 'expired-action-code':
        return 'Kode reset sudah kedaluwarsa. Silakan minta reset ulang.';
      case 'weak-password':
        return 'Password terlalu lemah. Gunakan kombinasi huruf, angka, dan simbol.';
      default:
        return 'Terjadi kesalahan yang tidak diketahui.';
    }
  }

  /// Konfirmasi reset password (untuk digunakan di deep link jika diperlukan)
  static Future<Map<String, dynamic>> confirmPasswordReset(
    String code,
    String newPassword,
  ) async {
    try {
      if (newPassword.length < 6) {
        return {'success': false, 'message': 'Password minimal 6 karakter'};
      }

      await _auth.confirmPasswordReset(code: code, newPassword: newPassword);

      return {
        'success': true,
        'message':
            'Password berhasil direset. Silakan login dengan password baru.',
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'invalid-action-code':
          errorMessage = 'Kode reset tidak valid atau sudah kedaluwarsa.';
          break;
        case 'expired-action-code':
          errorMessage =
              'Kode reset sudah kedaluwarsa. Silakan minta reset ulang.';
          break;
        case 'weak-password':
          errorMessage =
              'Password terlalu lemah. Gunakan kombinasi huruf, angka, dan simbol.';
          break;
        default:
          errorMessage = 'Terjadi kesalahan: ${e.message}';
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan yang tidak diketahui.',
      };
    }
  }

  /// Verifikasi kode reset password
  static Future<bool> verifyPasswordResetCode(String code) async {
    try {
      await _auth.verifyPasswordResetCode(code);
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error verifying password reset code: $e');
      }
      return false;
    }
  }
}
