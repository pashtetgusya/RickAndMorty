import Foundation

// MARK: - Episode DTO

/// Структура, описывающая `DTO` объект эпизода вселенной `"Rick and Morty"`.
///
/// Содержит полную информацию об эпизоде, включая его уникальный код,
/// дату выхода и персонажей, которые появляются в данном эпизоде.
public struct EpisodeDTO: Decodable, Sendable {
    
    // MARK: Codings keys
    
    /// Перечень ключей для декодирования структуры из `JSON`-формата.
    ///
    /// Обеспечивает маппинг между именами полей `JSON`-представления и свойствами структуры.
    private enum CodingKeys: String, CodingKey {
        
        // MARK: Cases
        
        case id
        case name
        case code = "episode"
        case releaseDate = "air_date"
        case characters
    }
    
    // MARK: Properties
    
    /// Идентификатор эпизода.
    public let id: Int
    /// Название эпизода.
    public let name: String
    /// Код эпизода.
    public let code: String
    /// Дата выхода эпизода.
    public let releaseDate: String
    /// Список персонажей, встречающихся в эпизоде.
    public let characters: [CharacterShortDTO]
}
