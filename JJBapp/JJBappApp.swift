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
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                            
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
                            
                            // Bouton de connexion rapide (DEV)
                            Button(action: {
                                email = "jeanminono13@gmail.com"
                                password = "jeanminono13"
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "bolt.fill")
                                        .font(.system(size: 14, weight: .bold))
                                    
                                    Text("CONNEXION RAPIDE (DEV)")
                                        .font(.system(size: 14, weight: .bold, design: .rounded))
                                }
                                .foregroundColor(.orange)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.orange.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.orange.opacity(0.5), lineWidth: 1)
                                        )
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
            CreateAccountView(onAccountCreated: {
                showDashboard = true
            })
        }
        .fullScreenCover(isPresented: $showDashboard) {
            DashboardView(onSignOut: {
                showDashboard = false
            })
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
        
        // Implémenter la logique Firebase de connexion
        Task {
            do {
                try await Auth.auth().signIn(withEmail: email, password: password)
                DispatchQueue.main.async {
                    showDashboard = true
                }
            } catch {
                DispatchQueue.main.async {
                    // TODO: Afficher l'erreur de connexion
                    print("Erreur de connexion: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - Page de création de compte
struct CreateAccountView: View {
    @Environment(\.dismiss) private var dismiss
    let onAccountCreated: () -> Void
    
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
                                .disableAutocorrection(true)
                            
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
        
        // Implémenter la logique Firebase de création de compte
        Task {
            do {
                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                print("Compte créé avec succès pour: \(result.user.email ?? "N/A")")
                
                DispatchQueue.main.async {
                    isLoading = false
                    // Création réussie, fermer la page et naviguer vers le dashboard
                    dismiss()
                    onAccountCreated()
                }
            } catch {
                DispatchQueue.main.async {
                    isLoading = false
                    // Afficher l'erreur Firebase
                    // Afficher l'erreur Firebase
                    let errorMessage: String
                    if let errorCode = AuthErrorCode(rawValue: (error as NSError).code) {
                        switch errorCode {
                        case .emailAlreadyInUse:
                            errorMessage = "Cet email est déjà utilisé par un autre compte"
                        case .weakPassword:
                            errorMessage = "Le mot de passe est trop faible"
                        case .invalidEmail:
                            errorMessage = "Format d'email invalide"
                        default:
                            errorMessage = "Erreur lors de la création du compte: \(error.localizedDescription)"
                        }
                    } else {
                        errorMessage = "Erreur lors de la création du compte: \(error.localizedDescription)"
                    }
                    showError(message: errorMessage)
                }
            }
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

// MARK: - TabView principale
struct DashboardView: View {
    let onSignOut: () -> Void
    
    var body: some View {
        TabView {
            // Onglet Accueil
            HomeView(onSignOut: onSignOut)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Accueil")
                }
            
            // Onglet JJB
            JJBView(onSignOut: onSignOut)
                .tabItem {
                    Image(systemName: "figure.martial.arts")
                    Text("JJB")
                }
            
            // Onglet Préparation
            PreparationView(onSignOut: onSignOut)
                .tabItem {
                    Image(systemName: "dumbbell.fill")
                    Text("Préparation")
                }
            
            // Onglet Techniques
            TechniquesView(onSignOut: onSignOut)
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Techniques")
                }
            
            // Onglet Profil
            ProfileView(onSignOut: onSignOut)
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profil")
                }
        }
        .accentColor(Color("GBRed"))
        .preferredColorScheme(.dark)
    }
}

// MARK: - Modale de déconnexion personnalisée
struct LogoutModalView: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        // Contenu de la modale sans arrière-plan masquant
        VStack(spacing: 30) {
            // Icône de déconnexion
            Image(systemName: "rectangle.portrait.and.arrow.right")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(Color("GBRed"))
                .padding(.top, 20)
            
            // Titre
            Text("Déconnexion")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(Color("GBOffWhite"))
            
            // Message
            Text("Êtes-vous sûr de vouloir vous déconnecter ?")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            // Boutons
            VStack(spacing: 16) {
                // Bouton Se déconnecter
                Button(action: onConfirm) {
                    Text("SE DÉCONNECTER")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color("GBOffWhite"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color("GBRed"))
                        )
                }
                .buttonStyle(PlainButtonStyle())
                
                // Bouton Annuler
                Button(action: onCancel) {
                    Text("ANNULER")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color("GBRed"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color("GBRed"), lineWidth: 2)
                                .fill(Color("GBDark"))
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: 320)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("GBDark"))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("GBGray"), lineWidth: 1)
                )
        )
        .padding(.horizontal, 40)
    }
}

