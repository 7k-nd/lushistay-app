import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/screens/home_screen.dart';
import 'package:elxau/screens/favorites_screen.dart';
import 'package:elxau/screens/bookings_screen.dart';
import 'package:elxau/screens/host_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    FavoritesScreen(),
    BookingsScreen(),
    HostScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LushiStayTheme.bg,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: LushiStayTheme.bgSurface,
          border: Border(
            top: BorderSide(
              color: LushiStayTheme.cardBorder,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.search_rounded, 'Explorer'),
                _buildNavItem(1, Icons.favorite_border_rounded, 'Favoris'),
                _buildNavItem(2, Icons.work_outline_rounded, 'Voyages'),
                _buildNavItem(3, Icons.key_rounded, 'Hôte'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? LushiStayTheme.copper : LushiStayTheme.textMuted;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const Gap(4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: color,
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
