import Foundation
import Data

// MARK: - Character

/// Структура, описывающая модель персонажа.
///
/// Содержит основную информацию о персонаже
/// (идентификатор, имя, статус и ссылку на изображение).
public struct Character: Equatable, Hashable {
    
    // MARK: Properties
    
    /// Идентификатор персонажа.
    public let id: Int
    /// Имя персонажа.
    public let name: String
    /// Пол персонажа.
    public let gender: String
    /// Вид (расса) персонажа.
    public let species: String
    /// Текущий статус персонажа.
    public let status: String
    /// Ссылка на изображение персонажа.
    public let imageURL: URL
    
    // MARK: Initialization
    
    /// Создает новый экземпляр структуры.
    /// - Parameter dto: `DTO` объект с информацией о персонаже.
    public init(dto: CharacterDTO) {
        self.id = dto.id
        self.name = dto.name
        self.gender = dto.gender.rawValue
        self.species = dto.species
        self.status = dto.status.rawValue
        self.imageURL = dto.imageURL
    }
    
    // MARK: Hashable protocol implementation
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: Equatable protocol implementation
    
    public static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }
}
