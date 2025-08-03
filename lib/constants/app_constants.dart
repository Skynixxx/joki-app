import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6B73FF);
  static const Color primaryLight = Color(0xFF9B59B6);
  static const Color primaryDark = Color(0xFF4C63D2);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF6B73FF), Color(0xFF9B59B6)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF8F9FF), Color(0xFFE8EEFF)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF6B73FF)],
    stops: [0.0, 0.5, 1.0],
  );

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textLight = Color(0xFFA0AEC0);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF8F9FF);
  static const Color backgroundCard = Colors.white;
  static const Color backgroundInput = Color(0xFFF7FAFC);

  // Border Colors
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E0);

  // Status Colors
  static const Color success = Color(0xFF48BB78);
  static const Color error = Color(0xFFE53E3E);
  static const Color warning = Color(0xFFED8936);
  static const Color info = Color(0xFF3182CE);

  // Social Colors
  static const Color google = Color(0xFFDB4437);
  static const Color facebook = Color(0xFF4267B2);
  static const Color twitter = Color(0xFF1DA1F2);

  // Shadow Colors
  static Color shadowLight = Colors.black.withValues(alpha: 0.1);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.2);
  static Color shadowDark = Colors.black.withValues(alpha: 0.3);
}

class AppSizes {
  // Padding & Margins
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusCircle = 50.0;

  // Icon Sizes
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 40.0;
  static const double iconXXL = 48.0;

  // Button Heights
  static const double buttonS = 36.0;
  static const double buttonM = 44.0;
  static const double buttonL = 52.0;
  static const double buttonXL = 60.0;

  // Input Heights
  static const double inputM = 48.0;
  static const double inputL = 56.0;
}

class AppTextStyles {
  // Headlines
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Button Text
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textLight,
  );

  // Link
  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );
}

class AppDecorations {
  // Card Decorations
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.backgroundCard,
    borderRadius: BorderRadius.circular(AppSizes.radiusM),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowLight,
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Input Decorations
  static InputDecoration inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primary),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      filled: true,
      fillColor: AppColors.backgroundInput,
    );
  }

  // Button Decorations
  static BoxDecoration gradientButtonDecoration = BoxDecoration(
    gradient: AppColors.secondaryGradient,
    borderRadius: BorderRadius.circular(AppSizes.radiusM),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.3),
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
    ],
  );

  // Social Button Decoration
  static BoxDecoration socialButtonDecoration = BoxDecoration(
    color: AppColors.backgroundCard,
    border: Border.all(color: AppColors.borderLight),
    borderRadius: BorderRadius.circular(AppSizes.radiusM),
  );
}

class AppAnimations {
  // Durations
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration long = Duration(milliseconds: 800);
  static const Duration extraLong = Duration(milliseconds: 1200);

  // Curves
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve elasticOut = Curves.elasticOut;
  static const Curve bounceOut = Curves.bounceOut;
}
