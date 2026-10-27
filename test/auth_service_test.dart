import 'package:flutter_test/flutter_test.dart';
import 'package:elxau/services/auth_service.dart';

void main() {
  group('AuthService account lifecycle', () {
    test('deleteAccount fails when not signed in', () async {
      final auth = AuthService(isFirebaseInitialized: false);
      await auth.init();

      final result = await auth.deleteAccount();

      expect(result['success'], isFalse);
      expect(result['message'], isNotNull);
    });

    test('demo signIn then deleteAccount clears session (debug)', () async {
      final auth = AuthService(isFirebaseInitialized: false);
      await auth.init();

      final signIn = await auth.signIn(
        email: 'client@example.com',
        password: 'any',
      );
      // En debug/test, demo auth est autorise.
      expect(signIn['success'], isTrue);
      expect(auth.isAuthenticated, isTrue);

      final deleted = await auth.deleteAccount();
      expect(deleted['success'], isTrue);
      expect(auth.isAuthenticated, isFalse);
      expect(auth.currentUser, isNull);
    });

    test('entity workspace demo sign-in sets isEntity', () async {
      final auth = AuthService(isFirebaseInitialized: false);
      await auth.init();

      final result = await auth.signInEntityWorkspace(
        email: 'admin@immotrust.app',
        password: 'any',
      );

      expect(result['success'], isTrue);
      expect(auth.currentUser?.isEntity, isTrue);
    });
  });
}