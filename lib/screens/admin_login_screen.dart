import 'package:flutter/cupertino.dart';
import 'package:elxau/brand_config.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/cupertino_ui.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:elxau/screens/entity_desktop_layout.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailKey = GlobalKey<AppFormFieldState>();
  final _passwordKey = GlobalKey<AppFormFieldState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleAdminLogin() async {
    if (!validateFields([_emailKey, _passwordKey])) return;

    setState(() => _isLoading = true);

    final authService = context.read<AuthService>();

    final result = await authService.signInEntityWorkspace(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (result['success'] == true) {
      final user = authService.currentUser;
      if (user != null && user.isEntity) {
        // Redirection vers le dashboard adapté (Desktop ou Mobile)
        Navigator.of(context).pushReplacement(
          appRoute(const EntityDesktopLayout()),
        );
      } else {
        // Déconnexion forcée si ce n'est pas un compte entité
        await authService.signOut();
        setState(() => _isLoading = false);
        _showErrorMessage('Accès réservé aux comptes entité ImmoTrust.');
      }
    } else {
      setState(() => _isLoading = false);
      _showErrorMessage(result['message'] ?? 'Erreur de connexion');
    }
  }

  void _showErrorMessage(String message) {
    showAppMessage(context, message, title: 'Erreur');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: ElxauTheme.accent, // Premium dark background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: ElxauTheme.accent.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: ElxauTheme.white.withValues(alpha: 0.1)),
              boxShadow: [
                BoxShadow(
                  color: ElxauTheme.black.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: ElxauTheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      CupertinoIcons.building_2_fill,
                      color: ElxauTheme.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    BrandConfig.entityWorkspaceName,
                    style: GoogleFonts.playfairDisplay(
                      color: ElxauTheme.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'Espace propriétaire & administrateur — ordinateur',
                    style: GoogleFonts.outfit(
                      color: ElxauTheme.white.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                AppFormField(
                  key: _emailKey,
                  controller: _emailController,
                  label: 'Adresse email',
                  placeholder: 'admin@immotrust.app',
                  prefixIcon: CupertinoIcons.mail,
                  keyboardType: TextInputType.emailAddress,
                  fillColor: ElxauTheme.white.withValues(alpha: 0.05),
                  textColor: ElxauTheme.white,
                  placeholderColor: ElxauTheme.white.withValues(alpha: 0.3),
                  borderColor: ElxauTheme.white.withValues(alpha: 0.1),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    if (!value.contains('@')) {
                      return 'Format email invalide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppFormField(
                  key: _passwordKey,
                  controller: _passwordController,
                  label: 'Mot de passe',
                  placeholder: '••••••••',
                  prefixIcon: CupertinoIcons.lock,
                  obscureText: _obscurePassword,
                  fillColor: ElxauTheme.white.withValues(alpha: 0.05),
                  textColor: ElxauTheme.white,
                  placeholderColor: ElxauTheme.white.withValues(alpha: 0.3),
                  borderColor: ElxauTheme.white.withValues(alpha: 0.1),
                  suffix: CupertinoButton(
                    padding: const EdgeInsets.only(right: 8),
                    minimumSize: Size.zero,
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Icon(
                      _obscurePassword
                          ? CupertinoIcons.eye
                          : CupertinoIcons.eye_slash,
                      color: ElxauTheme.white.withValues(alpha: 0.6),
                      size: 20,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                AppFilledButton(
                  onPressed: _isLoading ? null : _handleAdminLogin,
                  color: ElxauTheme.primary,
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: _isLoading
                      ? const CupertinoActivityIndicator(
                          color: ElxauTheme.white,
                        )
                      : Text(
                          'Se connecter au Workspace',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Accès restreint. Réservé aux personnels autorisés.',
                    style: GoogleFonts.outfit(
                      color: ElxauTheme.white.withValues(alpha: 0.3),
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
