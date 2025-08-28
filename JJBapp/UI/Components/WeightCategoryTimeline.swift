import SwiftUI

// MARK: - Composant de timeline des catégories de poids avec onglets
struct WeightCategoryTimeline: View {
    let currentWeight: Double
    @State private var selectedTab: CompetitionType = .gi
    @EnvironmentObject var themeManager: ThemeManager
    
    // Catégories de poids IBJJF pour Gi
    private var weightCategoriesGi: [WeightCategoryInfo] {
        return [
            WeightCategoryInfo(name: "Heavy", maxWeight: 94.3, color: .blue),
            WeightCategoryInfo(name: "Super Heavy", maxWeight: 100.5, color: .green, isCurrent: true),
            WeightCategoryInfo(name: "Ultra Heavy", maxWeight: nil, color: .red)
        ]
    }
    
    // Catégories de poids IBJJF pour No-Gi
    private var weightCategoriesNoGi: [WeightCategoryInfo] {
        return [
            WeightCategoryInfo(name: "Heavy", maxWeight: 91.5, color: .blue),
            WeightCategoryInfo(name: "Super Heavy", maxWeight: 97.5, color: .green, isCurrent: true),
            WeightCategoryInfo(name: "Ultra Heavy", maxWeight: nil, color: .red)
        ]
    }
    
    // Catégories actives selon l'onglet sélectionné
    private var activeWeightCategories: [WeightCategoryInfo] {
        return selectedTab == .gi ? weightCategoriesGi : weightCategoriesNoGi
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Titre
            HStack {
                Image(systemName: "scalemass.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.orange)
                
                Text("Timeline Catégories de Poids")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
            }
            
            // Onglets Gi/No-Gi
            HStack(spacing: 0) {
                // Onglet Gi
                Button(action: {
                    selectedTab = .gi
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "tshirt.fill")
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("GI")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(selectedTab == .gi ? .white : .blue)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(selectedTab == .gi ? Color.blue : Color.blue.opacity(0.1))
                    .cornerRadius(12, corners: [.topLeft, .bottomLeft])
                }
                
                // Onglet No-Gi
                Button(action: {
                    selectedTab = .noGi
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "figure.martial.arts")
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("NO-GI")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(selectedTab == .noGi ? .white : .purple)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(selectedTab == .noGi ? Color.purple : Color.purple.opacity(0.1))
                    .cornerRadius(12, corners: [.topRight, .bottomRight])
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            
            // Timeline visuelle
            HStack(spacing: 0) {
                ForEach(Array(activeWeightCategories.enumerated()), id: \.offset) { index, category in
                    VStack(spacing: 8) {
                        // Catégorie
                        VStack(spacing: 4) {
                            Text(category.name)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(category.isCurrent ? .white : category.color)
                                .multilineTextAlignment(.center)
                            
                            if let maxWeight = category.maxWeight {
                                Text("≤ \(String(format: "%.1f", maxWeight)) kg")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(category.isCurrent ? .white.opacity(0.9) : themeManager.secondaryTextColor)
                            } else {
                                Text("> \(String(format: "%.1f", activeWeightCategories[activeWeightCategories.count - 2].maxWeight ?? 0)) kg")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(themeManager.secondaryTextColor)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(category.isCurrent ? category.color : category.color.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(category.color, lineWidth: category.isCurrent ? 0 : 1)
                        )
                        
                        // Indicateur de position actuelle
                        if category.isCurrent {
                            VStack(spacing: 4) {
                                Image(systemName: "arrow.down.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(category.color)
                                
                                Text("\(String(format: "%.1f", currentWeight)) kg")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(category.color)
                            }
                        }
                        
                        // Flèche de connexion (sauf pour le dernier)
                        if index < activeWeightCategories.count - 1 {
                            HStack(spacing: 4) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 2)
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.gray.opacity(0.6))
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 16)
            
            // Informations de changement de catégorie
            VStack(spacing: 12) {
                // Descendre de catégorie
                if let heavyMax = activeWeightCategories.first?.maxWeight {
                    let weightToLose = currentWeight - heavyMax
                    if weightToLose > 0 {
                        HStack {
                            Image(systemName: "arrow.down.circle.fill")
                                .foregroundColor(.blue)
                            
                            Text("Pour descendre en \(activeWeightCategories.first?.name ?? ""):")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(themeManager.textColor)
                            
                            Spacer()
                            
                            Text("Perdre \(String(format: "%.1f", weightToLose)) kg")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                
                // Monter de catégorie
                if let superHeavyMax = activeWeightCategories[1].maxWeight {
                    let weightToGain = superHeavyMax - currentWeight
                    if weightToGain > 0 {
                        HStack {
                            Image(systemName: "arrow.up.circle.fill")
                                .foregroundColor(.green)
                            
                            Text("Marge en \(activeWeightCategories[1].name ?? ""):")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(themeManager.textColor)
                            
                            Spacer()
                            
                            Text("+ \(String(format: "%.1f", weightToGain)) kg")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.green)
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(themeManager.secondaryBackgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Structure d'information de catégorie
struct WeightCategoryInfo {
    let name: String
    let maxWeight: Double?
    let color: Color
    let isCurrent: Bool
    
    init(name: String, maxWeight: Double?, color: Color, isCurrent: Bool = false) {
        self.name = name
        self.maxWeight = maxWeight
        self.color = color
        self.isCurrent = isCurrent
    }
}

// MARK: - Extension pour les coins arrondis
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: - Preview
#Preview {
    WeightCategoryTimeline(currentWeight: 94.6)
        .environmentObject(ThemeManager())
        .padding()
}
