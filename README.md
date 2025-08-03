# 📚 Joki Tugas App

Aplikasi Flutter modern untuk layanan joki tugas dengan desain yang menarik dan user experience yang optimal.

## ✨ Fitur Utama

### 🎨 Splash Screen

- **Animasi Loading Menarik**: Custom loading widget dengan animasi berputar
- **Gradient Background**: Latar belakang gradient yang eye-catching dengan warna-warna calming
- **Smooth Transitions**: Transisi halus dengan fade effect menuju halaman auth
- **Brand Identity**: Logo dan nama aplikasi dengan animasi yang elegant

### 🔐 Authentication

- **Login & Register**: Formulir login dan registrasi dengan validasi lengkap
- **Tab Navigation**: Navigasi tab yang smooth antara login dan register
- **Social Login**: Integrasi dengan Google dan Facebook (UI ready)
- **Password Toggle**: Fitur show/hide password dengan icon FontAwesome
- **Input Validation**: Validasi real-time untuk email, password, dan konfirmasi password
- **Responsive Design**: Layout yang responsif untuk berbagai ukuran layar

### 🏠 Dashboard

- **Bottom Navigation**: Navigasi bawah dengan 3 tab utama (Beranda, Pesanan, Profil)
- **Quick Stats**: Kartu statistik untuk tugas selesai dan dalam proses
- **Service Cards**: Grid layanan dengan icon dan warna yang berbeda
- **User Profile**: Header dengan informasi pengguna dan notifikasi

### 📋 Pesanan

- **Order List**: Daftar pesanan dengan status dan detail
- **Status Badges**: Badge status dengan warna yang berbeda (Selesai, Proses)
- **Order Details**: Informasi lengkap pesanan termasuk deadline dan harga

### 👤 Profil

- **User Info**: Informasi profil pengguna dengan avatar
- **Menu Items**: Menu navigasi dengan icon FontAwesome
- **Settings**: Berbagai pengaturan aplikasi

## 🎨 Design System

### Warna Utama

- **Primary**: `#6B73FF` (Ungu-biru yang calming)
- **Secondary**: `#9B59B6` (Ungu muda)
- **Gradient**: Kombinasi warna yang memberikan efek modern dan menenangkan

### Typography

- **Font**: Google Fonts Poppins untuk readability yang optimal
- **Hierarchy**: Sistem typography yang konsisten dengan berbagai ukuran

### Komponen

- **Buttons**: Gradient buttons dengan shadow effect
- **Input Fields**: Rounded input dengan prefix icons
- **Cards**: Material design cards dengan elevation
- **Loading**: Custom loading widget dengan animasi

## 🛠 Teknologi

- **Framework**: Flutter 3.7.2+
- **Language**: Dart
- **State Management**: StatefulWidget
- **Animations**: flutter_animate package
- **Icons**: FontAwesome icons
- **Typography**: Google Fonts
- **Design**: Material Design 3

## 📱 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  font_awesome_flutter: ^10.7.0
  lottie: ^3.1.2
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.0
```

## 🚀 Instalasi dan Menjalankan

1. **Clone Repository**

   ```bash
   git clone <repository-url>
   cd joki_app
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Jalankan Aplikasi**

   ```bash
   # Untuk Windows
   flutter run -d windows

   # Untuk Web Browser
   flutter run -d chrome

   # Untuk Android Emulator
   flutter run -d android
   ```

## 📁 Struktur Proyek

```
lib/
├── main.dart                 # Entry point aplikasi
├── constants/
│   └── app_constants.dart    # Konstanta warna, ukuran, dan styling
├── screens/
│   ├── splash_screen.dart    # Halaman splash dengan animasi
│   ├── auth_screen.dart      # Halaman login/register
│   └── home_screen.dart      # Halaman utama dengan bottom nav
├── widgets/
│   └── custom_loading.dart   # Widget loading custom
└── routes/
    └── app_routes.dart       # Pengaturan routing aplikasi
```

## 🎯 Fitur yang Sudah Diimplementasi

- ✅ Splash screen dengan animasi
- ✅ Login/Register form dengan validasi
- ✅ Navigation antar halaman
- ✅ Bottom navigation
- ✅ Dashboard dengan statistik
- ✅ Daftar pesanan
- ✅ Halaman profil
- ✅ Custom loading animation
- ✅ Responsive design
- ✅ Material Design 3
- ✅ Dark/Light theme support

## 🔮 Pengembangan Selanjutnya

- [ ] Integrasi dengan backend API
- [ ] Database lokal dengan SQLite
- [ ] Push notifications
- [ ] Payment gateway integration
- [ ] Chat system
- [ ] File upload/download
- [ ] Advanced search and filter
- [ ] Multi-language support

## 📸 Screenshots

Aplikasi ini memiliki:

1. **Splash Screen**: Background gradient dengan logo animated dan loading spinner
2. **Auth Screen**: Tab-based login/register dengan social media buttons
3. **Home Dashboard**: Bottom navigation dengan stats cards dan service grid
4. **Orders Page**: List view dengan order status badges
5. **Profile Page**: User info dengan settings menu

## 🏆 Keunggulan

- **Modern UI/UX**: Design yang mengikuti tren terkini
- **Smooth Animations**: Animasi yang halus dan tidak mengganggu
- **Calming Colors**: Pemilihan warna yang nyaman di mata
- **Responsive**: Bekerja dengan baik di berbagai ukuran layar
- **Clean Code**: Struktur kode yang rapi dan mudah di-maintain
- **Reusable Components**: Komponen yang dapat digunakan ulang

---

_Dibuat dengan ❤️ menggunakan Flutter_
