import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/models/property.dart';
import 'package:elxau/services/firestore_service.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:elxau/widgets/property_card.dart';
import 'package:elxau/screens/property_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Tout';
  String _selectedQuartier = 'Tous les quartiers';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final Set<String> _favoriteIds = {};

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Tout', 'icon': Icons.grid_view_rounded, 'type': null},
    {'label': 'Hôtels', 'icon': Icons.apartment_rounded, 'type': PropertyType.hotel},
    {'label': 'Villas', 'icon': Icons.home_rounded, 'type': PropertyType.house},
    {'label': 'Appartements', 'icon': Icons.dashboard_rounded, 'type': PropertyType.apartment},
  ];

  final List<String> _quartiers = [
    'Tous les quartiers',
    'Golf',
    'Centre-ville',
    'Bel-Air',
    'Makutano',
    'Kipopo',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
    final authService = context.watch<AuthService>();
    final userName = authService.currentUser?.name ?? 'Voyageur';
    final userInitial = userName.isNotEmpty ? userName[0].toUpperCase() : 'V';

    return Scaffold(
      backgroundColor: LushiStayTheme.bg,
      body: SafeArea(
        bottom: false,
        child: StreamBuilder<List<Property>>(
          stream: firestoreService.getProperties(),
          builder: (context, snapshot) {
            final isLoading = snapshot.connectionState == ConnectionState.waiting;
            final allProperties = snapshot.data ?? [];

            // Filter by Category
            var filtered = allProperties.where((p) {
              if (_selectedCategory == 'Hôtels') return p.type == PropertyType.hotel;
              if (_selectedCategory == 'Villas') return p.type == PropertyType.house;
              if (_selectedCategory == 'Appartements') return p.type == PropertyType.apartment;
              return true;
            }).toList();

            // Filter by Quartier
            if (_selectedQuartier != 'Tous les quartiers') {
              filtered = filtered
                  .where((p) => p.quartier.toLowerCase() == _selectedQuartier.toLowerCase())
                  .toList();
            }

            // Filter by Search Query
            if (_searchQuery.trim().isNotEmpty) {
              final query = _searchQuery.toLowerCase();
              filtered = filtered.where((p) {
                return p.title.toLowerCase().contains(query) ||
                    p.quartier.toLowerCase().contains(query) ||
                    p.description.toLowerCase().contains(query);
              }).toList();
            }

            return CustomScrollView(
              slivers: [
                // Top Header: "MBOTE, VOYAGEUR" + "Où séjourner à Lushi ?" + Avatar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MBOTE, VOYAGEUR',
                                style: GoogleFonts.plusJakartaSans(
                                  color: LushiStayTheme.copperLight,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                'Où séjourner à Lushi ?',
                                style: GoogleFonts.playfairDisplay(
                                  color: LushiStayTheme.white,
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Profile Avatar circle green with letter 'V'
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF0F5A37),
                            border: Border.all(
                              color: const Color(0xFF22C55E),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              userInitial,
                              style: GoogleFonts.playfairDisplay(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: LushiStayTheme.inputBg,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: LushiStayTheme.cardBorder),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            color: LushiStayTheme.textSecondary,
                            size: 22,
                          ),
                          const Gap(12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (val) {
                                setState(() => _searchQuery = val);
                              },
                              style: GoogleFonts.plusJakartaSans(
                                color: LushiStayTheme.white,
                                fontSize: 14.5,
                              ),
                              cursorColor: LushiStayTheme.copper,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: 'Rechercher un logement, un quartier...',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  color: LushiStayTheme.textMuted,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              child: const Icon(
                                Icons.close_rounded,
                                color: LushiStayTheme.textSecondary,
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Category Filter Pills (Tout, Hôtels, Villas, Appartements)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 54,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const Gap(10),
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = _selectedCategory == cat['label'];
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat['label']),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? LushiStayTheme.copper
                                  : LushiStayTheme.bgCard,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected
                                    ? LushiStayTheme.copper
                                    : LushiStayTheme.cardBorder,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  cat['icon'] as IconData,
                                  size: 16,
                                  color: isSelected
                                      ? Colors.white
                                      : LushiStayTheme.textSecondary,
                                ),
                                const Gap(7),
                                Text(
                                  cat['label'] as String,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: isSelected
                                        ? Colors.white
                                        : LushiStayTheme.textSecondary,
                                    fontSize: 13,
                                    fontWeight:
                                        isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Neighborhood Filter Pills (Tous les quartiers, Golf, Centre-ville, ...)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 48,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      scrollDirection: Axis.horizontal,
                      itemCount: _quartiers.length,
                      separatorBuilder: (_, __) => const Gap(10),
                      itemBuilder: (context, index) {
                        final q = _quartiers[index];
                        final isSelected = _selectedQuartier == q;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedQuartier = q),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? LushiStayTheme.copper
                                  : LushiStayTheme.bgCard,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? LushiStayTheme.copper
                                    : LushiStayTheme.cardBorder,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected) ...[
                                  const Icon(
                                    Icons.location_on_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const Gap(5),
                                ],
                                Text(
                                  q,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: isSelected
                                        ? Colors.white
                                        : LushiStayTheme.textSecondary,
                                    fontSize: 12.5,
                                    fontWeight:
                                        isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Counter: "10 logements disponibles"
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                    child: Text(
                      '${filtered.length} logements disponibles',
                      style: GoogleFonts.plusJakartaSans(
                        color: LushiStayTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // Property Cards Feed
                if (isLoading)
                  SliverToBoxAdapter(
                    child: Skeletonizer(
                      enabled: true,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: List.generate(
                            2,
                            (index) => Container(
                              height: 300,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: LushiStayTheme.bgCard,
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else if (filtered.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
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
                            style: GoogleFonts.playfairDisplay(
                              color: LushiStayTheme.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(8),
                          Text(
                            'Essayez de modifier vos filtres de quartier ou catégorie.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              color: LushiStayTheme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final property = filtered[index];
                          final isFav = _favoriteIds.contains(property.id);
                          return PropertyCard(
                            property: property,
                            isFavorite: isFav,
                            onFavoriteToggle: (_) => _toggleFavorite(property.id),
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
                        childCount: filtered.length,
                      ),
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
