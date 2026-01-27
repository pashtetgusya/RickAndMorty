import Foundation

// MARK: - Character genter DTO

/// Энам, описывающий `DTO` объект возможных вариантов
/// пола персонажа во вселенной `"Rick and Morty"`.
public enum CharacterGenderDTO: String, Decodable, Sendable {
    
    // MARK: Cases
    
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
    case none = ""
}
