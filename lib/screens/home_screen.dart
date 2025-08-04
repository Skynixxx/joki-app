import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';
import '../services/auth_service.dart';
import '../utils/app_helpers.dart';
import 'auth_screen.dart';
import 'edit_profile_screen.dart';
import '../widgets/profile_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [DashboardTab(), OrdersTab(), ProfileTab()],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTextStyles.caption,
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.house, size: 20),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.clipboardList, size: 20),
              label: 'Pesanan',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user, size: 20),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                ProfileAvatar(
                  imageUrl: AuthService.currentUser?.photoUrl,
                  radius: 24,
                ),
                const SizedBox(width: AppSizes.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat datang!',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        AuthService.currentUser?.name ?? 'User',
                        style: AppTextStyles.headline4.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.bell,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),

            const SizedBox(height: AppSizes.paddingXL),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: FontAwesomeIcons.clipboardCheck,
                    title: 'Tugas Selesai',
                    value: '12',
                    color: AppColors.success,
                  ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
                ),
                const SizedBox(width: AppSizes.paddingM),
                Expanded(
                  child: _StatCard(
                    icon: FontAwesomeIcons.clock,
                    title: 'Dalam Proses',
                    value: '3',
                    color: AppColors.warning,
                  ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.paddingXL),

            // Services Section
            Text(
              'Layanan Kami',
              style: AppTextStyles.headline3.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 300.ms),

            const SizedBox(height: AppSizes.paddingL),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: AppSizes.paddingM,
              mainAxisSpacing: AppSizes.paddingM,
              childAspectRatio: 1.1,
              children:
                  [
                    _ServiceCard(
                      icon: FontAwesomeIcons.laptop,
                      title: 'Tugas Kuliah',
                      description: 'Bantuan tugas dan skripsi',
                    ),
                    _ServiceCard(
                      icon: FontAwesomeIcons.graduationCap,
                      title: 'Ujian Online',
                      description: 'Bantuan ujian dan kuis',
                    ),
                    _ServiceCard(
                      icon: FontAwesomeIcons.code,
                      title: 'Programming',
                      description: 'Project coding & website',
                    ),
                    _ServiceCard(
                      icon: FontAwesomeIcons.fileLines,
                      title: 'Makalah',
                      description: 'Penulisan paper & artikel',
                    ),
                  ].asMap().entries.map((entry) {
                    return entry.value
                        .animate()
                        .fadeIn(
                          duration: 600.ms,
                          delay: (400 + entry.key * 100).ms,
                        )
                        .slideY(begin: 0.3);
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: AppDecorations.cardDecoration.copyWith(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(icon, color: color, size: 24),
          const SizedBox(height: AppSizes.paddingM),
          Text(
            value,
            style: AppTextStyles.headline3.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: AppDecorations.cardDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: FaIcon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: AppSizes.paddingM),
          Text(
            title,
            style: AppTextStyles.headline4.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            description,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pesanan Saya',
              style: AppTextStyles.headline3.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 600.ms),

            const SizedBox(height: AppSizes.paddingL),

            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _OrderCard(
                        title: 'Tugas Algoritma ${index + 1}',
                        subject: 'Struktur Data',
                        status:
                            index % 3 == 0
                                ? 'Selesai'
                                : index % 3 == 1
                                ? 'Proses'
                                : 'Menunggu',
                        price: 'Rp ${(50 + index * 25)}.000',
                        date: '${20 + index} Jul 2025',
                      )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: (index * 100).ms)
                      .slideX(begin: 0.3);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String title;
  final String subject;
  final String status;
  final String price;
  final String date;

  const _OrderCard({
    required this.title,
    required this.subject,
    required this.status,
    required this.price,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor =
        status == 'Selesai'
            ? AppColors.success
            : status == 'Proses'
            ? AppColors.warning
            : AppColors.info;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: AppDecorations.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.headline4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingS,
                  vertical: AppSizes.paddingXS,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusS),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  status,
                  style: AppTextStyles.caption.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            subject,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: AppTextStyles.headline4.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                date,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.paddingXL),
              decoration: AppDecorations.cardDecoration,
              child: Column(
                children: [
                  ProfileAvatar(
                    imageUrl: AuthService.currentUser?.photoUrl,
                    radius: 40,
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  Text(
                    AuthService.currentUser?.name ?? 'User',
                    style: AppTextStyles.headline3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AuthService.currentUser?.email ?? 'user@email.com',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms),

            const SizedBox(height: AppSizes.paddingL),

            // Menu Items
            Expanded(
              child: Column(
                children:
                    [
                          _ProfileMenuItem(
                            icon: FontAwesomeIcons.user,
                            title: 'Edit Profil',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const EditProfileScreen(),
                                ),
                              );
                            },
                          ),
                          _ProfileMenuItem(
                            icon: FontAwesomeIcons.creditCard,
                            title: 'Metode Pembayaran',
                            onTap: () {},
                          ),
                          _ProfileMenuItem(
                            icon: FontAwesomeIcons.headset,
                            title: 'Bantuan & Support',
                            onTap: () {
                              Navigator.pushNamed(context, '/help-support');
                            },
                          ),
                          _ProfileMenuItem(
                            icon: FontAwesomeIcons.shield,
                            title: 'Kebijakan Privasi',
                            onTap: () {},
                          ),
                          _ProfileMenuItem(
                            icon: FontAwesomeIcons.arrowRightFromBracket,
                            title: 'Keluar',
                            onTap: () => _showLogoutDialog(context),
                            isDestructive: true,
                          ),
                        ]
                        .asMap()
                        .entries
                        .map(
                          (entry) => entry.value
                              .animate()
                              .fadeIn(
                                duration: 600.ms,
                                delay: (entry.key * 100).ms,
                              )
                              .slideX(begin: 0.3),
                        )
                        .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Function untuk menampilkan dialog konfirmasi logout
void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
        title: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.arrowRightFromBracket,
              color: AppColors.error,
              size: 20,
            ),
            const SizedBox(width: AppSizes.paddingS),
            Text(
              'Konfirmasi Keluar',
              style: AppTextStyles.headline4.copyWith(color: AppColors.error),
            ),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari aplikasi?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Batal',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            child: TextButton(
              onPressed: () async {
                // Tutup dialog
                Navigator.of(context).pop();

                // Tampilkan loading
                AppHelpers.showLoadingDialog(context, message: 'Keluar...');

                // Lakukan logout
                await AuthService.logout();

                // Tutup loading dan navigasi ke auth screen
                if (context.mounted) {
                  AppHelpers.hideLoadingDialog(context);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                    (route) => false, // Hapus semua route sebelumnya
                  );
                  AppHelpers.showSuccess(context, 'Berhasil keluar!');
                }
              },
              child: const Text(
                'Keluar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingS),
      child: ListTile(
        leading: FaIcon(
          icon,
          color: isDestructive ? AppColors.error : AppColors.textSecondary,
          size: 20,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
          ),
        ),
        trailing: FaIcon(
          FontAwesomeIcons.chevronRight,
          color: AppColors.textSecondary,
          size: 16,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
        tileColor: AppColors.backgroundCard,
      ),
    );
  }
}
