import Foundation

// MARK: - Rick and Morty character genter DTO

/// Перечень позможных вариантов
/// пола персонажа во вселенной `"Rick and Morty"`.
enum RnMCharacterGenderDTO: String, Decodable {
    
    // MARK: Cases
    
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
    case none = ""
}
