import SwiftUI

// MARK: - Composant de saisie du poids
struct WeightInput: View {
    @Binding var weight: Weight?
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Titre du champ
            Text("Poids")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(themeManager.textColor)
            
            // Champ de saisie
            HStack(spacing: 16) {
                // Icône
                Image(systemName: "scalemass")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(themeManager.secondaryTextColor)
                    .frame(width: 24)
                
                // Champ de texte
                TextField("Poids en kg", text: Binding(
                    get: {
                        if let weight = weight {
                            return String(format: "%.1f", weight.value)
                        }
                        return ""
                    },
                    set: { newValue in
                        if let doubleValue = Double(newValue.replacingOccurrences(of: ",", with: ".")) {
                            weight = Weight(value: doubleValue, unit: .kg)
                        } else if newValue.isEmpty {
                            weight = nil
                        }
                    }
                ))
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(themeManager.textColor)
                .keyboardType(.decimalPad)
                
                // Unité
                Text("kg")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(themeManager.secondaryTextColor)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(themeManager.secondaryBackgroundColor.opacity(0.3))
            )
            
            // Validation et aide
            if let weight = weight {
                HStack(spacing: 8) {
                    Image(systemName: weight.isValid ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                        .foregroundColor(weight.isValid ? .green : .orange)
                        .font(.system(size: 14))
                    
                    Text(weight.isValid ? "Poids valide" : "Poids hors limites (20-200 kg)")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(weight.isValid ? .green : .orange)
                }
            }
        }
    }
}

#Preview {
    WeightInput(weight: .constant(Weight(value: 75.0, unit: .kg)))
        .environmentObject(ThemeManager())
        .padding()
}
