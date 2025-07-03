import 'package:flutter/material.dart';

class AppConfig {
  // App Information
  static const String appName = 'EdoTalentHub';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Connecting customers with talented musicians, DJs, MCs, and cultural groups in Edo State, Nigeria';
  
  // Colors - Edo State inspired theme
  static const Color primaryColor = Color(0xFF1B5E20); // Deep Green
  static const Color secondaryColor = Color(0xFFFF8F00); // Edo Gold
  static const Color accentColor = Color(0xFFD32F2F); // Edo Red
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFFFA000);
  static const Color infoColor = Color(0xFF1976D2);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryColor, Color(0xFFFFB300)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Typography - Using system fonts for better web compatibility
  static TextTheme get textTheme => const TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: textPrimaryColor,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: textPrimaryColor,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: textPrimaryColor,
    ),
    headlineLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: textPrimaryColor,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: textPrimaryColor,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: textPrimaryColor,
    ),
    titleLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: textPrimaryColor,
    ),
    titleMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: textPrimaryColor,
    ),
    titleSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: textPrimaryColor,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: textPrimaryColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: textPrimaryColor,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: textSecondaryColor,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: textPrimaryColor,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: textPrimaryColor,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: textSecondaryColor,
    ),
  );

  // Spacing
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Border Radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusXXL = 24.0;

  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // API Configuration
  static const String baseUrl = 'https://api.edotalenthub.com'; // Replace with actual API URL
  static const int apiTimeout = 30000; // 30 seconds

  // Firebase Configuration
  static const String firebaseProjectId = 'edotalenthubapp'; // Updated to match actual Firebase project

  // Payment Configuration
  static const String bankName = 'EdoTalentHub Bank Account';
  static const String accountNumber = '1234567890'; // Replace with actual account number
  static const String accountName = 'EdoTalentHub Services';

  // Edo State Specific Configuration
  static const List<String> edoStateCities = [
    'Benin City',
    'Ekpoma',
    'Auchi',
    'Uromi',
    'Irrua',
    'Abudu',
    'Ehor',
    'Igueben',
    'Ubiaja',
    'Sabongida-Ora',
    'Otuo',
    'Afuze',
    'Owan',
    'Igarra',
    'Okpe',
    'Ologbo',
    'Udo',
    'Ekiadolor',
    'Isi',
    'Urhonigbe',
  ];

  static const List<String> artistCategories = [
    'Musician',
    'DJ',
    'MC',
    'Cultural Group',
    'Videographer',
    'Photographer',
    'Sound Engineer',
    'Event Planner',
    'Caterer',
    'Decorator',
  ];

  static const List<String> eventTypes = [
    'Wedding',
    'Corporate Event',
    'Birthday Party',
    'Cultural Festival',
    'Religious Event',
    'Graduation',
    'Anniversary',
    'Product Launch',
    'Political Rally',
    'Other',
  ];

  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxBioLength = 500;
  static const int maxEventDescriptionLength = 1000;
  static const double minBookingAmount = 5000.0; // ₦5,000
  static const double maxBookingAmount = 5000000.0; // ₦5,000,000

  // File Upload Limits
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxVideoSize = 50 * 1024 * 1024; // 50MB
  static const int maxAudioSize = 10 * 1024 * 1024; // 10MB

  // Booking Configuration
  static const int maxAdvanceBookingDays = 365; // 1 year
  static const int minAdvanceBookingHours = 24; // 24 hours
  static const double commissionPercentage = 0.15; // 15%
  static const double depositPercentage = 0.70; // 70%

  // Notification Configuration
  static const int maxNotificationRetention = 30; // 30 days
  static const int bookingReminderHours = 24; // 24 hours before event

  // Cache Configuration
  static const int imageCacheDays = 7;
  static const int profileCacheDays = 1;
  static const int bookingCacheDays = 1;
} 