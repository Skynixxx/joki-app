import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';
import '../utils/app_helpers.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Bantuan & Support',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderSection(),

            const SizedBox(height: AppSizes.paddingXL),

            // Quick Actions
            _buildQuickActions(context),

            const SizedBox(height: AppSizes.paddingXL),

            // Contact Options
            _buildContactSection(context),

            const SizedBox(height: AppSizes.paddingXL),

            // FAQ Section
            _buildFAQSection(),

            const SizedBox(height: AppSizes.paddingXL),

            // App Info
            _buildAppInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.support_agent,
            size: 60,
            color: Colors.white,
          ).animate().scale(delay: 100.ms),

          const SizedBox(height: AppSizes.paddingM),

          Text(
            'Kami Siap Membantu Anda',
            style: AppTextStyles.headline3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: AppSizes.paddingS),

          Text(
            'Tim support kami tersedia 24/7 untuk membantu menyelesaikan masalah Anda',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aksi Cepat',
          style: AppTextStyles.headline4.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: AppSizes.paddingM),

        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.chat_bubble_outline,
                title: 'Live Chat',
                subtitle: 'Chat langsung dengan admin',
                color: Colors.green,
                onTap: () => _openLiveChat(context),
              ),
            ),

            const SizedBox(width: AppSizes.paddingM),

            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.phone_outlined,
                title: 'Telepon',
                subtitle: 'Hubungi hotline kami',
                color: Colors.blue,
                onTap: () => _makePhoneCall(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
              ),
              child: Icon(icon, color: color, size: 24),
            ),

            const SizedBox(height: AppSizes.paddingS),

            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: AppSizes.paddingXS),

            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.3);
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hubungi Kami',
          style: AppTextStyles.headline4.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: AppSizes.paddingM),

        _buildContactCard(
          icon: FontAwesomeIcons.whatsapp,
          title: 'WhatsApp Developer',
          subtitle: 'Chat dengan Muhammad Fikri Haikal',
          value: '+62 0812-4699-5873',
          color: const Color(0xFF25D366),
          onTap: () => _openWhatsApp(context, 'developer'),
        ),

        const SizedBox(height: AppSizes.paddingM),

        _buildContactCard(
          icon: FontAwesomeIcons.envelope,
          title: 'Email Developer',
          subtitle: 'Kirim email ke Muhammad Fikri Haikal',
          value: 'fikrihaikal170308@gmail.com',
          color: AppColors.error,
          onTap: () => _sendEmail(context),
        ),

        const SizedBox(height: AppSizes.paddingM),

        _buildContactCard(
          icon: FontAwesomeIcons.github,
          title: 'GitHub Repository',
          subtitle: 'Lihat source code & laporkan bug',
          value: 'github.com/Skynixxx/joki-app',
          color: const Color(0xFF333333),
          onTap: () => _openGitHub(context),
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusS),
              ),
              child: FaIcon(icon, color: color, size: 20),
            ),

            const SizedBox(width: AppSizes.paddingM),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: AppSizes.paddingXS),

                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: AppSizes.paddingXS),

                  Text(
                    value,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.3);
  }

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pertanyaan Umum (FAQ)',
          style: AppTextStyles.headline4.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: AppSizes.paddingM),

        _buildFAQCard(
          question: 'Bagaimana cara memesan jasa tugas?',
          answer:
              'Anda dapat memesan melalui aplikasi dengan memilih layanan yang diinginkan, mengisi detail tugas, dan melakukan pembayaran.',
        ),

        _buildFAQCard(
          question: 'Berapa lama waktu pengerjaan tugas?',
          answer:
              'Waktu pengerjaan bervariasi tergantung kompleksitas tugas. Umumnya 1-7 hari kerja. Anda dapat berdiskusi dengan admin untuk deadline khusus.',
        ),

        _buildFAQCard(
          question: 'Bagaimana sistem pembayaran?',
          answer:
              'Kami menerima pembayaran melalui transfer bank, e-wallet (Dana, OVO, Gopay), dan metode pembayaran digital lainnya.',
        ),

        _buildFAQCard(
          question: 'Apakah ada garansi revisi?',
          answer:
              'Ya, kami memberikan garansi revisi sesuai dengan ketentuan yang berlaku. Silakan hubungi admin untuk detail lebih lanjut.',
        ),
      ],
    );
  }

  Widget _buildFAQCard({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Text(
              answer,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildAppInfo() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Aplikasi',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppSizes.paddingS),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Versi Aplikasi', style: AppTextStyles.bodySmall),
              Text(
                '1.0.0',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.paddingXS),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Developer', style: AppTextStyles.bodySmall),
              Text(
                'Muhammad Fikri Haikal',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.paddingXS),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Build', style: AppTextStyles.bodySmall),
              Text(
                '2025.01.01',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms);
  }

  // Action Methods
  void _openLiveChat(BuildContext context) {
    // Implement live chat - could open WhatsApp or Telegram
    _openWhatsApp(context, 'admin');
  }

  void _makePhoneCall(BuildContext context) async {
    final phoneNumber = 'tel:+62081246995873';
    if (await canLaunchUrl(Uri.parse(phoneNumber))) {
      await launchUrl(Uri.parse(phoneNumber));
    } else {
      if (context.mounted) {
        AppHelpers.showError(context, 'Tidak dapat membuka aplikasi telepon');
      }
    }
  }

  void _openWhatsApp(BuildContext context, String type) async {
    String phoneNumber = '62081246995873'; // Nomor Muhammad Fikri Haikal
    String message = '';

    if (type == 'developer') {
      message =
          'Halo Muhammad Fikri Haikal, saya ingin berkonsultasi mengenai aplikasi Joki Tugas';
    } else {
      message =
          'Halo Muhammad Fikri Haikal, saya butuh bantuan dengan aplikasi Joki Tugas';
    }

    final whatsappUrl =
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(
        Uri.parse(whatsappUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (context.mounted) {
        AppHelpers.showError(context, 'Tidak dapat membuka WhatsApp');
      }
    }
  }

  void _sendEmail(BuildContext context) async {
    const email = 'fikrihaikal170308@gmail.com'; // Email Muhammad Fikri Haikal
    const subject = 'Bantuan Aplikasi Joki Tugas';
    const body =
        'Halo Muhammad Fikri Haikal,\n\nSaya memerlukan bantuan dengan aplikasi Joki Tugas.\n\nMohon bantuannya.\n\nTerima kasih.';

    final emailUrl =
        'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

    if (await canLaunchUrl(Uri.parse(emailUrl))) {
      await launchUrl(Uri.parse(emailUrl));
    } else {
      if (context.mounted) {
        AppHelpers.showError(context, 'Tidak dapat membuka aplikasi email');
      }
    }
  }

  void _openGitHub(BuildContext context) async {
    const githubUrl =
        'https://github.com/Skynixxx/joki-app'; // Ganti dengan URL GitHub repo

    if (await canLaunchUrl(Uri.parse(githubUrl))) {
      await launchUrl(
        Uri.parse(githubUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (context.mounted) {
        AppHelpers.showError(context, 'Tidak dapat membuka GitHub');
      }
    }
  }
}
