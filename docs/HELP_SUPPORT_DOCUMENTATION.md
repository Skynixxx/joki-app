# 🆘 Bantuan & Support Documentation

## Overview

Halaman Bantuan & Support adalah fitur komprehensif yang menyediakan berbagai cara untuk user menghubungi developer, admin, dan tim support aplikasi Joki Tugas. Halaman ini dirancang untuk memberikan solusi cepat dan mudah bagi user yang membutuhkan bantuan.

## Fitur Utama

### 🚀 Quick Actions

- **Live Chat**: Akses cepat untuk chat langsung dengan admin
- **Telepon**: Hubungi hotline support secara langsung

### 📞 Contact Options

1. **WhatsApp Developer**

   - Chat langsung dengan developer aplikasi
   - Untuk konsultasi teknis dan pengembangan
   - Nomor: +62 812-3456-7890 (contoh)

2. **Telegram Admin**

   - Chat dengan admin aplikasi
   - Untuk bantuan umum dan operasional
   - Username: @jokitugas_admin

3. **Email Support**

   - Kirim email ke tim support
   - Untuk laporan bug dan pertanyaan detail
   - Email: support@jokitugas.com

4. **Admin Panel Web**

   - Akses ke halaman admin (khusus admin)
   - URL: admin.jokitugas.com
   - Untuk manajemen aplikasi dari sisi web

5. **GitHub Repository**
   - Akses source code
   - Laporkan bug atau request fitur
   - URL: github.com/Skynixxx/joki-app

### ❓ FAQ Section

Berisi pertanyaan umum dan jawaban yang sering ditanyakan user:

- Cara memesan jasa tugas
- Waktu pengerjaan
- Sistem pembayaran
- Garansi revisi

### ℹ️ App Information

Menampilkan informasi aplikasi:

- Versi aplikasi
- Developer name
- Build number

## Technical Implementation

### Dependencies

```yaml
url_launcher: ^6.2.4 # Untuk membuka URL eksternal
```

### Key Methods

#### 1. Phone Call

```dart
void _makePhoneCall(BuildContext context) async {
  final phoneNumber = 'tel:+6281234567890';
  if (await canLaunchUrl(Uri.parse(phoneNumber))) {
    await launchUrl(Uri.parse(phoneNumber));
  }
}
```

#### 2. WhatsApp Integration

```dart
void _openWhatsApp(BuildContext context, String type) async {
  String phoneNumber = type == 'developer' ? '6281234567890' : '6289876543210';
  String message = 'Halo, saya ingin berkonsultasi mengenai aplikasi Joki Tugas';

  final whatsappUrl = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';
  await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
}
```

#### 3. Email Support

```dart
void _sendEmail(BuildContext context) async {
  const email = 'support@jokitugas.com';
  const subject = 'Bantuan Aplikasi Joki Tugas';
  const body = 'Halo Tim Support,\n\nSaya memerlukan bantuan...';

  final emailUrl = 'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
  await launchUrl(Uri.parse(emailUrl));
}
```

#### 4. External URLs

```dart
void _openAdminPanel(BuildContext context) async {
  const adminUrl = 'https://admin.jokitugas.com';
  await launchUrl(Uri.parse(adminUrl), mode: LaunchMode.externalApplication);
}
```

## UI/UX Design

### Design Principles

- **Accessibility First**: Mudah ditemukan dan digunakan
- **Clear Hierarchy**: Informasi tersusun dengan baik
- **Visual Feedback**: Animasi dan feedback yang jelas
- **Responsive**: Adaptif untuk berbagai ukuran layar

### Color Scheme

