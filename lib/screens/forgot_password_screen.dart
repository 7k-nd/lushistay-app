import 'package:flutter/cupertino.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/cupertino_ui.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailKey = GlobalKey<AppFormFieldState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!validateFields([_emailKey])) return;

    final authService = context.read<AuthService>();

    final result = await authService.resetPassword(
      email: _emailController.text.trim(),
    );

    if (!mounted) return;

    await showAppMessage(
      context,
      result['message'] ?? (result['success'] == true ? 'Email envoyé' : 'Erreur'),
      title: result['success'] == true ? 'Succès' : 'Erreur',
    );
    if (result['success'] == true && mounted) {
      Navigator.pop(context);
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
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: ElxauTheme.white,
                    shape: BoxShape.circle,
                    boxShadow: ElxauTheme.softShadow,
                  ),
                  child: const Icon(
                    CupertinoIcons.lock_rotation,
                    size: 40,
                    color: ElxauTheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Réinitialiser le mot de passe',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  color: ElxauTheme.accent,
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Entrez votre email et nous vous enverrons les instructions pour réinitialiser votre mot de passe.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: ElxauTheme.secondaryText,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              AppFormField(
                key: _emailKey,
                controller: _emailController,
                label: 'Email',
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
              const SizedBox(height: 32),
              Consumer<AuthService>(
                builder: (context, authService, child) {
                  return SizedBox(
                    height: 56,
                    child: AppFilledButton(
                      onPressed:
                          authService.isLoading ? null : _handleResetPassword,
                      child: authService.isLoading
                          ? const CupertinoActivityIndicator(
                              color: ElxauTheme.white,
                            )
                          : const Text('Envoyer'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              CupertinoButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Retour à la connexion',
                  style: TextStyle(
                    color: ElxauTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
