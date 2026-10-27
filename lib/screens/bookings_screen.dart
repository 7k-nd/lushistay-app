import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/data/mock_data.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _selectedTab = 0; // 0 = En cours, 1 = Passés

  @override
  Widget build(BuildContext context) {
    final bookings = MockData.bookings;
    final now = DateTime.now();

    final activeBookings =
        bookings.where((b) => b.endDate.isAfter(now)).toList();
    final pastBookings =
        bookings.where((b) => b.endDate.isBefore(now)).toList();
    final currentList = _selectedTab == 0 ? activeBookings : pastBookings;

    return Scaffold(
      backgroundColor: LushiStayTheme.bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VOS ESCAPADES',
                      style: GoogleFonts.plusJakartaSans(
                        color: LushiStayTheme.copperLight,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      'Mes Voyages',
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(16),
                    // Segmented Tabs: "À venir / En cours" vs "Historique"
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: LushiStayTheme.bgCard,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: LushiStayTheme.cardBorder),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTab = 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _selectedTab == 0
                                      ? LushiStayTheme.copper
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'À venir (${activeBookings.length})',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: _selectedTab == 0
                                        ? Colors.white
                                        : LushiStayTheme.textSecondary,
                                    fontSize: 13,
                                    fontWeight: _selectedTab == 0
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTab = 1),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _selectedTab == 1
                                      ? LushiStayTheme.copper
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Historique (${pastBookings.length})',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: _selectedTab == 1
                                        ? Colors.white
                                        : LushiStayTheme.textSecondary,
                                    fontSize: 13,
                                    fontWeight: _selectedTab == 1
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (currentList.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                  child: Column(
                    children: [
                      const Icon(Icons.luggage_rounded,
                          size: 48, color: LushiStayTheme.textMuted),
                      const Gap(14),
                      Text(
                        _selectedTab == 0
                            ? 'Aucun voyage prévu pour l\'instant'
                            : 'Aucun historique de séjour',
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        'Découvrez nos villas et hôtels d\'exception dans l\'onglet Explorer.',
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
                      final b = currentList[index];
                      final startStr =
                          DateFormat('dd MMM yyyy', 'fr_FR').format(b.startDate);
                      final endStr =
                          DateFormat('dd MMM yyyy', 'fr_FR').format(b.endDate);
                      final propImage = b.property.images.isNotEmpty
                          ? b.property.images.first
                          : '';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: LushiStayTheme.bgCard,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: LushiStayTheme.cardBorder),
                          boxShadow: LushiStayTheme.cardShadow,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (propImage.isNotEmpty)
                              SizedBox(
                                height: 160,
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  imageUrl: propImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0F5A37),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Confirmé',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: const Color(0xFF4ADE80),
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '\$${b.totalPrice}',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(10),
                                  Text(
                                    b.property.title,
                                    style: GoogleFonts.playfairDisplay(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Gap(6),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today_rounded,
                                          size: 14,
                                          color: LushiStayTheme.copperLight),
                                      const Gap(6),
                                      Text(
                                        '$startStr  →  $endStr',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: LushiStayTheme.textSecondary,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(6),
                                  Row(
                                    children: [
                                      const Icon(Icons.person_outline_rounded,
                                          size: 15,
                                          color: LushiStayTheme.textSecondary),
                                      const Gap(6),
                                      Text(
                                        'Réservation au nom de ${b.userName}',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: LushiStayTheme.textMuted,
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 350.ms);
                    },
                    childCount: currentList.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
