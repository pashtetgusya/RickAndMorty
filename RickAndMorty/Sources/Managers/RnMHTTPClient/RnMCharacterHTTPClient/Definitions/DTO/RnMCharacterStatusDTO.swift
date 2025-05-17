import Foundation

// MARK: - Rick and Morty character status DTO

/// Перечень позможных вариантов
/// статуса персонажа во вселенной `"Rick and Morty"`.
enum RnMCharacterStatusDTO: String, Decodable {
    
    // MARK: Cases
    
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    case none = ""
}
