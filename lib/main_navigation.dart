import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/screens/home_screen.dart';
import 'package:elxau/screens/favorites_screen.dart';
import 'package:elxau/screens/bookings_screen.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:elxau/screens/login_screen.dart';
import 'package:elxau/utils/app_svg_icons.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const FavoritesScreen(),
      const BookingsScreen(),
      const _MessagesScreen(),
      const _ProfileScreen(),
    ];
  }

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
          color: Colors.white,
          border: Border(
            top: BorderSide(color: LushiStayTheme.cardBorder, width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, AppSvgIcons.navExplore, 'Explorer'),
                _buildNavItem(1, AppSvgIcons.navWishlist, 'Favoris'),
                _buildNavItem(2, AppSvgIcons.navTrips, 'Voyages'),
                _buildNavItem(3, AppSvgIcons.navMessages, 'Messages'),
                _buildNavItem(4, AppSvgIcons.navProfile, 'Profil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String svgIcon, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? LushiStayTheme.blue : LushiStayTheme.textMuted;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSvgIcons.svg(svgIcon, color: color, size: 22),
            const Gap(3),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Messages placeholder ───
class _MessagesScreen extends StatelessWidget {
  const _MessagesScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LushiStayTheme.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Messages',
                style: GoogleFonts.plusJakartaSans(
                  color: LushiStayTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      size: 48,
                      color: LushiStayTheme.textMuted,
                    ),
                    const Gap(16),
                    Text(
                      'Aucun message',
                      style: GoogleFonts.plusJakartaSans(
                        color: LushiStayTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      'Quand vous contacterez un hôte ou réserverez\nun logement, vos messages s\'afficheront ici.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: LushiStayTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Profile screen ───
class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final user = authService.currentUser;
    final name = user?.name ?? 'Voyageur';
    final email = user?.email ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'V';

    return Scaffold(
      backgroundColor: LushiStayTheme.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profil',
                style: GoogleFonts.plusJakartaSans(
                  color: LushiStayTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const Gap(24),

              // User card
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: LushiStayTheme.oceanBlue,
                    child: Text(
                      initial,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.plusJakartaSans(
                            color: LushiStayTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (email.isNotEmpty) ...[
                          const Gap(2),
                          Text(
                            email,
                            style: GoogleFonts.plusJakartaSans(
                              color: LushiStayTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: LushiStayTheme.textMuted,
                  ),
                ],
              ),

              const Gap(32),

              // Menu items
              _buildMenuItem(
                icon: Icons.lock_outline_rounded,
                label: 'Page d\'authentification animée',
                subtitle: 'Arrière-plan vidéo/animé premium',
                color: LushiStayTheme.blue,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.settings_outlined,
                label: 'Paramètres',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                label: 'Centre d\'aide',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.shield_outlined,
                label: 'Confidentialité et partage',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.description_outlined,
                label: 'Conditions générales',
                onTap: () {},
              ),

              const Gap(16),
              const Divider(color: LushiStayTheme.cardBorder),
              const Gap(16),

              // Hosting section
              _buildMenuItem(
                icon: Icons.add_home_outlined,
                label: 'Mettez votre logement sur LushiStay',
                subtitle: 'Gagnez de l\'argent facilement',
                onTap: () {
                  // Navigate to host tab
                },
              ),

              const Gap(16),
              const Divider(color: LushiStayTheme.cardBorder),
              const Gap(16),

              // Logout
              _buildMenuItem(
                icon: Icons.logout_rounded,
                label: 'Déconnexion',
                color: LushiStayTheme.destructive,
                onTap: () async {
                  await authService.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  }
                },
              ),

              const Gap(24),

              // Version
              Center(
                child: Text(
                  'LushiStay · Version 1.0.0',
                  style: GoogleFonts.plusJakartaSans(
                    color: LushiStayTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    String? subtitle,
    Color? color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color ?? LushiStayTheme.textPrimary, size: 24),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      color: color ?? LushiStayTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const Gap(2),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        color: LushiStayTheme.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (color == null)
              const Icon(
                Icons.chevron_right,
                color: LushiStayTheme.textMuted,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
