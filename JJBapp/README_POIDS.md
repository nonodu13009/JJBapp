# 🏋️ Fonctionnalité Poids - Profil Utilisateur

## Vue d'ensemble

Le profil utilisateur a été enrichi avec la gestion du poids, permettant aux utilisateurs de saisir et suivre leur poids en kilogrammes.

## Nouvelles fonctionnalités

### 1. Champ Poids dans le Modèle
- **Structure `Weight`** : Stocke la valeur et l'unité (kg par défaut)
- **Validation** : Poids accepté entre 20 et 200 kg
- **Formatage** : Affichage avec une décimale (ex: "75.5 kg")

### 2. Composant WeightInput
- **Interface utilisateur** : Champ de saisie avec icône balance
- **Validation en temps réel** : Feedback visuel sur la validité
- **Clavier numérique** : Optimisé pour la saisie de poids
- **Gestion des erreurs** : Messages d'aide contextuels

### 3. Intégration dans l'Interface
- **EditProfileView** : Ajout du champ poids dans le formulaire d'édition
- **ProfileView** : Affichage du poids dans la section d'informations
- **Persistance** : Sauvegarde automatique dans Firebase

## Structure des données

### Modèle Weight
```swift
struct Weight: Codable, Equatable {
    var value: Double        // Valeur en kg
    var unit: WeightUnit     // Unité (kg par défaut)
    
    var isValid: Bool        // Validation 20-200 kg
    var displayText: String  // Format "75.5 kg"
    var displayTextShort: String // Format "76 kg"
}
```

### Énumération WeightUnit
```swift
enum WeightUnit: String, CaseIterable, Codable {
    case kg = "kg"      // Kilogrammes
    case lbs = "lbs"    // Livres (pour future extension)
}
```

## Persistance Firebase

### Structure Firestore
- **Collection** : `users/{uid}/profile/main`
- **Champ** : `weight` (optionnel)
- **Règles** : Même sécurité que les autres champs du profil

### Migration
- Les profils existants n'ont pas de champ poids
- Le champ est ajouté automatiquement lors de la première modification
- Compatible avec les anciennes versions de l'app

## Validation et Sécurité

### Côté Client
- **Limites** : 20-200 kg
- **Format** : Nombre décimal avec une décimale
- **Feedback** : Validation en temps réel avec indicateurs visuels

### Côté Serveur
- **Règles Firestore** : Validation des types et formats
- **Sécurité** : Seul l'utilisateur propriétaire peut modifier son poids

## Utilisation

### Saisie du Poids
1. Aller dans "Modifier mon profil"
2. Saisir le poids dans le champ dédié
3. Le poids est validé automatiquement
4. Sauvegarder pour persister les données

### Affichage
- Le poids apparaît dans la vue profil
- Format : "75.5 kg"
- Icône : Balance (scalemass)

## Extensions futures

### Unités multiples
- Support des livres (lbs)
- Conversion automatique kg ↔ lbs
- Préférence utilisateur pour l'unité d'affichage

### Historique
- Suivi des variations de poids
- Graphiques d'évolution
- Objectifs de poids

### Intégration avec l'entraînement
- Calcul de catégorie de poids pour les compétitions
- Recommandations d'entraînement basées sur le poids
- Statistiques de performance pondérées

## Tests

### Scénarios de test
- [ ] Saisie d'un poids valide (ex: 75.5)
- [ ] Saisie d'un poids hors limites (ex: 15 ou 250)
- [ ] Saisie de caractères non numériques
- [ ] Sauvegarde et rechargement du profil
- [ ] Validation de la persistance Firebase
- [ ] Gestion des profils existants sans poids

### Validation
- [ ] Compilation sans erreurs
- [ ] Interface utilisateur cohérente avec le design Gracie Barra
- [ ] Mode sombre/clair supporté
- [ ] Accessibilité (VoiceOver, Dynamic Type)
- [ ] Performance (pas de lag lors de la saisie)

## Notes techniques

### Performance
- Validation en temps réel sans impact sur les performances
- Sauvegarde Firebase optimisée avec merge
- Pas de rechargement inutile des données

### Compatibilité
- iOS 17+ requis
- SwiftUI uniquement
- Architecture MVVM respectée
- Intégration transparente avec l'existant

### Maintenance
- Code modulaire et réutilisable
- Documentation complète
- Tests unitaires recommandés
- Migration automatique des données
