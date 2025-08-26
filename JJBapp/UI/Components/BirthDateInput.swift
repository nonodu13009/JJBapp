import SwiftUI

// MARK: - Composant de saisie de date de naissance
struct BirthDateInput: View {
    @Binding var birthDate: BirthDate
    @EnvironmentObject var themeManager: ThemeManager
    
    // États pour les champs de saisie
    @State private var dayText = ""
    @State private var monthText = ""
    @State private var yearText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Titre de la section
            Text("Date de naissance")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(themeManager.textColor)
            
            // Champs de saisie
            HStack(spacing: 12) {
                // Jour
                VStack(alignment: .leading, spacing: 8) {
                    Text("Jour")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(themeManager.secondaryTextColor)
                    
                    TextField("JJ", text: $dayText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(themeManager.textColor)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .onChange(of: dayText) { _, newValue in
                            updateBirthDate()
                        }
                        .onAppear {
                            dayText = birthDate.day?.description ?? ""
                        }
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(themeManager.secondaryBackgroundColor.opacity(0.3))
                        )
                }
                
                // Mois
                VStack(alignment: .leading, spacing: 8) {
                    Text("Mois")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(themeManager.secondaryTextColor)
                    
                    TextField("MM", text: $monthText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(themeManager.textColor)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .onChange(of: monthText) { _, newValue in
                            updateBirthDate()
                        }
                        .onAppear {
                            monthText = birthDate.month?.description ?? ""
                        }
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(themeManager.secondaryBackgroundColor.opacity(0.3))
                        )
                }
                
                // Année
                VStack(alignment: .leading, spacing: 8) {
                    Text("Année")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(themeManager.secondaryTextColor)
                    
                    TextField("AAAA", text: $yearText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(themeManager.textColor)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .onChange(of: yearText) { _, newValue in
                            updateBirthDate()
                        }
                        .onAppear {
                            yearText = birthDate.year?.description ?? ""
                        }
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(themeManager.secondaryBackgroundColor.opacity(0.3))
                        )
                }
            }
            
            // Affichage de la date et de l'âge
            if birthDate.isValid {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 16))
                    
                    Text(birthDate.displayText)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(themeManager.textColor)
                    
                    if let age = birthDate.age {
                        Text("(\(age) ans)")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                }
            } else if !dayText.isEmpty || !monthText.isEmpty || !yearText.isEmpty {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 16))
                    
                    Text("Date invalide")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.orange)
                }
            }
        }
    }
    
    // Mise à jour de la date de naissance
    private func updateBirthDate() {
        let day = Int(dayText)
        let month = Int(monthText)
        let year = Int(yearText)
        
        birthDate = BirthDate(day: day, month: month, year: year)
    }
}

#Preview {
    BirthDateInput(birthDate: .constant(BirthDate(day: 15, month: 6, year: 1990)))
        .environmentObject(ThemeManager())
        .padding()
}