// MARK: - Vues des onglets
struct HomeView: View {
    @State private var showLogout = false
    let onSignOut: () -> Void
    
    var body: some View {
        ZStack {
            Color("GBDark")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header avec bouton de déconnexion
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showLogout = true
                    }) {
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
                
                // Logo Gracie Barra
                Image("ban")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 120)
                
                // Titre
                Text("ACCUEIL")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color("GBOffWhite"))
                
                // Sous-titre
                Text("Dashboard, prochains entraînements, stats rapides, citations motivationnelles")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                // Placeholder
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("GBGray"))
                    .frame(height: 200)
                    .overlay(
                        Text("En construction")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(Color("GBOffWhite"))
                    )
                    .padding(.horizontal, 40)
                
                Spacer()
            }
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
    }
}

struct JJBView: View {
    @State private var showLogout = false
    let onSignOut: () -> Void
    
    var body: some View {
        ZStack {
            Color("GBDark")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header avec bouton de déconnexion
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showLogout = true
                    }) {
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
                
                // Icône JJB
                Image(systemName: "figure.martial.arts")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(Color("GBRed"))
                
                // Titre
                Text("JIU-JITSU")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color("GBOffWhite"))
                
                // Sous-titre
                Text("Historique entraînements, partenaires, notes sessions, calendrier cours")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                // Placeholder
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("GBGray"))
                    .frame(height: 200)
                    .overlay(
                        Text("En construction")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(Color("GBOffWhite"))
                    )
                    .padding(.horizontal, 40)
                
                Spacer()
            }
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
    }
}

struct PreparationView: View {
    @State private var showLogout = false
    let onSignOut: () -> Void
    
    var body: some View {
        ZStack {
            Color("GBDark")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header avec bouton de déconnexion
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showLogout = true
                    }) {
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
                
                // Icône Préparation
                Image(systemName: "dumbbell.fill")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(Color("GBRed"))
                
                // Titre
                Text("PRÉPARATION")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color("GBOffWhite"))
                
                // Sous-titre
                Text("Programmes physiques, exercices conditionnement, cardio JJB, timer")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                // Placeholder
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("GBGray"))
                    .frame(height: 200)
                    .overlay(
                        Text("En construction")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(Color("GBOffWhite"))
                    )
                    .padding(.horizontal, 40)
                
                Spacer()
            }
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
    }
}

struct TechniquesView: View {
    @State private var showLogout = false
    let onSignOut: () -> Void
    
    var body: some View {
        ZStack {
            Color("GBDark")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header avec bouton de déconnexion
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showLogout = true
                    }) {
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
                
                // Icône Techniques
                Image(systemName: "book.fill")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(Color("GBRed"))
                
                // Titre
                Text("TECHNIQUES")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color("GBOffWhite"))
                
                // Sous-titre
                Text("Bibliothèque mouvements, vidéos, notes techniques, progression par garde")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                // Placeholder
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("GBGray"))
                    .frame(height: 200)
                    .overlay(
                        Text("En construction")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(Color("GBOffWhite"))
                    )
                    .padding(.horizontal, 40)
                
                Spacer()
            }
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
    }
}

struct ProfileView: View {
    @State private var showLogout = false
    let onSignOut: () -> Void
    
    var body: some View {
        ZStack {
            Color("GBDark")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header avec bouton de déconnexion
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showLogout = true
                    }) {
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
                
                // Icône Profil
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(Color("GBRed"))
                
                // Titre
                Text("PROFIL")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color("GBOffWhite"))
                
                // Sous-titre
                Text("Infos personnelles, grade, objectifs, stats globales, paramètres")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                // Placeholder
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("GBGray"))
                    .frame(height: 200)
                    .overlay(
                        Text("En construction")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(Color("GBOffWhite"))
                    )
                    .padding(.horizontal, 40)
                
                Spacer()
            }
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
