import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:elxau/main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'vous@exemple.cd');
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin({bool isDemo = false}) async {
    setState(() => _isLoading = true);
    final auth = context.read<AuthService>();

    final email = isDemo
        ? 'demo@lushistay.cd'
        : (_emailController.text.trim().isEmpty
            ? 'vous@exemple.cd'
            : _emailController.text.trim());

    try {
      await auth.signIn(email: email, password: 'demo-password-2026');
    } catch (_) {
      // Demo fallback
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, anim, secAnim) => const MainNavigation(),
        transitionsBuilder: (context, anim, secAnim, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LushiStayTheme.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: LushiStayTheme.copper,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.apartment_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ).animate().fadeIn(duration: 500.ms).scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    curve: Curves.easeOutBack,
                  ),

              const Gap(24),

              // Title
              Text(
                'LushiStay',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

              const Gap(8),

              Text(
                'Séjours d\'exception à Lubumbashi',
                style: GoogleFonts.plusJakartaSans(
                  color: LushiStayTheme.textSecondary,
                  fontSize: 15,
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

              const Spacer(),

              // Email field
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: LushiStayTheme.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: LushiStayTheme.cardBorder),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      color: LushiStayTheme.textMuted,
                      size: 20,
                    ),
                    const Gap(12),
                    Expanded(
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        cursorColor: LushiStayTheme.copper,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            color: LushiStayTheme.textMuted,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms),

              const Gap(12),

              // Continue button - Airbnb style gradient pink/copper
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _handleLogin(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LushiStayTheme.copper,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Continuer',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ).animate().fadeIn(delay: 350.ms),

              const Gap(20),

              // Divider with "ou"
              Row(
                children: [
                  const Expanded(
                    child: Divider(color: LushiStayTheme.cardBorder),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'ou',
                      style: GoogleFonts.plusJakartaSans(
                        color: LushiStayTheme.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(color: LushiStayTheme.cardBorder),
                  ),
                ],
              ),

              const Gap(20),

              // Social login buttons - Airbnb style (outlined, full-width, icon left)
              _buildSocialButton(
                icon: Icons.g_mobiledata_rounded,
                label: 'Continuer avec Google',
                onTap: () => _handleLogin(isDemo: true),
              ),
              const Gap(12),
              _buildSocialButton(
                icon: Icons.apple_rounded,
                label: 'Continuer avec Apple',
                onTap: () => _handleLogin(isDemo: true),
              ),
              const Gap(12),
              _buildSocialButton(
                icon: Icons.phone_outlined,
                label: 'Continuer avec Téléphone',
                onTap: () => _handleLogin(isDemo: true),
              ),

              const Gap(24),

              // Demo note
              Text(
                'Mode démo · Aucune donnée réelle',
                style: GoogleFonts.plusJakartaSans(
                  color: LushiStayTheme.textMuted,
                  fontSize: 12,
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: _isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: LushiStayTheme.cardBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.white),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 24), // Balance the icon
          ],
        ),
      ),
    );
  }
}
