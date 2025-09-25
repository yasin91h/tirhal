import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Your specified colors
  static const Color darkBrown = Color(0xFF57564F); // 57564F
  static const Color mediumGray = Color(0xFF7A7A73); // 7A7A73
  static const Color lightGray = Color(0xFFDDDAD0); // DDDAD0
  static const Color cream = Color(0xFFF8F3CE); // F8F3CE

  // Primary brand colors (from UI analysis)
  static const Color primaryBlue =
      Color(0xFF00cabe); // Main teal-cyan used in AppBars
  static const Color accentTeal = Color(0xFF05CCBC); // Navigation accent
  static const Color tealPrimary = Colors.teal; // Onboarding/Login teal

  // Status colors for rides
  static const Color statusPending = Color(0xFFFF9800); // Orange
  static const Color statusAccepted = Color(0xFF4CAF50); // Green
  static const Color statusCompleted = Color(0xFF2196F3); // Blue
  static const Color statusCanceled = Color(0xFFF44336); // Red

  // Background colors
  static const Color backgroundLight =
      Color(0xFFF8F9FA); // Light gray background
  static const Color backgroundGray =
      Color(0xFFE5E5E5); // Medium gray background
  static const Color surfaceWhite = Color(0xFFFFFFFF); // Pure white

  // Text colors
  static const Color textPrimary = Color(0xFF000000); // Black text
  static const Color textSecondary = Color(0xFF757575); // Gray text
  static const Color textLight = Color(0xFF9E9E9E); // Light gray text
  static const Color textOnPrimary =
      Color(0xFFFFFFFF); // White text on colored backgrounds

  // Border and divider colors
  static const Color borderLight = Color(0xFFE0E0E0); // Light borders
  static const Color borderMedium = Color(0xFFBDBDBD); // Medium borders
  static const Color dividerColor = Color(0xFFE0E0E0); // Dividers

  // Shadow colors
  static const Color shadowLight = Color(0x1A000000); // Light shadow
  static const Color shadowMedium = Color(0x33000000); // Medium shadow

  // Additional utility colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color errorRed = Color(0xFFE57373);
  static const Color successGreen = Color(0xFF81C784);
  static const Color warningOrange = Color(0xFFFFB74D);
  static const Color transparent = Colors.transparent;

  // Dark theme colors
  static const Color darkBackgroundPrimary =
      Color(0xFF121212); // Very dark background
  static const Color darkBackgroundSecondary =
      Color(0xFF1E1E1E); // Slightly lighter dark background
  static const Color darkSurface = Color(0xFF2D2D2D); // Dark surface color
  static const Color darkSurfaceVariant =
      Color(0xFF404040); // Dark surface variant
  static const Color darkTextPrimary = Color(0xFFE0E0E0); // Light text on dark
  static const Color darkTextSecondary = Color(0xFFB3B3B3); // Medium light text
  static const Color darkBorder = Color(0xFF404040); // Dark borders
  static const Color darkDivider = Color(0xFF303030); // Dark dividers

  // Status color helpers
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return statusPending;
      case 'accepted':
        return statusAccepted;
      case 'completed':
        return statusCompleted;
      case 'canceled':
      case 'cancelled':
        return statusCanceled;
      default:
        return textSecondary;
    }
  }

  // Surface color variants
  static Color getSurfaceVariant(double opacity) {
    return backgroundGray.withOpacity(opacity);
  }

  // Shadow color variants
  static Color getShadow(double opacity) {
    return shadowMedium.withOpacity(opacity);
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: _createMaterialColor(AppColors.primaryBlue),

      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryBlue,
        secondary: AppColors.accentTeal,
        tertiary: AppColors.tealPrimary,
        surface: AppColors.surfaceWhite,
        background: AppColors.backgroundLight,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnPrimary,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        error: AppColors.statusCanceled,
        onError: AppColors.textOnPrimary,
        outline: AppColors.borderLight,
        surfaceVariant: AppColors.backgroundGray,
      ),

      // Scaffold background
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.textOnPrimary,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textOnPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textOnPrimary),
      ),

      // Text Theme
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
            color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.poppins(
            color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.poppins(
            color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.poppins(
            color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.poppins(
            color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.poppins(
            color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.poppins(
            color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.poppins(
            color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.poppins(
            color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.poppins(color: AppColors.textPrimary),
        bodyMedium: GoogleFonts.poppins(color: AppColors.textPrimary),
        bodySmall: GoogleFonts.poppins(color: AppColors.textSecondary),
        labelLarge: GoogleFonts.poppins(
            color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        labelMedium: GoogleFonts.poppins(
            color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        labelSmall: GoogleFonts.poppins(
            color: AppColors.textSecondary, fontWeight: FontWeight.w500),
      ),

      // Primary Text Theme
      primaryTextTheme: GoogleFonts.poppinsTextTheme().copyWith(
        titleLarge: GoogleFonts.poppins(
            color: AppColors.textOnPrimary, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.poppins(
            color: AppColors.textOnPrimary, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.poppins(color: AppColors.textOnPrimary),
        bodyMedium: GoogleFonts.poppins(color: AppColors.textOnPrimary),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.textOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 2,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 4,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surfaceWhite,
        elevation: 2,
        shadowColor: AppColors.shadowLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.statusCanceled),
        ),
        labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
        hintStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceWhite,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.textSecondary,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primaryBlue,
        unselectedLabelColor: AppColors.textSecondary,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.backgroundGray,
        selectedColor: AppColors.primaryBlue,
        labelStyle: GoogleFonts.poppins(color: AppColors.textPrimary),
        secondaryLabelStyle:
            GoogleFonts.poppins(color: AppColors.textOnPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: GoogleFonts.poppins(color: AppColors.textOnPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),

      // Primary Icon Theme
      primaryIconTheme: const IconThemeData(
        color: AppColors.textOnPrimary,
        size: 24,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerColor,
        thickness: 1,
        space: 16,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: _createMaterialColor(AppColors.primaryBlue),

      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryBlue,
        secondary: AppColors.accentTeal,
        tertiary: AppColors.tealPrimary,
        surface: AppColors.darkSurface,
        background: AppColors.darkBackgroundPrimary,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnPrimary,
        onSurface: AppColors.darkTextPrimary,
        onBackground: AppColors.darkTextPrimary,
        error: AppColors.statusCanceled,
        onError: AppColors.textOnPrimary,
        outline: AppColors.darkBorder,
        surfaceVariant: AppColors.darkSurfaceVariant,
      ),

      // Scaffold background
      scaffoldBackgroundColor: AppColors.darkBackgroundPrimary,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.textOnPrimary,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textOnPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textOnPrimary),
      ),

      // Text Theme
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
            color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.poppins(
            color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.poppins(
            color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.poppins(
            color: AppColors.darkTextPrimary, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.poppins(
            color: AppColors.darkTextPrimary, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.poppins(
            color: AppColors.darkTextPrimary, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.poppins(
            color: AppColors.darkTextPrimary, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.poppins(
            color: AppColors.darkTextPrimary, fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.poppins(
            color: AppColors.darkTextPrimary, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.poppins(color: AppColors.darkTextPrimary),
        bodyMedium: GoogleFonts.poppins(color: AppColors.darkTextPrimary),
        bodySmall: GoogleFonts.poppins(color: AppColors.darkTextSecondary),
        labelLarge: GoogleFonts.poppins(
            color: AppColors.darkTextPrimary, fontWeight: FontWeight.w500),
        labelMedium: GoogleFonts.poppins(
            color: AppColors.darkTextPrimary, fontWeight: FontWeight.w500),
        labelSmall: GoogleFonts.poppins(
            color: AppColors.darkTextSecondary, fontWeight: FontWeight.w500),
      ),

      // Primary Text Theme
      primaryTextTheme: GoogleFonts.poppinsTextTheme().copyWith(
        titleLarge: GoogleFonts.poppins(
            color: AppColors.textOnPrimary, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.poppins(
            color: AppColors.textOnPrimary, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.poppins(color: AppColors.textOnPrimary),
        bodyMedium: GoogleFonts.poppins(color: AppColors.textOnPrimary),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.textOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 2,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 4,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 2,
        shadowColor: AppColors.shadowLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.statusCanceled),
        ),
        labelStyle: GoogleFonts.poppins(color: AppColors.darkTextSecondary),
        hintStyle: GoogleFonts.poppins(color: AppColors.darkTextSecondary),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.darkTextSecondary,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primaryBlue,
        unselectedLabelColor: AppColors.darkTextSecondary,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        selectedColor: AppColors.primaryBlue,
        labelStyle: GoogleFonts.poppins(color: AppColors.darkTextPrimary),
        secondaryLabelStyle:
            GoogleFonts.poppins(color: AppColors.textOnPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: GoogleFonts.poppins(
          color: AppColors.darkTextPrimary,
          fontSize: 16,
        ),
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurface,
        contentTextStyle: GoogleFonts.poppins(color: AppColors.darkTextPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.darkTextPrimary,
        size: 24,
      ),

      // Primary Icon Theme
      primaryIconTheme: const IconThemeData(
        color: AppColors.textOnPrimary,
        size: 24,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
        space: 16,
      ),
    );
  }

  // Helper function to create MaterialColor from Color
  static MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
