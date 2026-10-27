import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:elxau/brand_config.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:elxau/services/firestore_service.dart';
import 'package:elxau/screens/admin_splash_screen.dart';
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
    debugPrint('Firebase initialisé avec succès pour ImmoTrust Entité');
  } catch (e) {
    debugPrint(
        'Erreur lors de l\'initialisation de Firebase pour ImmoTrust Entité: $e');
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
      child: const ElxauAdminApp(),
    ),
  );
}

class ElxauAdminApp extends StatelessWidget {
  const ElxauAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: BrandConfig.entityWorkspaceName,
      debugShowCheckedModeBanner: false,
      theme: ElxauTheme.cupertinoTheme,
      home: const AdminSplashScreen(),
    );
  }
}
