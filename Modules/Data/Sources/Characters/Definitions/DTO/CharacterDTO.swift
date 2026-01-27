import Foundation

// MARK: - Character DTO

/// Структура, описывающая `DTO` объект персонажа из вселенной `"Rick and Morty"`.
///
/// Содержит полную информацию о персонаже, включая его характеристики,
/// местоположения и эпизоды, в которых он появлялся.
public struct CharacterDTO: Decodable, Sendable {
    
    // MARK: Codings keys
    
    /// Перечень ключей для декодирования структуры из `JSON`-формата.
    ///
    /// Обеспечивает маппинг между именами полей `JSON`-представления и свойствами структуры.
    private enum CodingKeys: String, CodingKey {
        
        // MARK: Cases
        
        case id
        case name
        case gender
        case species
        case type
        case status
        case imageURL = "image"
        case originLocation = "origin"
        case lastLocation = "location"
        case episodesInWhichAppeared = "episode"
    }
    
    // MARK: Properties
    
    /// Идентификатор персонажа.
    public let id: Int
    /// Имя персонажа.
    public let name: String
    /// Пол персонажа.
    public let gender: CharacterGenderDTO
    /// Вид (расса) персонажа.
    public let species: String
    /// Подвид или особые характеристики персонажа.
    public let type: String
    /// Текущий статус персонажа.
    public let status: CharacterStatusDTO
    /// Ссылка на изображение персонажа.
    public let imageURL: URL
    /// Первоначальное местоположение персонажа.
    public let originLocation: LocationShortDTO
    /// Последнее известное местоположение персонажа.
    public let lastLocation: LocationShortDTO
    /// Список эпизодов, в которых появлялся персонаж.
    public let episodesInWhichAppeared: [EpisodeShortDTO]
}
