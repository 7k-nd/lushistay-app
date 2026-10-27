import 'package:flutter/cupertino.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/cupertino_ui.dart';
import 'package:elxau/models/property.dart';
import 'package:elxau/screens/property_list_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PropertySearchScreen extends StatefulWidget {
  const PropertySearchScreen({super.key});

  @override
  State<PropertySearchScreen> createState() => _PropertySearchScreenState();
}

class _PropertySearchScreenState extends State<PropertySearchScreen> {
  PropertyType? _selectedType;
  ListingPurpose? _selectedPurpose;
  String _selectedQuartier = 'Tous';
  String _durationUnit = 'jours'; // 'jours' ou 'mois'
  int _duration = 1;
  DateTime _startDate = DateTime.now();
  AppRange _priceRange = const AppRange(0, 1000);
  bool _hasPool = false;
  bool _hasFurnished = false;
  bool _hasParking = false;
  bool _hasSecurity = false;
  int _minBedrooms = 0;

  final List<String> _quartiers = [
    'Tous',
    'Lubumbashi',
    'Kenya',
    'Kampemba',
    'Katuba',
    'Ruashi',
    'Annexe',
    'Rwashi',
    'Kamalondo',
    'Commune Urbaine',
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: ElxauTheme.bg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(
            child: AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 400),
                  childAnimationBuilder: (w) => SlideAnimation(
                    verticalOffset: 40,
                    child: FadeInAnimation(child: w),
                  ),
                  children: [
                    const SizedBox(height: 24),
                    _buildTypeSelector(),
                    const SizedBox(height: 24),
                    _buildPurposeSelector(),
                    const SizedBox(height: 24),
                    _buildQuartierSelector(),
                    const SizedBox(height: 24),
                    _buildDateDurationCard(),
                    const SizedBox(height: 24),
                    _buildSpecificitiesCard(),
                    const SizedBox(height: 24),
                    _buildPriceRangeCard(),
                    const SizedBox(height: 40),
                    _buildSearchButton(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(CupertinoIcons.building_2_fill,
                    color: ElxauTheme.primary, size: 26),
                const SizedBox(width: 10),
                Text(
                  'Immobilier',
                  style: GoogleFonts.playfairDisplay(
                    color: ElxauTheme.accent,
                    fontWeight: FontWeight.w900,
                    fontSize: 26,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
            Text(
              'Trouvez votre bien idéal à Lubumbashi',
              style: GoogleFonts.outfit(
                color: ElxauTheme.secondaryText,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    final types = [
      PropertyType.hotel,
      PropertyType.house,
      PropertyType.apartment,
      PropertyType.land,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Je cherche un…'),
          const SizedBox(height: 14),
          Row(
            children: types.map((t) {
              final isSelected = _selectedType == t;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedType = t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? ElxauTheme.accent : ElxauTheme.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? ElxauTheme.primary : ElxauTheme.grayLight,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected ? ElxauTheme.softShadow : null,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          t.icon,
                          size: 24,
                          color: isSelected ? ElxauTheme.white : ElxauTheme.primary,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          t.label,
                          style: GoogleFonts.outfit(
                            color: isSelected ? ElxauTheme.white : ElxauTheme.accent,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPurposeSelector() {
    final options = <(ListingPurpose?, String)>[
      (null, 'Tous'),
      (ListingPurpose.sale, 'Acheter'),
      (ListingPurpose.rent, 'Louer'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Acheter ou louer'),
          const SizedBox(height: 14),
          Row(
            children: options.map((o) {
              final isSelected = _selectedPurpose == o.$1;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedPurpose = o.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? ElxauTheme.accent : ElxauTheme.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? ElxauTheme.primary
                            : ElxauTheme.grayLight,
                      ),
                    ),
                    child: Text(
                      o.$2,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        color: isSelected ? ElxauTheme.white : ElxauTheme.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuartierSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Quartier / Commune'),
          const SizedBox(height: 14),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _quartiers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final q = _quartiers[i];
                final isSelected = _selectedQuartier == q;
                return GestureDetector(
                  onTap: () => setState(() => _selectedQuartier = q),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? ElxauTheme.primary : ElxauTheme.white,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: isSelected ? ElxauTheme.primary : ElxauTheme.grayLight,
                      ),
                    ),
                    child: Text(
                      q,
                      style: GoogleFonts.outfit(
                        color: isSelected ? ElxauTheme.white : ElxauTheme.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateDurationCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: ElxauTheme.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: ElxauTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Date d\'arrivée & Durée'),
            const SizedBox(height: 16),
            // Date d'arrivée
            GestureDetector(
              onTap: () async {
                final now = DateTime.now();
                final minimumDate = DateTime(now.year, now.month, now.day);
                final picked = await pickCupertinoDate(
                  context,
                  initialDate: _startDate.isBefore(minimumDate) ? minimumDate : _startDate,
                  minimumDate: minimumDate,
                  maximumDate: now.add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => _startDate = picked);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ElxauTheme.bg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.calendar, color: ElxauTheme.primary, size: 20),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date d\'arrivée',
                          style: GoogleFonts.outfit(
                            color: ElxauTheme.secondaryText,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                          style: GoogleFonts.outfit(
                            color: ElxauTheme.accent,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(CupertinoIcons.chevron_right, color: ElxauTheme.secondaryText),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Durée : jours / mois
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Durée',
                        style: GoogleFonts.outfit(
                          color: ElxauTheme.secondaryText,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: ['jours', 'mois'].map((unit) {
                          final isSelected = _durationUnit == unit;
                          return GestureDetector(
                            onTap: () => setState(() {
                              _durationUnit = unit;
                              _duration = 1;
                              final newMax = unit == 'jours' ? 1000.0 : 10000.0;
                              _priceRange = AppRange(
                                _priceRange.start.clamp(0.0, newMax),
                                _priceRange.end.clamp(0.0, newMax),
                              );
                            }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? ElxauTheme.accent : ElxauTheme.bg,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                unit,
                                style: GoogleFonts.outfit(
                                  color: isSelected ? ElxauTheme.white : ElxauTheme.accent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Compteur
                Container(
                  decoration: BoxDecoration(
                    color: ElxauTheme.bg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.all(8),
                        minimumSize: Size.zero,
                        onPressed: () => setState(() => _duration = (_duration - 1).clamp(1, 365)),
                        child: const Icon(CupertinoIcons.minus, color: ElxauTheme.accent),
                      ),
                      Text(
                        '$_duration',
                        style: GoogleFonts.playfairDisplay(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: ElxauTheme.accent,
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.all(8),
                        minimumSize: Size.zero,
                        onPressed: () => setState(() => _duration = (_duration + 1).clamp(1, 365)),
                        child: const Icon(CupertinoIcons.plus, color: ElxauTheme.accent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecificitiesCard() {
    // Filtres selon le type sélectionné
    final showRooms = _selectedType != PropertyType.land;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: ElxauTheme.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: ElxauTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Spécificités'),
            const SizedBox(height: 16),
            if (showRooms) ...[
              // Chambres minimum
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chambres minimum',
                        style: GoogleFonts.outfit(color: ElxauTheme.accent, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '$_minBedrooms chambre${_minBedrooms > 1 ? 's' : ''}',
                        style: const TextStyle(color: ElxauTheme.secondaryText, fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _counterBtn(CupertinoIcons.minus, () {
                        setState(() => _minBedrooms = (_minBedrooms - 1).clamp(0, 10));
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '$_minBedrooms',
                          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: ElxauTheme.accent),
                        ),
                      ),
                      _counterBtn(CupertinoIcons.plus, () {
                        setState(() => _minBedrooms = (_minBedrooms + 1).clamp(0, 10));
                      }),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const AppDivider(color: ElxauTheme.grayLight),
              const SizedBox(height: 16),
            ],
            // Switches
            ...[
              if (showRooms) _buildSwitch('Meublé', CupertinoIcons.cube_box, _hasFurnished, (v) => setState(() => _hasFurnished = v)),
              if (showRooms) _buildSwitch('Piscine', CupertinoIcons.drop, _hasPool, (v) => setState(() => _hasPool = v)),
              _buildSwitch('Parking', CupertinoIcons.car, _hasParking, (v) => setState(() => _hasParking = v)),
              _buildSwitch('Sécurité 24h', CupertinoIcons.shield, _hasSecurity, (v) => setState(() => _hasSecurity = v)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(String label, IconData icon, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: value ? ElxauTheme.primary.withValues(alpha: 0.1) : ElxauTheme.bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: value ? ElxauTheme.primary : ElxauTheme.secondaryText, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.outfit(color: ElxauTheme.accent, fontWeight: FontWeight.w500),
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: ElxauTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeCard() {
    final max = _durationUnit == 'jours' ? 1000.0 : 10000.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: ElxauTheme.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: ElxauTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionTitle('Budget par $_durationUnit'),
                Text(
                  '\$${_priceRange.start.toInt()} — \$${_priceRange.end.toInt()}',
                  style: GoogleFonts.outfit(
                    color: ElxauTheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppRangeSlider(
              values: _priceRange,
              min: 0,
              max: max,
              onChanged: (v) => setState(() => _priceRange = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: AppFilledButton(
          onPressed: () {
            Navigator.push(
              context,
              appRoute(
                PropertyListScreen(
                  type: _selectedType,
                  purpose: _selectedPurpose,
                  quartier: _selectedQuartier == 'Tous' ? null : _selectedQuartier,
                  durationType: _durationUnit == 'jours' ? DurationType.days : DurationType.months,
                  duration: _duration,
                  startDate: _startDate,
                  minBedrooms: _minBedrooms,
                  hasPool: _hasPool ? true : null,
                  hasFurnished: _hasFurnished ? true : null,
                  hasParking: _hasParking ? true : null,
                  hasSecurity: _hasSecurity ? true : null,
                  maxPrice: _priceRange.end,
                  minPrice: _priceRange.start,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.search, color: ElxauTheme.white, size: 22),
              const SizedBox(width: 10),
              Text(
                'Rechercher les biens',
                style: GoogleFonts.outfit(
                  color: ElxauTheme.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.playfairDisplay(
        color: ElxauTheme.accent,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: ElxauTheme.bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: ElxauTheme.accent, size: 18),
      ),
    );
  }
}
