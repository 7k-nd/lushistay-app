import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:elxau/brand_config.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/cupertino_ui.dart';
import 'package:elxau/models/property.dart';
import 'package:elxau/models/notification.dart';
import 'package:elxau/screens/publish_property_screen.dart';
import 'package:elxau/screens/admin_login_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:elxau/services/firestore_service.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

// ============================================================
// ESPACE ENTITÉ - LAYOUT DESKTOP WORKSPACE
// Interface exclusive pour l'entité propriétaire
// Optimisée pour écrans PC (Desktop)
// ============================================================

class EntityDesktopLayout extends StatefulWidget {
  final VoidCallback? onExitEntityMode;

  const EntityDesktopLayout({super.key, this.onExitEntityMode});

  @override
  State<EntityDesktopLayout> createState() => _EntityDesktopLayoutState();
}

class _EntityDesktopLayoutState extends State<EntityDesktopLayout> {
  int _selectedIndex = 0;
  List<Property> _myProperties = [];
  List<NotificationModel> _notifications = [];
  List<Map<String, dynamic>> _whatsappContacts = [];
  PropertyType? _selectedCategory;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  StreamSubscription<List<Property>>? _propertiesSub;
  StreamSubscription<List<NotificationModel>>? _notificationsSub;
  StreamSubscription<List<Map<String, dynamic>>>? _whatsappSub;

