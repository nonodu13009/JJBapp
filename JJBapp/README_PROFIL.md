# Module Profil - JJBapp

## Structure des fichiers

### Models
- **`UserProfile.swift`** - Modèle de données du profil utilisateur
  - Champs obligatoires : `id` (UID Firebase), `email`
  - Champs optionnels : `pseudo`, `firstName`, `lastName`, `gender`, `birthDate`
  - Timestamps automatiques : `createdAt`, `updatedAt`

### Managers
- **`ProfileManager.swift`** - Gestionnaire Firebase pour le profil
  - Chargement/sauvegarde automatique
  - Écoute en temps réel des changements
  - Gestion des erreurs et états de chargement

### UI Components
- **`GenderSelector.swift`** - Sélecteur de genre avec icônes
  - 3 options : Homme, Femme, À définir
  - Design moderne avec animations
  - Couleurs adaptatives selon le thème

- **`BirthDateInput.swift`** - Saisie de date de naissance
  - 3 champs séparés : Jour, Mois, Année
  - Validation automatique et calcul d'âge
  - Feedback visuel (succès/erreur)

### UI Screens
- **`ProfileView.swift`** - Vue principale du profil
  - Affichage des informations existantes
  - Bouton d'édition
  - Header avec thème et déconnexion

- **`EditProfileView.swift`** - Vue d'édition du profil
  - Formulaire complet avec validation
  - Gestion des majuscules automatique
  - Sauvegarde Firebase en temps réel

## Fonctionnalités

### Gestion des majuscules
- **Pseudo** : Aucune transformation
- **Prénom/Nom** : Capitalisation automatique
  - Exemple : "jean-michel" → "Jean-Michel"
  - Gestion des prénoms composés avec tirets

### Sélecteur de genre
- Design moderne avec icônes SF Symbols
- 3 états visuels distincts
- Couleurs cohérentes avec le thème Gracie Barra

### Date de naissance
- 3 champs numériques séparés
- Validation automatique (jour 1-31, mois 1-12, année 1900-2024)
- Calcul automatique de l'âge
- Feedback visuel en temps réel

### Persistance Firebase
- Structure : `users/{uid}/profile/main`
- Sauvegarde automatique des timestamps
- Écoute en temps réel des changements
- Règles de sécurité propriétaire-uniquement

## Utilisation

### Dans le DashboardView
```swift
// Onglet Profil
ProfileView(onSignOut: onSignOut)
    .tabItem {
        Image(systemName: "person.circle.fill")
        Text("Profil")
    }
```

### Gestion du profil
```swift
@StateObject private var profileManager = ProfileManager()

// Charger le profil
await profileManager.loadProfile(for: userId)

// Sauvegarder des modifications
try await profileManager.saveProfile(updatedProfile)
```

## Sécurité

### Règles Firestore
- Accès restreint au propriétaire uniquement
- Authentification requise
- Structure sécurisée par UID utilisateur

### Validation
- Côté client : types, formats, longueurs
- Côté serveur : règles Firestore
- Pas de données sensibles stockées

## Extensibilité

### Champs futurs
- Grade (ceinture)
- Objectifs d'entraînement
- Statistiques globales
- Paramètres de l'application
- Avatar/photo de profil

### Structure modulaire
- Composants réutilisables
- Gestionnaire séparé
- Modèle extensible
- UI adaptative

## Notes techniques

- Compatible iOS 17+
- SwiftUI uniquement
- Architecture MVVM
- Thème adaptatif (clair/sombre)
- Mode offline Firestore activé
- Gestion des erreurs robuste
