import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elxau/theme.dart';
import 'package:gap/gap.dart';
import 'package:elxau/models/property.dart';
import 'package:elxau/data/mock_data.dart';
import 'package:elxau/widgets/property_card.dart';

class BuyScreen extends StatelessWidget {
  const BuyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // All mock properties are considered for sale in this demo.
    final List<Property> properties = MockProperties.properties;
    return Scaffold(
      backgroundColor: LushiStayTheme.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                'Biens à acheter',
                style: GoogleFonts.plusJakartaSans(
                  color: LushiStayTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Gap(8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  return PropertyCard(property: properties[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