  static const List<_SidebarItem> _sidebarItems = [
    _SidebarItem(CupertinoIcons.square_grid_2x2, 'Tableau de bord'),
    _SidebarItem(CupertinoIcons.house_fill, 'Mes Annonces'),
    _SidebarItem(CupertinoIcons.plus_circled, 'Publier un Bien'),
    _SidebarItem(CupertinoIcons.chart_bar, 'Statistiques'),
    _SidebarItem(CupertinoIcons.bell_fill, 'Notifications'),
    _SidebarItem(CupertinoIcons.chat_bubble_fill, 'Contacts WhatsApp'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkEntityAccess();
      _bindData();
    });
  }

  void _bindData() {
    final auth = context.read<AuthService>();
    final firestore = context.read<FirestoreService>();
    final ownerId = auth.currentUser?.id ?? '';

    _propertiesSub?.cancel();
    _notificationsSub?.cancel();
    _whatsappSub?.cancel();

    _propertiesSub = firestore.getOwnerProperties(ownerId).listen((list) {
      if (!mounted) return;
      setState(() => _myProperties = list);
    });

    _notificationsSub =
        firestore.getEntityNotifications(ownerId).listen((list) {
      if (!mounted) return;
      setState(() => _notifications = list);
    });

    _whatsappSub =
        firestore.getEntityWhatsAppContacts(ownerId).listen((list) {
      if (!mounted) return;
      setState(() => _whatsappContacts = list);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _propertiesSub?.cancel();
    _notificationsSub?.cancel();
    _whatsappSub?.cancel();
    super.dispose();
  }

  void _checkEntityAccess() {
    final authService = context.read<AuthService>();
    final user = authService.currentUser;
    if (user == null || !user.isEntity) {
      authService.signOut();
      Navigator.of(context).pushReplacement(
        appRoute(const AdminLoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: ElxauTheme.bg,
      body: Row(
        children: [
          _buildSidebar(),
          Container(
              width: 1, color: ElxauTheme.grayLight.withValues(alpha: 0.5)),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SIDEBAR NAVIGATION
  // ============================================================
  Widget _buildSidebar() {
    return Container(
      width: 280,
      color: ElxauTheme.accent,
      child: Column(
        children: [
          // Logo / Brand
          Container(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ElxauTheme.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(CupertinoIcons.building_2_fill,
                      color: ElxauTheme.white, size: 24),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      BrandConfig.entityWorkspaceName,
                      style: GoogleFonts.playfairDisplay(
                          color: ElxauTheme.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      'Espace entit? ? ordinateur',
                      style: GoogleFonts.outfit(
                          color: ElxauTheme.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppDivider(color: ElxauTheme.white.withValues(alpha: 0.12), height: 1),
          const SizedBox(height: 16),
          // Nav items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _sidebarItems.length,
              itemBuilder: (_, i) => _buildSidebarNavItem(i),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarNavItem(int index) {
    final item = _sidebarItems[index];
    final isSelected = _selectedIndex == index;
    final unreadCount = _notifications.where((n) => !n.isRead).length;
    final hasNotificationBadge = index == 4 && unreadCount > 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: () {
          if (index == 2) {
            // Naviguer vers l'écran de publication
            Navigator.push(
                context, appRoute(const PublishPropertyScreen()));
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? ElxauTheme.primary.withValues(alpha: 0.15)
                : ElxauTheme.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(item.icon,
                  color: isSelected
                      ? ElxauTheme.primary
                      : ElxauTheme.white.withValues(alpha: 0.54),
                  size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.label,
                  style: GoogleFonts.outfit(
                    color: isSelected
                        ? ElxauTheme.white
                        : ElxauTheme.white.withValues(alpha: 0.7),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              if (hasNotificationBadge)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                      color: ElxauTheme.destructive, shape: BoxShape.circle),
                  child: Text('$unreadCount',
                      style: const TextStyle(
                          color: ElxauTheme.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        color: ElxauTheme.white,
        boxShadow: [
          BoxShadow(
              color: ElxauTheme.accent.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Text(
            _sidebarItems[_selectedIndex].label,
            style: GoogleFonts.playfairDisplay(
                color: ElxauTheme.accent,
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
          const Spacer(),
          // Barre de recherche
          Container(
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: ElxauTheme.bg, borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                const Icon(CupertinoIcons.search,
                    color: ElxauTheme.secondaryText, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: CupertinoTextField(
                    controller: _searchController,
                    placeholder: 'Rechercher un bien...',
                    placeholderStyle: GoogleFonts.outfit(
                        color: ElxauTheme.secondaryText, fontSize: 14),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: const BoxDecoration(),
                    style: GoogleFonts.outfit(
                        color: ElxauTheme.accent, fontSize: 14),
                    onChanged: (val) {
                      setState(() => _searchQuery = val);
                    },
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    child: const Icon(CupertinoIcons.clear_circled_solid,
                        color: ElxauTheme.secondaryText, size: 16),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Cloche notifications
          Stack(
            children: [
              CupertinoButton(
                padding: const EdgeInsets.all(8),
                minimumSize: Size.zero,
                onPressed: () => setState(() => _selectedIndex = 4),
                child: const Icon(CupertinoIcons.bell,
                    color: ElxauTheme.accent, size: 22),
              ),
              if (_notifications.where((n) => !n.isRead).isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: ElxauTheme.destructive,
                          shape: BoxShape.circle)),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Profil entité
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
                color: ElxauTheme.accent,
                borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                AppAvatar(
                  radius: 14,
                  backgroundColor: ElxauTheme.primary,
                  child: Text('E',
                      style: GoogleFonts.playfairDisplay(
                          color: ElxauTheme.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                ),
                const SizedBox(width: 10),
                Text('Admin ImmoTrust',
                    style: GoogleFonts.outfit(
                        color: ElxauTheme.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTENU PRINCIPAL - ROUTEUR
  // ============================================================
  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildMyListings();
      case 3:
        return _buildAnalytics();
      case 4:
        return _buildNotificationsPage();
      case 5:
        return _buildWhatsAppContactsPage();
      default:
        return _buildDashboard();
    }
  }

  // ============================================================
  // TABLEAU DE BORD (DASHBOARD)
  // ============================================================
  Widget _buildDashboard() {
    final totalViews =
        _myProperties.fold<int>(0, (sum, p) => sum + p.viewsCount);
    final totalWhatsApp =
        _myProperties.fold<int>(0, (sum, p) => sum + p.whatsappContactCount);
    final unreadNotifs = _notifications.where((n) => !n.isRead).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: AnimationLimiter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (w) => SlideAnimation(
                verticalOffset: 30, child: FadeInAnimation(child: w)),
            children: [
              // Cartes statistiques
              Row(
                children: [
                  _buildDashStatCard(
                      'Biens Publiés',
                      '${_myProperties.length}',
                      CupertinoIcons.house_fill,
                      ElxauTheme.accent,
                      'Annonces actives'),
                  const SizedBox(width: 20),
                  _buildDashStatCard(
                      'Total Vues',
                      '$totalViews',
                      CupertinoIcons.eye_fill,
                      ElxauTheme.primary,
                      'Sur toutes les annonces'),
                  const SizedBox(width: 20),
                  _buildDashStatCard(
                      'Contacts WhatsApp',
                      '$totalWhatsApp',
                      CupertinoIcons.chat_bubble_fill,
                      const Color(0xFF25D366),
                      'Prospects intéressés'),
                  const SizedBox(width: 20),
                  _buildDashStatCard(
                      'Notifications',
                      '$unreadNotifs',
                      CupertinoIcons.bell_fill,
                      ElxauTheme.destructive,
                      'Non lues'),
                ],
              ),
              const SizedBox(height: 32),
              // Activité récente + Biens les plus vus
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildDashCard(
                      'Activité Récente',
                      CupertinoIcons.time,
                      _notifications.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Text(
                                'Aucune activité pour le moment.\nLes réservations et contacts apparaîtront ici.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ElxauTheme.secondaryText,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            )
                          : Column(
                              children: _notifications
                                  .take(4)
                                  .map((n) => _buildNotifTile(n))
                                  .toList()),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: _buildDashCard(
                      'Biens les Plus Vus',
                      CupertinoIcons.graph_circle,
                      Column(
                        children: () {
                          final sorted = List<Property>.from(_myProperties)
                            ..sort(
                                (a, b) => b.viewsCount.compareTo(a.viewsCount));
                          return sorted
                              .take(4)
                              .map((p) => _buildTopPropertyTile(p))
                              .toList();
                        }(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashStatCard(
      String title, String value, IconData icon, Color color, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ElxauTheme.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: ElxauTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: color, size: 22),
                ),
                const Spacer(),
                Icon(CupertinoIcons.graph_circle,
                    color: ElxauTheme.success.withValues(alpha: 0.7), size: 18),
              ],
            ),
            const SizedBox(height: 16),
            Text(value,
                style: GoogleFonts.playfairDisplay(
                    color: ElxauTheme.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 28)),
            const SizedBox(height: 4),
            Text(title,
                style: GoogleFonts.outfit(
                    color: ElxauTheme.accent,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
            Text(subtitle,
                style: GoogleFonts.outfit(
                    color: ElxauTheme.secondaryText, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildDashCard(String title, IconData icon, Widget child) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ElxauTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: ElxauTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: ElxauTheme.primary, size: 22),
              const SizedBox(width: 10),
              Text(title,
                  style: GoogleFonts.outfit(
                      color: ElxauTheme.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: AppDivider(),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildTopPropertyTile(Property p) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: p.images.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: p.images[0],
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                        width: 48,
                        height: 48,
                        color: ElxauTheme.grayLight),
                    errorWidget: (context, url, error) => Container(
                        width: 48,
                        height: 48,
                        color: ElxauTheme.grayLight,
                        child: const Icon(CupertinoIcons.house_fill, size: 20)),
                  )
                : Container(width: 48, height: 48, color: ElxauTheme.grayLight),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.title,
                    style: GoogleFonts.outfit(
                        color: ElxauTheme.accent,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Row(
                  children: [
                    Icon(p.type.icon,
                        size: 12, color: ElxauTheme.secondaryText),
                    const SizedBox(width: 4),
                    Text(p.type.label,
                        style: const TextStyle(
                            color: ElxauTheme.secondaryText, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(CupertinoIcons.eye_fill,
                      color: ElxauTheme.primary, size: 14),
                  const SizedBox(width: 4),
                  Text('${p.viewsCount}',
                      style: GoogleFonts.outfit(
                          color: ElxauTheme.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(CupertinoIcons.chat_bubble_fill,
                      color: Color(0xFF25D366), size: 12),
                  const SizedBox(width: 4),
                  Text('${p.whatsappContactCount}',
                      style: const TextStyle(
                          color: ElxauTheme.secondaryText, fontSize: 11)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MES ANNONCES
  // ============================================================
  Widget _buildCategorySelector() {
    final categories = <(PropertyType?, String, IconData, int)>[
      (null, 'Toutes', CupertinoIcons.square_grid_2x2, _myProperties.length),
      (
        PropertyType.hotel,
        PropertyType.hotel.label,
        PropertyType.hotel.icon,
        _myProperties.where((p) => p.type == PropertyType.hotel).length,
      ),
      (
        PropertyType.house,
        PropertyType.house.label,
        PropertyType.house.icon,
        _myProperties.where((p) => p.type == PropertyType.house).length,
      ),
      (
        PropertyType.apartment,
        PropertyType.apartment.label,
        PropertyType.apartment.icon,
        _myProperties.where((p) => p.type == PropertyType.apartment).length,
      ),
      (
        PropertyType.land,
        PropertyType.land.label,
        PropertyType.land.icon,
        _myProperties.where((p) => p.type == PropertyType.land).length,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedCategory == cat.$1;
          final count = cat.$4;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? ElxauTheme.accent : ElxauTheme.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? ElxauTheme.primary : ElxauTheme.grayLight,
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected ? ElxauTheme.softShadow : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      cat.$3,
                      size: 18,
                      color: isSelected ? ElxauTheme.primary : ElxauTheme.secondaryText,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      cat.$2,
                      style: GoogleFonts.outfit(
                        color: isSelected ? ElxauTheme.white : ElxauTheme.accent,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected ? ElxauTheme.primary : ElxauTheme.bg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$count',
                        style: GoogleFonts.outfit(
                          color: isSelected
                              ? ElxauTheme.accent
                              : ElxauTheme.secondaryText,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMyListings() {
    final filtered = _myProperties.where((p) {
      final matchesCat =
          _selectedCategory == null || p.type == _selectedCategory;
      final q = _searchQuery.trim().toLowerCase();
      final matchesSearch = q.isEmpty ||
          p.title.toLowerCase().contains(q) ||
          p.quartier.toLowerCase().contains(q) ||
          p.ville.toLowerCase().contains(q);
      return matchesCat && matchesSearch;
    }).toList();

    final categoryLabel =
        _selectedCategory != null ? _selectedCategory!.label : 'Toutes catégories';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: AnimationLimiter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (w) => SlideAnimation(
                verticalOffset: 30, child: FadeInAnimation(child: w)),
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Catalogue des biens',
                        style: GoogleFonts.playfairDisplay(
                            color: ElxauTheme.accent,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${filtered.length} annonce${filtered.length > 1 ? 's' : ''} affichée${filtered.length > 1 ? 's' : ''}'
                        '${_selectedCategory != null ? ' · $categoryLabel' : ''}'
                        ' (${_myProperties.length} au total)',
                        style: GoogleFonts.outfit(
                            color: ElxauTheme.secondaryText, fontSize: 14),
                      ),
                    ],
                  ),
                  const Spacer(),
                  AppFilledButton(
                    onPressed: () => Navigator.push(
                        context, appRoute(const PublishPropertyScreen())),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    borderRadius: BorderRadius.circular(14),
                    minSize: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(CupertinoIcons.add, size: 18),
                        const SizedBox(width: 8),
                        Text('Nouvelle Annonce',
                            style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Barre de sélection de catégorie
              _buildCategorySelector(),
              const SizedBox(height: 24),
              // Liste des annonces ou état vide
              if (filtered.isEmpty)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
                  decoration: BoxDecoration(
                    color: ElxauTheme.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: ElxauTheme.softShadow,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _selectedCategory != null
                            ? _selectedCategory!.icon
                            : CupertinoIcons.house_alt,
                        size: 56,
                        color: ElxauTheme.secondaryText.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedCategory != null
                            ? 'Aucun bien dans la catégorie "$categoryLabel"'
                            : 'Aucune annonce trouvée',
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ElxauTheme.accent),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _searchQuery.isNotEmpty
                            ? 'Essayez de modifier votre recherche ou de réinitialiser les filtres.'
                            : 'Vous n\'avez pas encore publié de bien dans cette catégorie.',
                        style: GoogleFonts.outfit(
                            fontSize: 14, color: ElxauTheme.secondaryText),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      if (_selectedCategory != null || _searchQuery.isNotEmpty)
                        AppFilledButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = null;
                              _searchQuery = '';
                              _searchController.clear();
                            });
                          },
                          child: const Text('Voir toutes les annonces'),
                        ),
                    ],
                  ),
                )
              else
                ...filtered.map((p) => _buildListingCard(p)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListingCard(Property p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ElxauTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: ElxauTheme.softShadow,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: p.images.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: p.images[0],
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                        width: 100,
                        height: 80,
                        color: ElxauTheme.grayLight),
                    errorWidget: (context, url, error) => Container(
                        width: 100,
                        height: 80,
                        color: ElxauTheme.grayLight,
                        child: const Icon(CupertinoIcons.house_fill)),
                  )
                : Container(
                    width: 100, height: 80, color: ElxauTheme.grayLight),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.title,
                    style: GoogleFonts.outfit(
                        color: ElxauTheme.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(p.type.icon,
                        size: 12, color: ElxauTheme.secondaryText),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${p.type.label} · ${p.quartier}, ${p.ville}',
                        style: const TextStyle(
                            color: ElxauTheme.secondaryText, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildMiniTag(
                        '\$${p.pricePerMonth.toInt()}/mois', ElxauTheme.accent),
                    const SizedBox(width: 8),
                    _buildMiniTag(
                      p.status == PropertyStatus.available
                          ? 'Disponible'
                          : p.status == PropertyStatus.sold
                              ? 'Vendu'
                              : 'Réservé',
                      p.status == PropertyStatus.available
                          ? ElxauTheme.success
                          : p.status == PropertyStatus.sold
                              ? ElxauTheme.destructive
                              : ElxauTheme.systemOrange,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Colonne statistiques
          Column(
            children: [
              Row(children: [
                const Icon(CupertinoIcons.eye_fill,
                    color: ElxauTheme.primary, size: 16),
                const SizedBox(width: 6),
                Text('${p.viewsCount} vues',
                    style: GoogleFonts.outfit(
                        color: ElxauTheme.accent,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(CupertinoIcons.chat_bubble_fill,
                    color: Color(0xFF25D366), size: 16),
                const SizedBox(width: 6),
                Text('${p.whatsappContactCount} contacts',
                    style: GoogleFonts.outfit(
                        color: ElxauTheme.accent,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
              ]),
            ],
          ),
          const SizedBox(width: 16),
          // Actions
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: () async {
              final v = await showAppSheet<String>(
                context: context,
                builder: (sheetContext) => CupertinoActionSheet(
                  actions: [
                    CupertinoActionSheetAction(
                      onPressed: () => Navigator.pop(sheetContext, 'edit'),
                      child: const Text('Modifier'),
                    ),
                    CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      onPressed: () => Navigator.pop(sheetContext, 'delete'),
                      child: const Text('Supprimer'),
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () => Navigator.pop(sheetContext),
                    child: const Text('Annuler'),
                  ),
                ),
              );
              if (!mounted) return;
              if (v == 'edit') {
                await showAppMessage(context, 'Édition de l\'annonce...');
              } else if (v == 'delete') {
                await showAppMessage(context, '"${p.title}" supprimée',
                    title: 'Information');
              }
            },
            child: const Icon(CupertinoIcons.ellipsis_vertical,
                color: ElxauTheme.secondaryText),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(100)),
      child: Text(text,
          style: GoogleFonts.outfit(
              color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  // ============================================================
  // STATISTIQUES / ANALYTICS
  // ============================================================
  Widget _buildAnalytics() {
    final sorted = List<Property>.from(_myProperties)
      ..sort((a, b) => b.viewsCount.compareTo(a.viewsCount));
    final totalViews = _myProperties.fold<int>(0, (s, p) => s + p.viewsCount);
    final totalContacts =
        _myProperties.fold<int>(0, (s, p) => s + p.whatsappContactCount);
    final conversionRate = totalViews > 0
        ? (totalContacts / totalViews * 100).toStringAsFixed(1)
        : '0.0';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: AnimationLimiter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (w) => SlideAnimation(
                verticalOffset: 30, child: FadeInAnimation(child: w)),
            children: [
              // Résumé statistiques
              Row(
                children: [
                  _buildDashStatCard(
                      'Total Vues',
                      '$totalViews',
                      CupertinoIcons.eye_fill,
                      ElxauTheme.primary,
                      'Toutes annonces confondues'),
                  const SizedBox(width: 20),
                  _buildDashStatCard(
                      'Total Contacts',
                      '$totalContacts',
                      CupertinoIcons.chat_bubble_fill,
                      const Color(0xFF25D366),
                      'Via WhatsApp'),
                  const SizedBox(width: 20),
                  _buildDashStatCard(
                      'Taux de Conversion',
                      '$conversionRate%',
                      CupertinoIcons.graph_circle,
                      ElxauTheme.systemBlue,
                      'Vues → Contacts'),
                ],
              ),
              const SizedBox(height: 32),
              Text('Détail par Annonce',
                  style: GoogleFonts.playfairDisplay(
                      color: ElxauTheme.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              const SizedBox(height: 16),
              // Détail par annonce avec barre de progression
              ...sorted.map((p) => _buildAnalyticsTile(p, totalViews)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsTile(Property p, int totalViews) {
    final viewPercent = totalViews > 0 ? p.viewsCount / totalViews : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ElxauTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: ElxauTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: p.images.isNotEmpty
                    ? Image.network(p.images[0],
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                            width: 56, height: 56, color: ElxauTheme.grayLight))
                    : Container(
                        width: 56, height: 56, color: ElxauTheme.grayLight),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.title,
                        style: GoogleFonts.outfit(
                            color: ElxauTheme.accent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    Row(
                      children: [
                        Icon(p.type.icon,
                            size: 12, color: ElxauTheme.secondaryText),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${p.type.label} · ${p.quartier}',
                            style: const TextStyle(
                                color: ElxauTheme.secondaryText, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${p.viewsCount} vues',
                      style: GoogleFonts.outfit(
                          color: ElxauTheme.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  Text('${p.whatsappContactCount} contacts WA',
                      style: const TextStyle(
                          color: Color(0xFF25D366),
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Barre de progression
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SizedBox(
              height: 8,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: ElxauTheme.grayLight),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: viewPercent.clamp(0.0, 1.0),
                    child: const ColoredBox(color: ElxauTheme.primary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text('${(viewPercent * 100).toStringAsFixed(1)}% du total des vues',
              style: const TextStyle(
                  color: ElxauTheme.secondaryText, fontSize: 11)),
        ],
      ),
    );
  }

  // ============================================================
  // NOTIFICATIONS
  // ============================================================
  Widget _buildNotificationsPage() {
    final ownerId = context.read<AuthService>().currentUser?.id ?? '';
    final firestore = context.read<FirestoreService>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: AnimationLimiter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (w) => SlideAnimation(
                verticalOffset: 30, child: FadeInAnimation(child: w)),
            children: [
              Row(
                children: [
                  Text(
                      '${_notifications.length} notification${_notifications.length > 1 ? 's' : ''}',
                      style: GoogleFonts.outfit(
                          color: ElxauTheme.secondaryText, fontSize: 14)),
                  const Spacer(),
                  if (_notifications.any((n) => !n.isRead))
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: () async {
                        await firestore
                            .markAllEntityNotificationsRead(ownerId);
                        setState(() {
                          _notifications = _notifications
                              .map((n) => n.copyWith(isRead: true))
                              .toList();
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(CupertinoIcons.checkmark_alt, size: 18),
                          const SizedBox(width: 6),
                          Text('Tout marquer comme lu',
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (_notifications.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 64),
                  decoration: BoxDecoration(
                    color: ElxauTheme.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: ElxauTheme.softShadow,
                  ),
                  child: Column(
                    children: [
                      Icon(CupertinoIcons.bell,
                          size: 48,
                          color:
                              ElxauTheme.secondaryText.withValues(alpha: 0.35)),
                      const SizedBox(height: 16),
                      Text(
                        'Aucune notification',
                        style: GoogleFonts.playfairDisplay(
                          color: ElxauTheme.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Les alertes de réservation, vues et contacts\napparaîtront ici en temps réel.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ElxauTheme.secondaryText,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ..._notifications.map((n) => _buildNotifTile(n)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotifTile(NotificationModel n) {
    final isRead = n.isRead;
    final icon = n.icon;
    final color = n.color;

    return GestureDetector(
      onTap: () async {
        if (isRead) return;
        final firestore = context.read<FirestoreService>();
        await firestore.markNotificationRead(n.id);
        setState(() {
          final i = _notifications.indexWhere((e) => e.id == n.id);
          if (i >= 0) {
            _notifications[i] = n.copyWith(isRead: true);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead ? ElxauTheme.white : color.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border:
              isRead ? null : Border.all(color: color.withValues(alpha: 0.15)),
          boxShadow: ElxauTheme.softShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(n.title,
                      style: GoogleFonts.outfit(
                          color: ElxauTheme.accent,
                          fontWeight:
                              isRead ? FontWeight.w500 : FontWeight.bold,
                          fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(n.message,
                      style: const TextStyle(
                          color: ElxauTheme.secondaryText, fontSize: 12)),
                ],
              ),
            ),
            Text(n.timeLabel,
                style: const TextStyle(
                    color: ElxauTheme.secondaryText, fontSize: 11)),
            if (!isRead)
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CONTACTS WHATSAPP
  // ============================================================
  Widget _buildWhatsAppContactsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: AnimationLimiter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (w) => SlideAnimation(
                verticalOffset: 30, child: FadeInAnimation(child: w)),
            children: [
              Row(
                children: [
                  Text('${_whatsappContacts.length} prospects via WhatsApp',
                      style: GoogleFonts.outfit(
                          color: ElxauTheme.secondaryText, fontSize: 14)),
                  const Spacer(),
                  AppFilledButton(
                    onPressed: () async {
                      final url = Uri.parse('https://web.whatsapp.com');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    color: const Color(0xFF25D366),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    borderRadius: BorderRadius.circular(14),
                    minSize: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(CupertinoIcons.arrow_up_right_square,
                            size: 18),
                        const SizedBox(width: 8),
                        Text('Ouvrir WhatsApp Web',
                            style:
                                GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_whatsappContacts.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 64),
                  decoration: BoxDecoration(
                    color: ElxauTheme.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: ElxauTheme.softShadow,
                  ),
                  child: Column(
                    children: [
                      Icon(CupertinoIcons.chat_bubble,
                          size: 48,
                          color:
                              ElxauTheme.secondaryText.withValues(alpha: 0.35)),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun contact WhatsApp',
                        style: GoogleFonts.playfairDisplay(
                          color: ElxauTheme.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Les prospects qui vous contactent via WhatsApp\ns\'afficheront ici.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ElxauTheme.secondaryText,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ..._whatsappContacts.map((c) => _buildWhatsAppContactTile(c)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWhatsAppContactTile(Map<String, dynamic> c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ElxauTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: ElxauTheme.softShadow,
      ),
      child: Row(
        children: [
          AppAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF25D366).withValues(alpha: 0.1),
            child: Text(
              c['name'].toString().isNotEmpty ? c['name'][0] : '?',
              style: GoogleFonts.playfairDisplay(
                  color: const Color(0xFF25D366),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c['name'],
                    style: GoogleFonts.outfit(
                        color: ElxauTheme.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                const SizedBox(height: 2),
                Text(c['phone'],
                    style: const TextStyle(
                        color: ElxauTheme.secondaryText, fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildMiniTag(c['property'], ElxauTheme.primary),
                    const SizedBox(width: 8),
                    Text(c['date'],
                        style: const TextStyle(
                            color: ElxauTheme.secondaryText, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('"${c['message']}"',
                  style: const TextStyle(
                      color: ElxauTheme.secondaryText,
                      fontSize: 12,
                      fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              AppFilledButton(
                onPressed: () async {
                  final phone =
                      c['phone'].toString().replaceAll(RegExp(r'[^0-9+]'), '');
                  final url = Uri.parse('https://wa.me/$phone');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                color: const Color(0xFF25D366),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                borderRadius: BorderRadius.circular(10),
                minSize: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.chat_bubble_fill, size: 16),
                    const SizedBox(width: 8),
                    Text('Répondre',
                        style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HELPER CLASSES
// ============================================================
class _SidebarItem {
  final IconData icon;
  final String label;
  const _SidebarItem(this.icon, this.label);
}
