import 'package:flutter/cupertino.dart';
import 'package:elxau/brand_config.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/cupertino_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppDownloadBanner extends StatelessWidget {
  const AppDownloadBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ElxauTheme.accent,
            ElxauTheme.accent.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ElxauTheme.accent.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              CupertinoIcons.device_phone_portrait,
              size: 100,
              color: ElxauTheme.white.withValues(alpha: 0.1),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ElxauTheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      CupertinoIcons.star_fill,
                      color: ElxauTheme.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Expérience Premium',
                    style: GoogleFonts.playfairDisplay(
                      color: ElxauTheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Téléchargez l\'app ${BrandConfig.appName}',
                style: GoogleFonts.playfairDisplay(
                  color: ElxauTheme.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Profitez d\'une navigation plus fluide, de notifications en temps réel et d\'offres exclusives.',
                style: TextStyle(
                  color: ElxauTheme.white.withValues(alpha: 0.8),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildStoreButton(
                    icon: FontAwesomeIcons.googlePlay,
                    label: 'Google Play',
                    onTap: () {
                      _showComingSoon(context);
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildStoreButton(
                    icon: FontAwesomeIcons.apple,
                    label: 'App Store',
                    onTap: () {
                      _showComingSoon(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoreButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: ElxauTheme.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ElxauTheme.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: ElxauTheme.white, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: ElxauTheme.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    showAppMessage(
      context,
      'L\'application mobile sera disponible très prochainement sur les stores.',
      title: 'Bientôt disponible',
    );
  }
}
