# ImmoTrust

Application immobiliere pour Lubumbashi, en RDC, avec une application client et un espace de gestion pour les proprietaires et administrateurs.

## Architecture

| Surface | Entree | Usage |
|---|---|---|
| Client | `lib/main.dart` | Chercher, louer ou acheter un bien |
| ImmoTrust Entite | `lib/main_admin.dart` | Gestion des annonces et espace proprietaire / administrateur |

Le nom de marque se change dans un seul fichier : `lib/brand_config.dart`.

## Application de bureau Windows

L'espace Entite est distribue sous forme d'un installateur Windows Inno Setup.

1. Sur le PC de developpement, installer Flutter, Visual Studio avec la charge **Desktop development with C++**, et **Inno Setup 6**.
2. Lancer `Build_ImmoTrust_Entite_Windows.bat`. Le script compile l'application puis genere `build/windows/installer/ImmoTrust-Entite-Setup-<version>.exe`.
3. Copier ce fichier d'installation sur le PC du bureau et l'ouvrir. L'assistant installe l'application dans Program Files, ajoute un raccourci au menu Demarrer et propose un raccourci sur le Bureau.
4. Pour desinstaller l'application, utiliser **Applications installees** dans les parametres Windows. Pour lancer le build directement depuis le depot de developpement, utiliser `Lancer_ImmoTrust_Entite_Windows.bat`.

Le PC cible n'a pas besoin de Flutter ni d'Inno Setup. Une connexion Internet est requise pour Firebase. Le build et l'installateur doivent etre generes sur Windows avec les outils C++ installes.

## Acces web de secours

`Build_ImmoTrust_Entite_Web.bat` construit l'espace Entite pour le navigateur dans `build/web`. Ce site est distinct du site client existant.

Avant une premiere publication, un administrateur Firebase doit creer le site Hosting `immotrust-entity` dans le projet `b-ebooking`, puis lier la cible locale :

```bash
firebase hosting:sites:create immotrust-entity --project b-ebooking
firebase target:apply hosting entity immotrust-entity --project b-ebooking
firebase deploy --only hosting:entity --project b-ebooking
```

Les commandes de creation et de publication modifient le projet Firebase et doivent etre executees par une personne autorisee. Apres publication, activer les domaines de connexion necessaires dans Firebase Authentication et ne communiquer l'URL qu'aux comptes Entite autorises. Les comptes doivent etre crees individuellement avec le role `isEntity` attribue de maniere controlee.

## Lancement pour developpement

- Client : `Lancer_ImmoTrust_Client.bat`
- Entite dans Chrome : `Lancer_ImmoTrust_Entite.bat`

Ou en ligne de commande :

```bash
flutter run -d chrome -t lib/main.dart
flutter run -d chrome -t lib/main_admin.dart
flutter run -d windows -t lib/main_admin.dart
```
