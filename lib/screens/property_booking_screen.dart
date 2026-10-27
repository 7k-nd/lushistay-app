import 'package:flutter/cupertino.dart';
import 'package:elxau/brand_config.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/cupertino_ui.dart';
import 'package:elxau/models/property.dart';
import 'package:elxau/screens/property_payment_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:elxau/services/firestore_service.dart';
import 'package:elxau/screens/login_screen.dart';


class PropertyBookingScreen extends StatefulWidget {
  final Property property;
  final DurationType durationType;
  final int duration;
  final DateTime startDate;
  final double totalPrice;

  const PropertyBookingScreen({
    super.key,
    required this.property,
    required this.durationType,
    required this.duration,
    required this.startDate,
    required this.totalPrice,
  });

  @override
  State<PropertyBookingScreen> createState() => _PropertyBookingScreenState();
}

class _PropertyBookingScreenState extends State<PropertyBookingScreen> {
  late DurationType _durationType;
  late int _duration;
  late DateTime _startDate;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  final _nameKey = GlobalKey<AppFormFieldState>();
  final _phoneKey = GlobalKey<AppFormFieldState>();

  @override
  void initState() {
    super.initState();
    _durationType = widget.durationType;
    _duration = widget.duration;
    _startDate = widget.startDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  DateTime get _endDate {
    if (_durationType == DurationType.days) {
      return _startDate.add(Duration(days: _duration));
    } else {
      return DateTime(_startDate.year, _startDate.month + _duration, _startDate.day);
    }
  }

  double get _totalPrice {
    final price = _durationType == DurationType.days
        ? widget.property.pricePerDay
        : widget.property.pricePerMonth;
    return price * _duration;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: ElxauTheme.bg,
      navigationBar: AppNavBar(
        middle: Text(
          'Demande de contact',
          style: GoogleFonts.playfairDisplay(color: ElxauTheme.accent, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Récapitulatif bien
          _buildPropertySummary(),
          const SizedBox(height: 28),

          // Section durée modifiable
          _buildSectionTitle('Dates & Durée'),
          const SizedBox(height: 14),
          _buildDateDurationEditor(),
          const SizedBox(height: 28),

          // Informations du réservant
          _buildSectionTitle('Vos informations'),
          const SizedBox(height: 14),
          AppFormField(
            key: _nameKey,
            controller: _nameController,
            label: 'Nom complet *',
            placeholder: 'Votre nom',
            prefixIcon: CupertinoIcons.person,
            validator: (v) => (v == null || v.isEmpty) ? 'Champ requis' : null,
          ),
          const SizedBox(height: 14),
          AppFormField(
            key: _phoneKey,
            controller: _phoneController,
            label: 'Téléphone *',
            placeholder: '+243 XXX XXX XXX',
            prefixIcon: CupertinoIcons.phone,
            keyboardType: TextInputType.phone,
            validator: (v) => (v == null || v.isEmpty) ? 'Numéro requis' : null,
          ),
          const SizedBox(height: 14),
          AppFormField(
            controller: _notesController,
            label: 'Notes (optionnel)',
            placeholder: 'Questions, horaire de visite…',
            prefixIcon: CupertinoIcons.doc_text,
            maxLines: 3,
          ),
          const SizedBox(height: 28),

          // Récapitulatif financier
          _buildFinancialSummary(),
          const SizedBox(height: 28),

          // CGU rapides
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ElxauTheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ElxauTheme.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.info, color: ElxauTheme.primary, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    BrandConfig.contactOnlyLong,
                    style: GoogleFonts.outfit(color: ElxauTheme.secondaryText, fontSize: 12, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Bouton contact WhatsApp
          SizedBox(
            width: double.infinity,
            height: 60,
            child: AppFilledButton(
              onPressed: _goToContact,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.chat_bubble_fill, color: ElxauTheme.white),
                  const SizedBox(width: 10),
                  Text(
                    'Continuer vers WhatsApp',
                    style: GoogleFonts.outfit(color: ElxauTheme.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPropertySummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ElxauTheme.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: ElxauTheme.softShadow,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: widget.property.images.isNotEmpty
                ? Image.network(
                    widget.property.images[0],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80, height: 80,
                      color: ElxauTheme.grayLight,
                      child: const Icon(CupertinoIcons.house, color: ElxauTheme.secondaryText),
                    ),
                  )
                : Container(width: 80, height: 80, color: ElxauTheme.grayLight),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.property.title,
                  style: GoogleFonts.outfit(color: ElxauTheme.accent, fontWeight: FontWeight.bold, fontSize: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(CupertinoIcons.location_solid, color: ElxauTheme.primary, size: 13),
                    const SizedBox(width: 3),
                    Text(
                      widget.property.quartier,
                      style: const TextStyle(color: ElxauTheme.secondaryText, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: ElxauTheme.accent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.property.type.icon,
                          color: ElxauTheme.accent, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        widget.property.type.label,
                        style: GoogleFonts.outfit(
                            color: ElxauTheme.accent,
                            fontSize: 11,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateDurationEditor() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ElxauTheme.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: ElxauTheme.softShadow,
      ),
      child: Column(
        children: [
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
            child: _infoRow(
              CupertinoIcons.calendar,
              'Arrivée',
              '${_startDate.day.toString().padLeft(2,'0')}/${_startDate.month.toString().padLeft(2,'0')}/${_startDate.year}',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: AppDivider(color: ElxauTheme.grayLight.withValues(alpha: 0.5)),
          ),
          _infoRow(
            CupertinoIcons.calendar,
            'Départ',
            '${_endDate.day.toString().padLeft(2,'0')}/${_endDate.month.toString().padLeft(2,'0')}/${_endDate.year}',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: AppDivider(color: ElxauTheme.grayLight.withValues(alpha: 0.5)),
          ),
          // Durée
          Row(
            children: [
              const Icon(CupertinoIcons.time, color: ElxauTheme.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Durée', style: TextStyle(color: ElxauTheme.secondaryText, fontSize: 11)),
                    Row(
                      children: ['jours', 'mois'].map((u) {
                        final sel = _durationType == (u == 'jours' ? DurationType.days : DurationType.months);
                        return GestureDetector(
                          onTap: () => setState(() {
                            _durationType = u == 'jours' ? DurationType.days : DurationType.months;
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8, top: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: sel ? ElxauTheme.accent : ElxauTheme.bg,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              u,
                              style: GoogleFonts.outfit(
                                color: sel ? ElxauTheme.white : ElxauTheme.accent,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _smallBtn(CupertinoIcons.minus, () => setState(() => _duration = (_duration - 1).clamp(1, 365))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '$_duration',
                      style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 20, color: ElxauTheme.accent),
                    ),
                  ),
                  _smallBtn(CupertinoIcons.plus, () => setState(() => _duration = (_duration + 1).clamp(1, 365))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary() {
    final unitPrice = _durationType == DurationType.days
        ? widget.property.pricePerDay
        : widget.property.pricePerMonth;
    final unit = _durationType == DurationType.days ? 'jour' : 'mois';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ElxauTheme.accent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _summaryRow('\$${unitPrice.toInt()} × $_duration $unit${_duration > 1 ? 's' : ''}', '\$${_totalPrice.toInt()}'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: AppDivider(color: ElxauTheme.white.withValues(alpha: 0.24)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Estimation indicative', style: GoogleFonts.outfit(color: ElxauTheme.white, fontWeight: FontWeight.bold, fontSize: 15)),
              Text(
                '\$${_totalPrice.toInt()}',
                style: GoogleFonts.playfairDisplay(color: ElxauTheme.primary, fontWeight: FontWeight.w900, fontSize: 26),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _goToContact() async {
    if (!validateFields([_nameKey, _phoneKey])) return;

    final authService = context.read<AuthService>();

    // Connexion obligatoire avant de soumettre une demande
    if (!authService.isAuthenticated) {
      final confirmed = await showCupertinoDialog<bool>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Connexion requise'),
          content: const Text(
            'Connectez-vous pour envoyer votre demande et la retrouver dans "Mes demandes".',
          ),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Se connecter'),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
      await Navigator.push(context, appRoute(const LoginScreen()));
      if (!mounted) return;
      if (!context.read<AuthService>().isAuthenticated) return;
    }

    final user = context.read<AuthService>().currentUser!;
    final firestoreService = context.read<FirestoreService>();

    final booking = PropertyBooking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: user.id,
      userName: _nameController.text.trim(),
      userPhone: _phoneController.text.trim(),
      property: widget.property,
      startDate: _startDate,
      endDate: _endDate,
      durationType: _durationType,
      durationValue: _duration,
      totalPrice: _totalPrice,
      paymentMethod: '',
      paymentStatus: 'pending',
      bookingStatus: 'upcoming',
      createdAt: DateTime.now(),
    );

    // Sauvegarde Firestore — non bloquante sur l'UX
    try {
      await firestoreService.createBooking(user.id, booking);
    } catch (e) {
      // On continue quand même vers WhatsApp même si Firestore échoue
      debugPrint('Erreur sauvegarde réservation: $e');
    }

    if (!mounted) return;
    Navigator.push(
      context,
      appRoute(PropertyPaymentScreen(booking: booking)),
    );
  }



  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: ElxauTheme.primary, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: ElxauTheme.secondaryText, fontSize: 11)),
            Text(value, style: GoogleFonts.outfit(color: ElxauTheme.accent, fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
        const Spacer(),
        const Icon(CupertinoIcons.chevron_right, color: ElxauTheme.secondaryText, size: 18),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: ElxauTheme.white.withValues(alpha: 0.7), fontSize: 13)),
        Text(value, style: const TextStyle(color: ElxauTheme.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _smallBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: ElxauTheme.bg, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: ElxauTheme.accent, size: 18),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.playfairDisplay(color: ElxauTheme.accent, fontWeight: FontWeight.bold, fontSize: 18),
    );
  }
}
