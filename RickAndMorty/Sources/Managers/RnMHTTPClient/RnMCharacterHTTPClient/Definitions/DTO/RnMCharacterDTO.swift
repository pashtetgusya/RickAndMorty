import Foundation

// MARK: - Rick and Morty character DTO

/// Структура, описывающая персонажа из вселенной `"Rick and Morty"`.
///
/// Содержит полную информацию о персонаже, включая его характеристики,
/// местоположения и эпизоды, в которых он появлялся.
struct RnMCharacterDTO: Decodable {
    
    // MARK: Codings keys
    
    /// Перечень ключей для декодирования структуры из JSON-формата.
    ///
    /// Обеспечивает маппинг между именами полей JSON-представления и свойствами структуры.
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
    let id: Int
    
    /// Имя персонажа.
    let name: String
    /// Пол персонажа.
    let gender: RnMCharacterGenderDTO
    /// Вид (расса) персонажа.
    let species: String
    /// Подвид или особые характеристики персонажа.
    let type: String
    
    /// Текущий статус персонажа.
    let status: RnMCharacterStatusDTO
    
    /// Ссылка на изображение персонажа.
    let imageURL: URL
    
    /// Первоначальное местоположение персонажа.
    let originLocation: RnMLocationShortDTO
    /// Последнее известное местоположение персонажа.
    let lastLocation: RnMLocationShortDTO
    
    /// Список эпизодов, в которых появлялся персонаж.
    let episodesInWhichAppeared: [RnMEpisodeShortDTO]
}