- **Primary Actions**: AppColors.primary (#6B73FF)
- **WhatsApp**: #25D366
- **Telegram**: #0088CC
- **Email**: AppColors.error (Red)
- **GitHub**: #333333

### Animations

```dart
.animate().fadeIn(delay: 100.ms).scale(delay: 100.ms)  // Header
.animate().fadeIn(delay: 400.ms).slideX(begin: -0.3)   // Quick Actions
.animate().fadeIn(delay: 500.ms).slideX(begin: 0.3)    // Contact Cards
.animate().fadeIn(delay: 600.ms)                       // FAQ Items
```

## Setup Instructions

### 1. Contact Information Setup

Update contact details di help_support_screen.dart:

```dart
// WhatsApp Numbers
String phoneNumber = type == 'developer'
  ? '6281234567890'  // Ganti dengan nomor developer
  : '6289876543210'; // Ganti dengan nomor admin

// Telegram
const telegramUrl = 'https://t.me/jokitugas_admin'; // Update username

// Email
const email = 'support@jokitugas.com'; // Update email support

// Admin Panel
const adminUrl = 'https://admin.jokitugas.com'; // Update URL admin panel

// GitHub
const githubUrl = 'https://github.com/Skynixxx/joki-app'; // Update repo URL
```

### 2. URL Launcher Configuration

#### Android (android/app/src/main/AndroidManifest.xml)

```xml
<queries>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="https" />
  </intent>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="http" />
  </intent>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="tel" />
  </intent>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="mailto" />
  </intent>
</queries>
```

#### iOS (ios/Runner/Info.plist)

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>https</string>
  <string>http</string>
  <string>tel</string>
  <string>mailto</string>
</array>
```

## Navigation

### From Home Screen

```dart
// ProfileTab menu item
_ProfileMenuItem(
  icon: FontAwesomeIcons.headset,
  title: 'Bantuan & Support',
  onTap: () {
    Navigator.pushNamed(context, '/help-support');
  },
),
```

### Route Configuration

```dart
// main.dart
routes: {
  '/help-support': (context) => const HelpSupportScreen(),
},
```

## Error Handling

### URL Launch Failures

```dart
if (await canLaunchUrl(Uri.parse(url))) {
  await launchUrl(Uri.parse(url));
} else {
  if (context.mounted) {
    AppHelpers.showError(context, 'Tidak dapat membuka aplikasi');
  }
}
```

### Common Issues

1. **App tidak terinstall**: WhatsApp/Telegram tidak terinstall
2. **Permission denied**: Android permission untuk phone calls
3. **Invalid URL**: URL format tidak benar
4. **Network issues**: Tidak ada koneksi internet

## Maintenance

### Regular Updates

1. **Contact Information**: Update nomor/email secara berkala
2. **FAQ Content**: Tambah pertanyaan baru sesuai feedback user
3. **App Version**: Update versi aplikasi di app info
4. **URL Validity**: Pastikan semua URL masih aktif

### Analytics Tracking

Tambahkan tracking untuk:

- Contact method yang paling sering digunakan
- FAQ items yang sering dibuka
- Error rate untuk URL launches

## Security Considerations

### Contact Information

- Jangan hardcode sensitive information
- Gunakan environment variables untuk production
- Validate URLs sebelum launch

### External Links

- Pastikan URL aman dan terpercaya
- Implement URL validation
- Monitor external link clicks

## Future Enhancements

### Phase 1

1. **In-App Chat**: Chat langsung dalam aplikasi
2. **Ticket System**: Sistem tiket support
3. **Knowledge Base**: Database artikel bantuan

### Phase 2

1. **Video Call Support**: Support video call
2. **Screen Sharing**: Remote assistance
3. **AI Chatbot**: Automated responses untuk pertanyaan umum

### Phase 3

1. **Community Forum**: Forum komunitas user
2. **Tutorial Videos**: Video tutorial dalam app
3. **Live Support Hours**: Jadwal support real-time

## Best Practices

### User Experience

1. **Quick Access**: Menu bantuan mudah ditemukan
2. **Multiple Channels**: Berikan beberapa opsi kontak
3. **Clear Expectations**: Jelaskan response time
4. **Follow Up**: System untuk follow up issues

### Technical

1. **Error Handling**: Graceful handling untuk failures
2. **Performance**: Optimized loading dan animations
3. **Accessibility**: Support screen readers dan keyboard navigation
4. **Testing**: Comprehensive testing untuk semua contact methods

## Integration dengan Admin Panel Web

### Admin Features yang Direncanakan

1. **User Management**: Kelola akun user
2. **Order Management**: Monitor dan kelola pesanan
3. **Analytics Dashboard**: Statistik penggunaan app
4. **Content Management**: Update FAQ dan informasi
5. **Support Ticket System**: Kelola tiket support
6. **Notification System**: Kirim notifikasi ke users

### Technical Stack (Rencana)

- **Backend**: Node.js/Express atau Laravel
- **Database**: PostgreSQL atau MongoDB
- **Frontend**: React.js atau Vue.js
- **Authentication**: JWT tokens
- **Real-time**: Socket.io untuk live updates

### API Integration

```dart
// Future API calls untuk admin panel
class AdminApiService {
  static Future<void> submitSupportTicket(String issue) async {
    // API call ke admin panel
  }

  static Future<List<FAQ>> getFAQs() async {
    // Fetch FAQ dari admin panel
  }
}
```

Halaman Bantuan & Support ini memberikan foundation yang kuat untuk customer support dan komunikasi antara user dengan tim pengembang aplikasi.
