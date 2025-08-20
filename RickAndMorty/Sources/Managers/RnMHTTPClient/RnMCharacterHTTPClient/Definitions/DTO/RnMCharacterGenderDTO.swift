import Foundation

// MARK: - Rick and Morty character genter DTO

/// Перечень позможных вариантов
/// пола персонажа во вселенной `"Rick and Morty"`.
enum RnMCharacterGenderDTO: String, Decodable {
    
    // MARK: Cases
    
    case female
    case male
    case genderless
    case unknown
    case none = ""
    
    // MARK: Initialization
    
    init?(rawValue: String) {
        switch rawValue.lowercased() {
        case RnMCharacterGenderDTO.female.rawValue: self = .female
        case RnMCharacterGenderDTO.male.rawValue: self = .male
        case RnMCharacterGenderDTO.genderless.rawValue: self = .genderless
        case RnMCharacterGenderDTO.unknown.rawValue: self = .unknown
        
        default: self = .none
        }
    }
}
