# ImmoTrust — Smoke checklist (avant closed testing / Play)

Coche chaque point sur un build **debug** puis, si possible, un **release** (`flutter build appbundle`).

## Build & identite
- [ ] `applicationId` = `app.immotrust.client` (Android)
- [ ] Bundle iOS = `app.immotrust.client` (si iOS)
- [ ] `key.properties` + `immotrust-upload.jks` presents pour `bundleRelease`
- [ ] Firebase : app Android enregistree avec ce package + SHA-1 upload

## Auth
- [ ] Client : inscription / login / logout OK (Firebase)
- [ ] Client : reset password envoie un email (ou message d erreur clair)
- [ ] Entite : login workspace refuse un compte non-entite en logique prod
- [ ] Profil : **Supprimer mon compte** fonctionne (ou demande reconnexion recente)
- [ ] Build **release** : pas de bypass demo si Firebase down

## Catalogue & contact
- [ ] Accueil charge des annonces (ou etat vide, **sans** faux catalogue en release)
- [ ] Recherche / filtres quartier + acheter/louer
- [ ] Fiche bien : bandeau « aucun paiement dans l app »
- [ ] Bouton WhatsApp ouvre une conversation pre-remplie
- [ ] Aucun ecran M-Pesa / carte / « Payer maintenant »

## Profil & legal
- [ ] Liens Confidentialite + CGU ouvrent https://immotrust.web.app/...
- [ ] Aide ouvre mailto support@immotrust.app
- [ ] Pas de menus « bientot » trompeurs

## Store
- [ ] Privacy URL colle dans Play Console
- [ ] Data safety aligne (compte, annonces, pas de paiement, pas de vente de donnees)
- [ ] Captures + description FR pretes

## Non-regression rapide
- [ ] Pas de crash au cold start (client + entite)
- [ ] Navigation bas de page (accueil / recherche / profil) stable