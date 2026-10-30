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
  int _selectedTab = 0; // 0 = À venir, 1 = Passés

  @override
  Widget build(BuildContext context) {
    final bookings = MockData.bookings;
    final now = DateTime.now();

    final activeBookings = bookings.where((b) => b.endDate.isAfter(now)).toList();
    final pastBookings = bookings.where((b) => b.endDate.isBefore(now)).toList();
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
                      'Voyages',
                      style: GoogleFonts.plusJakartaSans(
                        color: LushiStayTheme.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Gap(16),
                    // Airbnb style clean pill switcher
                    Row(
                      children: [
                        _buildTabPill(0, 'À venir (${activeBookings.length})'),
                        const Gap(10),
                        _buildTabPill(1, 'Passés (${pastBookings.length})'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (currentList.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.luggage_outlined,
                          size: 48,
                          color: LushiStayTheme.textMuted,
                        ),
                        const Gap(16),
                        Text(
                          _selectedTab == 0
                              ? 'Aucun voyage prévu pour le moment'
                              : 'Aucun voyage passé',
                          style: GoogleFonts.plusJakartaSans(
                            color: LushiStayTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          'Il est temps de dépoussiérer vos valises et de planifier votre prochaine escapade à Lubumbashi.',
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
                      final b = currentList[index];
                      final startStr = DateFormat('dd MMM', 'fr_FR').format(b.startDate);
                      final endStr = DateFormat('dd MMM yyyy', 'fr_FR').format(b.endDate);
                      final propImage = b.property.images.isNotEmpty ? b.property.images.first : '';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: LushiStayTheme.bgCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: LushiStayTheme.cardBorder),
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
                                  placeholder: (_, __) => Container(color: LushiStayTheme.bgSurface),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Séjour à ${b.property.quartier}',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: LushiStayTheme.textMuted,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0F5A37),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Confirmé',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: const Color(0xFF4ADE80),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(6),
                                  Text(
                                    b.property.title,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: LushiStayTheme.textPrimary,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Gap(8),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today_outlined, size: 14, color: LushiStayTheme.copperLight),
                                      const Gap(6),
                                      Text(
                                        '$startStr – $endStr',
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
                                      const Icon(Icons.person_outline, size: 14, color: LushiStayTheme.textMuted),
                                      const Gap(6),
                                      Text(
                                        'Réservé par ${b.userName}',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: LushiStayTheme.textMuted,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 300.ms);
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

  Widget _buildTabPill(int index, String label) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? LushiStayTheme.textPrimary : LushiStayTheme.bgSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? LushiStayTheme.textPrimary : LushiStayTheme.cardBorder,
          ),
          boxShadow: isSelected ? LushiStayTheme.softShadow : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: isSelected ? Colors.white : LushiStayTheme.textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
