//
//  ContentView.swift
//  JJBapp
//
//  Created by Jean-Michel Nogaro on 25/08/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthManager()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Group {
            if authManager.authState == .authenticated {
                DashboardView(onSignOut: {
                    authManager.authState = .unauthenticated
                })
                .environmentObject(themeManager)
            } else {
                WelcomeView()
                    .onAppear {
                        // Réinitialiser l'état d'authentification au démarrage
                        authManager.authState = .unauthenticated
                    }
            }
        }
        .environmentObject(authManager)
    }
}

#Preview {
    ContentView()
        .environmentObject(ThemeManager())
}
