# Guide d'installation de Flutter sur Windows

Pour exécuter votre application **Elxau**, vous devez installer Flutter. Voici les étapes simplifiées :

## 1. Télécharger le SDK Flutter
- Allez sur [la page officielle de Flutter](https://docs.flutter.dev/get-started/install/windows/desktop?tab=download).
- Cliquez sur le bouton bleu pour télécharger le fichier **.zip** du SDK.
- Une fois téléchargé, extrayez le contenu dans un dossier comme `C:\flutter`.
  > [!IMPORTANT]
  > Ne l'installez pas dans `C:\Program Files` car cela nécessite des privilèges élevés.

## 2. Configurer le PATH (Environnement)
- Tapez "Environnement" dans votre barre de recherche Windows et sélectionnez **Modifier les variables d'environnement système**.
- Cliquez sur **Variables d'environnement**.
- Sous **Variables utilisateur**, trouvez la variable `Path`, sélectionnez-la et cliquez sur **Modifier**.
- Cliquez sur **Nouveau** et ajoutez le chemin : `C:\flutter\bin`.
- Cliquez sur OK partout.

## 3. Installer Git
- Téléchargez et installez Git depuis [git-scm.com](https://git-scm.com/download/win). C'est nécessaire pour que Flutter fonctionne correctement.

## 4. Vérifier l'installation
- Ouvrez un nouveau terminal et tapez :
  ```powershell
  flutter doctor
  ```
- Suivez les instructions pour installer ce qui manque (souvent Android Studio pour le SDK Android).

## 5. Lancer l'application Elxau
- Une fois `flutter doctor` validé, allez dans le dossier de votre app :
  ```powershell
  cd "C:\Users\RD CONGO\Desktop\elxau"
  flutter pub get
  flutter run
  ```

---
> [!TIP]
> Si vous préférez que j'essaie de télécharger le SDK pour vous directement, dites-le moi, mais le processus peut être lent selon votre connexion.
