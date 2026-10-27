import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/models/property.dart';
import 'package:elxau/services/firestore_service.dart';
import 'package:elxau/widgets/property_card.dart';
import 'package:elxau/screens/property_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Tout';
  final Set<String> _favoriteIds = {};

  static const List<_CategoryItem> _categories = [
    _CategoryItem('Tout', Icons.apps_rounded),
    _CategoryItem('Hôtels', Icons.apartment_outlined),
    _CategoryItem('Villas', Icons.home_outlined),
    _CategoryItem('Apparts', Icons.dashboard_outlined),
    _CategoryItem('Piscine', Icons.pool_outlined),
    _CategoryItem('Lac', Icons.water_outlined),
  ];

  void _toggleFavorite(String propertyId) {
    setState(() {
      if (_favoriteIds.contains(propertyId)) {
        _favoriteIds.remove(propertyId);
      } else {
        _favoriteIds.add(propertyId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = context.watch<FirestoreService>();

    return Scaffold(
      backgroundColor: LushiStayTheme.bg,
      body: SafeArea(
        bottom: false,
        child: StreamBuilder<List<Property>>(
          stream: firestoreService.getProperties(),
          builder: (context, snapshot) {
            final isLoading = snapshot.connectionState == ConnectionState.waiting;
            final allProperties = snapshot.data ?? [];

            // Filter by category
            var filtered = allProperties.where((p) {
              if (_selectedCategory == 'Hôtels') return p.type == PropertyType.hotel;
              if (_selectedCategory == 'Villas') return p.type == PropertyType.house;
              if (_selectedCategory == 'Apparts') return p.type == PropertyType.apartment;
              if (_selectedCategory == 'Piscine') return p.features.hasPool == true;
              return true;
            }).toList();

            return Column(
              children: [
                // ─── Search bar (tappable pill, not a text field) ───
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: GestureDetector(
                    onTap: () {
                      // TODO: open search
                    },
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: LushiStayTheme.bgCard,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: LushiStayTheme.cardBorder),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: LushiStayTheme.textPrimary,
                            size: 22,
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Où allez-vous ?',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: LushiStayTheme.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'N\'importe où · N\'importe quand · Voyageurs',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: LushiStayTheme.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: LushiStayTheme.cardBorder),
                            ),
                            child: const Icon(
                              Icons.tune_rounded,
                              color: LushiStayTheme.textPrimary,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ─── Category bar with icons + label + underline ───
                Container(
                  height: 72,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: LushiStayTheme.cardBorder,
                        width: 1,
                      ),
                    ),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat.label;
                      final color = isSelected
                          ? LushiStayTheme.textPrimary
                          : LushiStayTheme.textMuted;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat.label),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 64,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(cat.icon, size: 26, color: color),
                              const Gap(4),
                              Text(
                                cat.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  color: color,
                                  fontSize: 11,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                              const Gap(6),
                              // Underline indicator
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 2,
                                width: isSelected ? 28 : 0,
                                decoration: BoxDecoration(
                                  color: LushiStayTheme.copper,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ─── Property feed ───
                Expanded(
                  child: isLoading
                      ? Skeletonizer(
                          enabled: true,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                            itemCount: 3,
                            itemBuilder: (context, index) => Container(
                              height: 300,
                              margin: const EdgeInsets.only(bottom: 24),
                              decoration: BoxDecoration(
                                color: LushiStayTheme.bgCard,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        )
                      : filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.search_off_rounded,
                                    size: 48,
                                    color: LushiStayTheme.textMuted,
                                  ),
                                  const Gap(16),
                                  Text(
                                    'Aucun logement trouvé',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: LushiStayTheme.textPrimary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Gap(8),
                                  Text(
                                    'Essayez une autre catégorie',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: LushiStayTheme.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final property = filtered[index];
                                final isFav = _favoriteIds.contains(property.id);
                                return PropertyCard(
                                  property: property,
                                  isFavorite: isFav,
                                  onFavoriteToggle: (_) =>
                                      _toggleFavorite(property.id),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => PropertyDetailScreen(
                                          property: property,
                                          durationType: DurationType.days,
                                          duration: 1,
                                          startDate: DateTime.now(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategoryItem {
  final String label;
  final IconData icon;
  const _CategoryItem(this.label, this.icon);
}
