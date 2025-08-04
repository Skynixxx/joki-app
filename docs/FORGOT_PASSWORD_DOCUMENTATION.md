# Fitur Lupa Password - Dokumentasi

## Overview

Fitur lupa password memungkinkan pengguna untuk mereset password mereka melalui email menggunakan Firebase Authentication. Fitur ini terintegrasi penuh dengan sistem autentikasi yang sudah ada.

## Komponen yang Dibuat

### 1. PasswordResetService (`lib/services/password_reset_service.dart`)

Service utama yang menangani logika reset password:

#### Methods:

- `sendPasswordResetEmail(String email)` - Mengirim email reset password
- `checkEmailExists(String email)` - Memeriksa apakah email terdaftar
- `confirmPasswordReset(String code, String newPassword)` - Konfirmasi reset password
- `verifyPasswordResetCode(String code)` - Verifikasi kode reset
- `isValidEmail(String email)` - Validasi format email
- `getErrorMessage(String errorCode)` - Mendapatkan pesan error yang user-friendly

#### Error Handling:

- `user-not-found`: Email tidak ditemukan
- `invalid-email`: Format email tidak valid
- `too-many-requests`: Terlalu banyak permintaan
- `network-request-failed`: Masalah koneksi internet
- `invalid-action-code`: Kode reset tidak valid/expired
- `weak-password`: Password terlalu lemah

### 2. ForgotPasswordScreen (`lib/screens/forgot_password_screen.dart`)

UI screen untuk fitur lupa password:

#### Fitur UI:

- Form input email dengan validasi
- Loading state saat mengirim email
- Success state dengan konfirmasi email terkirim
- Error handling dengan snackbar
- Tombol untuk mengirim ulang email
- Animasi yang menarik menggunakan flutter_animate
- Design yang konsisten dengan tema aplikasi

#### States:

- `_isLoading`: State untuk loading saat mengirim email
- `_emailSent`: State untuk konfirmasi email telah dikirim

### 3. Integration di AuthScreen

Menambahkan tombol "Lupa Password?" di halaman login:

- Ditempatkan setelah tombol login
- Navigasi ke `/forgot-password` route
- Styling konsisten dengan tema aplikasi

### 4. Route Configuration

Menambahkan route baru di `main.dart`:

```dart
'/forgot-password': (context) => const ForgotPasswordScreen(),
```

## Cara Menggunakan

### Dari Sisi User:

1. Di halaman login, klik tombol "Lupa Password?"
2. Masukkan email yang terdaftar
3. Klik "Kirim Email Reset"
4. Cek email (termasuk folder spam)
5. Klik link di email untuk reset password
6. Masukkan password baru di halaman Firebase
7. Kembali ke aplikasi dan login dengan password baru

### Dari Sisi Developer:

```dart
// Mengirim email reset password
final result = await PasswordResetService.sendPasswordResetEmail('user@example.com');

if (result['success']) {
  // Email berhasil dikirim
  print(result['message']);
} else {
  // Terjadi error
  print(result['message']);
}

// Validasi email
bool isValid = PasswordResetService.isValidEmail('user@example.com');

// Cek apakah email sudah terdaftar
bool exists = await PasswordResetService.checkEmailExists('user@example.com');
```

## Keamanan

### Firebase Security:

- Menggunakan Firebase Authentication untuk keamanan
- Link reset password memiliki expired time
- Email verification untuk memastikan ownership
- Password baru harus memenuhi kriteria Firebase

### App Security:

- Validasi input email di frontend
- Rate limiting untuk mencegah spam
- Error messages yang tidak memberikan informasi sensitif
- Proper error handling untuk semua edge cases

## Testing

### Test Cases:

1. **Email Valid**:

   - Input: email yang terdaftar
   - Expected: Email reset terkirim

2. **Email Tidak Terdaftar**:

   - Input: email yang belum terdaftar
   - Expected: Error "Email tidak ditemukan"

3. **Email Invalid**:

   - Input: format email salah
   - Expected: Error validasi format

4. **Network Error**:

   - Kondisi: Tidak ada internet
   - Expected: Error koneksi

5. **Too Many Requests**:
   - Kondisi: Spam request
   - Expected: Error rate limit

### Manual Testing:

1. Buka aplikasi dan pergi ke halaman login
2. Klik "Lupa Password?"
3. Test dengan berbagai skenario email
4. Verifikasi email diterima di inbox
5. Test link reset password dari email

## Konfigurasi Firebase

### Pastikan di Firebase Console:

1. Authentication > Settings > Authorized domains sudah benar
2. Authentication > Templates > Password reset template sudah dikustomisasi
3. Authentication > Settings > Email verification template aktif

### Custom Email Template (Opsional):

Bisa dikustomisasi di Firebase Console untuk branding yang lebih baik.

## Troubleshooting

### Common Issues:

1. **Email tidak masuk**: Cek spam folder, pastikan domain authorized di Firebase
2. **Link expired**: Minta reset ulang, link Firebase biasanya expire dalam 1 jam
3. **Password terlalu lemah**: Firebase memiliki requirement minimal 6 karakter
4. **Rate limiting**: Tunggu beberapa menit sebelum mencoba lagi

### Debug Mode:

Service menggunakan `kDebugMode` untuk logging error di development:

```dart
if (kDebugMode) {
  debugPrint('Password reset error: ${e.code} - ${e.message}');
}
```

## Future Enhancements

### Possible Improvements:

1. **Custom Reset Page**: Membuat halaman reset password di dalam aplikasi
2. **SMS Reset**: Alternatif reset via SMS
3. **Biometric Reset**: Reset menggunakan biometrik untuk user yang pernah login
4. **Security Questions**: Tambahan layer keamanan
5. **Email Customization**: Template email yang lebih branded
6. **Analytics**: Tracking usage fitur lupa password

### Deep Link Integration:

Untuk pengalaman yang lebih seamless, bisa menambahkan deep link handling untuk langsung membuka aplikasi dari email reset.

## Dependencies

Fitur ini menggunakan:

- `firebase_auth`: ^5.7.0 (Firebase Authentication)
- `flutter_animate`: ^4.5.0 (Animasi UI)
- Material Design 3 components
- Built-in Flutter validation

## Conclusion

Fitur lupa password telah terintegrasi penuh dengan sistem autentikasi aplikasi. Implementasi mengikuti best practices untuk keamanan dan user experience. Fitur siap untuk production dengan proper error handling dan user feedback.
