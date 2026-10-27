import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/brand_config.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:elxau/main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController(text: 'Grâce Mwamba');
  final _emailController = TextEditingController(text: 'vous@exemple.cd');
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue({bool isInstantDemo = false}) async {
    setState(() => _isLoading = true);
    final auth = context.read<AuthService>();

    final email = _emailController.text.trim().isEmpty
        ? 'vous@exemple.cd'
        : _emailController.text.trim();

    try {
      await auth.signIn(email: email, password: 'demo-password-2026');
    } catch (_) {
      // Demo fallback always succeeds
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, anim, secAnim) => const MainNavigation(),
        transitionsBuilder: (context, anim, secAnim, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LushiStayTheme.bg,
      body: Stack(
        children: [
          // Background City Night Mood Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF070C15).withValues(alpha: 0.9),
                    const Color(0xFF0B111E).withValues(alpha: 0.96),
                    LushiStayTheme.bg,
                  ],
                ),
              ),
            ),
          ),

          // Ambient subtle copper glow at top
          Positioned(
            top: -100,
            left: MediaQuery.of(context).size.width * 0.2,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: LushiStayTheme.copper.withValues(alpha: 0.12),
                boxShadow: [
                  BoxShadow(
                    color: LushiStayTheme.copper.withValues(alpha: 0.15),
                    blurRadius: 120,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Gap(16),

                    // Top Logo: Copper Diamond + LushiStay
                    Row(
                      children: [
                        Transform.rotate(
                          angle: 0.785398, // 45 degrees
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  LushiStayTheme.copperLight,
                                  LushiStayTheme.copper,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: LushiStayTheme.copper
                                      .withValues(alpha: 0.4),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(14),
                        Text(
                          'LushiStay',
                          style: GoogleFonts.playfairDisplay(
                            color: LushiStayTheme.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),

                    const Gap(36),

                    // Main Headline
                    Text(
                      'Séjours d\'exception\nà Lubumbashi',
                      style: GoogleFonts.playfairDisplay(
                        color: LushiStayTheme.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        height: 1.15,
                      ),
                    ).animate().fadeIn(delay: 100.ms, duration: 450.ms),

                    const Gap(14),

                    // Subtitle
                    Text(
                      'Villas, appartements et chambres d\'hôtel premium dans la capitale du cuivre.',
                      style: GoogleFonts.plusJakartaSans(
                        color: LushiStayTheme.textSecondary,
                        fontSize: 14.5,
                        height: 1.5,
                      ),
                    ).animate().fadeIn(delay: 200.ms, duration: 450.ms),

                    const Gap(40),

                    // Form - Nom complet
                    Text(
                      'Nom complet',
                      style: GoogleFonts.plusJakartaSans(
                        color: LushiStayTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(8),
                    Container(
                      height: 54,
                      decoration: BoxDecoration(
                        color: LushiStayTheme.inputBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: LushiStayTheme.inputBorder),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Center(
                        child: TextField(
                          controller: _nameController,
                          style: GoogleFonts.plusJakartaSans(
                            color: LushiStayTheme.white,
                            fontSize: 15,
                          ),
                          cursorColor: LushiStayTheme.copper,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Ex. Grâce Mwamba',
                            hintStyle: GoogleFonts.plusJakartaSans(
                              color: LushiStayTheme.textMuted,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 250.ms),

                    const Gap(18),

                    // Form - Email
                    Text(
                      'Email',
                      style: GoogleFonts.plusJakartaSans(
                        color: LushiStayTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(8),
                    Container(
                      height: 54,
                      decoration: BoxDecoration(
                        color: LushiStayTheme.inputBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: LushiStayTheme.inputBorder),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Center(
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.plusJakartaSans(
                            color: LushiStayTheme.white,
                            fontSize: 15,
                          ),
                          cursorColor: LushiStayTheme.copper,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'vous@exemple.cd',
                            hintStyle: GoogleFonts.plusJakartaSans(
                              color: LushiStayTheme.textMuted,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 300.ms),

                    const Gap(28),

                    // Primary Button: "Continuer"
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () => _handleContinue(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: LushiStayTheme.copper,
                          foregroundColor: LushiStayTheme.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'Continuer',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                    ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.1),

                    const Gap(24),

                    // Divider with "ou"
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: LushiStayTheme.cardBorder,
                            thickness: 1,
                          ),
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
                          child: Divider(
                            color: LushiStayTheme.cardBorder,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 400.ms),

                    const Gap(24),

                    // Secondary Demo Button: "⚡ Accès démo instantané"
                    SizedBox(
                      height: 54,
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => _handleContinue(isInstantDemo: true),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: LushiStayTheme.inputBg,
                          foregroundColor: LushiStayTheme.white,
                          side: const BorderSide(
                            color: LushiStayTheme.inputBorder,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.bolt_rounded,
                              color: LushiStayTheme.gold,
                              size: 20,
                            ),
                            const Gap(8),
                            Text(
                              'Accès démo instantané',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.1),

                    const Gap(28),

                    // Demo Mode Note
                    Center(
                      child: Text(
                        BrandConfig.demoSubtitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          color: LushiStayTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ).animate().fadeIn(delay: 500.ms),

                    const Gap(24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
