import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('URL Launcher Tests', () {
    test('Can launch WhatsApp URL', () async {
      const whatsappUrl =
          'https://wa.me/6281234567890?text=Halo%20Admin%20Joki%20Tugas%2C%20saya%20butuh%20bantuan';
      final canLaunch = await canLaunchUrl(Uri.parse(whatsappUrl));
      expect(canLaunch, isTrue);
    });

    test('Can launch Telegram URL', () async {
      const telegramUrl = 'https://t.me/jokitugas_admin';
      final canLaunch = await canLaunchUrl(Uri.parse(telegramUrl));
      expect(canLaunch, isTrue);
    });

    test('Can launch Email URL', () async {
      const emailUrl =
          'mailto:support@jokitugas.com?subject=Bantuan%20Aplikasi&body=Halo%2C%20saya%20butuh%20bantuan%20dengan%3A';
      final canLaunch = await canLaunchUrl(Uri.parse(emailUrl));
      expect(canLaunch, isTrue);
    });

    test('Can launch GitHub URL', () async {
      const githubUrl = 'https://github.com/Skynixxx/joki-app';
      final canLaunch = await canLaunchUrl(Uri.parse(githubUrl));
      expect(canLaunch, isTrue);
    });

    test('Can launch Admin Panel URL', () async {
      const adminUrl = 'https://admin.jokitugas.com';
      final canLaunch = await canLaunchUrl(Uri.parse(adminUrl));
      expect(canLaunch, isTrue);
    });
  });
}
