import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/brand_config.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:elxau/screens/publish_property_screen.dart';
import 'package:elxau/screens/login_screen.dart';

class HostScreen extends StatelessWidget {
  const HostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final user = authService.currentUser;

    return Scaffold(
      backgroundColor: LushiStayTheme.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'ESPACE HÔTE LUSHISTAY',
                style: GoogleFonts.plusJakartaSans(
                  color: LushiStayTheme.copperLight,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const Gap(4),
              Text(
                'Tableau de bord',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              Text(
                'Gérez vos villas, appartements et réservations à Lubumbashi.',
                style: GoogleFonts.plusJakartaSans(
                  color: LushiStayTheme.textSecondary,
                  fontSize: 13.5,
                ),
              ),

              const Gap(24),

              // Earnings Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1E2F4A),
                      Color(0xFF142036),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: LushiStayTheme.copper.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: LushiStayTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Revenus ce mois-ci',
                          style: GoogleFonts.plusJakartaSans(
                            color: LushiStayTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: LushiStayTheme.copper.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '+24% vs sept.',
                            style: GoogleFonts.plusJakartaSans(
                              color: LushiStayTheme.copperLight,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Text(
                      '\$4,850',
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      '${BrandConfig.formatFc(4850)} générés',
                      style: GoogleFonts.plusJakartaSans(
                        color: LushiStayTheme.copperLight,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),

              const Gap(20),

              // Quick Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      'Taux d\'occupation',
                      '88%',
                      Icons.pie_chart_outline_rounded,
                    ),
                  ),
                  const Gap(14),
                  Expanded(
                    child: _buildMetricCard(
                      'Note globale',
                      '★ 4.92',
                      Icons.star_rounded,
                      iconColor: LushiStayTheme.gold,
                    ),
                  ),
                ],
              ),

              const Gap(24),

              // Action Button: Publier un nouveau bien
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PublishPropertyScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: LushiStayTheme.copper,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_home_rounded, size: 20),
                    const Gap(8),
                    Text(
                      'Publier un logement',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(32),

              // Profile section
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: LushiStayTheme.bgCard,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: LushiStayTheme.cardBorder),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0F5A37),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'V',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Gap(14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.name ?? 'Grâce Mwamba',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Gap(2),
                              Text(
                                user?.email ?? 'vous@exemple.cd',
                                style: GoogleFonts.plusJakartaSans(
                                  color: LushiStayTheme.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                    const Divider(color: LushiStayTheme.cardBorder),
                    const Gap(8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.logout_rounded,
                          color: Color(0xFFEF4444)),
                      title: Text(
                        'Déconnexion',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFFEF4444),
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon,
      {Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LushiStayTheme.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: LushiStayTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor ?? LushiStayTheme.copperLight, size: 24),
          const Gap(10),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: LushiStayTheme.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
