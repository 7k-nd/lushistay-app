import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/brand_config.dart';
import 'package:elxau/models/property.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Property property;
  final DurationType durationType;
  final int duration;
  final DateTime startDate;

  const PropertyDetailScreen({
    super.key,
    required this.property,
    this.durationType = DurationType.days,
    this.duration = 1,
    required this.startDate,
  });

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  int _currentImageIndex = 0;
  bool _isFavorite = false;
  bool _isDescriptionExpanded = false;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showBookingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AirbnbBookingSheet(property: widget.property),
    );
  }

  // Simple purchase dialog placeholder
  void _showPurchaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Acheter le bien'),
        content: const Text('Cette fonctionnalité est en cours de mise en œuvre. Vous pouvez simuler un achat en confirmant.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Achat simulé – merci!')),
              );
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AirbnbBookingSheet(property: widget.property),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.property;
    final images = p.images.isNotEmpty
        ? p.images
        : [
            'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=1200&q=80',
            'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200&q=80',
            'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=1200&q=80',
          ];

    final bedrooms = p.features.bedrooms ?? 2;
    final bathrooms = p.features.bathrooms ?? 1;
    final surface = p.features.surfaceM2?.round() ?? 85;

    return Scaffold(
      backgroundColor: LushiStayTheme.bg,
      body: Stack(
        children: [
          // Scrollable Body
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. Full-bleed Image Carousel (Airbnb style) ──
                Stack(
                  children: [
                    SizedBox(
                      height: 330,
                      width: double.infinity,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: images.length,
                        onPageChanged: (i) => setState(() => _currentImageIndex = i),
                        itemBuilder: (context, index) {
                          return Image.network(
                            images[index],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: const Color(0xFFF1F5F9),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: LushiStayTheme.blue,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, url, error) => Container(
                              color: const Color(0xFFF1F5F9),
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: LushiStayTheme.textMuted,
                                  size: 40,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Top Action Buttons (Airbnb Circular Buttons)
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Back Button
                            _buildCircularButton(
                              icon: Icons.arrow_back,
                              onTap: () => Navigator.of(context).pop(),
                            ),
                            Row(
                              children: [
                                _buildCircularButton(
                                  icon: Icons.share_outlined,
                                  onTap: () {},
                                ),
                                const Gap(12),
                                _buildCircularButton(
                                  icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                                  iconColor: _isFavorite ? LushiStayTheme.blue : LushiStayTheme.textPrimary,
                                  onTap: () => setState(() => _isFavorite = !_isFavorite),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Image Counter Pill (Bottom Right: "1 / 5")
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_currentImageIndex + 1} / ${images.length}',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // ── 2. Header Info & Ratings ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.title,
                        style: GoogleFonts.plusJakartaSans(
                          color: LushiStayTheme.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        'Logement entier · ${p.quartier}, ${p.ville}',
                        style: GoogleFonts.plusJakartaSans(
                          color: LushiStayTheme.textSecondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(10),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 18, color: LushiStayTheme.textPrimary),
                          const Gap(4),
                          Text(
                            p.rating.toStringAsFixed(2),
                            style: GoogleFonts.plusJakartaSans(
                              color: LushiStayTheme.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            '· ${p.reviewCount} avis',
                            style: GoogleFonts.plusJakartaSans(
                              color: LushiStayTheme.textSecondary,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          if (p.isVerified) ...[
                            const Gap(8),
                            const Text('·', style: TextStyle(color: LushiStayTheme.textMuted)),
                            const Gap(8),
                            const Icon(Icons.verified_rounded, size: 16, color: LushiStayTheme.copperLight),
                            const Gap(4),
                            Text(
                              'Hôte d\'exception',
                              style: GoogleFonts.plusJakartaSans(
                                color: LushiStayTheme.copperLight,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Divider(color: LushiStayTheme.cardBorder, height: 1),
                ),

                // ── 3. Host Profile Card (Airbnb Style) ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: LushiStayTheme.copper,
                        child: Text(
                          p.ownerName.isNotEmpty ? p.ownerName[0].toUpperCase() : 'L',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 20,
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
                              'Hôte : ${p.ownerName}',
                              style: GoogleFonts.plusJakartaSans(
                                color: LushiStayTheme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Gap(2),
                            Text(
                              'Partenaire certifié LushiStay Lubumbashi',
                              style: GoogleFonts.plusJakartaSans(
                                color: LushiStayTheme.textMuted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Divider(color: LushiStayTheme.cardBorder, height: 1),
                ),

                // ── 4. Key Highlights Row ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildKeyMetric(Icons.king_bed_outlined, '$bedrooms chambres'),
                      _buildKeyMetric(Icons.bathtub_outlined, '$bathrooms sdb'),
                      _buildKeyMetric(Icons.square_foot_rounded, '$surface m²'),
                      _buildKeyMetric(Icons.people_outline, 'Jusqu\'à ${bedrooms * 2} pers.'),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Divider(color: LushiStayTheme.cardBorder, height: 1),
                ),

                // ── 5. Description Section ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'À propos de ce logement',
                        style: GoogleFonts.plusJakartaSans(
                          color: LushiStayTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Gap(10),
                      Text(
                        p.description,
                        maxLines: _isDescriptionExpanded ? null : 4,
                        overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          color: LushiStayTheme.textSecondary,
                          fontSize: 14.5,
                          height: 1.55,
                        ),
                      ),
                      const Gap(8),
                      GestureDetector(
                        onTap: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
                        child: Text(
                          _isDescriptionExpanded ? 'Moins d\'infos' : 'En savoir plus >',
                          style: GoogleFonts.plusJakartaSans(
                            color: LushiStayTheme.copperLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Divider(color: LushiStayTheme.cardBorder, height: 1),
                ),

                // ── 6. "Ce que propose ce logement" (Airbnb Amenities Grid) ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ce que propose ce logement',
                        style: GoogleFonts.plusJakartaSans(
                          color: LushiStayTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Gap(16),
                      _buildAmenityRow(Icons.wifi, 'Wi-Fi fibre haut débit'),
                      _buildAmenityRow(Icons.local_parking_outlined, 'Parking privé gratuit sur place'),
                      _buildAmenityRow(Icons.ac_unit_outlined, 'Climatisation réversible'),
                      _buildAmenityRow(Icons.shield_outlined, 'Sécurité privée 24h/24 & vidéosurveillance'),
                      _buildAmenityRow(Icons.water_drop_outlined, 'Approvisionnement continu en eau (forage)'),
                      _buildAmenityRow(Icons.bolt_outlined, 'Électricité garantie avec groupe électrogène'),
                      if (p.features.hasPool == true)
                        _buildAmenityRow(Icons.pool_outlined, 'Piscine privée accessible'),
                      if (p.features.hasGarden == true)
                        _buildAmenityRow(Icons.park_outlined, 'Jardin arboré privatif'),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Divider(color: LushiStayTheme.cardBorder, height: 1),
                ),

                // ── 7. Location map placeholder ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Où se situe le logement',
                        style: GoogleFonts.plusJakartaSans(
                          color: LushiStayTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Gap(6),
                      Text(
                        '${p.quartier}, Lubumbashi, Haut-Katanga, RD Congo',
                        style: GoogleFonts.plusJakartaSans(
                          color: LushiStayTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const Gap(14),
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: LushiStayTheme.bgCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: LushiStayTheme.cardBorder),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on, color: LushiStayTheme.coral, size: 32),
                              const Gap(6),
                              Text(
                                p.quartier,
                                style: GoogleFonts.plusJakartaSans(
                                  color: LushiStayTheme.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Sticky Airbnb Bottom Bar ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                20,
                14,
                20,
                MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: const BoxDecoration(
                color: LushiStayTheme.bgSurface,
                border: Border(
                  top: BorderSide(color: LushiStayTheme.cardBorder, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '\$${p.pricePerDay.round()}',
                              style: GoogleFonts.plusJakartaSans(
                                color: LushiStayTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: ' / nuit',
                              style: GoogleFonts.plusJakartaSans(
                                color: LushiStayTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(2),
                      Text(
                        BrandConfig.formatFc(p.pricePerDay.toInt()),
                        style: GoogleFonts.plusJakartaSans(
                          color: LushiStayTheme.oceanBlueMedium,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => _showBookingSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LushiStayTheme.copper,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Réserver',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor ?? LushiStayTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildKeyMetric(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 24, color: LushiStayTheme.textSecondary),
        const Gap(6),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: LushiStayTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAmenityRow(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, size: 22, color: LushiStayTheme.textSecondary),
          const Gap(14),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: LushiStayTheme.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Booking Bottom Sheet ──
class _AirbnbBookingSheet extends StatefulWidget {
  final Property property;

  const _AirbnbBookingSheet({required this.property});

  @override
  State<_AirbnbBookingSheet> createState() => _AirbnbBookingSheetState();
}

class _AirbnbBookingSheetState extends State<_AirbnbBookingSheet> {
  int _nights = 2;
  int _guests = 2;
  bool _isSuccess = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.property;
    final totalUsd = (p.pricePerDay * _nights).round();

    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      decoration: const BoxDecoration(
        color: LushiStayTheme.bgSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: _isSuccess
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(16),
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F5A37),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, color: Color(0xFF4ADE80), size: 32),
                ),
                const Gap(16),
                Text(
                  'Réservation confirmée !',
                  style: GoogleFonts.plusJakartaSans(
                    color: LushiStayTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(8),
                Text(
                  'Votre séjour à ${p.title} est validé pour $_nights nuits.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    color: LushiStayTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const Gap(24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LushiStayTheme.copper,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Fermer'),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: LushiStayTheme.cardBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Gap(18),
                Text(
                  'Détails de la réservation',
                  style: GoogleFonts.plusJakartaSans(
                    color: LushiStayTheme.textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(16),
                // Nuits
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Nombre de nuits', style: GoogleFonts.plusJakartaSans(color: LushiStayTheme.textSecondary, fontSize: 14)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _nights > 1 ? () => setState(() => _nights--) : null,
                          icon: const Icon(Icons.remove_circle_outline, color: LushiStayTheme.coral),
                        ),
                        Text('$_nights nuits', style: GoogleFonts.plusJakartaSans(color: LushiStayTheme.textPrimary, fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: () => setState(() => _nights++),
                          icon: const Icon(Icons.add_circle_outline, color: LushiStayTheme.coral),
                        ),
                      ],
                    ),
                  ],
                ),
                // Voyageurs
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Voyageurs', style: GoogleFonts.plusJakartaSans(color: LushiStayTheme.textSecondary, fontSize: 14)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _guests > 1 ? () => setState(() => _guests--) : null,
                          icon: const Icon(Icons.remove_circle_outline, color: LushiStayTheme.coral),
                        ),
                        Text('$_guests pers.', style: GoogleFonts.plusJakartaSans(color: LushiStayTheme.textPrimary, fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: () => setState(() => _guests++),
                          icon: const Icon(Icons.add_circle_outline, color: LushiStayTheme.coral),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(color: LushiStayTheme.cardBorder),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total estimé', style: GoogleFonts.plusJakartaSans(color: LushiStayTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$$totalUsd', style: GoogleFonts.plusJakartaSans(color: LushiStayTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
                        Text(BrandConfig.formatFc(totalUsd), style: GoogleFonts.plusJakartaSans(color: LushiStayTheme.oceanBlueMedium, fontSize: 13, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
                const Gap(20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => setState(() => _isSuccess = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LushiStayTheme.copper,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Confirmer la réservation', style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),
                const Gap(10),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () async {
                      final uri = ContactWhatsApp.waMeUri(
                        ownerPhone: p.ownerPhone,
                        text: ContactWhatsApp.interestMessage(
                          propertyTitle: p.title,
                          indicativePriceUsd: p.pricePerDay.round(),
                        ),
                      );
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: LushiStayTheme.cardBorder),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.chat_bubble_outline, color: Color(0xFF22C55E), size: 18),
                        const Gap(8),
                        Text('Contacter sur WhatsApp', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
