import Foundation
import SwiftUI

// MARK: - Gestionnaire des catégories IBJJF
class IBJJFCategoryManager: ObservableObject {
    static let shared = IBJJFCategoryManager()
    
    private init() {}
    
    // MARK: - Catégories de poids (Gi)
    private let weightCategoriesGi: [WeightCategory] = [
        WeightCategory(name: "Rooster (Galo)", maxWeight: 57.5, shortName: "Galo", portugueseName: "Galo", color: .orange),
        WeightCategory(name: "Light Feather (Pluma)", maxWeight: 64.0, shortName: "Pluma", portugueseName: "Pluma", color: .blue),
        WeightCategory(name: "Feather (Pena)", maxWeight: 70.0, shortName: "Pena", portugueseName: "Pena", color: .green),
        WeightCategory(name: "Light (Leve)", maxWeight: 76.0, shortName: "Leve", portugueseName: "Leve", color: .purple),
        WeightCategory(name: "Middle (Médio)", maxWeight: 82.3, shortName: "Médio", portugueseName: "Médio", color: .red),
        WeightCategory(name: "Medium Heavy (Médio Pesado)", maxWeight: 88.3, shortName: "Médio Pesado", portugueseName: "Médio Pesado", color: .pink),
        WeightCategory(name: "Heavy (Pesado)", maxWeight: 94.3, shortName: "Pesado", portugueseName: "Pesado", color: .brown),
        WeightCategory(name: "Super Heavy (Super Pesado)", maxWeight: 100.5, shortName: "Super Pesado", portugueseName: "Super Pesado", color: .gray),
        WeightCategory(name: "Ultra Heavy (Pesadíssimo)", maxWeight: Double.infinity, shortName: "Pesadíssimo", portugueseName: "Pesadíssimo", color: .black)
    ]
    
    // MARK: - Catégories de poids (No Gi)
    private let weightCategoriesNoGi: [WeightCategory] = [
        WeightCategory(name: "Rooster (Galo)", maxWeight: 55.5, shortName: "Galo", portugueseName: "Galo", color: .orange),
        WeightCategory(name: "Light Feather (Pluma)", maxWeight: 61.5, shortName: "Pluma", portugueseName: "Pluma", color: .blue),
        WeightCategory(name: "Feather (Pena)", maxWeight: 67.5, shortName: "Pena", portugueseName: "Pena", color: .green),
        WeightCategory(name: "Light (Leve)", maxWeight: 73.5, shortName: "Leve", portugueseName: "Leve", color: .purple),
        WeightCategory(name: "Middle (Médio)", maxWeight: 79.5, shortName: "Médio", portugueseName: "Médio", color: .red),
        WeightCategory(name: "Medium Heavy (Médio Pesado)", maxWeight: 85.5, shortName: "Médio Pesado", portugueseName: "Médio Pesado", color: .pink),
        WeightCategory(name: "Heavy (Pesado)", maxWeight: 91.5, shortName: "Pesado", portugueseName: "Pesado", color: .brown),
        WeightCategory(name: "Super Heavy (Super Pesado)", maxWeight: 97.5, shortName: "Super Pesado", portugueseName: "Super Pesado", color: .gray),
        WeightCategory(name: "Ultra Heavy (Pesadíssimo)", maxWeight: Double.infinity, shortName: "Pesadíssimo", portugueseName: "Pesadíssimo", color: .black)
    ]
    
    // MARK: - Catégories d'âge
    private let ageCategories: [AgeCategory] = [
        AgeCategory(name: "Mighty-Mite 1", minAge: 4, maxAge: 4, shortName: "Mighty-Mite 1", color: .blue),
        AgeCategory(name: "Mighty-Mite 2", minAge: 5, maxAge: 5, shortName: "Mighty-Mite 2", color: .blue),
        AgeCategory(name: "Mighty-Mite 3", minAge: 6, maxAge: 6, shortName: "Mighty-Mite 3", color: .blue),
        AgeCategory(name: "Pee-Wee 1", minAge: 7, maxAge: 7, shortName: "Pee-Wee 1", color: .green),
        AgeCategory(name: "Pee-Wee 2", minAge: 8, maxAge: 8, shortName: "Pee-Wee 2", color: .green),
        AgeCategory(name: "Pee-Wee 3", minAge: 9, maxAge: 9, shortName: "Pee-Wee 3", color: .green),
        AgeCategory(name: "Junior 1", minAge: 10, maxAge: 10, shortName: "Junior 1", color: .orange),
        AgeCategory(name: "Junior 2", minAge: 11, maxAge: 11, shortName: "Junior 2", color: .orange),
        AgeCategory(name: "Junior 3", minAge: 12, maxAge: 12, shortName: "Junior 3", color: .orange),
        AgeCategory(name: "Teen 1", minAge: 13, maxAge: 13, shortName: "Teen 1", color: .red),
        AgeCategory(name: "Teen 2", minAge: 14, maxAge: 14, shortName: "Teen 2", color: .red),
        AgeCategory(name: "Teen 3", minAge: 15, maxAge: 15, shortName: "Teen 3", color: .red),
        AgeCategory(name: "Juvenile 1", minAge: 16, maxAge: 16, shortName: "Juvenile 1", color: .purple),
        AgeCategory(name: "Juvenile 2", minAge: 17, maxAge: 17, shortName: "Juvenile 2", color: .purple),
        AgeCategory(name: "Adult", minAge: 18, maxAge: 29, shortName: "Adult", color: .black),
        AgeCategory(name: "Master 1", minAge: 30, maxAge: 35, shortName: "Master 1", color: .brown),
        AgeCategory(name: "Master 2", minAge: 36, maxAge: 40, shortName: "Master 2", color: .brown),
        AgeCategory(name: "Master 3", minAge: 41, maxAge: 45, shortName: "Master 3", color: .brown),
        AgeCategory(name: "Master 4", minAge: 46, maxAge: 50, shortName: "Master 4", color: .brown),
        AgeCategory(name: "Master 5", minAge: 51, maxAge: 55, shortName: "Master 5", color: .brown),
        AgeCategory(name: "Master 6", minAge: 56, maxAge: 60, shortName: "Master 6", color: .brown),
        AgeCategory(name: "Master 7", minAge: 61, maxAge: 65, shortName: "Master 7", color: .brown)
    ]
    
