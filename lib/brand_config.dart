import 'package:intl/intl.dart';

/// Configuration de marque — LushiStay
class BrandConfig {
  BrandConfig._();

  static const String appName = 'LushiStay';
  static const String appNameShort = 'LushiStay';
  static const String tagline = "Séjours d'exception à Lubumbashi";
  static const String subtitle =
      'Villas, appartements et chambres d\'hôtel premium dans la capitale du cuivre.';
  static const String entityWorkspaceName = 'LushiStay Hôte';
  static const String description =
      'Villas, appartements et chambres d\'hôtel premium à Lubumbashi.';
  static const String marketLabel = 'Lubumbashi · RDC';
  static const String demoSubtitle =
      'Mode démo : aucun mot de passe requis, paiements simulés.';

  static const String supportEmail = 'contact@lushistay.cd';
  static const String privacyUrl = 'https://lushistay.cd/privacy.html';
  static const String termsUrl = 'https://lushistay.cd/terms.html';

  static const String logoAsset = 'assets/images/immotrust.png';
  static const bool paymentsInAppEnabled = true;

  static const String contactOnlyShort =
      'Aucun paiement dans l\'app — contactez l\'hôte directement.';

  static const String contactOnlyLong =
      'LushiStay facilite vos séjours d\'exception à Lubumbashi. '
      'Les prix affichés sont indicatifs. Aucun paiement forcé '
      'dans l\'application : échangez directement avec l\'hôte '
      '(WhatsApp / téléphone) pour organiser votre venue en toute sérénité.';

  static const int usdToFcRate = 2850;

  static String formatUsdAndFc(num usd, {bool perNight = true}) {
    final fc = (usd * usdToFcRate).round();
    final fcFormatted = NumberFormat('#,###', 'fr_FR').format(fc).replaceAll('\u00A0', ' ');
    final suffix = perNight ? ' / nuit' : '';
    return '\$$usd$suffix • $fcFormatted FC';
  }

  static String formatFc(num usd) {
    final fc = (usd * usdToFcRate).round();
    return '${NumberFormat('#,###', 'fr_FR').format(fc).replaceAll('\u00A0', ' ')} FC';
  }
}

/// Builds a WhatsApp contact link
class ContactWhatsApp {
  ContactWhatsApp._();

  static String sanitizePhone(String ownerPhone) =>
      ownerPhone.replaceAll(RegExp(r'[^0-9+]'), '');

  static String interestMessage({
    required String propertyTitle,
    String? purposeLabel,
    String? userName,
    String? userPhone,
    int? indicativePriceUsd,
  }) {
    final buf = StringBuffer(
      'Bonjour, je suis intéressé(e) par',
    );
    if (purposeLabel != null && purposeLabel.isNotEmpty) {
      buf.write(' votre bien ($purposeLabel)');
    }
    buf.write(' : $propertyTitle.');
    if (userName != null && userName.isNotEmpty) {
      buf.write('\nNom : $userName');
    }
    if (userPhone != null && userPhone.isNotEmpty) {
      buf.write('\nTél : $userPhone');
    }
    if (indicativePriceUsd != null) {
      buf.write('\nTarif : \$$indicativePriceUsd / nuit');
    }
    return buf.toString();
  }

  static Uri waMeUri({
    required String ownerPhone,
    required String text,
  }) {
    final phone = sanitizePhone(ownerPhone);
    return Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(text)}',
    );
  }
}
