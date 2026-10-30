import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:elxau/screens/login_screen.dart';
import 'package:elxau/main_navigation.dart';
import 'package:elxau/utils/app_svg_icons.dart';

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
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    final target = const MainNavigation();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, anim, secAnim) => target,
        transitionsBuilder: (context, anim, secAnim, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LushiStayTheme.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Modern brand logo pill
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: AppSvgIcons.svg(
                  AppSvgIcons.iconVilla,
                  color: LushiStayTheme.blue,
                  size: 44,
                ),
              ),
            ).animate().fadeIn(duration: 400.ms).scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1, 1),
                  curve: Curves.easeOutBack,
                ),

            const SizedBox(height: 24),

            Text(
              'LushiStay',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