    // MARK: - Méthodes publiques
    func getIBJJFClassification(age: Int, weight: Double, isGi: Bool) -> IBJJFClassification {
        let ageCategory = getAgeCategory(for: age)
        let weightCategory = getWeightCategory(for: weight, isGi: isGi)
        
        return IBJJFClassification(
            ageCategory: ageCategory,
            weightCategory: weightCategory,
            isGi: isGi
        )
    }
    
    func getAgeCategory(for age: Int) -> AgeCategory? {
        return ageCategories.first { category in
            age >= category.minAge && age <= category.maxAge
        }
    }
    
    func getWeightCategory(for weight: Double, isGi: Bool) -> WeightCategory? {
        let categories = isGi ? weightCategoriesGi : weightCategoriesNoGi
        return categories.first { category in
            weight <= category.maxWeight
        }
    }
    
    func getAllAgeCategories() -> [AgeCategory] {
        return ageCategories
    }
    
    func getAllWeightCategories(isGi: Bool) -> [WeightCategory] {
        return isGi ? weightCategoriesGi : weightCategoriesNoGi
    }
}

// MARK: - Modèles de données
struct IBJJFClassification {
    let ageCategory: AgeCategory?
    let weightCategory: WeightCategory?
    let isGi: Bool
    
    var isValid: Bool {
        return ageCategory != nil && weightCategory != nil
    }
    
    var displayText: String {
        guard let age = ageCategory?.shortName,
              let weight = weightCategory?.shortName else {
            return "Classification incomplète"
        }
        return "\(age) - \(weight)"
    }
}

struct AgeCategory: Identifiable, Codable {
    let id = UUID()
    let name: String
    let minAge: Int
    let maxAge: Int
    let shortName: String
    let color: Color
    
    var ageRange: String {
        if minAge == maxAge {
            return "\(minAge) ans"
        } else {
            return "\(minAge) - \(maxAge) ans"
        }
    }
    
    var isMaster: Bool {
        return shortName.hasPrefix("Master")
    }
    
    var isChild: Bool {
        return minAge < 16
    }
    
    var isAdult: Bool {
        return shortName == "Adult"
    }
}

struct WeightCategory: Identifiable, Codable {
    let id = UUID()
    let name: String
    let maxWeight: Double
    let shortName: String
    let portugueseName: String
    let color: Color
    
    var weightRange: String {
        if maxWeight == Double.infinity {
            return "\(getPreviousMaxWeight())+ kg"
        } else {
            return "≤ \(maxWeight) kg"
        }
    }
    
    private func getPreviousMaxWeight() -> Double {
        // Logique pour obtenir le poids max de la catégorie précédente
        // Pour simplifier, on retourne une valeur fixe
        return 97.5
    }
}

// MARK: - Extensions pour la sérialisation Color
extension Color: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let colorName = try container.decode(String.self)
        
        switch colorName {
        case "orange": self = .orange
        case "blue": self = .blue
        case "green": self = .green
        case "purple": self = .purple
        case "red": self = .red
        case "pink": self = .pink
        case "brown": self = .brown
        case "gray": self = .gray
        case "black": self = .black
        default: self = .primary
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        let colorName: String
        if self == .orange { colorName = "orange" }
        else if self == .blue { colorName = "blue" }
        else if self == .green { colorName = "green" }
        else if self == .purple { colorName = "purple" }
        else if self == .red { colorName = "red" }
        else if self == .pink { colorName = "pink" }
        else if self == .brown { colorName = "brown" }
        else if self == .gray { colorName = "gray" }
        else if self == .black { colorName = "black" }
        else { colorName = "primary" }
        
        try container.encode(colorName)
    }
}
