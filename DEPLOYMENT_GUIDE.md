# 🚀 Guide de Déploiement - Applytics Flutter

## Option 1 : Test Local (Recommandé pour débuter) ✅

### Étape 1 : Vérifier que tout compile

Ouvrez un terminal et exécutez :

```bash
cd /Users/sowakillian/Desktop/work/les_ignobles/customer_products/applytics_flutter

# Analyser le code
flutter analyze

# Lancer les tests
flutter test

# Vérifier le format
dart format lib/ test/ --set-exit-if-changed
```

### Étape 2 : Tester avec l'application exemple

```bash
# Aller dans le dossier example
cd example

# Installer les dépendances
flutter pub get

# Lancer l'application (iOS)
flutter run -d ios

# Ou Android
flutter run -d android

# Ou Web
flutter run -d chrome
```

### Étape 3 : Utiliser dans un autre projet Flutter local

Dans un autre projet Flutter, ajoutez dans `pubspec.yaml` :

```yaml
dependencies:
  applytics_flutter:
    path: /Users/sowakillian/Desktop/work/les_ignobles/customer_products/applytics_flutter
```

Puis :
```bash
flutter pub get
```

---

## Option 2 : Publication sur pub.dev 🌍

### Prérequis

1. **Compte Google** pour vous connecter à pub.dev
2. **Vérifier que le package est prêt** :

```bash
cd /Users/sowakillian/Desktop/work/les_ignobles/customer_products/applytics_flutter

# Vérifier le package
dart pub publish --dry-run
```

### Étapes de publication

1. **Mettre à jour le pubspec.yaml**

Assurez-vous que ces champs sont corrects :
```yaml
name: applytics_flutter
description: "A powerful analytics package for Flutter apps inspired by PostHog..."
version: 0.0.1  # Suivre semver (semantic versioning)
homepage: https://github.com/VOTRE_USERNAME/applytics_flutter
repository: https://github.com/VOTRE_USERNAME/applytics_flutter
```

2. **Créer un fichier CHANGELOG.md** (déjà présent)

Assurez-vous qu'il contient :
```markdown
## 0.0.1
* Initial release
* Event tracking with batching
* Session management
* User identification
```

3. **Publier**

```bash
# Test de publication (ne publie pas vraiment)
dart pub publish --dry-run

# Publication réelle
dart pub publish
```

Vous devrez :
- Vous connecter avec votre compte Google
- Accepter les termes de pub.dev
- Confirmer la publication

### Après publication

Le package sera disponible sur https://pub.dev/packages/applytics_flutter

Les autres pourront l'utiliser avec :
```yaml
dependencies:
  applytics_flutter: ^0.0.1
```

---

## Option 3 : Publication sur Git (GitHub/GitLab) 📦

Alternative à pub.dev, vous pouvez utiliser directement depuis Git :

### 1. Créer un repository GitHub

```bash
cd /Users/sowakillian/Desktop/work/les_ignobles/customer_products/applytics_flutter

git init
git add .
git commit -m "Initial commit - Applytics Flutter package"
git branch -M main
git remote add origin https://github.com/VOTRE_USERNAME/applytics_flutter.git
git push -u origin main
```

### 2. Utilisation dans d'autres projets

```yaml
dependencies:
  applytics_flutter:
    git:
      url: https://github.com/VOTRE_USERNAME/applytics_flutter.git
      ref: main  # ou un tag spécifique comme v0.0.1
```

---

## 🧪 Checklist avant publication

- [ ] Tous les tests passent (`flutter test`)
- [ ] Aucune erreur d'analyse (`flutter analyze`)
- [ ] Code formaté correctement (`dart format lib/ test/`)
- [ ] README.md complet avec exemples
- [ ] CHANGELOG.md à jour
- [ ] LICENSE présent (MIT déjà inclus)
- [ ] Exemples fonctionnels dans `/example`
- [ ] Version correcte dans pubspec.yaml
- [ ] Documentation des API (dartdoc)

---

## 📝 Commandes utiles

```bash
# Générer la documentation
dart doc .

# Vérifier les dépendances
flutter pub outdated

# Mettre à jour les dépendances
flutter pub upgrade

# Vérifier le score du package
dart pub publish --dry-run
```

---

## 🎯 Recommandation pour vous

**Je vous recommande de commencer par :**

1. ✅ Tester localement avec l'app exemple
2. ✅ Créer un petit backend de test pour recevoir les événements
3. ✅ Tester l'intégration complète
4. ✅ Mettre sur GitHub
5. ✅ Publier sur pub.dev quand tout est stable

Cela vous permettra d'itérer rapidement sans vous soucier des versions publiques.

---

## 🔥 Prochaine étape : Créer le Backend

Voulez-vous que je vous aide à créer :
1. Un backend simple (Node.js/Express ou Python/FastAPI) pour recevoir les événements ?
2. Une base de données pour stocker les événements ?
3. Un dashboard web pour visualiser les analytics ?

