import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// SVG Icons haute précision pour LushiStay
class AppSvgIcons {
  AppSvgIcons._();

  // ─── Categories ───
  static const String iconAll = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
  <rect x="3" y="3" width="7" height="7" rx="2"/>
  <rect x="14" y="3" width="7" height="7" rx="2"/>
  <rect x="14" y="14" width="7" height="7" rx="2"/>
  <rect x="3" y="14" width="7" height="7" rx="2"/>
</svg>
''';

  static const String iconVilla = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
  <path d="M3 10.5L12 3l9 7.5"/>
  <path d="M5 9.5V20a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V9.5"/>
  <path d="M9 21V12h6v9"/>
  <path d="M10 7h4"/>
</svg>
''';

  static const String iconHotel = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
  <path d="M3 21h18"/>
  <path d="M5 21V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v16"/>
  <path d="M9 7h1"/>
  <path d="M9 11h1"/>
  <path d="M9 15h1"/>
  <path d="M14 7h1"/>
  <path d="M14 11h1"/>
  <path d="M14 15h1"/>
  <path d="M10 21v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3"/>
</svg>
''';

  static const String iconApartment = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
  <rect x="4" y="2" width="16" height="20" rx="2"/>
  <path d="M9 22v-4h6v4"/>
  <path d="M8 6h.01M16 6h.01M12 6h.01M8 10h.01M16 10h.01M12 10h.01M8 14h.01M16 14h.01M12 14h.01"/>
</svg>
''';

  static const String iconPool = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
  <path d="M2 18c1.5 1 3 1 4.5 0s3-1 4.5 0 3 1 4.5 0 3-1 4.5 0 3 1 4 0"/>
  <path d="M2 21c1.5 1 3 1 4.5 0s3-1 4.5 0 3 1 4.5 0 3-1 4.5 0 3 1 4 0"/>
  <path d="M7 14v-5a3 3 0 0 1 6 0v5"/>
  <path d="M7 9h6"/>
  <path d="M18 10v4"/>
  <path d="M18 6a2 2 0 1 0 0-4 2 2 0 0 0 0 4z"/>
</svg>
''';

  static const String iconLake = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
  <path d="M12 3c-4.5 4.5-6 8-6 11a6 6 0 0 0 12 0c0-3-1.5-6.5-6-11z"/>
  <path d="M2 20c2 1 4 1 6 0s4-1 6 0 4 1 6 0 4-1 4 0"/>
</svg>
''';

    static const String navBuy = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M6 2L3 6v13a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
  <line x1="3" y1="6" x2="21" y2="6"/>
  <path d="M16 10a4 4 0 0 1-8 0"/>
</svg>
''' ;
  static const String navExplore = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="11" cy="11" r="7"/>
  <line x1="21" y1="21" x2="16.65" y2="16.65"/>
</svg>
''';

  static const String navWishlist = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
</svg>
''';

  static const String navTrips = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <rect x="3" y="6" width="18" height="15" rx="3"/>
  <path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
  <line x1="12" y1="11" x2="12" y2="16"/>
  <line x1="3" y1="13.5" x2="21" y2="13.5"/>
</svg>
''';

  static const String navMessages = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
</svg>
''';

  static const String navProfile = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="12" cy="7" r="4"/>
  <path d="M5.5 21a6.5 6.5 0 0 1 13 0"/>
</svg>
''';

  // ─── Filter & Search ───
  static const String iconFilter = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <line x1="4" y1="21" x2="4" y2="14"/>
  <line x1="4" y1="10" x2="4" y2="3"/>
  <line x1="12" y1="21" x2="12" y2="12"/>
  <line x1="12" y1="8" x2="12" y2="3"/>
  <line x1="20" y1="21" x2="20" y2="16"/>
  <line x1="20" y1="12" x2="20" y2="3"/>
  <line x1="1" y1="14" x2="7" y2="14"/>
  <line x1="9" y1="8" x2="15" y2="8"/>
  <line x1="17" y1="16" x2="23" y2="16"/>
</svg>
''';

  // ─── Helper widget ───
  static Widget svg(
    String svgString, {
    required Color color,
    double size = 24,
  }) {
    return SvgPicture.string(
      svgString,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
