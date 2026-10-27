import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:elxau/brand_config.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/cupertino_ui.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:elxau/screens/admin_login_screen.dart';
import 'package:elxau/screens/entity_desktop_layout.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminSplashScreen extends StatefulWidget {
  const AdminSplashScreen({super.key});

  @override
  State<AdminSplashScreen> createState() => _AdminSplashScreenState();
}

class _AdminSplashScreenState extends State<AdminSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.9, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 3000), () async {
      if (!mounted) return;

      final authService = context.read<AuthService>();

      Widget destination;
      if (authService.isAuthenticated) {
        final user = authService.currentUser;
        if (user != null && user.isEntity) {
          // Espace entité pensé pour ordinateur, même sur petit écran.
          destination = const EntityDesktopLayout();
        } else {
          // If logged in as client, force logout for the admin app
          await authService.signOut();
          destination = const AdminLoginScreen();
        }
      } else {
        destination = const AdminLoginScreen();
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => destination,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: ElxauTheme.accent, // Dark premium background
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ElxauTheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        CupertinoIcons.building_2_fill,
                        color: ElxauTheme.white,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      BrandConfig.entityWorkspaceName,
                      style: GoogleFonts.playfairDisplay(
                        color: ElxauTheme.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Espace proprietaire et administrateur - ordinateur',
                      style: GoogleFonts.outfit(
                        color: ElxauTheme.white.withValues(alpha: 0.6),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 40,
            right: 40,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return Center(
                        child: SizedBox(
                          height: 3,
                          width: 140,
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: ElxauTheme.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 140 * _progressAnimation.value,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: ElxauTheme.primary,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
