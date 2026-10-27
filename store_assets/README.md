# Assets Google Play — ImmoTrust

Préparer les fichiers **dans ce dossier** avant la publication. Tailles **exactes** (pas d’à-peu-près). Pas d’invention de logo : réutiliser le visuel de marque déjà dans l’app.

Application ciblée : client téléphone ImmoTrust (`app.immotrust.client`), **mise en relation uniquement** — aucun écran de paiement.

---

## Captures téléphone — 1080 × 1920

| Règle | Valeur |
|---|---|
| Taille | **1080 × 1920 pixels** (portrait, ratio 9:16) |
| Format | PNG 24 bits **sans transparence**, ou JPEG |
| Nombre | **6** (Play impose 2 min. / 8 max.) |
| Convention de nom | `{nn}-{slug}-1080x1920.png` |

### Les 6 écrans à capturer

| Fichier | Écran (app **client** sur téléphone) | Ce qui doit se voir |
|---|---|---|
| `01-accueil-1080x1920.png` | Accueil | Annonces Lubumbashi, recherche, slogan / marché |
| `02-recherche-1080x1920.png` | Recherche | Filtres quartier, acheter / louer, caractéristiques |
| `03-resultats-1080x1920.png` | Liste de résultats | Cartes de biens après une recherche |
| `04-detail-annonce-1080x1920.png` | Fiche d’un bien | Photos, infos, caractéristiques ; bandeau « aucun paiement dans l’app » si visible |
| `05-demande-contact-1080x1920.png` | Demande de contact | Formulaire et/ou bouton WhatsApp ou téléphone |
| `06-demandes-1080x1920.png` | Mes demandes | Suivi des mises en relation (onglet Demandes) |

Capturer le **client téléphone**, pas l’espace Entité (ordinateur). Ne pas inventer un écran « Favoris » s’il n’existe pas dans le build.

### Comment exporter

1. Téléphone physique, ou émulateur en **plein écran** (masquer la barre d’outils AVD).
2. Sortie **exactement** 1080 × 1920 (recadrer ou redimensionner **en conservant 9:16** ; ne pas étirer).
3. Build sans bannière Demo / DEBUG.
4. Données **anonymes** (prénoms fictifs, numéros partiellement masqués).

### Ne pas montrer

- Chrome de l’émulateur (Extended controls, cadre AVD, filigrane « Android Emulator »)
- Notifications personnelles, e-mails, SMS, photos de la galerie réelle
- Vrais noms, téléphones, e-mails ou adresses d’utilisateurs
- Paiement, M-Pesa, carte bancaire, bouton « Payer maintenant »
- Dialogues système (crash, permission) ou clavier qui cache le contenu utile
- Cadre marketing de téléphone (mockup) autour de l’UI — Play veut l’écran réel
- Marques tierces ajoutées (hors icône WhatsApp déjà présente dans l’app)
- Texte illisible, flou, ou toute taille autre que 1080 × 1920

---

## Image mise en avant — 1024 × 500

| Règle | Valeur |
|---|---|
| Taille | **1024 × 500 pixels** |
| Format | PNG 24 bits **sans alpha**, ou JPEG |
| Nom de fichier | `feature-graphic-1024x500.png` |

Contenu : **ImmoTrust** + **Lubumbashi · RDC** + **Acheter · Louer · Confiance**. Marge intérieure ≥ 48 px. Pas de petit texte, pas de cadre d’appareil, pas de visuel de paiement.

Couleurs existantes : fond `#FAF9F6`, or `#DAA520`, texte `#121212`. Ne pas créer un nouveau logo.

---

## Icône haute résolution — 512 × 512

| Règle | Valeur |
|---|---|
| Taille | **512 × 512 pixels** |
| Format | PNG 32 bits |
| Nom de fichier | `icon-512x512.png` |

Source uniquement : logo déjà utilisé (`assets/images/immotrust.png` ou icône launcher). Redimensionner ce fichier ; **ne pas** dessiner une nouvelle marque.

---

## Contrôle avant envoi Play Console

- [ ] `01` … `06` en **1080 × 1920**, noms ci-dessus
- [ ] `feature-graphic-1024x500.png` en **1024 × 500**
- [ ] `icon-512x512.png` en **512 × 512** (logo existant)
- [ ] Aucune donnée personnelle réelle
- [ ] Aucun chrome d’émulateur
- [ ] Les captures correspondent au build soumis (contact, pas paiement)
