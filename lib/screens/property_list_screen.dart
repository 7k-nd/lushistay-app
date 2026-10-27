import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/cupertino_ui.dart';
import 'package:elxau/models/property.dart';
import 'package:elxau/services/firestore_service.dart';
import 'package:elxau/widgets/property_card.dart';
import 'package:elxau/screens/property_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PropertyListScreen extends StatefulWidget {
  final PropertyType? type;
  final String? quartier;
  final ListingPurpose? purpose;
  final DurationType durationType;
  final int duration;
  final DateTime startDate;
  final int minBedrooms;
  final bool? hasPool;
  final bool? hasFurnished;
  final bool? hasParking;
  final bool? hasSecurity;
  final double minPrice;
  final double maxPrice;

  const PropertyListScreen({
    super.key,
    this.type,
    this.quartier,
    this.purpose,
    required this.durationType,
    required this.duration,
    required this.startDate,
    this.minBedrooms = 0,
    this.hasPool,
    this.hasFurnished,
    this.hasParking,
    this.hasSecurity,
    this.minPrice = 0,
    this.maxPrice = 999999999,
  });

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  String _sortBy = 'rating';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  double _displayPrice(Property p) {
    if (p.purpose == ListingPurpose.sale) {
      return p.priceSale ?? p.pricePerMonth;
    }
    return widget.durationType == DurationType.days
        ? p.pricePerDay
        : p.pricePerMonth;
  }

  List<Property> _filter(List<Property> source) {
    var list = source.where((p) {
      if (widget.type != null && p.type != widget.type) return false;
      if (widget.purpose != null && p.purpose != widget.purpose) return false;
      if (widget.quartier != null &&
          !p.quartier
              .toLowerCase()
              .contains(widget.quartier!.toLowerCase()) &&
          !p.ville.toLowerCase().contains(widget.quartier!.toLowerCase())) {
        return false;
      }
      final price = _displayPrice(p);
      if (price < widget.minPrice || price > widget.maxPrice) return false;
      if (widget.minBedrooms > 0 &&
          (p.features.bedrooms ?? 0) < widget.minBedrooms) {
        return false;
      }
      if (widget.hasPool == true && p.features.hasPool != true) return false;
      if (widget.hasFurnished == true && p.features.hasFurnished != true) {
        return false;
      }
      if (widget.hasParking == true && p.features.hasParking != true) {
        return false;
      }
      if (widget.hasSecurity == true && p.features.hasSecurity != true) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!p.title.toLowerCase().contains(q) &&
            !p.quartier.toLowerCase().contains(q) &&
            !p.description.toLowerCase().contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();

    switch (_sortBy) {
      case 'rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'price_asc':
        list.sort((a, b) => _displayPrice(a).compareTo(_displayPrice(b)));
        break;
      case 'price_desc':
        list.sort((a, b) => _displayPrice(b).compareTo(_displayPrice(a)));
        break;
    }
    return list;
  }

  void _showSortOptions() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Trier par'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _sortBy = 'rating');
            },
            child: const Text('Mieux notés'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _sortBy = 'price_asc');
            },
            child: const Text('Prix croissant'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _sortBy = 'price_desc');
            },
            child: const Text('Prix décroissant'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
      ),
    );
  }

  String get _subtitle {
    final parts = <String>[];
    if (widget.quartier != null) parts.add(widget.quartier!);
    if (widget.purpose == ListingPurpose.sale) parts.add('À vendre');
    if (widget.purpose == ListingPurpose.rent) parts.add('À louer');
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService =
        Provider.of<FirestoreService>(context, listen: false);

    return AppScaffold(
      backgroundColor: ElxauTheme.bg,
      navigationBar: AppNavBar(
        middle: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.type?.label ?? 'Résultats',
              style: GoogleFonts.playfairDisplay(
                color: ElxauTheme.accent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (_subtitle.isNotEmpty)
              Text(
                _subtitle,
                style: const TextStyle(
                    color: ElxauTheme.secondaryText, fontSize: 11),
              ),
          ],
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          onPressed: _showSortOptions,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ElxauTheme.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: ElxauTheme.softShadow,
            ),
            child: const Icon(CupertinoIcons.sort_down,
                color: ElxauTheme.accent, size: 20),
          ),
        ),
      ),
      body: StreamBuilder<List<Property>>(
        stream: firestoreService.getProperties(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(
              child: CupertinoActivityIndicator(color: ElxauTheme.primary),
            );
          }

          final results = _filter(snapshot.data ?? []);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: CupertinoTextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(color: ElxauTheme.accent),
                  placeholder: 'Rechercher un bien...',
                  placeholderStyle: TextStyle(
                      color: ElxauTheme.secondaryText.withValues(alpha: 0.6)),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Icon(CupertinoIcons.search,
                        color: ElxauTheme.primary, size: 20),
                  ),
                  suffix: _searchQuery.isNotEmpty
                      ? CupertinoButton(
                          padding: const EdgeInsets.only(right: 8),
                          minimumSize: Size.zero,
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                          child: const Icon(
                            CupertinoIcons.clear_circled_solid,
                            color: ElxauTheme.secondaryText,
                            size: 18,
                          ),
                        )
                      : null,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: ElxauTheme.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      '${results.length} bien${results.length > 1 ? 's' : ''} trouvé${results.length > 1 ? 's' : ''}',
                      style: GoogleFonts.outfit(
                        color: ElxauTheme.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    if (widget.minPrice > 0 || widget.maxPrice < 999999999)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: ElxauTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          '\$${widget.minPrice.toInt()} — \$${widget.maxPrice.toInt()}',
                          style: GoogleFonts.outfit(
                            color: ElxauTheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: results.isEmpty
                    ? _buildEmpty()
                    : AnimationLimiter(
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                          itemCount: results.length,
                          itemBuilder: (ctx, i) =>
                              AnimationConfiguration.staggeredList(
                            position: i,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50,
                              child: FadeInAnimation(
                                child: PropertyCard(
                                  property: results[i],
                                  isHorizontal: false,
                                  onTap: () => Navigator.push(
                                    ctx,
                                    appRoute(
                                      PropertyDetailScreen(
                                        property: results[i],
                                        durationType: widget.durationType,
                                        duration: widget.duration,
                                        startDate: widget.startDate,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(CupertinoIcons.house,
              size: 64, color: ElxauTheme.secondaryText),
          const SizedBox(height: 20),
          Text(
            'Aucun bien trouvé',
            style: GoogleFonts.playfairDisplay(
              color: ElxauTheme.accent,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Essayez de modifier vos filtres\nou de changer de quartier',
            textAlign: TextAlign.center,
            style: TextStyle(color: ElxauTheme.secondaryText),
          ),
          const SizedBox(height: 24),
          AppFilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Modifier la recherche'),
          ),
        ],
      ),
    );
  }
}
