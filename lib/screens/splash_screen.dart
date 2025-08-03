import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'auth_screen.dart';
import 'home_screen.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_loading.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _startAnimation();
    _navigateToNextScreen();
  }

  _startAnimation() {
    _controller.forward();
  }

  _navigateToNextScreen() {
    Timer(const Duration(seconds: 3), () {
      // Check if user is already logged in
      if (AuthService.isLoggedIn && AuthService.currentUser != null) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => const HomeScreen(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => const AuthScreen(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo dengan animasi
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value * 3.14159,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.assignment_turned_in,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // App Name dengan animasi
              const Text(
                    'Joki Tugas',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 800.ms)
                  .slideY(begin: 0.3, end: 0)
                  .then()
                  .shimmer(duration: 1200.ms, color: Colors.white54),

              const SizedBox(height: 10),

              // Tagline
              const Text(
                    'Solusi Terpercaya untuk Tugas Anda',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 60),

              // Loading indicator
              const CustomLoadingWidget(size: 40, color: Colors.white)
                  .animate()
                  .fadeIn(delay: 1200.ms, duration: 400.ms)
                  .scale(begin: Offset(0.5, 0.5), end: Offset(1.0, 1.0)),

              const SizedBox(height: 20),

              // Loading text
              const Text(
                'Memuat aplikasi...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                  fontWeight: FontWeight.w300,
                ),
              ).animate().fadeIn(delay: 1500.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
