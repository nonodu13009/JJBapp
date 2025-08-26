import Foundation
import FirebaseFirestore
import FirebaseAuth

// MARK: - Gestionnaire de profil utilisateur
@MainActor
class ProfileManager: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var profileListener: ListenerRegistration?
    
    // Collection Firestore pour les profils
    private func profileCollection(for userId: String) -> CollectionReference {
        return db.collection("users").document(userId).collection("profile")
    }
    
    // Charger le profil utilisateur
    func loadProfile(for userId: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let snapshot = try await profileCollection(for: userId).document("main").getDocument()
            
            if snapshot.exists, let data = snapshot.data() {
                // Décoder le profil existant
                let profile = try Firestore.Decoder().decode(UserProfile.self, from: data)
                userProfile = profile
            } else {
                // Créer un profil par défaut si aucun n'existe
                if let user = Auth.auth().currentUser {
                    let defaultProfile = UserProfile(id: userId, email: user.email ?? "")
                    userProfile = defaultProfile
                    // Sauvegarder le profil par défaut
                    try await saveProfile(defaultProfile)
                }
            }
        } catch {
            errorMessage = "Erreur lors du chargement du profil: \(error.localizedDescription)"
            print("Erreur chargement profil: \(error)")
        }
        
        isLoading = false
    }
    
    // Sauvegarder le profil utilisateur
    func saveProfile(_ profile: UserProfile) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            var updatedProfile = profile
            updatedProfile.updateTimestamp()
            
            let data = try Firestore.Encoder().encode(updatedProfile)
            try await profileCollection(for: profile.id).document("main").setData(data, merge: true)
            
            userProfile = updatedProfile
        } catch {
            errorMessage = "Erreur lors de la sauvegarde: \(error.localizedDescription)"
            print("Erreur sauvegarde profil: \(error)")
            throw error
        }
        
        isLoading = false
    }
    
    // Mettre à jour un champ spécifique du profil
    func updateProfileField<T>(_ field: WritableKeyPath<UserProfile, T>, value: T) async {
        guard var profile = userProfile else { return }
        
        profile[keyPath: field] = value
        profile.updateTimestamp()
        
        do {
            try await saveProfile(profile)
        } catch {
            errorMessage = "Erreur lors de la mise à jour: \(error.localizedDescription)"
        }
    }
    
        // Écouter les changements du profil en temps réel
    func startProfileListener(for userId: String) {
        Task { @MainActor in
            stopProfileListener() // Arrêter l'ancien listener
        }

        profileListener = profileCollection(for: userId).document("main")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    Task { @MainActor in
                        self.errorMessage = "Erreur d'écoute: \(error.localizedDescription)"
                    }
                    return
                }

                guard let snapshot = snapshot, snapshot.exists,
                      let data = snapshot.data() else { return }

                do {
                    let profile = try Firestore.Decoder().decode(UserProfile.self, from: data)
                    Task { @MainActor in
                        self.userProfile = profile
                    }
                } catch {
                    Task { @MainActor in
                        self.errorMessage = "Erreur décodage profil: \(error.localizedDescription)"
                    }
                }
            }
    }
    
    // Arrêter l'écoute des changements
    func stopProfileListener() {
        profileListener?.remove()
        profileListener = nil
    }
    
    // Nettoyer les ressources
    deinit {
        // Note: stopProfileListener() ne peut pas être appelé ici car deinit n'est pas @MainActor
        // Le listener sera automatiquement supprimé quand l'objet est détruit
        profileListener?.remove()
        profileListener = nil
    }
}
