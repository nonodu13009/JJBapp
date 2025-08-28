import SwiftUI

// MARK: - Vue d'édition du profil
struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var profileManager: ProfileManager
    let onDismiss: () -> Void
    
    // États locaux pour l'édition
    @State private var pseudo = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var gender: Gender?
    @State private var birthDate = BirthDate()
    @State private var weight: Weight?
    @State private var competitionType: CompetitionType = .gi
    @State private var isLoading = false
    @State private var showSaveSuccess = false
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header avec bouton retour et sauvegarde
                    EditProfileHeader(
                        onBack: { dismiss() },
                        onSave: saveProfile,
                        isLoading: isLoading
                    )
                    .environmentObject(themeManager)
                    
                    // Formulaire d'édition
                    ScrollView {
                        VStack(spacing: 30) {
                            // Champs de saisie
                            VStack(spacing: 24) {
                                // Pseudo
                                ProfileTextField(
                                    title: "Pseudo",
                                    placeholder: "Votre pseudo (optionnel)",
                                    text: $pseudo,
                                    icon: "person.text.rectangle",
                                    textTransform: .none
                                )
                                
                                // Prénom
                                ProfileTextField(
                                    title: "Prénom",
                                    placeholder: "Votre prénom (optionnel)",
                                    text: $firstName,
                                    icon: "person",
                                    textTransform: .capitalized
                                )
                                
                                // Nom
                                ProfileTextField(
                                    title: "Nom",
                                    placeholder: "Votre nom (optionnel)",
                                    text: $lastName,
                                    icon: "person",
                                    textTransform: .capitalized
                                )
                                
                                // Sélecteur de genre
                                GenderSelector(selectedGender: $gender)
                                
                                // Date de naissance
                                BirthDateInput(birthDate: $birthDate)
                                
                                // Poids
                                WeightInput(weight: $weight)
                                
                                // Type de compétition
                                CompetitionTypeSelector(selectedType: $competitionType)
                            }
                            .padding(.horizontal, 40)
                            
                            // Message d'erreur
                            if let errorMessage = profileManager.errorMessage {
                                ErrorMessageView(message: errorMessage)
                            }
                            
                            // Espace en bas
                            Spacer(minLength: 100)
                        }
                        .padding(.vertical, 30)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadCurrentProfile()
        }
        .alert("Profil sauvegardé", isPresented: $showSaveSuccess) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Vos informations ont été sauvegardées avec succès.")
        }
    }
    
    // Charger le profil actuel
    private func loadCurrentProfile() {
        guard let profile = profileManager.userProfile else { return }
        
        pseudo = profile.pseudo ?? ""
        firstName = profile.firstName ?? ""
        lastName = profile.lastName ?? ""
        gender = profile.gender
        birthDate = profile.birthDate ?? BirthDate()
        weight = profile.weight
        competitionType = profile.competitionType ?? .gi
    }
    
    // Sauvegarder le profil
    private func saveProfile() {
        guard let profile = profileManager.userProfile else { return }
        
        isLoading = true
        
        // Créer une copie mise à jour du profil
        var updatedProfile = profile
        updatedProfile.pseudo = pseudo.isEmpty ? nil : pseudo
        updatedProfile.firstName = firstName.isEmpty ? nil : firstName
        updatedProfile.lastName = lastName.isEmpty ? nil : lastName
        updatedProfile.gender = gender
        updatedProfile.birthDate = birthDate
        updatedProfile.weight = weight
        updatedProfile.competitionType = competitionType
        
        Task {
            do {
                try await profileManager.saveProfile(updatedProfile)
                DispatchQueue.main.async {
                    isLoading = false
                    showSaveSuccess = true
                }
            } catch {
                DispatchQueue.main.async {
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Header de la vue d'édition
struct EditProfileHeader: View {
    let onBack: () -> Void
    let onSave: () -> Void
    let isLoading: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            // Bouton retour
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(themeManager.textColor)
                    .padding()
                    .background(
                        Circle()
                            .fill(themeManager.secondaryBackgroundColor.opacity(0.3))
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            // Titre
            Text("Modifier mon profil")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(themeManager.textColor)
            
            Spacer()
            
            // Bouton de sauvegarde
            Button(action: onSave) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text("Sauvegarder")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("GBRed"))
            )
            .buttonStyle(PlainButtonStyle())
            .disabled(isLoading)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

// MARK: - Champ de texte pour le profil
struct ProfileTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let icon: String
    let textTransform: TextTransform
    
    @EnvironmentObject var themeManager: ThemeManager
    
    enum TextTransform {
        case none
        case capitalized
        case uppercase
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Titre du champ
            Text(title)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(themeManager.textColor)
            
            // Champ de saisie
            HStack(spacing: 16) {
                // Icône
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(themeManager.secondaryTextColor)
                    .frame(width: 24)
                
                // Champ de texte
                TextField(placeholder, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(themeManager.textColor)
                    .textInputAutocapitalization(textTransform == .capitalized ? .words : .none)
                    .onChange(of: text) { _, newValue in
                        applyTextTransform(newValue)
                    }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(themeManager.secondaryBackgroundColor.opacity(0.3))
            )
        }
    }
    
    // Appliquer la transformation de texte
    private func applyTextTransform(_ newValue: String) {
        switch textTransform {
        case .none:
            text = newValue
        case .capitalized:
            // Gestion des prénoms composés (ex: "Jean-Michel" -> "Jean-Michel")
            let words = newValue.components(separatedBy: " ")
            let capitalizedWords = words.map { word in
                if word.contains("-") {
                    let parts = word.components(separatedBy: "-")
                    let capitalizedParts = parts.map { $0.prefix(1).uppercased() + $0.dropFirst().lowercased() }
                    return capitalizedParts.joined(separator: "-")
                } else {
                    return word.prefix(1).uppercased() + word.dropFirst().lowercased()
                }
            }
            text = capitalizedWords.joined(separator: " ")
        case .uppercase:
            text = newValue.uppercased()
        }
    }
}

// MARK: - Vue de message d'erreur
struct ErrorMessageView: View {
    let message: String
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
                .font(.system(size: 16))
            
            Text(message)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.orange)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.orange.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal, 40)
    }
}

#Preview {
    EditProfileView(
        profileManager: ProfileManager(),
        onDismiss: {}
    )
    .environmentObject(ThemeManager())
}
