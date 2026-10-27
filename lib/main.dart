import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elxau/brand_config.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:elxau/services/firestore_service.dart';
import 'package:elxau/screens/splash_screen.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isFirebaseInitialized = false;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    isFirebaseInitialized = true;
    debugPrint('Firebase initialisé avec succès');
  } catch (e) {
    debugPrint('Erreur lors de l\'initialisation de Firebase: $e');
  }

  final authService = AuthService(isFirebaseInitialized: isFirebaseInitialized);
  await authService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authService),
        Provider(
          create: (_) =>
              FirestoreService(isFirebaseInitialized: isFirebaseInitialized),
        ),
      ],
      child: const LushiStayApp(),
    ),
  );
}

class LushiStayApp extends StatelessWidget {
  const LushiStayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: BrandConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: LushiStayTheme.materialTheme,
      home: const SplashScreen(),
    );
  }
}

typedef ElxauApp = LushiStayApp;
