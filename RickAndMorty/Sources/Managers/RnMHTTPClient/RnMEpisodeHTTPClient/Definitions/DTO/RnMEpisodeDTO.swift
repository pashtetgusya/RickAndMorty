import Foundation

// MARK: - Rick and Morty episode DTO

/// Структура, описывающая эпизод вселенной `"Rick and Morty"`.
///
/// Содержит полную информацию об эпизоде, включая его уникальный код,
/// дату выхода и персонажей, которые появляются в данном эпизоде.
struct RnMEpisodeDTO: Decodable {
    
    // MARK: Codings keys
    
    /// Перечень ключей для декодирования структуры из JSON-формата.
    ///
    /// Обеспечивает маппинг между именами полей JSON-представления и свойствами структуры.
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
    let id: Int
    
    /// Название эпизода.
    let name: String
    /// Код эпизода.
    let code: String
    /// Дата выхода эпизода.
    let releaseDate: String
    
    /// Список персонажей, встречающихся в эпизоде.
    let characters: [RnMCharacterShortDTO]
}
