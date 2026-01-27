import Foundation

// MARK: - Character status DTO

/// Энам, описывающий `DTO` объект возможных вариантов
/// статуса персонажа во вселенной `"Rick and Morty"`.
public enum CharacterStatusDTO: String, Decodable, Sendable {
    
    // MARK: Cases
    
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    case none = ""
}
