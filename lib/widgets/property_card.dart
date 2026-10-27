import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/brand_config.dart';
import 'package:elxau/models/property.dart';

class PropertyCard extends StatefulWidget {
  final Property property;
  final VoidCallback? onTap;
  final bool isFavorite;
  final ValueChanged<bool>? onFavoriteToggle;
  final bool isHorizontal;

  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.isHorizontal = false,
  });

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    widget.onFavoriteToggle?.call(_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.property;
    final isHotel = p.type == PropertyType.hotel;
    final tagLabel = p.type.label == 'Maison' ? 'Villa' : p.type.label;
    final tagIcon = isHotel
        ? Icons.apartment_rounded
        : (p.type == PropertyType.house
            ? Icons.home_rounded
            : Icons.dashboard_rounded);

    final imageUrl = p.images.isNotEmpty
        ? p.images.first
        : 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=1200';

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 22),
        decoration: BoxDecoration(
          color: LushiStayTheme.bgCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: LushiStayTheme.cardBorder, width: 1),
          boxShadow: LushiStayTheme.cardShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                SizedBox(
                  height: 230,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
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
                      child: const Icon(Icons.broken_image_rounded,
                          color: LushiStayTheme.textMuted, size: 40),
                    ),
                  ),
                ),
                // Gradient Shadow on bottom of image for contrast
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.15),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.75),
                        ],
                      ),
                    ),
                  ),
                ),
                // Top Left: Category Badge
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isHotel
                          ? LushiStayTheme.hotelGreen
                          : Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isHotel
                            ? LushiStayTheme.hotelGreenText.withValues(alpha: 0.4)
                            : Colors.white.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tagIcon,
                          size: 14,
                          color: isHotel
                              ? LushiStayTheme.hotelGreenText
                              : Colors.white,
                        ),
                        const Gap(5),
                        Text(
                          tagLabel,
                          style: GoogleFonts.plusJakartaSans(
                            color: isHotel
                                ? LushiStayTheme.white
                                : Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Top Right: Favorite Button
                Positioned(
                  top: 14,
                  right: 14,
                  child: GestureDetector(
                    onTap: _toggleFavorite,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite
                            ? const Color(0xFFEF4444)
                            : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                // Bottom of Image: Location & Rating preview
                Positioned(
                  bottom: 12,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 15,
                        color: LushiStayTheme.copperLight,
                      ),
                      const Gap(4),
                      Text(
                        '${p.quartier} · ${p.ville}',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: LushiStayTheme.gold,
                      ),
                      const Gap(3),
                      Text(
                        p.rating.toStringAsFixed(2),
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Card Content Section
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    p.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(
                      color: LushiStayTheme.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const Gap(10),
                  // Price line matching screenshot: $320 / nuit • 912 000 FC
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '\$${p.pricePerDay}',
                              style: GoogleFonts.plusJakartaSans(
                                color: LushiStayTheme.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: ' / nuit',
                              style: GoogleFonts.plusJakartaSans(
                                color: LushiStayTheme.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: '  •  ',
                              style: GoogleFonts.plusJakartaSans(
                                color: LushiStayTheme.textMuted,
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                              text: BrandConfig.formatFc(p.pricePerDay.toInt()),
                              style: GoogleFonts.plusJakartaSans(
                                color: LushiStayTheme.copperLight,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(
          begin: 0.08,
          end: 0,
          curve: Curves.easeOutCubic,
        );
  }
}
