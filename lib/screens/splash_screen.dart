import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:elxau/screens/login_screen.dart';
import 'package:elxau/main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;

    final auth = context.read<AuthService>();
    final target = auth.isAuthenticated
        ? const MainNavigation()
        : const LoginScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, anim, secAnim) => target,
        transitionsBuilder: (context, anim, secAnim, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LushiStayTheme.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rotating diamond icon with copper glow
            Transform.rotate(
              angle: 0.785398,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      LushiStayTheme.copperLight,
                      LushiStayTheme.copper,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: LushiStayTheme.copper.withValues(alpha: 0.5),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
              ),
            )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1.05, 1.05),
                  duration: 1200.ms,
                  curve: Curves.easeInOut,
                ),

            const Gap(32),

            Text(
              'LushiStay',
              style: GoogleFonts.playfairDisplay(
                color: LushiStayTheme.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),

            const Gap(10),

            Text(
              'LUBUMBASHI · SÉJOURS D\'EXCEPTION',
              style: GoogleFonts.plusJakartaSans(
                color: LushiStayTheme.copperLight,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }
}
