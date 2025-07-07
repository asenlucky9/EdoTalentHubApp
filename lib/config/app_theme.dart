import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_config.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConfig.primaryColor,
        brightness: Brightness.light,
        primary: AppConfig.primaryColor,
        secondary: AppConfig.secondaryColor,
        surface: AppConfig.surfaceColor,
        background: AppConfig.backgroundColor,
        error: AppConfig.errorColor,
      ),
      
      // Text Theme
      textTheme: AppConfig.textTheme.copyWith(
        displayLarge: AppConfig.textTheme.displayLarge?.copyWith(
          color: AppConfig.textPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: AppConfig.textTheme.displayMedium?.copyWith(
          color: AppConfig.textPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: AppConfig.textTheme.displaySmall?.copyWith(
          color: AppConfig.textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: AppConfig.textTheme.headlineLarge?.copyWith(
          color: AppConfig.textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: AppConfig.textTheme.headlineMedium?.copyWith(
          color: AppConfig.textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: AppConfig.textTheme.headlineSmall?.copyWith(
          color: AppConfig.textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: AppConfig.textTheme.titleLarge?.copyWith(
          color: AppConfig.textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: AppConfig.textTheme.titleMedium?.copyWith(
          color: AppConfig.textPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: AppConfig.textTheme.titleSmall?.copyWith(
          color: AppConfig.textPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: AppConfig.textTheme.bodyLarge?.copyWith(
          color: AppConfig.textPrimaryColor,
        ),
        bodyMedium: AppConfig.textTheme.bodyMedium?.copyWith(
          color: AppConfig.textPrimaryColor,
        ),
        bodySmall: AppConfig.textTheme.bodySmall?.copyWith(
          color: AppConfig.textSecondaryColor,
        ),
        labelLarge: AppConfig.textTheme.labelLarge?.copyWith(
          color: AppConfig.textPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: AppConfig.textTheme.labelMedium?.copyWith(
          color: AppConfig.textPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: AppConfig.textTheme.labelSmall?.copyWith(
          color: AppConfig.textSecondaryColor,
        ),
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppConfig.surfaceColor,
        foregroundColor: AppConfig.textPrimaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppConfig.textTheme.titleLarge?.copyWith(
          color: AppConfig.textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppConfig.surfaceColor,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.radiusL),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppConfig.paddingM,
          vertical: AppConfig.paddingS,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConfig.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: AppConfig.primaryColor.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.radiusM),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConfig.paddingL,
            vertical: AppConfig.paddingM,
          ),
          textStyle: AppConfig.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConfig.primaryColor,
          side: const BorderSide(color: AppConfig.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.radiusM),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConfig.paddingL,
            vertical: AppConfig.paddingM,
          ),
          textStyle: AppConfig.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppConfig.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.radiusM),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConfig.paddingM,
            vertical: AppConfig.paddingS,
          ),
          textStyle: AppConfig.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConfig.backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.radiusM),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.radiusM),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.radiusM),
          borderSide: const BorderSide(
            color: AppConfig.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.radiusM),
          borderSide: const BorderSide(
            color: AppConfig.errorColor,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.radiusM),
          borderSide: const BorderSide(
            color: AppConfig.errorColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConfig.paddingM,
          vertical: AppConfig.paddingM,
        ),
        hintStyle: AppConfig.textTheme.bodyMedium?.copyWith(
          color: AppConfig.textSecondaryColor,
        ),
        labelStyle: AppConfig.textTheme.bodyMedium?.copyWith(
          color: AppConfig.textSecondaryColor,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppConfig.surfaceColor,
        selectedItemColor: AppConfig.primaryColor,
        unselectedItemColor: AppConfig.textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppConfig.radiusL)),
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppConfig.backgroundColor,
        selectedColor: AppConfig.primaryColor.withValues(alpha: 0.1),
        disabledColor: Colors.grey.shade200,
        labelStyle: AppConfig.textTheme.bodySmall?.copyWith(
          color: AppConfig.textPrimaryColor,
        ),
        secondaryLabelStyle: AppConfig.textTheme.bodySmall?.copyWith(
          color: AppConfig.primaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.radiusM),
        ),
        side: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Colors.grey,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppConfig.textPrimaryColor,
        size: 24,
      ),

      // Primary Icon Theme
      primaryIconTheme: const IconThemeData(
        color: AppConfig.primaryColor,
        size: 24,
      ),

      // Scaffold Background Color
      scaffoldBackgroundColor: AppConfig.backgroundColor,

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppConfig.surfaceColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.radiusL),
        ),
        titleTextStyle: AppConfig.textTheme.titleLarge?.copyWith(
          color: AppConfig.textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: AppConfig.textTheme.bodyMedium?.copyWith(
          color: AppConfig.textPrimaryColor,
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppConfig.textPrimaryColor,
        contentTextStyle: AppConfig.textTheme.bodyMedium?.copyWith(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.radiusM),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppConfig.surfaceColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConfig.radiusL),
          ),
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppConfig.primaryColor;
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppConfig.primaryColor.withValues(alpha: 0.5);
          }
          return Colors.grey.shade300;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppConfig.primaryColor;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.radiusS),
        ),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppConfig.primaryColor;
          }
          return Colors.grey;
        }),
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: AppConfig.primaryColor,
        inactiveTrackColor: Colors.grey.shade300,
        thumbColor: AppConfig.primaryColor,
        overlayColor: AppConfig.primaryColor.withValues(alpha: 0.2),
        valueIndicatorColor: AppConfig.primaryColor,
        valueIndicatorTextStyle: AppConfig.textTheme.bodySmall?.copyWith(
          color: Colors.white,
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppConfig.primaryColor,
        linearTrackColor: Colors.grey,
        circularTrackColor: Colors.grey,
      ),

      // Tab Bar Theme
      tabBarTheme: const TabBarThemeData(
        labelColor: AppConfig.primaryColor,
        unselectedLabelColor: AppConfig.textSecondaryColor,
        indicatorColor: AppConfig.primaryColor,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConfig.primaryColor,
        brightness: Brightness.dark,
        primary: AppConfig.primaryColor,
        secondary: AppConfig.secondaryColor,
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
        error: AppConfig.errorColor,
      ),
      
      // For now, we'll use the light theme as the base
      // Dark theme can be implemented later if needed
      textTheme: AppConfig.textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppConfig.textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
    );
  }
} 