import 'package:flutter/cupertino.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/cupertino_ui.dart';
import 'package:elxau/models/property.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:elxau/services/firestore_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PublishPropertyScreen extends StatefulWidget {
  const PublishPropertyScreen({super.key});

  @override
  State<PublishPropertyScreen> createState() => _PublishPropertyScreenState();
}

class _PublishPropertyScreenState extends State<PublishPropertyScreen> {
  int _currentStep = 0;

  final _titleKey = GlobalKey<AppFormFieldState>();
  final _descKey = GlobalKey<AppFormFieldState>();
  final _quartierKey = GlobalKey<AppFormFieldState>();
  final _priceDayKey = GlobalKey<AppFormFieldState>();
  final _priceMonthKey = GlobalKey<AppFormFieldState>();
  final _ownerNameKey = GlobalKey<AppFormFieldState>();
  final _ownerPhoneKey = GlobalKey<AppFormFieldState>();

  // Étape 1 : Type et localisation
  PropertyType _type = PropertyType.house;
  ListingPurpose _purpose = ListingPurpose.rent;
  LegalStatus _legalStatus = LegalStatus.unknown;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _quartierController = TextEditingController();
  final _communeController = TextEditingController();
  final _addressController = TextEditingController();

  // Étape 2 : Prix
  final _pricePerDayController = TextEditingController();
  final _pricePerMonthController = TextEditingController();

  // Étape 3 : Caractéristiques
  int _bedrooms = 2;
  int _bathrooms = 1;
  double _surface = 80;
  bool _hasParking = false;
  bool _hasGarden = false;
  bool _hasPool = false;
  bool _hasSecurity = false;
  bool _hasWater = true;
  bool _hasElectricity = true;
  bool _hasFurnished = false;
  bool _hasInternet = false;
  bool _hasAC = false;
  bool _isViabilized = false;
  final _landTitleController = TextEditingController();

  // Étape 4 : Contact
  final _ownerNameController = TextEditingController();
  final _ownerPhoneController = TextEditingController();

