//
//  JJBappApp.swift
//  JJBapp
//
//  Created by Jean-Michel Nogaro on 25/08/2025.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct JJBappApp: App {
    // Configuration Firebase au démarrage de l'app
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            // Commence par la page d'accueil sombre
            WelcomeView()
        }
    }
}

// MARK: - Page d'accueil sombre Gracie Barra
struct WelcomeView: View {
    @State private var showLogin = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Arrière-plan sombre
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Logo Gracie Barra
                    Image("ban")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 120)
                        .padding(.bottom, 20)
                    
                    // Titre principal
                    VStack(spacing: 16) {
                        Text("JIU-JITSU BRÉSILIEN")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Découvrez l'univers du Jiu-Jitsu")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    Spacer()
                    
                    // CTA rouge "On se lance"
                    Button(action: {
                        showLogin = true
                    }) {
                        Text("ON SE LANCE")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(Color.red)
                            )
                            .padding(.horizontal, 40)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }
            }
        }
        .fullScreenCover(isPresented: $showLogin) {
            // Navigation vers la page de connexion
            AuthView()
        }
    }
}

// MARK: - Page de connexion
struct AuthView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authManager = AuthManager()
    @State private var showPassword = false
    @State private var email = ""
    @State private var password = ""
    @State private var showCreateAccount = false
    @State private var showDashboard = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Arrière-plan sombre cohérent
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Bouton retour
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Logo plus petit
                    Image("ban")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 90)
                    
                    // Titre de connexion
                    Text("CONNEXION")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Accédez à votre espace Jiu-Jitsu")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    // Champs de connexion avec fonctionnalités
                    VStack(spacing: 20) {
                        // Champ Email
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                                .frame(width: 20)
                            
                            TextField("", text: $email)
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .placeholder(when: email.isEmpty) {
                                    Text("Email")
                                        .foregroundColor(.gray.opacity(0.7))
                                        .italic()
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.3))
                        )
                        
                        // Champ Mot de passe avec bouton voir/masquer
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                                .frame(width: 20)
                            
                            Group {
                                if showPassword {
                                    TextField("", text: $password)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .placeholder(when: password.isEmpty) {
                                            Text("Mot de passe")
                                                .foregroundColor(.gray.opacity(0.7))
                                                .italic()
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                        }
                                } else {
                                    SecureField("", text: $password)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .placeholder(when: password.isEmpty) {
                                            Text("Mot de passe")
                                                .foregroundColor(.gray.opacity(0.7))
                                                .italic()
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                        }
                                }
                            }
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            
                            Spacer()
                            
                            // Bouton voir/masquer le mot de passe
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.3))
                        )
                        
                        // Boutons de connexion et création de compte
                        VStack(spacing: 16) {
                            // Bouton Se connecter
                            Button(action: {
                                signIn()
                            }) {
                                Text("SE CONNECTER")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color.red)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Bouton Créer mon compte
                            Button(action: {
                                showCreateAccount = true
                            }) {
                                Text("CRÉER MON COMPTE")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.red, lineWidth: 2)
                                            .fill(Color.clear)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showCreateAccount) {
            CreateAccountView()
        }
        .fullScreenCover(isPresented: $showDashboard) {
            DashboardView()
        }
    }
    
    // MARK: - Fonction de connexion
    private func signIn() {
        // Validation des champs
        guard !email.isEmpty else {
            // TODO: Afficher erreur "Veuillez saisir votre email"
            return
        }
        
        guard !password.isEmpty else {
            // TODO: Afficher erreur "Veuillez saisir votre mot de passe"
            return
        }
        
        // TODO: Implémenter la logique Firebase de connexion
        // Pour l'instant, on simule une connexion réussie
        showDashboard = true
    }
}

