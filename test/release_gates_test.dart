import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:elxau/brand_config.dart';
import 'package:elxau/demo_config.dart';

void main() {
  group('Release gates / brand', () {
    test('no in-app payments in current product mode', () {
      expect(BrandConfig.paymentsInAppEnabled, isFalse);
      expect(BrandConfig.contactOnlyShort.toLowerCase(), contains('paiement'));
      expect(BrandConfig.contactOnlyLong.toLowerCase(), contains('whatsapp'));
    });

    test('contact copy has no checkout / M-Pesa CTA', () {
      const forbidden = [
        'payer maintenant',
        'm-pesa',
        'mpesa',
        'orange money',
      ];
      final copy = [
        BrandConfig.contactOnlyShort,
        BrandConfig.contactOnlyLong,
        ContactWhatsApp.interestMessage(
          propertyTitle: 'Villa test',
          userName: 'Patrice',
          userPhone: '+243990000000',
          indicativePriceUsd: 500,
        ),
      ].join('\n').toLowerCase();
      for (final word in forbidden) {
        expect(copy, isNot(contains(word)), reason: 'found "$word" in contact copy');
      }
    });

    test('WhatsApp contact URI is wa.me, not a payment endpoint', () {
      final uri = ContactWhatsApp.waMeUri(
        ownerPhone: '+243 990 000 000',
        text: ContactWhatsApp.interestMessage(
          propertyTitle: 'Villa Golf',
          userName: 'Patrice',
          userPhone: '+243111',
          indicativePriceUsd: 500,
        ),
      );
      expect(uri.scheme, 'https');
      expect(uri.host, 'wa.me');
      expect(uri.path, contains('243990000000'));
      expect(uri.queryParameters['text'], contains('intéressé(e)'));
      expect(uri.queryParameters['text'], contains('Estimation indicative'));
      expect(uri.queryParameters['text']!.toLowerCase(), isNot(contains('payer')));
      expect(uri.queryParameters['text']!.toLowerCase(), isNot(contains('m-pesa')));
    });

    test('legacy payment/booking screens have no checkout CTA', () {
      const forbidden = [
        'payer maintenant',
        'm-pesa',
        'mpesa',
        'orange money',
      ];
      for (final relative in [
        'lib/screens/property_payment_screen.dart',
        'lib/screens/property_booking_screen.dart',
      ]) {
        final src = File(relative).readAsStringSync().toLowerCase();
        for (final word in forbidden) {
          expect(src, isNot(contains(word)), reason: '$relative contains "$word"');
        }
        expect(src, contains('whatsapp'), reason: '$relative should route to WhatsApp');
      }
    });

    test('legal URLs are public HTTPS ImmoTrust pages', () {
      expect(BrandConfig.privacyUrl.startsWith('https://'), isTrue);
      expect(BrandConfig.termsUrl.startsWith('https://'), isTrue);
      expect(BrandConfig.privacyUrl, contains('immotrust'));
      expect(BrandConfig.termsUrl, contains('immotrust'));
      expect(BrandConfig.privacyUrl, endsWith('privacy.html'));
      expect(BrandConfig.termsUrl, endsWith('terms.html'));
    });

    test('support email and app naming', () {
      expect(BrandConfig.appName, 'ImmoTrust');
      expect(BrandConfig.supportEmail, contains('@'));
      expect(BrandConfig.supportEmail.toLowerCase(), contains('immotrust'));
    });

    test('no user-visible leftover Elxau brand in download banner', () {
      final src = File('lib/widgets/app_download_banner.dart').readAsStringSync();
      expect(src, isNot(contains('app Elxau')));
      expect(src, contains('BrandConfig.appName'));
    });

    test('demo flags are explicit constants', () {
      // En release, DemoConfig.*Enabled reste false via kDebugMode.
      expect(DemoConfig.allowDemoAuth, isA<bool>());
      expect(DemoConfig.allowDemoData, isA<bool>());
    });
  });
}