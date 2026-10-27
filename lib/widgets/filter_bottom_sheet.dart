import 'package:flutter/cupertino.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/cupertino_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> initialFilters;

  const FilterBottomSheet({super.key, required this.initialFilters});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late AppRange _priceRange;
  late double _minRating;
  late List<String> _selectedFacilities;

  final List<String> _facilities = [
    'WiFi', 'Piscine', 'Parking', 'Restaurant',
    'Spa', 'Gym', 'Bar', 'Climatisation'
  ];

  @override
  void initState() {
    super.initState();
    _priceRange = widget.initialFilters['priceRange'] ?? const AppRange(0, 1000);
    _minRating = widget.initialFilters['minRating'] ?? 0.0;
    _selectedFacilities = List<String>.from(widget.initialFilters['facilities'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
      decoration: const BoxDecoration(
        color: ElxauTheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ElxauTheme.secondaryText.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filtres',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: ElxauTheme.accent,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  onPressed: () {
                    setState(() {
                      _priceRange = const AppRange(0, 1000);
                      _minRating = 0.0;
                      _selectedFacilities = [];
                    });
                  },
                  child: const Text('Réinitialiser', style: TextStyle(color: ElxauTheme.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('GAMME DE PRIX (CDF)'),
            const SizedBox(height: 8),
            AppRangeSlider(
              values: _priceRange,
              min: 0,
              max: 1000,
              onChanged: (values) => setState(() => _priceRange = values),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('0k CDF', style: TextStyle(color: ElxauTheme.secondaryText, fontSize: 12)),
                Text('1.000k+ CDF', style: TextStyle(color: ElxauTheme.secondaryText, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('NOTE MINIMALE'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                final rating = index + 1.0;
                final isSelected = _minRating >= rating;
                return GestureDetector(
                  onTap: () => setState(() => _minRating = rating),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? ElxauTheme.accent : ElxauTheme.bg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.star_fill,
                          color: isSelected ? ElxauTheme.primary : ElxauTheme.secondaryText.withValues(alpha: 0.5),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isSelected ? ElxauTheme.white : ElxauTheme.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('ÉQUIPEMENTS'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _facilities.map((facility) {
                final isSelected = _selectedFacilities.contains(facility);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedFacilities.remove(facility);
                      } else {
                        _selectedFacilities.add(facility);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? ElxauTheme.primary : ElxauTheme.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? ElxauTheme.primary : ElxauTheme.grayLight,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      facility,
                      style: TextStyle(
                        color: isSelected ? ElxauTheme.white : ElxauTheme.secondaryText,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: AppFilledButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'priceRange': _priceRange,
                    'minRating': _minRating,
                    'facilities': _selectedFacilities,
                  });
                },
                borderRadius: BorderRadius.circular(20),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Text('Appliquer les filtres'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 10,
        color: ElxauTheme.secondaryText,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
      ),
    );
  }
}
