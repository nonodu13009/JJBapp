import Foundation
import FirebaseFirestore

// MARK: - Modèle de profil utilisateur
struct UserProfile: Codable, Identifiable {
    let id: String // UID Firebase Auth
    var email: String
    var pseudo: String?
    var firstName: String?
    var lastName: String?
    var gender: Gender?
    var birthDate: BirthDate?
    var createdAt: Date
    var updatedAt: Date
    
    // Initialisation avec valeurs par défaut
    init(id: String, email: String) {
        self.id = id
        self.email = email
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    // Mise à jour des timestamps
    mutating func updateTimestamp() {
        self.updatedAt = Date()
    }
}

// MARK: - Énumération pour le genre
enum Gender: String, CaseIterable, Codable {
    case male = "male"
    case female = "female"
    case undefined = "undefined"
    
    var displayName: String {
        switch self {
        case .male: return "Homme"
        case .female: return "Femme"
        case .undefined: return "À définir"
        }
    }
    
    var iconName: String {
        switch self {
        case .male: return "person.fill"
        case .female: return "person.fill"
        case .undefined: return "person.crop.circle"
        }
    }
    
    var color: String {
        switch self {
        case .male: return "GBRed"
        case .female: return "GBRed"
        case .undefined: return "GBGray"
        }
    }
}

// MARK: - Structure pour la date de naissance
struct BirthDate: Codable, Equatable {
    var day: Int?
    var month: Int?
    var year: Int?
    
    var isValid: Bool {
        guard let day = day, let month = month, let year = year else { return false }
        return day >= 1 && day <= 31 && month >= 1 && month <= 12 && year >= 1900 && year <= Date().year
    }
    
    var displayText: String {
        if let day = day, let month = month, let year = year {
            return String(format: "%02d/%02d/%04d", day, month, year)
        }
        return "Non définie"
    }
    
    var age: Int? {
        guard isValid else { return nil }
        let calendar = Calendar.current
        let today = Date()
        let birthDate = calendar.date(from: DateComponents(year: year, month: month, day: day)) ?? today
        return calendar.dateComponents([.year], from: birthDate, to: today).year
    }
}

// MARK: - Extension pour la date
extension Date {
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
}
