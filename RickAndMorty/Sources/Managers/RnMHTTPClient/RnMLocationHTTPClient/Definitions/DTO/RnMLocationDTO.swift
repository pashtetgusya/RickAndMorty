import Foundation

// MARK: - Rick and Morty location DTO

/// Структура, описывающая локацию из вселенной `"Rick and Morty"`.
///
/// Содержит полную информацию о локации, включая тип,
/// измерение (галлактику) в котором находится локация и
/// персонажей, находящихся на данной локации.
struct RnMLocationDTO: Decodable {
    
    // MARK: Codings keys
    
    /// Перечень ключей для декодирования структуры из JSON-формата.
    ///
    /// Обеспечивает маппинг между именами полей JSON-представления и свойствами структуры.
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
    let id: Int
    
    /// Название локации.
    let name: String
    /// Тип локации.
    let type: String
    /// Измерение (галлактика) в котором находится локация.
    let dimension: String
    
    /// Список персонажей, находящихся в локации.
    let residents: [RnMCharacterShortDTO]
}
