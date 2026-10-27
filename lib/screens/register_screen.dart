import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/cupertino_ui.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:elxau/brand_config.dart';
import 'package:elxau/main_navigation.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nomKey = GlobalKey<AppFormFieldState>();
  final _emailKey = GlobalKey<AppFormFieldState>();
  final _passwordKey = GlobalKey<AppFormFieldState>();
  final _confirmKey = GlobalKey<AppFormFieldState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!validateFields([_nomKey, _emailKey, _passwordKey, _confirmKey])) return;
    if (!_acceptTerms) {
      await showAppMessage(
        context,
        'Veuillez accepter les conditions d\'utilisation',
        title: 'Inscription',
      );
      return;
    }

    final authService = context.read<AuthService>();

    final result = await authService.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      nom: _nomController.text.trim(),
      prenom: _prenomController.text.trim().isEmpty
          ? null
          : _prenomController.text.trim(),
      telephone: _telephoneController.text.trim().isEmpty
          ? null
          : _telephoneController.text.trim(),
      isEntity: false,
      entityName: null,
    );

    if (!mounted) return;

    if (result['success'] == true) {
      Navigator.of(context).pushReplacement(
        appRoute(const MainNavigation()),
      );
    } else {
      await showAppMessage(
        context,
        result['message'] ?? 'Erreur d\'inscription',
        title: 'Inscription',
      );
    }
  }

  Future<void> _openLegalUrl(String url) async {
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) {
      await showAppMessage(context, 'Impossible d ouvrir ce lien.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      navigationBar: const AppNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Créer un compte',
                style: GoogleFonts.playfairDisplay(
                  color: ElxauTheme.accent,
                  fontWeight: FontWeight.w900,
                  fontSize: 32,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Rejoignez-nous pour des expériences uniques',
                style: GoogleFonts.outfit(
                  color: ElxauTheme.secondaryText,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),
              AppFormField(
                key: _nomKey,
                controller: _nomController,
                label: 'Nom *',
                placeholder: 'Votre nom',
                prefixIcon: CupertinoIcons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppFormField(
                controller: _prenomController,
                label: 'Prénom',
                placeholder: 'Votre prénom (optionnel)',
                prefixIcon: CupertinoIcons.person,
              ),
              const SizedBox(height: 16),
              AppFormField(
                key: _emailKey,
                controller: _emailController,
                label: 'Email *',
                placeholder: 'votre@email.com',
                prefixIcon: CupertinoIcons.mail,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  if (!value.contains('@')) {
                    return 'Email invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppFormField(
                controller: _telephoneController,
                label: 'Téléphone',
                placeholder: '+243 XXX XXX XXX (optionnel)',
                prefixIcon: CupertinoIcons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              AppFormField(
                key: _passwordKey,
                controller: _passwordController,
                label: 'Mot de passe *',
                placeholder: '••••••••',
                prefixIcon: CupertinoIcons.lock,
                obscureText: _obscurePassword,
                suffix: CupertinoButton(
                  padding: const EdgeInsets.only(right: 8),
                  minimumSize: Size.zero,
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  child: Icon(
                    _obscurePassword
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                    color: ElxauTheme.secondaryText,
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  if (value.length < 6) {
                    return 'Au moins 6 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppFormField(
                key: _confirmKey,
                controller: _confirmPasswordController,
                label: 'Confirmer le mot de passe *',
                placeholder: '••••••••',
                prefixIcon: CupertinoIcons.lock,
                obscureText: _obscureConfirmPassword,
                suffix: CupertinoButton(
                  padding: const EdgeInsets.only(right: 8),
                  minimumSize: Size.zero,
                  onPressed: () {
                    setState(
                        () => _obscureConfirmPassword = !_obscureConfirmPassword);
                  },
                  child: Icon(
                    _obscureConfirmPassword
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                    color: ElxauTheme.secondaryText,
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez confirmer votre mot de passe';
                  }
                  if (value != _passwordController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  CupertinoCheckbox(
                    value: _acceptTerms,
                    activeColor: ElxauTheme.primary,
                    onChanged: (value) {
                      setState(() {
                        _acceptTerms = value ?? false;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12,
                          color: ElxauTheme.secondaryText,
                        ),
                        children: [
                          const TextSpan(text: 'J\'accepte les '),
                          TextSpan(
                            text: 'Conditions d\'utilisation',
                            style: const TextStyle(
                              color: ElxauTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap =
                                  () => _openLegalUrl(BrandConfig.termsUrl),
                          ),
                          const TextSpan(text: ' et la '),
                          TextSpan(
                            text: 'Politique de confidentialite',
                            style: const TextStyle(
                              color: ElxauTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap =
                                  () => _openLegalUrl(BrandConfig.privacyUrl),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Consumer<AuthService>(
                builder: (context, authService, child) {
                  return SizedBox(
                    height: 56,
                    child: AppFilledButton(
                      onPressed:
                          authService.isLoading ? null : _handleRegister,
                      child: authService.isLoading
                          ? const CupertinoActivityIndicator(
                              color: ElxauTheme.white,
                            )
                          : const Text('S\'inscrire'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Déjà un compte ?',
                    style: TextStyle(color: ElxauTheme.secondaryText),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Se connecter',
                      style: TextStyle(
                        color: ElxauTheme.primary,
                        fontWeight: FontWeight.bold,
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
}
