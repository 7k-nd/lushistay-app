import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LushiStayTheme {
  // ─── Brand Palette — Dark Airbnb 2026 ───
  static const Color bg = Color(0xFF0B111E);
  static const Color bgSurface = Color(0xFF0E1626);
  static const Color bgCard = Color(0xFF141D2E);
  static const Color cardBorder = Color(0xFF1E2C44);
  static const Color inputBg = Color(0xFF131C2D);
  static const Color inputBorder = Color(0xFF22324D);

  // Airbnb pink adapted to copper for Lubumbashi
  static const Color copper = Color(0xFFC27849);
  static const Color copperDark = Color(0xFFA56037);
  static const Color copperLight = Color(0xFFD98A5B);
  static const Color primary = copper;

  static const Color gold = Color(0xFFFBBF24);
  static const Color hotelGreen = Color(0xFF0D5F3A);
  static const Color hotelGreenText = Color(0xFF4ADE80);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  static const Color destructive = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);

  // Compatibility aliases (old screens still reference these)
  static const Color accent = Color(0xFF0E1626);
  static const Color secondaryText = Color(0xFF94A3B8);
  static const Color grayLight = Color(0xFF1E2C44);
  static const Color systemBlue = Color(0xFF007AFF);
  static const Color systemOrange = Color(0xFFFF9500);
  static const Color systemGrey5 = Color(0xFF1E2B42);
  static const Color transparent = Color(0x00000000);

  // ─── Shadows ───
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get strongShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.35),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get cardShadow => softShadow;

  static List<BoxShadow> get copperGlow => [
        BoxShadow(
          color: copper.withValues(alpha: 0.2),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  // ─── Decorations ───
  static BoxDecoration get glassDecoration => BoxDecoration(
        color: bgCard.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 1),
      );

  static BoxDecoration get cardDecoration => BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardBorder, width: 1),
      );

  // ─── Typography (all sans-serif like Airbnb Cereal → Plus Jakarta Sans) ───
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
        color: white,
        fontWeight: FontWeight.w800,
        fontSize: 30,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle get displayMedium => GoogleFonts.plusJakartaSans(
        color: white,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        letterSpacing: -0.3,
        height: 1.25,
      );

  static TextStyle get displaySmall => GoogleFonts.plusJakartaSans(
        color: white,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      );

  static TextStyle get titleLarge => GoogleFonts.plusJakartaSans(
        color: white,
        fontWeight: FontWeight.w700,
        fontSize: 18,
        letterSpacing: 0.1,
      );

  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
        color: white,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      );

  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
        color: textPrimary,
        fontSize: 15,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        color: textSecondary,
        fontSize: 14,
        height: 1.45,
      );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
        color: textMuted,
        fontSize: 12,
      );

  static TextStyle get labelLarge => GoogleFonts.plusJakartaSans(
        color: copperLight,
        fontWeight: FontWeight.w700,
        fontSize: 12,
        letterSpacing: 1.2,
      );

  static TextStyle get labelUppercase => GoogleFonts.plusJakartaSans(
        color: copperLight,
        fontWeight: FontWeight.w800,
        fontSize: 11,
        letterSpacing: 1.5,
      );

  // ─── Material 3 Theme ───
  static ThemeData get materialTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        canvasColor: bg,
        colorScheme: const ColorScheme.dark(
          primary: copper,
          onPrimary: white,
          secondary: copperLight,
          surface: bgSurface,
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
        brightness: Brightness.dark,
        primaryColor: copper,
        scaffoldBackgroundColor: bg,
        barBackgroundColor: bgSurface.withValues(alpha: 0.9),
        textTheme: CupertinoTextThemeData(
          primaryColor: white,
          textStyle: GoogleFonts.plusJakartaSans(
            color: textPrimary,
            fontSize: 15,
          ),
          navTitleTextStyle: GoogleFonts.plusJakartaSans(
            color: white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}

// Backward compatibility alias
typedef ElxauTheme = LushiStayTheme;
