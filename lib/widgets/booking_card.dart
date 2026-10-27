import 'package:flutter/cupertino.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/cupertino_ui.dart';
import 'package:elxau/models/property.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingCard extends StatelessWidget {
  final PropertyBooking booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final bool isUpcoming = booking.bookingStatus == 'upcoming';
    final String formattedCheckIn = DateFormat('dd MMM yyyy', 'fr_FR').format(booking.startDate);
    final String formattedCheckOut = DateFormat('dd MMM yyyy', 'fr_FR').format(booking.endDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ElxauTheme.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: ElxauTheme.softShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: booking.property.images.isNotEmpty ? Image.network(
                  booking.property.images.first,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(CupertinoIcons.house, size: 40),
                ) : const Icon(CupertinoIcons.house, size: 40),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              booking.property.title,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ElxauTheme.accent,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                               color: isUpcoming ? ElxauTheme.primary.withValues(alpha: 0.1) : ElxauTheme.secondaryText.withValues(alpha: 0.1),
                               borderRadius: BorderRadius.circular(8)
                            ),
                            child: Text(
                               isUpcoming ? 'À VENIR' : 'TERMINÉE',
                               style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isUpcoming ? ElxauTheme.primary : ElxauTheme.secondaryText
                               ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${booking.property.quartier}, ${booking.property.ville}',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: ElxauTheme.secondaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                       Text(
                        '\$${booking.totalPrice}',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ElxauTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const AppDivider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateColumn('Arrivée', formattedCheckIn),
                const Icon(CupertinoIcons.arrow_right, color: ElxauTheme.secondaryText),
                _buildDateColumn('Départ', formattedCheckOut),
                 if(isUpcoming)
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: () {},
                      child: const Icon(CupertinoIcons.qrcode, color: ElxauTheme.accent),
                    )
              ],
            ),
          )
        ],
      ),
    );
  }

   Widget _buildDateColumn(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: ElxauTheme.secondaryText,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ElxauTheme.accent,
          ),
        ),
      ],
    );
  }
}
