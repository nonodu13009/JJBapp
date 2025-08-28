import SwiftUI

// MARK: - Composant de sélection du type de compétition
struct CompetitionTypeSelector: View {
    @Binding var selectedType: CompetitionType
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Titre du champ
            Text("Type de compétition")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(themeManager.textColor)
            
            // Sélecteur
            HStack(spacing: 16) {
                // Icône
                Image(systemName: "figure.martial.arts")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(themeManager.secondaryTextColor)
                    .frame(width: 24)
                
                // Options
                HStack(spacing: 0) {
                    ForEach(CompetitionType.allCases, id: \.self) { type in
                        Button(action: {
                            selectedType = type
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: type.iconName)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(selectedType == type ? .white : themeManager.textColor)
                                
                                Text(type.shortName)
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(selectedType == type ? .white : themeManager.textColor)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedType == type ? Color("GBRed") : themeManager.secondaryBackgroundColor.opacity(0.3))
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("GBRed").opacity(0.3), lineWidth: 1)
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(themeManager.secondaryBackgroundColor.opacity(0.3))
            )
            
            // Description
            Text("Sélectionnez votre type de compétition principal pour le calcul des catégories IBJJF")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(themeManager.secondaryTextColor)
                .multilineTextAlignment(.leading)
        }
    }
}

// MARK: - Énumération des types de compétition
enum CompetitionType: String, CaseIterable, Codable {
    case gi = "gi"
    case noGi = "noGi"
    
    var displayName: String {
        switch self {
        case .gi: return "Gi (Kimono)"
        case .noGi: return "No Gi (Rashguard)"
        }
    }
    
    var shortName: String {
        switch self {
        case .gi: return "Gi"
        case .noGi: return "No Gi"
        }
    }
    
    var iconName: String {
        switch self {
        case .gi: return "person.fill"
        case .noGi: return "figure.martial.arts"
        }
    }
    
    var description: String {
        switch self {
        case .gi: return "Compétition avec kimono traditionnel"
        case .noGi: return "Compétition en tenue de sport"
        }
    }
}

#Preview {
    CompetitionTypeSelector(selectedType: .constant(.gi))
        .environmentObject(ThemeManager())
        .padding()
}
