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
                          'Favoris',
                          style: GoogleFonts.plusJakartaSans(
                            color: LushiStayTheme.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          '${favorites.length} coups de cœur enregistrés',
                          style: GoogleFonts.plusJakartaSans(
                            color: LushiStayTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (favorites.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.favorite_border_rounded,
                              size: 48,
                              color: LushiStayTheme.textMuted,
                            ),
                            const Gap(16),
                            Text(
                              'Créez votre première liste de favoris',
                              style: GoogleFonts.plusJakartaSans(
                                color: LushiStayTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Gap(8),
                            Text(
                              'Lorsque vous explorez des logements, appuyez sur le cœur pour enregistrer vos coups de cœur ici.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                color: LushiStayTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
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
