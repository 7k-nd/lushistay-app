import 'package:flutter/foundation.dart';

/// Controle les modes demo locaux (auth mock, catalogues mock).
///
/// En release, tout est desactive quoi qu'il arrive.
/// En debug, basculer [allowDemoAuth] / [allowDemoData] a false
/// pour tester le comportement prod sans rebuild release.
class DemoConfig {
  const DemoConfig._();

  /// Auth mock / bypass entite (emails demo, session mock_*).
  static const bool allowDemoAuth = true;

  /// Catalogue / bookings locaux quand Firebase est absent.
  static const bool allowDemoData = true;

  static bool get demoAuthEnabled => kDebugMode && allowDemoAuth;

  static bool get demoDataEnabled => kDebugMode && allowDemoData;
}