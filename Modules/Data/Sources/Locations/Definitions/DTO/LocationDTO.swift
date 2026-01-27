import Foundation

// MARK: - Location DTO

/// Структура, описывающая `DTO` объект локации из вселенной `"Rick and Morty"`.
///
/// Содержит полную информацию о локации, включая тип,
/// измерение (галлактику) в котором находится локация и
/// персонажей, находящихся на данной локации.
public struct LocationDTO: Decodable, Sendable {
    
    // MARK: Codings keys
    
    /// Перечень ключей для декодирования структуры из `JSON`-формата.
    ///
    /// Обеспечивает маппинг между именами полей `JSON`-представления и свойствами структуры.
    private enum CodingKeys: String, CodingKey {
        
        // MARK: Cases
        
        case id
        case name
        case type
        case dimension
        case residents
    }
    
    // MARK: Properties
    
    /// Идентификатор локации.
    public let id: Int
    /// Название локации.
    public let name: String
    /// Тип локации.
    public let type: String // LocationTypeDTO
    /// Измерение (галлактика) в котором находится локация.
    public let dimension: String
    /// Список персонажей, находящихся в локации.
    public let residents: [CharacterShortDTO]
}
