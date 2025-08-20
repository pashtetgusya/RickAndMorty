import Foundation

// MARK: - Rick and Morty character status DTO

/// Перечень позможных вариантов
/// статуса персонажа во вселенной `"Rick and Morty"`.
enum RnMCharacterStatusDTO: String, Decodable {
    
    // MARK: Cases
    
    case alive
    case dead
    case unknown
    case none = ""
    
    // MARK: Initialization
    
    init?(rawValue: String) {
        switch rawValue.lowercased() {
        case RnMCharacterStatusDTO.alive.rawValue: self = .alive
        case RnMCharacterStatusDTO.dead.rawValue: self = .dead
        case RnMCharacterStatusDTO.unknown.rawValue: self = .unknown
        
        default: self = .none
        }
    }
}
