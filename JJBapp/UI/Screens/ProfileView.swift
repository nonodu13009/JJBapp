import SwiftUI
import FirebaseAuth

// MARK: - Vue principale du profil
struct ProfileView: View {
    @State private var showLogout = false
    @State private var showEditProfile = false
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var profileManager = ProfileManager()
    let onSignOut: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header avec boutons de thème et déconnexion
                    ProfileHeader(
                        onThemeToggle: { themeManager.toggleTheme() },
                        onLogout: { showLogout = true }
                    )
                    .environmentObject(themeManager)
                    
                    // Contenu du profil
                    ScrollView {
                        VStack(spacing: 30) {
                            // Informations du profil
                            if let profile = profileManager.userProfile {
                                ProfileInfoSection(profile: profile)
                                    .environmentObject(themeManager)
                            }
                            
                            // Bouton d'édition
                            Button(action: {
                                showEditProfile = true
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 18, weight: .semibold))
                                    
                                    Text("MODIFIER MON PROFIL")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 28)
                                        .fill(Color("GBRed"))
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 40)
                            
                            // Placeholder pour futures fonctionnalités
                            RoundedRectangle(cornerRadius: 20)
                                .fill(themeManager.secondaryBackgroundColor)
                                .frame(height: 200)
                                .overlay(
                                    VStack(spacing: 16) {
                                        Image(systemName: "plus.circle")
                                            .font(.system(size: 40, weight: .light))
                                            .foregroundColor(themeManager.secondaryTextColor)
                                        
                                        Text("Fonctionnalités à venir")
                                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                                            .foregroundColor(themeManager.textColor)
                                        
                                        Text("Grade, objectifs, statistiques...")
                                            .font(.system(size: 14, weight: .medium, design: .rounded))
                                            .foregroundColor(themeManager.secondaryTextColor)
                                            .multilineTextAlignment(.center)
                                    }
                                )
                                .padding(.horizontal, 40)
                        }
                        .padding(.vertical, 30)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if let userId = Auth.auth().currentUser?.uid {
                Task {
                    await profileManager.loadProfile(for: userId)
                    profileManager.startProfileListener(for: userId)
                }
            }
        }
        .onDisappear {
            profileManager.stopProfileListener()
        }
        .sheet(isPresented: $showLogout) {
            LogoutModalView(
                onConfirm: {
                    showLogout = false
                    onSignOut()
                },
                onCancel: {
                    showLogout = false
                }
            )
        }
        .sheet(isPresented: $showEditProfile) {
            EditProfileView(
                profileManager: profileManager,
                onDismiss: { showEditProfile = false }
            )
            .environmentObject(themeManager)
        }
    }
}

// MARK: - Header du profil
struct ProfileHeader: View {
    let onThemeToggle: () -> Void
    let onLogout: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            // Bouton de basculement de thème
            Button(action: onThemeToggle) {
                Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color("GBRed"))
                    .padding(12)
                    .background(
                        Circle()
                            .fill(Color("GBRed").opacity(0.1))
                            .overlay(
                                Circle()
                                    .stroke(Color("GBRed").opacity(0.3), lineWidth: 1)
                            )
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            // Bouton de déconnexion
            Button(action: onLogout) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color("GBRed"))
                    .padding(12)
                    .background(
                        Circle()
                            .fill(Color("GBRed").opacity(0.1))
                            .overlay(
                                Circle()
                                    .stroke(Color("GBRed").opacity(0.3), lineWidth: 1)
                            )
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

// MARK: - Section d'informations du profil
struct ProfileInfoSection: View {
    let profile: UserProfile
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 24) {
            // Avatar et email
            VStack(spacing: 16) {
                // Avatar placeholder
                Circle()
                    .fill(Color("GBRed").opacity(0.1))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(Color("GBRed"))
                    )
                
                // Email
                Text(profile.email)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(themeManager.textColor)
            }
            
            // Informations personnelles
            VStack(spacing: 20) {
                // Pseudo
                if let pseudo = profile.pseudo, !pseudo.isEmpty {
                    InfoRow(
                        icon: "person.text.rectangle",
                        title: "Pseudo",
                        value: pseudo
                    )
                }
                
                // Nom et prénom
                if let firstName = profile.firstName, !firstName.isEmpty {
                    InfoRow(
                        icon: "person",
                        title: "Prénom",
                        value: firstName
                    )
                }
                
                if let lastName = profile.lastName, !lastName.isEmpty {
                    InfoRow(
                        icon: "person",
                        title: "Nom",
                        value: lastName
                    )
                }
                
                // Genre
                if let gender = profile.gender {
                    InfoRow(
                        icon: gender.iconName,
                        title: "Genre",
                        value: gender.displayName
                    )
                }
                
                // Date de naissance
                if let birthDate = profile.birthDate, birthDate.isValid {
                    InfoRow(
                        icon: "calendar",
                        title: "Date de naissance",
                        value: "\(birthDate.displayText) (\(birthDate.age ?? 0) ans)"
                    )
                }
                
                // Poids
                if let weight = profile.weight {
                    InfoRow(
                        icon: "scalemass",
                        title: "Poids",
                        value: weight.displayText
                    )
                }
            }
            
            // Classification IBJJF
            if let weight = profile.weight,
               let birthDate = profile.birthDate,
               birthDate.isValid,
               let age = birthDate.age {
                
                let classification = IBJJFCategoryManager.shared.getIBJJFClassification(
                    age: age,
                    weight: weight.value,
                    isGi: profile.competitionType == .gi
                )
                
                IBJJFClassificationTag(classification: classification)
                    .environmentObject(themeManager)
                
                // Timeline des catégories de poids
                WeightCategoryTimeline(currentWeight: weight.value)
                    .environmentObject(themeManager)
            }
        }
        .padding(.horizontal, 40)
    }
}

// MARK: - Ligne d'information
struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 16) {
            // Icône
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color("GBRed"))
                .frame(width: 24)
            
            // Contenu
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(themeManager.secondaryTextColor)
                
                Text(value)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(themeManager.textColor)
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

#Preview {
    ProfileView(onSignOut: {})
        .environmentObject(ThemeManager())
}
