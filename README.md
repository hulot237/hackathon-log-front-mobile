# LogTracker - Application Mobile de Gestion de Logs

Une application Flutter moderne pour la gestion des journaux d'applications avec une interface utilisateur élégante et une expérience utilisateur intuitive. Cette application permet aux utilisateurs de suivre, filtrer et analyser les logs d'applications sur appareils mobiles.

## Fonctionnalités

- **Écran de démarrage**: Logo animé et indicateur de chargement
- **Onboarding**: Introduction aux fonctionnalités de l'application avec animations fluides
- **Authentification**: Écran de connexion avec options email/mot de passe et connexion Google
- **Tableau de bord**: Vue d'ensemble des statistiques de logs avec graphiques et journaux récents
- **Liste des logs**: Liste complète des journaux avec capacités de filtrage et de recherche
- **Détails des logs**: Vue détaillée des journaux individuels avec métadonnées et stacktrace
- **Notifications push**: Alertes en temps réel pour les erreurs critiques via Firebase Messaging
- **Support du mode sombre**: Prise en charge complète des thèmes clair et sombre
- **Design responsive**: Fonctionne sur différentes tailles d'écran

## Détails Techniques

- **Framework**: Flutter 3.x
- **Gestion d'état**: Bloc/Cubit
- **Interface utilisateur**: Material Design 3
- **Animations**: Flutter Animate pour des transitions fluides
- **Graphiques**: FL Chart pour la visualisation des données
- **Notifications**: Firebase Cloud Messaging avec flutter_local_notifications

## Structure du Projet

```
lib/
├── constants/       # Constantes et définitions de thème
├── models/          # Modèles de données
├── cubits/          # Gestion d'état avec Bloc/Cubit
├── screens/         # Écrans de l'interface utilisateur
├── widgets/         # Composants UI réutilisables
├── services/        # Services (Firebase, notifications, etc.)
├── utils/           # Fonctions utilitaires
└── main.dart        # Point d'entrée de l'application
```

## Configuration des Notifications Push

L'application est configurée pour afficher les notifications push dans tous les scénarios :
- Lorsque l'application est au premier plan
- Lorsque l'application est en arrière-plan
- Lorsque l'application est fermée

Le package `flutter_local_notifications` est utilisé en conjonction avec Firebase Messaging pour gérer l'affichage des notifications locales et assurer une expérience utilisateur cohérente.

## Mise en Route

1. Assurez-vous d'avoir Flutter installé sur votre machine
2. Clonez ce dépôt
3. Exécutez `flutter pub get` pour installer les dépendances
4. Configurez votre projet Firebase:
   - Créez un projet dans la console Firebase
   - Ajoutez les fichiers de configuration (google-services.json pour Android, GoogleService-Info.plist pour iOS)
5. Exécutez `flutter run` pour démarrer l'application

## Données de Démonstration

L'application utilise des données simulées à des fins de démonstration. Dans un scénario réel, celles-ci seraient remplacées par des appels API à un service backend.

## Améliorations Futures

- Intégration backend avec streaming de logs en temps réel
- Options de filtrage avancées
- Catégories de logs personnalisées
- Exportation des logs dans différents formats
- Gestion des utilisateurs et fonctionnalités de collaboration en équipe
- Tableau de bord analytique avancé avec plus de visualisations
