# LogTracker - Application Mobile de Gestion de Logs

Une application Flutter moderne pour la gestion des journaux d'applications avec une interface utilisateur élégante et une expérience utilisateur intuitive. Cette application permet aux utilisateurs de suivre, filtrer et analyser les logs d'applications sur appareils mobiles.

## Fonctionnalités

- **Écran de démarrage**: Logo animé et indicateur de chargement
- **Onboarding**: Introduction aux fonctionnalités de l'application avec animations fluides
- **Authentification**: Écran de connexion avec options email/mot de passe 
- **Tableau de bord**: Vue d'ensemble des statistiques de logs avec graphiques et journaux récents
- **Liste des logs**: Liste complète des journaux avec capacités de filtrage et de recherche
- **Détails des logs**: Vue détaillée des journaux individuels avec métadonnées et stacktrace
- **Profil utilisateur**: Gestion des informations personnelles et préférences utilisateur
- **Notifications push**: Alertes en temps réel pour les erreurs critiques via Firebase Messaging
- **Centre de notifications**: Gestion centralisée des notifications avec marquage comme lues
- **Design responsive**: Fonctionne sur différentes tailles d'écran

## Détails Techniques

- **Framework**: Flutter 3.x
- **Gestion d'état**: Bloc/Cubit avec flutter_bloc
- **Interface utilisateur**: Material Design 3 avec thème personnalisé
- **Animations**: Flutter Animate pour des transitions et effets fluides
- **Graphiques**: FL Chart pour la visualisation des données
- **Notifications**: Firebase Cloud Messaging avec flutter_local_notifications
- **Gestion des dates**: Intl pour le formatage et la localisation
- **Thème**: Support du mode sombre et clair avec thème dynamique

## Structure du Projet

```
lib/
├─ constants/       # Constantes et définitions de thème
├─ models/          # Modèles de données (Log, Notification, User)
├─ cubits/          # Gestion d'état avec Bloc/Cubit
│   ├─ log/          # Gestion des logs
│   ├─ notification/  # Gestion des notifications
│   └─ user/         # Gestion du profil utilisateur
├─ screens/         # Écrans de l'interface utilisateur
├─ widgets/         # Composants UI réutilisables
├─ services/        # Services (Firebase, notifications, etc.)
├─ utils/           # Fonctions utilitaires
└─ main.dart        # Point d'entrée de l'application
```

## Fonctionnalité de Profil Utilisateur

L'application dispose d'une page de profil utilisateur complète permettant aux utilisateurs de :

- Consulter et modifier leurs informations personnelles (nom, email)
- Gérer leurs préférences (mode sombre, notifications)
- Visualiser les informations de compte (ID utilisateur, date de création, dernière connexion)

La gestion d'état du profil utilisateur est assurée par un `UserCubit` dédié, qui maintient les informations utilisateur à travers l'application. L'interface utilisateur du profil est conçue avec des animations fluides et un design intuitif pour une expérience utilisateur optimale.

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
- Options de filtrage avancées et recherche plein texte
- Catégories de logs personnalisées et étiquettes
- Exportation des logs dans différents formats (CSV, JSON, PDF)
- Fonctionnalités de collaboration en équipe avec rôles et permissions
- Tableau de bord analytique avancé avec plus de visualisations
- Intégration avec des services d'alerte externes (Slack, Email, SMS)
- Authentification multi-facteurs et sécurité avancée
- Synchronisation hors ligne et mise en cache des données
- Tests unitaires et d'intégration complets
- Support multi-langue et localisation
