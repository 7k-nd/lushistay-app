import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:elxau/brand_config.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/cupertino_ui.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:elxau/screens/login_screen.dart';
import 'package:elxau/screens/notifications_screen.dart';
import 'package:elxau/screens/edit_profile_screen.dart';
import 'package:elxau/screens/bookings_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _openUrl(BuildContext context, String url) async {
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      await showAppMessage(context, 'Impossible d ouvrir ce lien.');
    }
  }

  Future<void> _openSupport(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: BrandConfig.supportEmail,
      queryParameters: {
        'subject': 'Aide ImmoTrust',
      },
    );
    final opened = await launchUrl(uri);
    if (!opened && context.mounted) {
      await showAppMessage(
        context,
        'Ecrivez-nous a ${BrandConfig.supportEmail}',
      );
    }
  }

  Future<void> _requireLogin(BuildContext context) async {
    final go = await showAppConfirm(
      context,
      title: 'Connexion requise',
      message: 'Connectez-vous pour acceder a cette fonctionnalite.',
      confirmLabel: 'Se connecter',
    );
    if (go && context.mounted) {
      Navigator.push(context, appRoute(const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final user = authService.currentUser;

    final menuItems = <Widget>[
      if (user != null) ...[
        _buildProfileItem(
          icon: CupertinoIcons.person,
          title: 'Informations personnelles',
          onTap: () {
            Navigator.push(context, appRoute(const EditProfileScreen()));
          },
        ),
        _buildProfileItem(
          icon: CupertinoIcons.heart,
          title: 'Mes demandes',
          onTap: () {
            Navigator.push(context, appRoute(const BookingsScreen()));
          },
        ),
        _buildProfileItem(
          icon: CupertinoIcons.bell,
          title: 'Notifications',
          onTap: () {
            Navigator.push(context, appRoute(const NotificationsScreen()));
          },
        ),
      ] else ...[
        _buildProfileItem(
          icon: CupertinoIcons.person,
          title: 'Informations personnelles',
          onTap: () => _requireLogin(context),
        ),
        _buildProfileItem(
          icon: CupertinoIcons.heart,
          title: 'Mes demandes',
          onTap: () => _requireLogin(context),
        ),
      ],
      _buildProfileItem(
        icon: CupertinoIcons.chat_bubble_2,
        title: 'Mise en relation',
        onTap: () => showAppMessage(context, BrandConfig.contactOnlyLong),
      ),
      _buildProfileItem(
        icon: CupertinoIcons.doc_text,
        title: 'Confidentialite',
        onTap: () => _openUrl(context, BrandConfig.privacyUrl),
      ),
      _buildProfileItem(
        icon: CupertinoIcons.doc_on_doc,
        title: 'Conditions d utilisation',
        onTap: () => _openUrl(context, BrandConfig.termsUrl),
      ),
      _buildProfileItem(
        icon: CupertinoIcons.question_circle,
        title: 'Aide et support',
        onTap: () => _openSupport(context),
      ),
      if (user != null)
        _buildProfileItem(
          icon: CupertinoIcons.trash,
          title: 'Supprimer mon compte',
          destructive: true,
          onTap: () => _handleDeleteAccount(context),
        ),
    ];

    return AppScaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: ElxauTheme.white,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: ElxauTheme.primary, width: 2),
                        ),
                        child: AppAvatar(
                          radius: 54,
                          backgroundColor: ElxauTheme.bg,
                          child: user?.photoUrl != null
                              ? Image.network(
                                  user!.photoUrl!,
                                  fit: BoxFit.cover,
                                  width: 108,
                                  height: 108,
                                )
                              : const Icon(CupertinoIcons.person,
                                  size: 60, color: ElxauTheme.primary),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        user?.nomComplet ?? 'Invite',
                        style: GoogleFonts.playfairDisplay(
                          color: ElxauTheme.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      if (user == null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Parcourez les biens librement',
                          style: GoogleFonts.outfit(
                            color: ElxauTheme.secondaryText,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (user != null) ...[
                  _buildUserInfo('Email', user.email),
                  if (user.telephone != null)
                    _buildUserInfo('Telephone', user.telephone!),
                  if (user.dateInscription != null)
                    _buildUserInfo(
                      'Membre depuis',
                      '${user.dateInscription!.day}/${user.dateInscription!.month}/${user.dateInscription!.year}',
                    ),
                  const SizedBox(height: 24),
                ],
                AnimationLimiter(
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 375),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(child: widget),
                      ),
                      children: menuItems,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: user == null
                      ? AppFilledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              appRoute(const LoginScreen()),
                            );
                          },
                          color: ElxauTheme.accent,
                          child: const Text('Se connecter'),
                        )
                      : AppOutlineButton(
                          onPressed: () => _handleLogout(context),
                          borderColor: ElxauTheme.destructive,
                          textColor: ElxauTheme.destructive,
                          child: const Text('Se deconnecter'),
                        ),
                ),
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: ElxauTheme.secondaryText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: ElxauTheme.accent,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool destructive = false,
  }) {
    final color = destructive ? ElxauTheme.destructive : ElxauTheme.accent;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ElxauTheme.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: ElxauTheme.softShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: destructive
                    ? ElxauTheme.destructive.withValues(alpha: 0.08)
                    : ElxauTheme.bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: color,
                ),
              ),
            ),
            Icon(
              CupertinoIcons.right_chevron,
              color: ElxauTheme.secondaryText.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showAppConfirm(
      context,
      title: 'Deconnexion',
      message: 'Etes-vous sur de vouloir vous deconnecter ?',
      confirmLabel: 'Se deconnecter',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      await context.read<AuthService>().signOut();
      if (!context.mounted) return;
      Navigator.of(context).pushReplacement(
        appRoute(const LoginScreen()),
      );
    }
  }

  Future<void> _handleDeleteAccount(BuildContext context) async {
    final confirmed = await showAppConfirm(
      context,
      title: 'Supprimer mon compte',
      message:
          'Cette action est definitive. Votre compte et vos donnees de profil seront supprimes. '
          'Les annonces deja publiees pourront etre traitees separement par le support.',
      confirmLabel: 'Supprimer',
      isDestructive: true,
    );
    if (!confirmed || !context.mounted) return;

    final auth = context.read<AuthService>();
    final result = await auth.deleteAccount();
    if (!context.mounted) return;

    await showAppMessage(
      context,
      result['message'] as String? ?? 'Operation terminee',
      title: (result['success'] == true) ? 'Compte supprime' : 'Impossible',
    );

    if (result['success'] == true && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        appRoute(const LoginScreen()),
        (_) => false,
      );
    }
  }
}