import 'package:flutter_test/flutter_test.dart';
import 'package:elxau/models/user.dart';

void main() {
  group('User Model Tests', () {
    test('User serialization and deserialization matches', () {
      final date = DateTime(2026, 7, 30);
      final user = User(
        id: '123',
        email: 'test@immotrust.app',
        nom: 'Tshimanga',
        prenom: 'Patrice',
        telephone: '+243990000000',
        isEntity: true,
        entityName: 'ImmoTrust Entité',
        dateInscription: date,
      );

      final json = user.toJson();

      expect(json['id'], '123');
      expect(json['email'], 'test@immotrust.app');
      expect(json['isEntity'], true);
      expect(json['entityName'], 'ImmoTrust Entité');

      final deserialized = User.fromJson(json);

      expect(deserialized.id, user.id);
      expect(deserialized.email, user.email);
      expect(deserialized.nom, user.nom);
      expect(deserialized.prenom, user.prenom);
      expect(deserialized.telephone, user.telephone);
      expect(deserialized.isEntity, user.isEntity);
      expect(deserialized.entityName, user.entityName);
    });

    test('nomComplet returns entityName when isEntity is true', () {
      final user = User(
        id: '123',
        email: 'test@immotrust.app',
        nom: 'Tshimanga',
        isEntity: true,
        entityName: 'ImmoTrust Entité',
      );

      expect(user.nomComplet, 'ImmoTrust Entité');
    });

    test('nomComplet returns prenom + nom when isEntity is false', () {
      final user = User(
        id: '123',
        email: 'client@gmail.com',
        nom: 'Mukendi',
        prenom: 'Sophie',
        isEntity: false,
      );

      expect(user.nomComplet, 'Sophie Mukendi');
    });
  });
}
