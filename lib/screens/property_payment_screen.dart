import 'package:flutter/cupertino.dart';
import 'package:elxau/brand_config.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/cupertino_ui.dart';
import 'package:elxau/models/property.dart';
import 'package:elxau/main_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

/// Ancien écran «paiement » — MVP contact-only (aucun PSP).
class PropertyPaymentScreen extends StatelessWidget {
  final PropertyBooking booking;

  const PropertyPaymentScreen({super.key, required this.booking});

  Future<void> _openWhatsApp(BuildContext context) async {
    final url = ContactWhatsApp.waMeUri(
      ownerPhone: booking.property.ownerPhone,
      text: ContactWhatsApp.interestMessage(
        propertyTitle: booking.property.title,
        userName: booking.userName,
        userPhone: booking.userPhone,
        indicativePriceUsd: booking.totalPrice.toInt(),
      ),
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      await showAppMessage(context, 'Impossible d\'ouvrir WhatsApp');
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = booking.property;
    return AppScaffold(
      backgroundColor: ElxauTheme.bg,
      navigationBar: AppNavBar(
        middle: Text(
          'Contacter l\'annonceur',
          style: GoogleFonts.playfairDisplay(
            color: ElxauTheme.accent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ElxauTheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ElxauTheme.primary.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(CupertinoIcons.info_circle_fill,
                    color: ElxauTheme.primary, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    BrandConfig.contactOnlyLong,
                    style: GoogleFonts.outfit(
                      color: ElxauTheme.secondaryText,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            p.title,
            style: GoogleFonts.outfit(
              color: ElxauTheme.accent,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${p.quartier} · ${p.type.label}',
            style: const TextStyle(
              color: ElxauTheme.secondaryText,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Estimation indicative',
            style: GoogleFonts.outfit(
              color: ElxauTheme.secondaryText,
              fontSize: 12,
            ),
          ),
          Text(
            '\$${booking.totalPrice.toInt()}',
            style: GoogleFonts.playfairDisplay(
              color: ElxauTheme.accent,
              fontWeight: FontWeight.w900,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ce montant n\'est pas débité dans ImmoTrust.',
            style: GoogleFonts.outfit(
              color: ElxauTheme.secondaryText,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 32),
          AppFilledButton(
            onPressed: () => _openWhatsApp(context),
            color: const Color(0xFF25D366),
            padding: const EdgeInsets.symmetric(vertical: 18),
            borderRadius: BorderRadius.circular(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(CupertinoIcons.chat_bubble_fill,
                    color: ElxauTheme.white),
                const SizedBox(width: 10),
                Text(
                  'Ouvrir WhatsApp',
                  style: GoogleFonts.outfit(
                    color: ElxauTheme.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppOutlineButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                appRoute(const MainNavigation()),
                (_) => false,
              );
            },
            child: Text(
              'Retour à l\'accueil',
              style: GoogleFonts.outfit(
                color: ElxauTheme.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}