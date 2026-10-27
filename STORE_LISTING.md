# ImmoTrust — Fiche Google Play

Document **UTF-8** (accents français). Prêt à coller dans Play Console.

| Champ | Valeur |
|---|---|
| Nom de l’application | ImmoTrust |
| Identifiant | `app.immotrust.client` |
| Marché | Lubumbashi, République démocratique du Congo |
| Mode produit | Mise en relation uniquement — **aucun paiement dans l’application** |
| Assistance | `support@immotrust.app` |
| Confidentialité | https://immotrust.web.app/privacy.html |
| Conditions | https://immotrust.web.app/terms.html |

---

## Titre (30 caractères maximum)

```
ImmoTrust
```

9 caractères.

---

## Description courte (80 caractères maximum)

Coller **uniquement** la ligne ci-dessous (sans guillemets) :

```
Trouvez un bien à Lubumbashi et contactez l'annonceur. Sans paiement dans l'app.
```

**80 caractères** (limite Play : 80). Accents UTF-8 : `à`.

---

## Description longue (à coller dans Play Console)

Texte brut ci-dessous, jusqu’à la ligne « FIN DE LA DESCRIPTION ». Ne pas coller les titres Markdown de ce fichier.

```
ImmoTrust vous aide à trouver un bien immobilier à acheter ou à louer à Lubumbashi (RDC) et à entrer en contact avec l'annonceur, au même endroit.

Parcourez les annonces, consultez les photos et les informations utiles, filtrez par quartier ou par projet (acheter / louer), puis contactez directement la personne qui publie le bien. Les prix affichés sont indicatifs.

Fonctionnalités principales :
• Rechercher des biens immobiliers à acheter ou à louer à Lubumbashi.
• Filtrer par quartier, budget et caractéristiques.
• Consulter les photos, informations et caractéristiques des annonces.
• Envoyer une demande de contact et joindre l'annonceur (WhatsApp ou téléphone).
• Suivre vos demandes de mise en relation depuis l'application.
• Créer un compte pour gérer votre profil.

ImmoTrust est une plateforme de mise en relation. Elle ne vend pas de biens, ne fournit pas de service de paiement intégré et n'est pas partie aux accords conclus entre utilisateurs. Aucun paiement n'est collecté dans l'application : visite, négociation et transaction se font directement avec l'annonceur. Vérifiez toujours les informations et les documents avant toute visite, négociation ou transaction.

Assistance : support@immotrust.app
Confidentialité : https://immotrust.web.app/privacy.html
Conditions d'utilisation : https://immotrust.web.app/terms.html
```

FIN DE LA DESCRIPTION

---

## Sécurité des données (Play Console)

Déclarer **uniquement** les pratiques du build soumis. Rechecker avant chaque mise en production.

### À déclarer

| Catégorie Play Console | Collecte ? | Détail (ImmoTrust client) |
|---|---|---|
| Infos personnelles | Oui | Nom, adresse e-mail, numéro de téléphone (création de compte et mise en relation). |
| Activité dans l’application | Oui | Demandes de contact, annonces consultées / publiées si l’utilisateur en crée, interactions nécessaires au service. |
| Photos et vidéos | Oui, si l’utilisateur en envoie | Uniquement si la version soumise permet d’ajouter des images à une annonce (ou une photo de profil). Pas de scan automatique de la galerie. |
| Position | Non | Pas de GPS ni de localisation précise / approximative de l’appareil. Le quartier d’une annonce est un texte saisi, pas une position device. Manifest : `INTERNET` seulement. |
| Infos financières | Non | Aucune collecte. **Aucun paiement intégré** (pas de carte, pas de Mobile Money dans l’app). |
| Santé, messages SMS, fichiers audio, contacts du téléphone, calendrier, identifiants publicitaires | Non | Sauf si un SDK ajouté plus tard le justifie — ce n’est pas le cas du client actuel. |

### Partage et vente

- **Vente de données : non.** Ne pas cocher « vente de données ».
- **Partage :** les informations d’une annonce et les coordonnées que l’annonceur rend visibles sont consultables par les utilisateurs qui ouvrent l’annonce (mise en relation). Prestataires techniques : Google Firebase (authentification, base de données), strictement pour faire fonctionner le service.
- Ne pas déclarer de partage publicitaire / courtier en données.

### Sécurité (questionnaire Play)

- Données chiffrées en transit : **oui** (HTTPS / Firebase).
- Les utilisateurs peuvent demander la suppression du compte et des données : **oui** (action « Supprimer mon compte » dans l’app, ou e-mail `support@immotrust.app`).

---

## Captures d’écran

Voir `store_assets/README.md` : **6** captures téléphone **1080 × 1920**, plus l’image mise en avant **1024 × 500**.

1. Accueil (annonces Lubumbashi).
2. Recherche avec filtres (quartier, acheter / louer).
3. Résultats de recherche.
4. Détail d’une annonce (photos et caractéristiques).
5. Demande de contact (WhatsApp / téléphone).
6. Suivi des demandes de mise en relation.

Ne pas capturer d’écran de paiement : il n’y en a pas dans le produit.

---

## URLs légales (Play Console)

| Champ Play Console | URL |
|---|---|
| Politique de confidentialité | https://immotrust.web.app/privacy.html |
| Conditions d’utilisation (si demandé) | https://immotrust.web.app/terms.html |

Site Hosting actuel : https://immotrust.web.app  
E-mail d’assistance : `support@immotrust.app` 

Catégorie suggérée : **Maison et décoration** (House & Home) ou **Style de vie**. Fiche en **français**.
