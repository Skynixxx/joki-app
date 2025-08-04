import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SessionManager {
  static Timer? _idleTimer;
  static Timer? _warningTimer;
  static DateTime _lastActivity = DateTime.now();
  static const int _sessionTimeoutMinutes = 10;
  static const int _warningTimeoutMinutes = 8; // Warn 2 minutes before logout
  static bool _isWarningShown = false;
  static BuildContext? _context;

  // Initialize session tracking
  static void initialize(BuildContext context) {
    _context = context;
    _resetIdleTimer();

    if (kDebugMode) {
      debugPrint('Session Manager initialized');
    }
  }

  // Reset the idle timer (call this on user activity)
  static void resetIdleTimer() {
    _lastActivity = DateTime.now();
    _isWarningShown = false;
    _resetIdleTimer();
  }

  // Private method to reset timers
  static void _resetIdleTimer() {
    _idleTimer?.cancel();
    _warningTimer?.cancel();

    // Set warning timer (8 minutes)
    _warningTimer = Timer(
      Duration(minutes: _warningTimeoutMinutes),
      _showWarningDialog,
    );

    // Set logout timer (10 minutes)
    _idleTimer = Timer(
      Duration(minutes: _sessionTimeoutMinutes),
      _handleAutoLogout,
    );

    if (kDebugMode) {
      debugPrint(
        'Idle timer reset. Next warning in $_warningTimeoutMinutes minutes',
      );
    }
  }

  // Show warning dialog 2 minutes before auto logout
  static void _showWarningDialog() {
    if (_context == null || _isWarningShown) return;

    _isWarningShown = true;

    showDialog(
      context: _context!,
      barrierDismissible: false,
      builder:
          (context) => _SessionWarningDialog(
            onExtendSession: () {
              Navigator.of(context).pop();
              resetIdleTimer();
            },
            onSaveDraft: () async {
              Navigator.of(context).pop();
              await _saveDraftAndLogout();
            },
            onLogoutNow: () async {
              Navigator.of(context).pop();
              await _forceLogout();
            },
          ),
    );
  }

  // Handle automatic logout
  static void _handleAutoLogout() {
    if (_context == null) return;

    // If warning is still showing, save draft and logout
    if (_isWarningShown) {
      Navigator.of(_context!).pop(); // Close warning dialog
    }

    _saveDraftAndLogout();
  }

  // Save draft and logout
  static Future<void> _saveDraftAndLogout() async {
    if (_context == null) return;

    // Show saving dialog
    showDialog(
      context: _context!,
      barrierDismissible: false,
      builder:
          (context) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Menyimpan draft...'),
              ],
            ),
          ),
    );

    try {
      // Simulate saving draft (implement actual draft saving here)
      await Future.delayed(const Duration(seconds: 2));

      // Close loading dialog
      Navigator.of(_context!).pop();

      // Show success message
      _showSnackBar('Draft berhasil disimpan. Anda telah logout otomatis.');

      // Logout
      await AuthService.logout();

      // Navigate to login
      _navigateToLogin();
    } catch (e) {
      // Close loading dialog
      Navigator.of(_context!).pop();

      // Show error and force logout anyway
      _showSnackBar(
        'Gagal menyimpan draft, tetapi Anda tetap logout karena sesi berakhir.',
      );
      await _forceLogout();
    }
  }

  // Force logout without saving
  static Future<void> _forceLogout() async {
    if (_context == null) return;

    _showSnackBar('Sesi berakhir. Anda telah logout otomatis.');

    await AuthService.logout();
    _navigateToLogin();
  }

  // Navigate to login screen
  static void _navigateToLogin() {
    if (_context == null) return;

    Navigator.of(_context!).pushNamedAndRemoveUntil('/auth', (route) => false);
  }

  // Show snackbar message
  static void _showSnackBar(String message) {
    if (_context == null) return;

    ScaffoldMessenger.of(_context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Clean up timers
  static void dispose() {
    _idleTimer?.cancel();
    _warningTimer?.cancel();
    _context = null;

    if (kDebugMode) {
      debugPrint('Session Manager disposed');
    }
  }

  // Check if session is still valid
  static bool isSessionValid() {
    final now = DateTime.now();
    final timeDiff = now.difference(_lastActivity).inMinutes;
    return timeDiff < _sessionTimeoutMinutes;
  }

  // Get remaining session time in minutes
  static int getRemainingMinutes() {
    final now = DateTime.now();
    final timeDiff = now.difference(_lastActivity).inMinutes;
    return (_sessionTimeoutMinutes - timeDiff).clamp(0, _sessionTimeoutMinutes);
  }
}

// Warning dialog widget
class _SessionWarningDialog extends StatefulWidget {
  final VoidCallback onExtendSession;
  final VoidCallback onSaveDraft;
  final VoidCallback onLogoutNow;

  const _SessionWarningDialog({
    required this.onExtendSession,
    required this.onSaveDraft,
    required this.onLogoutNow,
  });

  @override
  State<_SessionWarningDialog> createState() => _SessionWarningDialogState();
}

class _SessionWarningDialogState extends State<_SessionWarningDialog> {
  int _countdown = 120; // 2 minutes in seconds
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });

      if (_countdown <= 0) {
        timer.cancel();
        // Auto save draft and logout
        widget.onSaveDraft();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = _countdown ~/ 60;
    final seconds = _countdown % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.warning, color: Colors.orange, size: 28),
          SizedBox(width: 8),
          Text('Peringatan Sesi'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Anda tidak aktif selama 8 menit. Sesi akan berakhir dalam:',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Text(
              _formattedTime,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Pilih tindakan yang ingin dilakukan:',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onLogoutNow,
          child: const Text(
            'Logout Sekarang',
            style: TextStyle(color: Colors.red),
          ),
        ),
        ElevatedButton(
          onPressed: widget.onSaveDraft,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          child: const Text('Simpan Draft & Logout'),
        ),
        ElevatedButton(
          onPressed: widget.onExtendSession,
          child: const Text('Lanjutkan Sesi'),
        ),
      ],
    );
  }
}
