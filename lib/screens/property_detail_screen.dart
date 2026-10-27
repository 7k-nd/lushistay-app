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

  void _showBookingDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BookingBottomSheet(property: widget.property),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.property;
    final isHotel = p.type == PropertyType.hotel;
    final tagLabel = isHotel ? 'Hôtel' : (p.type == PropertyType.house ? 'Villa' : p.type.label);
    final buttonLabel = isHotel ? 'Réserver la chambre' : 'Réserver le séjour';

    final images = p.images.isNotEmpty
        ? p.images
        : [
            'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=1200&q=80',
            'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200&q=80',
            'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=1200&q=80',
          ];

    return Scaffold(
      backgroundColor: LushiStayTheme.bg,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Image Gallery
                Stack(
                  children: [
                    SizedBox(
                      height: 380,
                      width: double.infinity,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: images.length,
                        onPageChanged: (i) {
                          setState(() => _currentImageIndex = i);
                        },
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: images[index],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: LushiStayTheme.bgSurface,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      LushiStayTheme.copper),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: LushiStayTheme.bgSurface,
                              child: const Icon(
                                Icons.broken_image_rounded,
                                color: LushiStayTheme.textMuted,
                                size: 50,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.5),
                              Colors.transparent,
                              LushiStayTheme.bg.withValues(alpha: 0.95),
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Top App Bar Controls
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Back Button
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.chevron_left_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ),
                            // Favorite Button
                            GestureDetector(
                              onTap: () {
                                setState(() => _isFavorite = !_isFavorite);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Icon(
                                  _isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _isFavorite
                                      ? const Color(0xFFEF4444)
                                      : Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Carousel Dots (Matching screenshot: active copper oval, inactive gray round)
                    Positioned(
                      bottom: 24,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(images.length, (idx) {
                          final isActive = idx == _currentImageIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 6,
                            width: isActive ? 20 : 6,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? LushiStayTheme.copper
                                  : Colors.white.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),

                // Main Details Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isHotel
                              ? LushiStayTheme.hotelGreen
                              : Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isHotel
                                ? LushiStayTheme.hotelGreenText.withValues(alpha: 0.4)
                                : Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          tagLabel,
                          style: GoogleFonts.plusJakartaSans(
                            color: isHotel
                                ? LushiStayTheme.white
                                : Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const Gap(12),

                      // Title
                      Text(
                        p.title,
                        style: GoogleFonts.playfairDisplay(
                          color: LushiStayTheme.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const Gap(8),

                      // Location & Rating row: 📍 Golf, Lubumbashi   ★ 4.90 (212 avis)
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: LushiStayTheme.copperLight,
                          ),
                          const Gap(4),
                          Text(
                            '${p.quartier}, ${p.ville}',
                            style: GoogleFonts.plusJakartaSans(
                              color: LushiStayTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const Gap(16),
                          const Icon(
                            Icons.star_rounded,
                            size: 18,
                            color: LushiStayTheme.gold,
                          ),
                          const Gap(4),
                          Text(
                            '${p.rating.toStringAsFixed(2)} (${p.reviewCount} avis)',
                            style: GoogleFonts.plusJakartaSans(
                              color: LushiStayTheme.white,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const Gap(22),
                      const Divider(color: LushiStayTheme.cardBorder),
                      const Gap(16),

                      // Host Card: Green avatar 'L' + Proposé par LushiStay Premium + Verified check
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF0F5A37),
                              border: Border.all(
                                color: const Color(0xFF22C55E),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                p.ownerName.isNotEmpty
                                    ? p.ownerName[0].toUpperCase()
                                    : 'L',
                                style: GoogleFonts.playfairDisplay(
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
                                  'Proposé par',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: LushiStayTheme.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                                const Gap(2),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        p.ownerName,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: LushiStayTheme.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Gap(6),
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF10B981),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Gap(18),
                      const Divider(color: LushiStayTheme.cardBorder),
                      const Gap(16),

                      // Description
                      Text(
                        p.description,
                        style: GoogleFonts.plusJakartaSans(
                          color: LushiStayTheme.textSecondary,
                          fontSize: 14.5,
                          height: 1.55,
                        ),
                      ),

                      const Gap(24),

                      // Équipements Section
                      Text(
                        'Équipements',
                        style: GoogleFonts.playfairDisplay(
                          color: LushiStayTheme.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(14),

                      // Horizontal Amenities Chips matching screenshot
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _buildAmenityChip('Wi-Fi haut débit', Icons.wifi_rounded),
                          _buildAmenityChip('Piscine', Icons.pool_rounded),
                          _buildAmenityChip('Spa & Bien-être', Icons.spa_rounded),
                          _buildAmenityChip('Petit-déjeuner inclus', Icons.restaurant_rounded),
                          _buildAmenityChip('Climatisation', Icons.ac_unit_rounded),
                          _buildAmenityChip('Parking privé', Icons.local_parking_rounded),
                          _buildAmenityChip('Sécurité 24/7', Icons.shield_rounded),
                          _buildAmenityChip('Navette Luano', Icons.airport_shuttle_rounded),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sticky Bottom Bar matching screenshot: $145 / nuit • 413 250 FC + "Réserver la chambre"
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(context).padding.bottom + 14,
              ),
              decoration: BoxDecoration(
                color: LushiStayTheme.bgSurface,
                border: const Border(
                  top: BorderSide(color: LushiStayTheme.cardBorder, width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Price Left
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '\$${p.pricePerDay}',
                              style: GoogleFonts.plusJakartaSans(
                                color: LushiStayTheme.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: ' / nuit',
                              style: GoogleFonts.plusJakartaSans(
                                color: LushiStayTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(2),
                      Text(
                        BrandConfig.formatFc(p.pricePerDay),
                        style: GoogleFonts.plusJakartaSans(
                          color: LushiStayTheme.copperLight,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Reserve Button
                  ElevatedButton(
                    onPressed: () => _showBookingDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LushiStayTheme.copper,
                      foregroundColor: LushiStayTheme.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      buttonLabel,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
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

  Widget _buildAmenityChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: LushiStayTheme.bgCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: LushiStayTheme.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: LushiStayTheme.copper,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              size: 10,
              color: Colors.white,
            ),
          ),
          const Gap(8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: LushiStayTheme.textPrimary,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingBottomSheet extends StatefulWidget {
  final Property property;

  const _BookingBottomSheet({required this.property});

  @override
  State<_BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<_BookingBottomSheet> {
  int _nights = 2;
  int _guests = 2;
  bool _isSuccess = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.property;
    final totalUsd = p.pricePerDay * _nights;

    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      decoration: const BoxDecoration(
        color: LushiStayTheme.bgSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: LushiStayTheme.cardBorder, width: 1),
        ),
      ),
      child: _isSuccess
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(16),
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F5A37),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF4ADE80),
                    size: 36,
                  ),
                ),
                const Gap(18),
                Text(
                  'Réservation confirmée !',
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(8),
                Text(
                  'Votre séjour à "${p.title}" a bien été enregistré en mode démo.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    color: LushiStayTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const Gap(24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LushiStayTheme.copper,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('Fermer'),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: LushiStayTheme.cardBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Gap(20),
                Text(
                  'Réserver ${p.title}',
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(16),
                // Nights Counter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Durée du séjour',
                      style: GoogleFonts.plusJakartaSans(
                        color: LushiStayTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _nights > 1
                              ? () => setState(() => _nights--)
                              : null,
                          icon: const Icon(Icons.remove_circle_outline,
                              color: LushiStayTheme.copper),
                        ),
                        Text(
                          '$_nights nuits',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _nights++),
                          icon: const Icon(Icons.add_circle_outline,
                              color: LushiStayTheme.copper),
                        ),
                      ],
                    ),
                  ],
                ),
                // Guests Counter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Voyageurs',
                      style: GoogleFonts.plusJakartaSans(
                        color: LushiStayTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _guests > 1
                              ? () => setState(() => _guests--)
                              : null,
                          icon: const Icon(Icons.remove_circle_outline,
                              color: LushiStayTheme.copper),
                        ),
                        Text(
                          '$_guests pers.',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _guests++),
                          icon: const Icon(Icons.add_circle_outline,
                              color: LushiStayTheme.copper),
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(12),
                const Divider(color: LushiStayTheme.cardBorder),
                const Gap(12),
                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total estimé',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$$totalUsd',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          BrandConfig.formatFc(totalUsd),
                          style: GoogleFonts.plusJakartaSans(
                            color: LushiStayTheme.copperLight,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(22),
                // Confirm Demo Booking Button
                ElevatedButton(
                  onPressed: () {
                    setState(() => _isSuccess = true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LushiStayTheme.copper,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Confirmer la réservation',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Gap(12),
                // Direct WhatsApp Button
                OutlinedButton(
                  onPressed: () async {
                    final uri = ContactWhatsApp.waMeUri(
                      ownerPhone: p.ownerPhone,
                      text: ContactWhatsApp.interestMessage(
                        propertyTitle: p.title,
                        indicativePriceUsd: p.pricePerDay.round(),
                      ),
                    );
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: LushiStayTheme.cardBorder),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.chat_rounded,
                          color: Color(0xFF22C55E), size: 18),
                      const Gap(8),
                      Text(
                        'Contacter l\'hôte sur WhatsApp',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
