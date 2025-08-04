import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'auth_screen.dart';

class SplashScreenDebug extends StatefulWidget {
  const SplashScreenDebug({super.key});

  @override
  State<SplashScreenDebug> createState() => _SplashScreenDebugState();
}

class _SplashScreenDebugState extends State<SplashScreenDebug>
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
      // For debugging - always go to Auth screen
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
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6B73FF);
    const accentColor = Color(0xFF9C27B0);
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor,
              Color(0xFF8A7FFF),
              accentColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo dengan animasi
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          size: 60,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // App Name dengan animasi slide
              Text(
                'Joki Tugas',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              )
                  .animate()
                  .slideY(
                    delay: 300.ms,
                    duration: 600.ms,
                    begin: 1,
                    curve: Curves.easeOut,
                  )
                  .fadeIn(delay: 300.ms, duration: 600.ms),

              const SizedBox(height: 16),

              // Tagline dengan animasi
              Text(
                'Solusi Cerdas untuk Tugasmu',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w400,
                ),
              )
                  .animate()
                  .slideY(
                    delay: 600.ms,
                    duration: 600.ms,
                    begin: 1,
                    curve: Curves.easeOut,
                  )
                  .fadeIn(delay: 600.ms, duration: 600.ms),

              const SizedBox(height: 80),

              // Loading indicator dengan animasi
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              )
                  .animate()
                  .scale(delay: 900.ms, duration: 500.ms)
                  .fadeIn(delay: 900.ms, duration: 500.ms),

              const SizedBox(height: 24),

              // Loading text
              Text(
                'Memuat aplikasi...',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              )
                  .animate()
                  .fadeIn(delay: 1200.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
