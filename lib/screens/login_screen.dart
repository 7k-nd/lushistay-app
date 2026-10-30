import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:elxau/main_navigation.dart';
import 'package:elxau/utils/app_svg_icons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'voyageur@katanga.cd');
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
            ? 'voyageur@katanga.cd'
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

  void _continueAsGuest() {
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
      backgroundColor: const Color(0xFF070D18),
      body: Stack(
        children: [
          // ─── 1. Animated Luxury Villa Hero Background (Ken Burns effect) ───
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1613977257363-707ba9348227?w=1600&q=85',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: const Color(0xFF070D18)),
              errorWidget: (context, url, error) => Container(color: const Color(0xFF070D18)),
            )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.10, 1.10),
                  duration: const Duration(seconds: 16),
                  curve: Curves.easeInOut,
                ),
          ),

          // ─── 2. Deep Blue Cinematic Gradient Overlay ───
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0A152E).withValues(alpha: 0.65),
                    const Color(0xFF070D18).withValues(alpha: 0.88),
                  ],
                ),
              ),
            ),
          ),

          // ─── 3. Foreground Glassmorphism Content ───
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Brand Pill
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: LushiStayTheme.blue,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: LushiStayTheme.blue.withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: AppSvgIcons.svg(
                            AppSvgIcons.iconVilla,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ).animate().fadeIn(duration: 400.ms).scale(curve: Curves.easeOutBack),

                      const Gap(16),

                      Text(
                        'LushiStay',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ).animate().fadeIn(delay: 100.ms),

                      const Gap(4),

                      Text(
                        'Séjours d\'exception à Lubumbashi',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFFCBD5E1),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ).animate().fadeIn(delay: 200.ms),

                      const Gap(28),

                      // Frosted Glass Form Card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                          child: Container(
                            padding: const EdgeInsets.all(26),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.5),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bienvenue',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: LushiStayTheme.textPrimary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  'Connectez-vous pour organiser votre séjour',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: LushiStayTheme.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),

                                const Gap(20),

                                // Email Field
                                Container(
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
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
                                            color: LushiStayTheme.textPrimary,
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          cursorColor: LushiStayTheme.blue,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Adresse email',
                                            hintStyle: GoogleFonts.plusJakartaSans(
                                              color: LushiStayTheme.textMuted,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Gap(14),

                                // Blue Primary Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : () => _handleLogin(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: LushiStayTheme.blue,
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
                                            'Continuer avec email',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                  ),
                                ),

                                const Gap(18),

                                // Divider "ou"
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Divider(color: Color(0xFFE2E8F0)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        'ou',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: LushiStayTheme.textMuted,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                      child: Divider(color: Color(0xFFE2E8F0)),
                                    ),
                                  ],
                                ),

                                const Gap(16),

                                // Guest direct access button (instant exploration)
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: OutlinedButton(
                                    onPressed: _continueAsGuest,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: LushiStayTheme.blue,
                                      side: BorderSide(
                                        color: LushiStayTheme.blue.withValues(alpha: 0.35),
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        AppSvgIcons.svg(
                                          AppSvgIcons.navExplore,
                                          color: LushiStayTheme.blue,
                                          size: 18,
                                        ),
                                        const Gap(8),
                                        Text(
                                          'Explorer sans connexion',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.08, end: 0),

                      const Gap(24),

                      Text(
                        'Lubumbashi · République Démocratique du Congo',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
