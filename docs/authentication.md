# 🔐 Authentication System Documentation

## Overview

Sistem autentikasi aplikasi Joki Tugas menggunakan Firebase Authentication dengan dukungan login via email/password dan Google Sign-In.

## Architecture

### AuthService (`lib/services/auth_service.dart`)

Service utama untuk menangani semua operasi autentikasi:

#### Core Methods:

- `initialize()` - Inisialisasi dan cek status login
- `login(email, password)` - Login dengan email/password
- `register(name, email, password)` - Registrasi user baru
- `loginWithGoogle()` - Login dengan Google
- `logout()` - Logout dan clear session
- `currentUser` - Getter untuk user saat ini
- `isLoggedIn` - Check status login

#### Session Management:

Terintegrasi dengan `SessionManager` dan `PersistentLoginService` untuk:

- Auto-logout setelah 10 menit idle
- Persistent login state
- Session restoration saat app restart

### User Model (`lib/models/user.dart`)

Model data user sederhana untuk aplikasi:

```dart
class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### UserModel (`lib/models/user_model.dart`)

Model data user untuk Firebase Firestore:

```dart
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? updatedAt;
}
```

## Authentication Flow

### 1. Registration Flow

```
User Input → Validation → Firebase Auth → Firestore User Doc → Update UI
```

### 2. Login Flow

```
User Input → Firebase Auth → Fetch Firestore Data → Set Current User → Navigate
```

### 3. Google Sign-In Flow

```
Google Sign-In → Firebase Credential → Save/Update Firestore → Set Current User
```

### 4. Session Management

```
App Start → Check Persistent Login → Restore Session → Auto-logout Timer
```

## Security Features

### Firebase Authentication

- Email/password validation
- Google OAuth integration
- Secure token management
- Password reset via email

### Session Security

- 10-minute auto-logout
- Activity detection for timer reset
- Secure session persistence
- Draft saving before logout

### Data Protection

- User data stored in Firestore
- Environment-based Firebase config
- Proper error handling
- No sensitive data in logs (production)

## Configuration

### Firebase Setup

1. Create Firebase project
2. Enable Authentication methods
3. Configure Google Sign-In
4. Update `lib/config/firebase_config.dart`

### Google Sign-In

1. Configure OAuth consent screen
2. Download `google-services.json` (Android)
3. Update client IDs in configuration
4. Add authorized domains

## Usage Examples

### Basic Login

```dart
final user = await AuthService.login(email, password);
if (user != null) {
  // Navigate to home
} else {
  // Show error
}
```

### Google Sign-In

```dart
final user = await AuthService.loginWithGoogle();
if (user != null) {
  // Navigate to home
} else {
  // Show error
}
```

### Check Login Status

```dart
if (AuthService.isLoggedIn) {
  final currentUser = AuthService.currentUser;
  // Use current user data
}
```

### Logout

```dart
await AuthService.logout();
// Navigate to login screen
```

## Error Handling

### Common Error Cases:

- Network connectivity issues
- Invalid credentials
- Firebase configuration errors
- Google Sign-In cancellation
- Session expiration

### Error Response Format:

```dart
// Methods return null on error
final user = await AuthService.login(email, password);
if (user == null) {
  // Handle error - show user-friendly message
}
```

## Testing

### Manual Testing Checklist:

- [ ] Email/password registration
- [ ] Email/password login
- [ ] Google Sign-In
- [ ] Invalid credentials handling
- [ ] Network error handling
- [ ] Session persistence
- [ ] Auto-logout functionality
- [ ] Password reset

### Test Accounts:

Use Firebase Authentication test accounts for development.

## Future Enhancements

### Planned Features:

1. **Two-Factor Authentication (2FA)**
2. **Biometric Authentication**
3. **Social Login** (Apple, additional providers)
4. **Email Verification** flow
5. **Account Linking** (multiple providers)
6. **Advanced Session Management**

### Security Improvements:

1. **Rate Limiting** for login attempts
2. **Device Registration** and tracking
3. **Suspicious Activity** detection
4. **Account Recovery** options
5. **Privacy Controls** for user data

## Troubleshooting

### Common Issues:

1. **Google Sign-In not working:**

   - Check client ID configuration
   - Verify SHA-1 fingerprints
   - Ensure authorized domains are set

2. **Firebase connection errors:**

   - Verify Firebase configuration
   - Check network connectivity
   - Validate API keys

3. **Session not persisting:**
   - Check SharedPreferences implementation
   - Verify session timeout settings
   - Ensure proper initialization

### Debug Mode:

Enable debug logging in development:

```dart
if (kDebugMode) {
  debugPrint('Auth error: $error');
}
```

## Dependencies

### Required Packages:

- `firebase_core` - Firebase initialization
- `firebase_auth` - Authentication
- `cloud_firestore` - User data storage
- `google_sign_in` - Google OAuth
- `shared_preferences` - Session persistence

### Version Compatibility:

See `pubspec.yaml` for current versions and compatibility matrix.