// MARK: - Page de création de compte
struct CreateAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showError = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Arrière-plan sombre cohérent
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Bouton retour
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Logo plus petit
                    Image("ban")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 90)
                    
                    // Titre de création de compte
                    Text("CRÉER MON COMPTE")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Rejoignez l'univers du Jiu-Jitsu")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    // Champs de saisie
                    VStack(spacing: 20) {
                        // Champ Email
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                                .frame(width: 20)
                            
                            TextField("", text: $email)
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .placeholder(when: email.isEmpty) {
                                    Text("Email")
                                        .foregroundColor(.gray.opacity(0.7))
                                        .italic()
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                }
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.3))
                        )
                        
                        // Champ Mot de passe
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                                .frame(width: 20)
                            
                            Group {
                                if showPassword {
                                    TextField("", text: $password)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .placeholder(when: password.isEmpty) {
                                            Text("Mot de passe")
                                                .foregroundColor(.gray.opacity(0.7))
                                                .italic()
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                        }
                                } else {
                                    SecureField("", text: $password)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .placeholder(when: password.isEmpty) {
                                            Text("Mot de passe")
                                                .foregroundColor(.gray.opacity(0.7))
                                                .italic()
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                        }
                                }
                            }
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            
                            Spacer()
                            
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.3))
                        )
                        
                        // Champ Confirmer le mot de passe
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                                .frame(width: 20)
                            
                            Group {
                                if showConfirmPassword {
                                    TextField("", text: $confirmPassword)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .placeholder(when: confirmPassword.isEmpty) {
                                            Text("Confirmer le mot de passe")
                                                .foregroundColor(.gray.opacity(0.7))
                                                .italic()
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                        }
                                } else {
                                    SecureField("", text: $confirmPassword)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .placeholder(when: confirmPassword.isEmpty) {
                                            Text("Confirmer le mot de passe")
                                                .foregroundColor(.gray.opacity(0.7))
                                                .italic()
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                        }
                                }
                            }
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            
                            Spacer()
                            
                            Button(action: {
                                showConfirmPassword.toggle()
                            }) {
                                Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.3))
                        )
                        
                        // Message d'erreur
                        if showError {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.red.opacity(0.1))
                                )
                        }
                        
                        // Bouton de création de compte
                        Button(action: {
                            createAccount()
                        }) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Text("CRÉER MON COMPTE")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.red)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(isLoading)
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Validation et création de compte
    private func createAccount() {
        // Réinitialiser les erreurs
        showError = false
        errorMessage = ""
        
        // Validation des champs
        guard !email.isEmpty else {
            showError(message: "Veuillez saisir votre email")
            return
        }
        
        guard isValidEmail(email) else {
            showError(message: "Veuillez saisir un email valide")
            return
        }
        
        guard !password.isEmpty else {
            showError(message: "Veuillez saisir un mot de passe")
            return
        }
        
        guard password.count >= 6 else {
            showError(message: "Le mot de passe doit contenir au moins 6 caractères")
            return
        }
        
        guard !confirmPassword.isEmpty else {
            showError(message: "Veuillez confirmer votre mot de passe")
            return
        }
        
        guard password == confirmPassword else {
            showError(message: "Les mots de passe ne correspondent pas")
            return
        }
        
        // Démarrer la création de compte
        isLoading = true
        
        // TODO: Implémenter la logique Firebase de création de compte
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            // Simuler une création réussie et basculer vers le dashboard
            dismiss()
            // TODO: Naviguer vers le dashboard après création réussie
        }
    }
    
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// MARK: - Dashboard principal
struct DashboardView: View {
    @State private var showLogout = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Arrière-plan sombre cohérent
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // Header avec icône connectée
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showLogout = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 16, weight: .bold))
                                
                                Text("Connecté")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.green)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.green.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.green.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    // Logo Gracie Barra
                    Image("ban")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 120)
                    
                    // Titre du dashboard
                    Text("DASHBOARD")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Bienvenue dans votre espace Jiu-Jitsu")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    // Placeholder pour contenu futur
                    VStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 100)
                            .overlay(
                                Text("Contenu à venir...")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                            )
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 100)
                            .overlay(
                                Text("Fonctionnalités en développement")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                            )
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Déconnexion", isPresented: $showLogout) {
            Button("Annuler", role: .cancel) { }
            Button("Se déconnecter", role: .destructive) {
                // TODO: Implémenter la déconnexion Firebase
                // Pour l'instant, on simule un retour à l'accueil
            }
        } message: {
            Text("Êtes-vous sûr de vouloir vous déconnecter ?")
        }
    }
}

// MARK: - Extension pour les placeholders personnalisés
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// MARK: - Gestionnaire d'authentification (simplifié pour l'instant)
@MainActor
class AuthManager: ObservableObject {
    @Published var authState: AuthState = .loading
    
    init() {
        // Pour l'instant, on commence en mode non connecté
        authState = .unauthenticated
    }
}

// MARK: - États d'authentification
enum AuthState {
    case loading
    case authenticated(user: User)
    case unauthenticated
}
