import SwiftUI

// MARK: - Sélecteur de genre moderne avec icônes
struct GenderSelector: View {
    @Binding var selectedGender: Gender?
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Titre de la section
            Text("Genre")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(themeManager.textColor)
            
            // Boutons de sélection
            HStack(spacing: 16) {
                ForEach(Gender.allCases, id: \.self) { gender in
                    GenderButton(
                        gender: gender,
                        isSelected: selectedGender == gender,
                        onTap: {
                            selectedGender = gender
                        }
                    )
                }
            }
        }
    }
}

// MARK: - Bouton de genre individuel
struct GenderButton: View {
    let gender: Gender
    let isSelected: Bool
    let onTap: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // Icône
                Image(systemName: gender.iconName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .white : Color(gender.color))
                
                // Texte
                Text(gender.displayName)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(isSelected ? .white : themeManager.textColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color(gender.color) : themeManager.secondaryBackgroundColor.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? Color(gender.color) : Color(gender.color).opacity(0.3),
                                lineWidth: isSelected ? 0 : 2
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    GenderSelector(selectedGender: .constant(.undefined))
        .environmentObject(ThemeManager())
        .padding()
}
