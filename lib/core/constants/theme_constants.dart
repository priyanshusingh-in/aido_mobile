import 'package:flutter/material.dart';

class AppColors {
  // Primary palette (Modern Task Scheduling App)
  static const Color primary = Color(0xFF6366F1); // Deep Purple - modern, trustworthy
  static const Color primaryDark = Color(0xFF4F46E5); // Darker Purple
  static const Color accent = Color(0xFF3B82F6); // Soft Blue - calm, professional
  static const Color accentLight = Color(0xFF06B6D4); // Bright Cyan - interactive

  // Backgrounds (Modern Dark Theme)
  static const Color background = Color(0xFF0F172A); // Deep slate - easy on eyes
  static const Color backgroundSecondary = Color(0xFF1E293B); // Lighter slate - cards

  // Card colors
  static const Color cardBackground = Color(0xFF1E293B);
  static const Color cardBorder = Color(0xFF334155);

  // Input colors
  static const Color inputBackground = Color(0xFF1E293B);
  static const Color inputBorder = Color(0xFF475569);
  static const Color inputFocusedBorder = Color(0xFF6366F1);

  // Status colors (Modern & Vibrant)
  static const Color success = Color(0xFF10B981); // Mint Green - fresh, energetic
  static const Color warning = Color(0xFFF59E0B); // Warm Orange - attention
  static const Color error = Color(0xFFEF4444); // Modern Red
  static const Color info = Color(0xFF06B6D4); // Bright Cyan

  // Legacy colors for backward compatibility (mapped to new palette)
  static const Color secondary = accent;
  static const Color surfaceVariant = backgroundSecondary;

  // Schedule type colors (Vibrant & Distinct)
  static const Color meeting = Color(0xFF6366F1); // Deep Purple
  static const Color reminder = Color(0xFF10B981); // Mint Green
  static const Color task = Color(0xFF3B82F6); // Soft Blue
  static const Color appointment = Color(0xFFEC4899); // Soft Pink

  // Priority colors (Clear Visual Hierarchy)
  static const Color priorityHigh = Color(0xFFEF4444); // Modern Red
  static const Color priorityMedium = Color(0xFFF59E0B); // Warm Orange
  static const Color priorityLow = Color(0xFF10B981); // Mint Green

  // Text colors (High Contrast for Readability)
  static const Color textPrimary = Color(0xFFF8FAFC); // Almost white
  static const Color textSecondary = Color(0xFFCBD5E1); // Light gray
  static const Color textTertiary = Color(0xFF94A3B8); // Medium gray

  // Divider, border
  static const Color divider = Color(0xFF334155);
  static const Color border = Color(0xFF475569);

  // Gradients (Modern & Professional)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [backgroundSecondary, background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Success gradient for positive actions
  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTextStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.1,
  );

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  // Labels and captions
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.1,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    letterSpacing: 0.2,
  );

  // Buttons
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.1,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.1,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.1,
  );
}

class AppShadows {
  static const List<BoxShadow> small = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> large = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
}

class AppBorderRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double xlarge = 24.0;
  static const double round = 50.0;
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}
