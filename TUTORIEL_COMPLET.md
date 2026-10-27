# 🌟 Tutoriel Complet : Gérer votre projet Elxau

Bienvenue dans ce guide simplifié et détaillé pour maîtriser votre application **Elxau**. Ce tutoriel vous expliquera comment lancer l'application, comprendre sa structure et continuer son développement.

---

## 🚀 1. Lancer l'Application

Vous disposez de deux manières simples de tester votre application sans avoir à taper de commandes complexes.

### A. Tester sur votre Ordinateur (Mode Chrome)
C'est la méthode la plus rapide pour voir les changements visuels.
1. Double-cliquez sur le fichier `Lancer_B&E.bat`.
2. Une fenêtre noire s'ouvre, attendez que Google Chrome se lance.
3. **Astuce Premium :** Pour voir l'application comme sur un téléphone :
   - Appuyez sur **F12** dans Chrome.
   - Cliquez sur l'icône "Téléphone/Tablette" (en haut à gauche de la console) ou faites **Ctrl + Shift + M**.

### B. Tester sur votre Téléphone Réel
Idéal pour tester l'expérience tactile.
1. Connectez votre téléphone au **même Wi-Fi** que votre ordinateur.
2. Double-cliquez sur `Lancer_Sur_Telephone.bat`.
3. Une adresse IP s'affichera (ex: `http://192.168.1.15:8080`).
4. Tapez cette adresse dans le navigateur de votre téléphone.

---

## 📂 2. Comprendre la Structure du Projet

Le code source se trouve dans le dossier `lib/`. Voici à quoi servent les dossiers principaux :

| Dossier | Utilité |
| :--- | :--- |
| `lib/screens/` | Contient les **pages** complètes (Accueil, Recherche, Profil). |
| `lib/widgets/` | Contient les **composants** réutilisables (Boutons, Cartes d'hôtels, Barre de navigation). |
| `lib/models/` | Définit la structure des données (ce qu'est un "Hôtel", une "Chambre"). |
| `lib/services/` | Gère la logique complexe (Connexion Firebase, Base de données). |
| `assets/` | Contient vos images et icônes. |

---

## 🛠️ 3. Guide de Développement Rapide

### Comment changer un texte ?
La plupart des textes se trouvent dans les fichiers du dossier `lib/screens/`.
- Ouvrez le fichier avec un éditeur (comme VS Code).
- Utilisez **Ctrl + F** pour chercher le texte actuel.
- Modifiez-le et enregistrez. Si l'application tourne, elle se mettra à jour presque instantanément !

### Comment ajouter une image ?
1. Placez votre image dans `assets/images/`.
2. Dans le code, utilisez : `Image.asset('assets/images/mon_image.png')`.

---

## 🔥 4. État actuel de Firebase (Base de données)

L'application est configurée pour utiliser **Firebase** (Authentification et Base de données en temps réel).

> [!IMPORTANT]
> **Statut actuel :** Le code est prêt, mais la connexion finale vers votre projet Firebase spécifique doit être activée.
> Pour finaliser cela, il faudra exécuter la commande `flutterfire configure` une fois que vous aurez créé votre projet sur la console Google Firebase.

---

## ❓ FAQ (Questions Fréquentes)

**Q : L'application est lente au premier lancement ?**
R : C'est normal, Flutter compile tout le projet. Les lancements suivants seront beaucoup plus rapides.

**Q : Comment voir les erreurs ?**
R : Regardez la fenêtre noire (le terminal) qui s'est ouverte quand vous avez lancé le projet.

---

> [!TIP]
> Gardez ce guide ouvert pendant que vous travaillez. Si vous avez besoin de modifier une fonctionnalité spécifique (ex: le système de paiement), n'hésitez pas à me demander !