  bool _isPublishing = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _quartierController.dispose();
    _communeController.dispose();
    _addressController.dispose();
    _pricePerDayController.dispose();
    _pricePerMonthController.dispose();
    _landTitleController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    super.dispose();
  }

  final List<String> _stepTitles = [
    'Type & Localisation',
    'Tarification',
    'Caractéristiques',
    'Contact & Publication',
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: ElxauTheme.bg,
      navigationBar: AppNavBar(
        backgroundColor: ElxauTheme.bg,
        middle: Text(
          'Publier une annonce',
          style: GoogleFonts.playfairDisplay(
              color: ElxauTheme.accent,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          _buildProgressBar(),
          Expanded(
            child: IndexedStack(
              index: _currentStep,
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
                _buildStep4(),
              ],
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Étape ${_currentStep + 1}/4 · ${_stepTitles[_currentStep]}',
                style: GoogleFonts.outfit(
                    color: ElxauTheme.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
              Text(
                '${((_currentStep + 1) / 4 * 100).toInt()}%',
                style: GoogleFonts.outfit(
                    color: ElxauTheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SizedBox(
              height: 6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: ElxauTheme.grayLight),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (_currentStep + 1) / 4,
                    child: const ColoredBox(color: ElxauTheme.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── ÉTAPE 1 : Type & Localisation ─────────────────────────────────────────
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Type de bien'),
          const SizedBox(height: 14),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.2,
            children: PropertyType.values.map((t) {
              final isSelected = _type == t;
              return GestureDetector(
                onTap: () => setState(() => _type = t),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected ? ElxauTheme.accent : ElxauTheme.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? ElxauTheme.primary
                          : ElxauTheme.grayLight,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        t.icon,
                        size: 20,
                        color: isSelected ? ElxauTheme.white : ElxauTheme.accent,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        t.label,
                        style: GoogleFonts.outfit(
                          color:
                              isSelected ? ElxauTheme.white : ElxauTheme.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _sectionTitle('Acheter ou louer'),
          const SizedBox(height: 14),
          Row(
            children: ListingPurpose.values.map((p) {
              final selected = _purpose == p;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: p == ListingPurpose.sale ? 8 : 0,
                      left: p == ListingPurpose.rent ? 8 : 0),
                  child: GestureDetector(
                    onTap: () => setState(() => _purpose = p),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: selected ? ElxauTheme.primary : ElxauTheme.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected
                              ? ElxauTheme.primary
                              : ElxauTheme.grayLight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          p.label,
                          style: GoogleFonts.outfit(
                            color: selected
                                ? ElxauTheme.white
                                : ElxauTheme.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _sectionTitle('Titre de l\'annonce'),
          const SizedBox(height: 10),
          _buildField(_titleController, 'Ex: Belle villa avec piscine',
              CupertinoIcons.textformat,
              fieldKey: _titleKey,
              validator: (v) => (v == null || v.isEmpty) ? 'Titre requis' : null),
          const SizedBox(height: 16),
          _sectionTitle('Description'),
          const SizedBox(height: 10),
          _buildField(_descController, 'Décrivez votre bien en détail...',
              CupertinoIcons.doc_text,
              maxLines: 4,
              fieldKey: _descKey,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Description requise' : null),
          const SizedBox(height: 16),
          _sectionTitle('Localisation'),
          const SizedBox(height: 10),
          _buildField(_quartierController, 'Quartier (ex: Kenya)',
              CupertinoIcons.location_solid,
              fieldKey: _quartierKey,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Quartier requis' : null),
          const SizedBox(height: 12),
          _buildField(_communeController, 'Commune (ex: Lubumbashi)',
              CupertinoIcons.map),
          const SizedBox(height: 12),
          _buildField(_addressController, 'Adresse complète',
              CupertinoIcons.house),
          const SizedBox(height: 24),
          _sectionTitle('Statut Juridique'),
          const SizedBox(height: 10),
          _buildLegalStatusDropdown(),
        ],
      ),
    );
  }

  Widget _buildLegalStatusDropdown() {
    return GestureDetector(
      onTap: () {
        showAppSheet(
          context: context,
          builder: (sheetContext) => CupertinoActionSheet(
            title: const Text('Statut Juridique'),
            actions: LegalStatus.values.map((status) {
              return CupertinoActionSheetAction(
                onPressed: () {
                  setState(() => _legalStatus = status);
                  Navigator.pop(sheetContext);
                },
                child: Text(status.label),
              );
            }).toList(),
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(sheetContext),
              child: const Text('Annuler'),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: ElxauTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ElxauTheme.grayLight),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _legalStatus.label,
                style: const TextStyle(color: ElxauTheme.accent, fontSize: 14),
              ),
            ),
            const Icon(CupertinoIcons.shield,
                color: ElxauTheme.primary, size: 20),
          ],
        ),
      ),
    );
  }

  // ─── ÉTAPE 2 : Tarification ─────────────────────────────────────────────────
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: ElxauTheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: ElxauTheme.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.info,
                    color: ElxauTheme.primary, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Définissez vos tarifs. Les clients pourront réserver à la journée ou au mois.',
                    style: GoogleFonts.outfit(
                        color: ElxauTheme.secondaryText,
                        fontSize: 12,
                        height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _sectionTitle('Prix par jour (\$)'),
          const SizedBox(height: 10),
          _buildField(
            _pricePerDayController,
            'Ex: 80',
            CupertinoIcons.calendar,
            keyboardType: TextInputType.number,
            fieldKey: _priceDayKey,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Prix/jour requis' : null,
          ),
          const SizedBox(height: 24),
          _sectionTitle('Prix par mois (\$)'),
          const SizedBox(height: 10),
          _buildField(
            _pricePerMonthController,
            'Ex: 1500',
            CupertinoIcons.calendar,
            keyboardType: TextInputType.number,
            fieldKey: _priceMonthKey,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Prix/mois requis' : null,
          ),
          const SizedBox(height: 28),
          if (_pricePerDayController.text.isNotEmpty &&
              _pricePerMonthController.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ElxauTheme.accent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _pricePreviewRow(
                      'Tarif journalier', '\$${_pricePerDayController.text}'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: AppDivider(
                        color: ElxauTheme.white.withValues(alpha: 0.24)),
                  ),
                  _pricePreviewRow(
                      'Tarif mensuel', '\$${_pricePerMonthController.text}'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: AppDivider(
                        color: ElxauTheme.white.withValues(alpha: 0.24)),
                  ),
                  _pricePreviewRow('Revenu mensuel estimé',
                      '\$${_pricePerMonthController.text}'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _pricePreviewRow(String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: ElxauTheme.white.withValues(alpha: 0.7),
                  fontSize: 13)),
          Text(value,
              style: GoogleFonts.outfit(
                  color: ElxauTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
        ],
      );

  // ─── ÉTAPE 3 : Caractéristiques ─────────────────────────────────────────────
  Widget _buildStep3() {
    final showRooms = _type != PropertyType.land;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showRooms) ...[
            _sectionTitle('Pièces'),
            const SizedBox(height: 14),
            _buildCounter('Chambres', _bedrooms, (v) => setState(() => _bedrooms = v),
                CupertinoIcons.bed_double),
            const SizedBox(height: 12),
            _buildCounter(
                'Salles de bain',
                _bathrooms,
                (v) => setState(() => _bathrooms = v),
                CupertinoIcons.drop),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _sectionTitle('Surface (m²)')),
                Text('${_surface.toInt()} m²',
                    style: GoogleFonts.outfit(
                        color: ElxauTheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ],
            ),
            CupertinoSlider(
              value: _surface,
              min: 10,
              max: 2000,
              activeColor: ElxauTheme.primary,
              onChanged: (v) => setState(() => _surface = v),
            ),
            const SizedBox(height: 20),
          ],
          if (_type == PropertyType.land) ...[
            _sectionTitle('Terrain'),
            const SizedBox(height: 10),
            _buildField(_landTitleController, 'Numéro du titre foncier',
                CupertinoIcons.doc_text),
            const SizedBox(height: 14),
            _buildSwitch(
                'Terrain viabilisé',
                CupertinoIcons.checkmark_circle,
                _isViabilized,
                (v) => setState(() => _isViabilized = v)),
            const SizedBox(height: 14),
          ],
          _sectionTitle('Équipements & Services'),
          const SizedBox(height: 14),
          if (showRooms) ...[
            _buildSwitch('Meublé', CupertinoIcons.cube_box, _hasFurnished,
                (v) => setState(() => _hasFurnished = v)),
            _buildSwitch('Climatisation', CupertinoIcons.snow, _hasAC,
                (v) => setState(() => _hasAC = v)),
            _buildSwitch('Piscine', CupertinoIcons.drop_triangle, _hasPool,
                (v) => setState(() => _hasPool = v)),
            _buildSwitch('Jardin', CupertinoIcons.leaf_arrow_circlepath,
                _hasGarden, (v) => setState(() => _hasGarden = v)),
            _buildSwitch('Balcon/Terrasse', CupertinoIcons.square, false, (_) {}),
            _buildSwitch('Wi-Fi inclus', CupertinoIcons.wifi, _hasInternet,
                (v) => setState(() => _hasInternet = v)),
          ],
          _buildSwitch('Parking', CupertinoIcons.car, _hasParking,
              (v) => setState(() => _hasParking = v)),
          _buildSwitch('Sécurité 24h', CupertinoIcons.lock_shield, _hasSecurity,
              (v) => setState(() => _hasSecurity = v)),
          _buildSwitch('Eau courante', CupertinoIcons.drop_fill, _hasWater,
              (v) => setState(() => _hasWater = v)),
          _buildSwitch('Électricité', CupertinoIcons.bolt_fill, _hasElectricity,
              (v) => setState(() => _hasElectricity = v)),
        ],
      ),
    );
  }

  Widget _buildCounter(
      String label, int value, Function(int) onChanged, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ElxauTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: ElxauTheme.softShadow,
      ),
      child: Row(
        children: [
          Icon(icon, color: ElxauTheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label,
                  style: GoogleFonts.outfit(
                      color: ElxauTheme.accent, fontWeight: FontWeight.w600))),
          _cntBtn(CupertinoIcons.minus, () => onChanged((value - 1).clamp(0, 20))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text('$value',
                style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: ElxauTheme.accent)),
          ),
          _cntBtn(CupertinoIcons.plus, () => onChanged(value + 1)),
        ],
      ),
    );
  }

  Widget _cntBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: ElxauTheme.bg, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 16, color: ElxauTheme.accent),
      ),
    );
  }

  // ─── ÉTAPE 4 : Contact & Publication ────────────────────────────────────────
  Widget _buildStep4() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Vos coordonnées'),
          const SizedBox(height: 6),
          Text(
            'Ces informations seront visibles par les locataires intéressés.',
            style: GoogleFonts.outfit(
                color: ElxauTheme.secondaryText, fontSize: 12),
          ),
          const SizedBox(height: 16),
          _buildField(_ownerNameController, 'Votre nom complet',
              CupertinoIcons.person,
              fieldKey: _ownerNameKey,
              validator: (v) => (v == null || v.isEmpty) ? 'Nom requis' : null),
          const SizedBox(height: 12),
          _buildField(_ownerPhoneController, '+243 XXX XXX XXX',
              CupertinoIcons.phone,
              keyboardType: TextInputType.phone,
              fieldKey: _ownerPhoneKey,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Téléphone requis' : null),
          const SizedBox(height: 28),
          _sectionTitle('Récapitulatif de l\'annonce'),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ElxauTheme.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: ElxauTheme.softShadow,
            ),
            child: Column(
              children: [
                _recapRow('Type', _type.label),
                _recapRow(
                    'Titre',
                    _titleController.text.isEmpty
                        ? '(non renseigné)'
                        : _titleController.text),
                _recapRow(
                    'Quartier',
                    _quartierController.text.isEmpty
                        ? '—'
                        : _quartierController.text),
                _recapRow('Statut Jurid.', _legalStatus.label),
                _recapRow(
                    'Prix/jour',
                    _pricePerDayController.text.isEmpty
                        ? '—'
                        : '\$${_pricePerDayController.text}'),
                _recapRow(
                    'Prix/mois',
                    _pricePerMonthController.text.isEmpty
                        ? '—'
                        : '\$${_pricePerMonthController.text}'),
                if (_type != PropertyType.land)
                  _recapRow('Chambres', '$_bedrooms'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ElxauTheme.success.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: ElxauTheme.success.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.checkmark_seal_fill,
                    color: ElxauTheme.success, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Votre annonce sera vérifiée par notre équipe dans les 24h avant publication.',
                    style: GoogleFonts.outfit(
                        color: ElxauTheme.secondaryText,
                        fontSize: 12,
                        height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: AppFilledButton(
              onPressed: _isPublishing ? null : _handlePublish,
              color: ElxauTheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              borderRadius: BorderRadius.circular(20),
              child: _isPublishing
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoActivityIndicator(color: ElxauTheme.white),
                        SizedBox(width: 12),
                        Text('Publication en cours...',
                            style: TextStyle(
                                color: ElxauTheme.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.cloud_upload),
                        const SizedBox(width: 10),
                        Text('Publier l\'annonce',
                            style: GoogleFonts.outfit(
                                color: ElxauTheme.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recapRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: const TextStyle(
                    color: ElxauTheme.secondaryText, fontSize: 12)),
          ),
          Expanded(
            child: Text(value,
                style: GoogleFonts.outfit(
                    color: ElxauTheme.accent,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ),
        ],
      ),
    );
  }

  // ─── Navigation Steps ────────────────────────────────────────────────────────
  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      decoration: BoxDecoration(
        color: ElxauTheme.bg,
        border: Border(
            top: BorderSide(color: ElxauTheme.grayLight.withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: AppOutlineButton(
                onPressed: () => setState(() => _currentStep--),
                borderColor: ElxauTheme.accent,
                child: Text('Retour',
                    style: GoogleFonts.outfit(
                        color: ElxauTheme.accent, fontWeight: FontWeight.bold)),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          if (_currentStep < 3)
            Expanded(
              flex: 2,
              child: AppFilledButton(
                onPressed: _nextStep,
                padding: const EdgeInsets.symmetric(vertical: 16),
                borderRadius: BorderRadius.circular(16),
                child: Text('Suivant →',
                    style: GoogleFonts.outfit(
                        color: ElxauTheme.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
            ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (!validateFields([_titleKey, _descKey, _quartierKey])) {
        showAppMessage(
            context, 'Veuillez remplir les champs obligatoires',
            title: 'Information');
        return;
      }
    } else if (_currentStep == 1) {
      if (!validateFields([_priceDayKey, _priceMonthKey])) {
        showAppMessage(context, 'Veuillez définir vos tarifs',
            title: 'Information');
        return;
      }
    }
    setState(() => _currentStep++);
  }

  Future<void> _handlePublish() async {
    if (!validateFields([_ownerNameKey, _ownerPhoneKey])) {
      await showAppMessage(context, 'Veuillez renseigner vos coordonnées',
          title: 'Information');
      return;
    }
    setState(() => _isPublishing = true);

    try {
      final auth = context.read<AuthService>();
      final firestore = context.read<FirestoreService>();
      final priceMonth =
          double.tryParse(_pricePerMonthController.text.trim()) ?? 0;
      final priceDay =
          double.tryParse(_pricePerDayController.text.trim()) ?? 0;

      final property = Property(
        id: '',
        ownerId: auth.currentUser?.id ?? 'anonymous',
        ownerName: _ownerNameController.text.trim(),
        ownerPhone: _ownerPhoneController.text.trim(),
        legalStatus: _legalStatus,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        type: _type,
        status: PropertyStatus.available,
        quartier: _quartierController.text.trim(),
        commune: _communeController.text.trim(),
        ville: 'Lubumbashi',
        fullAddress: _addressController.text.trim(),
        pricePerDay: priceDay,
        pricePerMonth: priceMonth,
        images: const [
          'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800',
        ],
        rating: 0,
        reviewCount: 0,
        features: PropertyFeatures(
          bedrooms: _bedrooms,
          bathrooms: _bathrooms,
          surfaceM2: _surface,
          hasParking: _hasParking,
          hasGarden: _hasGarden,
          hasPool: _hasPool,
          hasSecurity: _hasSecurity,
          hasWater: _hasWater,
          hasElectricity: _hasElectricity,
          hasFurnished: _hasFurnished,
          hasInternet: _hasInternet,
          hasAirConditioning: _hasAC,
          isViabilized: _isViabilized,
          landTitle: _landTitleController.text.trim().isEmpty
              ? null
              : _landTitleController.text.trim(),
        ),
        tags: [_type.label, _purpose.label],
        createdAt: DateTime.now(),
        isVerified: false,
        purpose: _purpose,
        priceSale: _purpose == ListingPurpose.sale ? priceMonth : null,
      );

      await firestore.createProperty(property);

      if (!mounted) return;
      setState(() => _isPublishing = false);
      showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: ElxauTheme.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: ElxauTheme.success.withValues(alpha: 0.1),
                      shape: BoxShape.circle),
                  child: const Icon(CupertinoIcons.checkmark_circle_fill,
                      color: ElxauTheme.success, size: 60),
                ),
                const SizedBox(height: 20),
                Text('Annonce publiee !',
                    style: GoogleFonts.playfairDisplay(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: ElxauTheme.accent)),
                const SizedBox(height: 10),
                Text(
                  'Votre annonce "${_titleController.text}" est maintenant visible.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: ElxauTheme.secondaryText),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: AppFilledButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.of(context).pop();
                    },
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    borderRadius: BorderRadius.circular(16),
                    child: const Text('OK',
                        style: TextStyle(
                            color: ElxauTheme.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isPublishing = false);
      await showAppMessage(context, 'Echec publication: $e', title: 'Erreur');
    }
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: GoogleFonts.playfairDisplay(
            color: ElxauTheme.accent, fontWeight: FontWeight.bold, fontSize: 16),
      );

  Widget _buildSwitch(
      String label, IconData icon, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: value
                  ? ElxauTheme.primary.withValues(alpha: 0.1)
                  : ElxauTheme.bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon,
                color: value ? ElxauTheme.primary : ElxauTheme.secondaryText,
                size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label,
                  style: GoogleFonts.outfit(
                      color: ElxauTheme.accent, fontWeight: FontWeight.w500))),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: ElxauTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    Key? fieldKey,
  }) {
    return AppFormField(
      key: fieldKey,
      controller: controller,
      placeholder: hint,
      prefixIcon: icon,
      keyboardType: keyboardType ?? TextInputType.text,
      maxLines: maxLines,
      validator: validator,
    );
  }
}
