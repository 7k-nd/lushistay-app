import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LushiStayTheme {
  // ─── Brand Palette — Pure White & Vibrant Royal Blue ───
  static const Color bg = Color(0xFFFFFFFF);
  static const Color bgSurface = Color(0xFFF8FAFC);
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE2E8F0);
  static const Color inputBg = Color(0xFFF1F5F9);
  static const Color inputBorder = Color(0xFFCBD5E1);

  // Primary: Vibrant Royal / Electric Blue
  static const Color blue = Color(0xFF1D4ED8); // Solid vibrant blue
  static const Color blueLight = Color(0xFF3B82F6);
  static const Color blueDark = Color(0xFF1E3A8A); // Deep Navy
  static const Color primary = blue;

  // Secondary
  static const Color secondary = blueDark;
  static const Color oceanBlue = blueDark;
  static const Color oceanBlueMedium = blue;
  static const Color oceanBlueLight = blueLight;

  // Aliases for compatibility
  static const Color coral = blue;
  static const Color coralDark = blueDark;
  static const Color coralLight = blueLight;
  static const Color copper = blue;
  static const Color copperDark = blueDark;
  static const Color copperLight = blue;

  static const Color gold = Color(0xFFF59E0B);
  static const Color hotelGreen = Color(0xFF059669);
  static const Color hotelGreenText = Color(0xFF10B981);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF0F172A);

  // Ultra-legible dark typography colors (high contrast on white)
  static const Color textPrimary = Color(0xFF0F172A); // Very dark slate (almost black)
  static const Color textSecondary = Color(0xFF334155); // Solid readable dark slate
  static const Color textMuted = Color(0xFF64748B); // Readable medium slate

  static const Color destructive = Color(0xFFDC2626);
  static const Color success = Color(0xFF16A34A);

  // Compatibility aliases (existing screens)
  static const Color accent = Color(0xFFF8FAFC);
  static const Color secondaryText = Color(0xFF334155);
  static const Color grayLight = Color(0xFFE2E8F0);
  static const Color systemBlue = Color(0xFF1D4ED8);
  static const Color systemOrange = Color(0xFFEA580C);
  static const Color systemGrey5 = Color(0xFFF1F5F9);
  static const Color transparent = Color(0x00000000);

  // ─── Shadows ───
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get strongShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get cardShadow => softShadow;

  static List<BoxShadow> get blueGlow => [
        BoxShadow(
          color: blue.withValues(alpha: 0.25),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get coralGlow => blueGlow;
  static List<BoxShadow> get copperGlow => blueGlow;

  // ─── Decorations ───
  static BoxDecoration get glassDecoration => BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 1),
        boxShadow: softShadow,
      );

  static BoxDecoration get cardDecoration => BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 1),
        boxShadow: softShadow,
      );

  // ─── Typography with robust Fallback ───
  static TextStyle _fontStyle({
    required Color color,
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
    ).copyWith(
      fontFamilyFallback: const ['Segoe UI', 'Roboto', 'Arial', 'sans-serif'],
    );
  }

  static TextStyle get displayLarge => _fontStyle(
        color: textPrimary,
        fontWeight: FontWeight.w800,
        fontSize: 30,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle get displayMedium => _fontStyle(
        color: textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        letterSpacing: -0.3,
        height: 1.25,
      );

  static TextStyle get displaySmall => _fontStyle(
        color: textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      );

  static TextStyle get titleLarge => _fontStyle(
        color: textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 18,
        letterSpacing: 0.1,
      );

  static TextStyle get titleMedium => _fontStyle(
        color: textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      );

  static TextStyle get bodyLarge => _fontStyle(
        color: textPrimary,
        fontSize: 15,
        height: 1.5,
      );

  static TextStyle get bodyMedium => _fontStyle(
        color: textSecondary,
        fontSize: 14,
        height: 1.45,
      );

  static TextStyle get bodySmall => _fontStyle(
        color: textMuted,
        fontSize: 12,
      );

  static TextStyle get labelLarge => _fontStyle(
        color: primary,
        fontWeight: FontWeight.w700,
        fontSize: 12,
        letterSpacing: 1.2,
      );

  static TextStyle get labelUppercase => _fontStyle(
        color: primary,
        fontWeight: FontWeight.w800,
        fontSize: 11,
        letterSpacing: 1.5,
      );

  // ─── Material 3 Theme ───
  static ThemeData get materialTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: bg,
        canvasColor: bg,
        colorScheme: const ColorScheme.light(
          primary: blue,
          onPrimary: white,
          secondary: blueDark,
          onSecondary: white,
          surface: bg,
          onSurface: textPrimary,
          error: destructive,
        ),
        cardColor: bgCard,
        dividerColor: cardBorder,
        textTheme: TextTheme(
          displayLarge: displayLarge,
          displayMedium: displayMedium,
          displaySmall: displaySmall,
          titleLarge: titleLarge,
          titleMedium: titleMedium,
          bodyLarge: bodyLarge,
          bodyMedium: bodyMedium,
          bodySmall: bodySmall,
        ),
      );

  // ─── Cupertino Theme (cross-platform compat) ───
  static CupertinoThemeData get cupertinoTheme => CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: blue,
        scaffoldBackgroundColor: bg,
        barBackgroundColor: bgSurface.withValues(alpha: 0.9),
        textTheme: CupertinoTextThemeData(
          primaryColor: textPrimary,
          textStyle: GoogleFonts.plusJakartaSans(
            color: textPrimary,
            fontSize: 15,
          ),
          navTitleTextStyle: GoogleFonts.plusJakartaSans(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}

// Backward compatibility alias
typedef ElxauTheme = LushiStayTheme;
