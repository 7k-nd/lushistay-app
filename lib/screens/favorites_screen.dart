import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/models/property.dart';
import 'package:elxau/services/firestore_service.dart';
import 'package:elxau/widgets/property_card.dart';
import 'package:elxau/screens/property_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = context.watch<FirestoreService>();

    return Scaffold(
      backgroundColor: LushiStayTheme.bg,
      body: SafeArea(
        child: StreamBuilder<List<Property>>(
          stream: firestoreService.getProperties(),
          builder: (context, snapshot) {
            final all = snapshot.data ?? [];
            // Pick top rated as default favorited items for preview
            final favorites = all.where((p) => p.rating >= 4.90).toList();

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'COUPS DE COEUR',
                          style: GoogleFonts.plusJakartaSans(
                            color: LushiStayTheme.copperLight,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          'Vos Favoris à Lushi',
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(6),
                        Text(
                          '${favorites.length} propriétés sauvegardées pour vos prochains séjours.',
                          style: GoogleFonts.plusJakartaSans(
                            color: LushiStayTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (favorites.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 80),
                      child: Column(
                        children: [
                          const Icon(Icons.favorite_border_rounded,
                              size: 48, color: LushiStayTheme.textMuted),
                          const Gap(14),
                          Text(
                            'Aucun favori pour le moment',
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
                          final prop = favorites[index];
                          return PropertyCard(
                            property: prop,
                            isFavorite: true,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PropertyDetailScreen(
                                    property: prop,
                                    startDate: DateTime.now(),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        childCount: favorites.length,
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
