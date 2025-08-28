# 🏆 Classification IBJJF - Profil Utilisateur

## Vue d'ensemble

Le profil utilisateur a été enrichi avec un système de classification automatique IBJJF (International Brazilian Jiu-Jitsu Federation) qui affiche automatiquement les catégories d'âge et de poids du compétiteur.

## 🎯 Fonctionnalités ajoutées

### 1. Classification automatique
- **Calcul automatique** : La classification est calculée automatiquement à partir de l'âge et du poids
- **Mise à jour en temps réel** : La classification se met à jour automatiquement lors des modifications du profil
- **Validation des données** : Vérification que l'âge et le poids sont valides avant affichage

### 2. Catégories d'âge IBJJF
- **Enfants** : Mighty-Mite (4-6 ans), Pee-Wee (7-9 ans), Junior (10-12 ans), Teen (13-15 ans)
- **Adultes** : Juvenile 1 (16 ans), Juvenile 2 (17 ans), Adult (18-29 ans)
- **Masters** : Master 1 (30-35 ans) jusqu'à Master 7 (61-65 ans)

### 3. Catégories de poids IBJJF
- **Gi (Kimono)** : Rooster (57.5kg), Light Feather (64kg), Feather (70kg), Light (76kg), Middle (82.3kg), etc.
- **No Gi** : Catégories similaires mais sans kimono
- **Poids absolu** : Catégorie ouverte pour tous les poids

### 4. Type de compétition
- **Sélecteur Gi/No Gi** : L'utilisateur peut choisir son type de compétition préféré
- **Classification adaptée** : La classification s'adapte au type de compétition sélectionné
- **Persistance Firebase** : Le choix est sauvegardé dans le profil utilisateur

## 🔧 Implémentation technique

### Modèles créés
- **`IBJJFCategoryManager`** : Gestionnaire central des catégories IBJJF
- **`IBJJFClassification`** : Structure contenant la classification complète
- **`AgeCategory`** : Catégorie d'âge avec nom et plage
- **`WeightCategory`** : Catégorie de poids avec limites et couleurs
- **`CompetitionType`** : Énumération Gi/No Gi

### Composants UI
- **`IBJJFClassificationTag`** : Affichage élégant de la classification avec tags colorés
- **`CompetitionTypeSelector`** : Sélecteur de type de compétition
- **Intégration dans `ProfileView`** : Affichage automatique de la classification

### Logique de classification
```swift
// Exemple d'utilisation
let classification = IBJJFCategoryManager.shared.getIBJJFClassification(
    age: 25,
    weight: 75.0,
    isGi: true
)
```

## 📱 Interface utilisateur

### Affichage de la classification
- **Titre avec icône trophée** : "Classification IBJJF"
- **Tags colorés** : Catégorie d'âge et de poids avec couleurs distinctives
- **Informations détaillées** : Noms en français, anglais et portugais
- **Design cohérent** : Respect du thème Gracie Barra de l'application

### Sélecteur de compétition
- **Boutons radio** : Choix entre Gi et No Gi
- **Icônes explicites** : Représentation visuelle du type de compétition
- **Validation** : Vérification que le type est sélectionné

## 🗄️ Persistance des données

### Firebase Firestore
- **Champ `competitionType`** : Ajouté au modèle `UserProfile`
- **Synchronisation** : Mise à jour automatique lors des modifications
- **Règles de sécurité** : L'utilisateur peut modifier son type de compétition

### Structure des données
```swift
struct UserProfile {
    // ... autres champs
    var competitionType: CompetitionType?
    var weight: Weight?
    var birthDate: BirthDate?
}
```

## 🎨 Design et UX

### Thème Gracie Barra
- **Couleurs cohérentes** : Utilisation des couleurs de la marque
- **Typographie** : Police système avec design arrondi
- **Espacement** : Marges et espacements harmonieux
- **Mode sombre** : Support complet du thème sombre

### Accessibilité
- **Labels VoiceOver** : Descriptions claires pour les lecteurs d'écran
- **Contraste** : Respect des standards d'accessibilité
- **Taille de texte** : Support du Dynamic Type

## 🚀 Utilisation

### Pour l'utilisateur
1. **Remplir le profil** : Saisir l'âge (date de naissance) et le poids
2. **Choisir le type de compétition** : Gi ou No Gi
3. **Voir la classification** : Affichage automatique dans le profil

### Pour le développeur
1. **Importer le gestionnaire** : `IBJJFCategoryManager.shared`
2. **Appeler la méthode** : `getIBJJFClassification(age:weight:isGi:)`
3. **Utiliser le composant** : `IBJJFClassificationTag(classification:)`

## 📋 Tests et validation

### Scénarios testés
- **Classification correcte** : Vérification des catégories selon l'IBJJF
- **Gestion des erreurs** : Données manquantes ou invalides
- **Performance** : Calcul rapide de la classification
- **Interface** : Affichage correct sur différents appareils

### Validation des données
- **Âge** : Doit être entre 4 et 65 ans
- **Poids** : Doit être entre 20 et 200 kg
- **Type de compétition** : Doit être Gi ou No Gi

## 🔮 Évolutions futures

### Fonctionnalités prévues
- **Historique des classifications** : Suivi des changements de catégorie
- **Notifications** : Alertes lors des changements de catégorie
- **Statistiques** : Analyse des performances par catégorie
- **Compétitions** : Intégration avec les événements IBJJF

### Améliorations techniques
- **Cache local** : Stockage des catégories pour usage hors ligne
- **API IBJJF** : Synchronisation avec les données officielles
- **Migrations** : Gestion des changements de règles IBJJF

---

*Documentation mise à jour le 28 août 2025*
