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
  final bool isHorizontal; // compat param, unused

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
  int _currentPage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    widget.onFavoriteToggle?.call(_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.property;
    final images = p.images.isNotEmpty
        ? p.images
        : ['https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=1200'];

    final bedrooms = p.features.bedrooms ?? 0;
    final bathrooms = p.features.bathrooms ?? 0;

    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Image carousel ───
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 240,
                    width: double.infinity,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      onPageChanged: (i) => setState(() => _currentPage = i),
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: images[index],
                          fit: BoxFit.cover,
                          placeholder: (ctx, url) => Container(
                            color: LushiStayTheme.bgCard,
                          ),
                          errorWidget: (ctx, url, err) => Container(
                            color: LushiStayTheme.bgCard,
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: LushiStayTheme.textMuted,
                              size: 32,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Heart — top right, Airbnb style (no background)
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: _toggleFavorite,
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? LushiStayTheme.destructive : Colors.white,
                      size: 26,
                      shadows: const [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),

                // Dot indicators — bottom center
                if (images.length > 1)
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        images.length > 5 ? 5 : images.length,
                        (idx) {
                          final isActive = idx == _currentPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 6,
                            width: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),

            const Gap(10),

            // ─── Text content below image ───
            // Row 1: Location — Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '${p.quartier}, ${p.ville}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      color: LushiStayTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: LushiStayTheme.textPrimary,
                    ),
                    const Gap(3),
                    Text(
                      p.rating.toStringAsFixed(2),
                      style: GoogleFonts.plusJakartaSans(
                        color: LushiStayTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Gap(2),

            // Row 2: Title
            Text(
              p.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                color: LushiStayTheme.textSecondary,
                fontSize: 14,
              ),
            ),

            const Gap(2),

            // Row 3: Features
            Text(
              '$bedrooms ch. · $bathrooms sdb',
              style: GoogleFonts.plusJakartaSans(
                color: LushiStayTheme.textSecondary,
                fontSize: 14,
              ),
            ),

            const Gap(6),

            // Row 4: Price
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '\$${p.pricePerDay.round()}',
                    style: GoogleFonts.plusJakartaSans(
                      color: LushiStayTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: ' / nuit',
                    style: GoogleFonts.plusJakartaSans(
                      color: LushiStayTheme.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                  TextSpan(
                    text: '  ·  ${BrandConfig.formatFc(p.pricePerDay.toInt())}',
                    style: GoogleFonts.plusJakartaSans(
                      color: LushiStayTheme.copperLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 350.ms);
  }
}
