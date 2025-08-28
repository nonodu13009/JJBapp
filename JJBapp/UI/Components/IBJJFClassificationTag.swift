import SwiftUI

// MARK: - Composant d'affichage de la classification IBJJF
struct IBJJFClassificationTag: View {
    let classification: IBJJFClassification
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            // Titre principal
            HStack {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.yellow)
                
                Text("Classification IBJJF")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
            }
            
            // Classification complète : Âge, Gi, No-Gi
            if classification.isValid {
                VStack(spacing: 16) {
                    // ÂGE
                    if let ageCategory = classification.ageCategory {
                        HStack {
                            Image(systemName: ageCategory.isMaster ? "crown.fill" : "person.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(ageCategory.color)
                                .frame(width: 24)
                            
                            Text("ÂGE :")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(themeManager.textColor)
                            
                            Text(ageCategory.shortName)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(ageCategory.color)
                            
                            Spacer()
                        }
                    }
                    
                    // GI
                    if let weightCategory = classification.weightCategory {
                        HStack {
                            Image(systemName: "tshirt.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            
                            Text("GI :")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(themeManager.textColor)
                            
                            Text(weightCategory.shortName)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.blue)
                            
                            Spacer()
                        }
                    }
                    
                    // NO-GI
                    if let weightCategory = classification.weightCategory {
                        HStack {
                            Image(systemName: "figure.martial.arts")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.purple)
                                .frame(width: 24)
                            
                            Text("NO-GI :")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(themeManager.textColor)
                            
                            Text(weightCategory.shortName)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.purple)
                            
                            Spacer()
                        }
                    }
                }
            } else {
                // Message d'erreur
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    
                    Text("Classification incomplète")
                        .foregroundColor(themeManager.secondaryTextColor)
                        .font(.system(size: 14, weight: .medium))
                    
                    Spacer()
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(themeManager.secondaryBackgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Composant de tag de classification
struct ClassificationTag: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let icon: String
    let isWeight: Bool
    let isGi: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Icône
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 24, height: 24)
                .background(color.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                // Titre
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                
                // Valeur principale
                Text(value)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(color)
                
                // Sous-titre
                Text(subtitle)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                
                // Warning pour la pesée Gi
                if isWeight && isGi {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.orange)
                        
                        Text("Pesée avec kimono")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.orange)
                    }
                    .padding(.top, 2)
                }
                
                // Info pour No Gi
                if isWeight && !isGi {
                    HStack(spacing: 4) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.blue)
                        
                        Text("Tenue de sport")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 2)
                }
            }
            
            Spacer()
            
            // Indicateur de validation
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.system(size: 20))
        }
        .padding()
        .background(color.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Composant de type de compétition
struct CompetitionTypeTag: View {
    let isGi: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isGi ? "tshirt.fill" : "figure.martial.arts")
                .foregroundColor(isGi ? .blue : .purple)
                .font(.system(size: 14, weight: .semibold))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(isGi ? "Gi (Kimono)" : "No Gi")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isGi ? .blue : .purple)
                
                // Sous-titre explicatif
                Text(isGi ? "Kimono inclus dans la pesée" : "Tenue de sport pour la pesée")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(isGi ? "IBJJF" : "ADCC")
                .font(.system(size: 10, weight: .bold))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(isGi ? Color.blue.opacity(0.2) : Color.purple.opacity(0.2))
                .foregroundColor(isGi ? .blue : .purple)
                .cornerRadius(6)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    let classification = IBJJFClassification(
        ageCategory: AgeCategory(
            name: "Master 1",
            minAge: 30,
            maxAge: 35,
            shortName: "Master 1",
            color: .brown
        ),
        weightCategory: WeightCategory(
            name: "Middle (Médio)",
            maxWeight: 82.3,
            shortName: "Médio",
            portugueseName: "Médio",
            color: .red
        ),
        isGi: true
    )
    
    return IBJJFClassificationTag(classification: classification)
        .environmentObject(ThemeManager())
        .padding()
}
