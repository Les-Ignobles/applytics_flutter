<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Applytics Flutter

Un package Flutter puissant pour l'analyse d'événements, inspiré de PostHog. Envoyez des événements analytiques à votre propre backend avec support du batching, gestion de sessions, et plus encore.

## 🚀 Fonctionnalités

- ✅ Suivi d'événements simple et intuitif
- ✅ Batching automatique des événements
- ✅ Gestion automatique des sessions
- ✅ Identification des utilisateurs
- ✅ File d'attente avec envoi périodique
- ✅ Support du mode debug
- ✅ Gestion des erreurs réseau avec retry
- ✅ Tests de connexion API
- ✅ Architecture singleton pour un accès facile

## 📦 Installation

Ajoutez cette dépendance à votre `pubspec.yaml` :

```yaml
dependencies:
  applytics_flutter: ^0.0.1
```

Puis exécutez :

```bash
flutter pub get
```

## 🎯 Usage de base

### 1. Initialisation

Initialisez Applytics au démarrage de votre application :

```dart
import 'package:applytics_flutter/applytics_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ApplyticsClient.initialize(
    config: AnalyticsConfig(
      apiUrl: 'https://your-api-url.com/api',
      apiKey: 'your-api-key',
      debug: true, // Active les logs de debug
      batchSize: 10, // Envoie les événements par lots de 10
      flushIntervalSeconds: 30, // Ou toutes les 30 secondes
    ),
  );

  runApp(MyApp());
}
```

### 2. Suivre des événements

```dart
final analytics = ApplyticsClient.instance;

// Événement simple
analytics.track('button_clicked');

// Événement avec propriétés
analytics.track('product_viewed', properties: {
  'product_id': '123',
  'product_name': 'iPhone 15',
  'category': 'electronics',
  'price': 999.99,
});
```

### 3. Identifier un utilisateur

```dart
analytics.identify('user_123', userProperties: {
  'name': 'John Doe',
  'email': 'john@example.com',
  'plan': 'premium',
});
```

### 4. Reset (déconnexion)

```dart
analytics.reset(); // Réinitialise l'utilisateur et la session
```

## 🔧 Configuration avancée

### Options de configuration

```dart
AnalyticsConfig(
  apiUrl: 'https://your-api-url.com/api', // Required
  apiKey: 'your-api-key', // Required
  
  debug: false, // Active les logs de debug
  batchSize: 10, // Nombre d'événements avant envoi automatique
  flushIntervalSeconds: 30, // Intervalle d'envoi en secondes
  timeoutSeconds: 10, // Timeout des requêtes HTTP
  enableSessionTracking: true, // Active le suivi de session
)
```

### Fonctionnalités supplémentaires

```dart
// Forcer l'envoi immédiat de tous les événements en attente
await analytics.flush();

// Obtenir la taille de la file d'attente
int queueSize = analytics.queueSize;

// Obtenir l'ID de session actuel
String? sessionId = analytics.sessionId;

// Obtenir l'ID utilisateur actuel
String? userId = analytics.userId;

// Tester la connexion à l'API
bool isConnected = await analytics.testConnection();
```

## 📡 Format des données envoyées

Les événements sont envoyés au format JSON suivant :

```json
{
  "events": [
    {
      "name": "button_clicked",
      "properties": {
        "button_name": "submit"
      },
      "timestamp": "2025-12-01T10:30:00.000Z",
      "user_id": "user_123",
      "session_id": "1701425400000-1701425400000000"
    }
  ]
}
```

### Endpoints API attendus

Votre backend devrait exposer ces endpoints :

- `POST /events` - Recevoir les événements (avec header `Authorization: Bearer {apiKey}`)
- `GET /health` - Vérifier la santé de l'API (optionnel)

## 🧪 Exemple complet

Consultez le dossier `example/` pour une application complète démontrant toutes les fonctionnalités.

## 📝 Bonnes pratiques

1. **Initialisez une seule fois** au démarrage de l'application
2. **Utilisez des noms d'événements cohérents** (snake_case recommandé)
3. **Ajoutez des propriétés pertinentes** pour faciliter l'analyse
4. **Appelez `flush()`** avant de fermer l'application pour éviter de perdre des événements
5. **Activez le mode debug** pendant le développement

## 🔮 Prochaines étapes

Pour créer la plateforme web d'analyse :
- Backend API pour recevoir et stocker les événements
- Base de données pour le stockage (PostgreSQL, MongoDB, etc.)
- Dashboard web avec graphiques et statistiques
- Filtres et segmentation des données

## 📄 License

MIT License

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une issue ou une pull request.
# applytics_flutter
