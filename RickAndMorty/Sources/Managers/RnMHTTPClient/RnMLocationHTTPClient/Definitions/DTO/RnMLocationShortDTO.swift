import Foundation

// MARK: - Rick and Morty location short DTO

/// Структура, описывающая краткое представление локации из вселенной `"Rick and Morty"`.
///
/// Используется в случаях, когда API возвращает только ссылку локацию
/// (первоначальное или последнее известное местоположение персонажа).
struct RnMLocationShortDTO: Decodable {
    
    // MARK: Coding keys
    
    /// Перечень ключей для декодирования структуры из JSON-формата.
    ///
    /// Обеспечивает маппинг между именами полей JSON-представления и свойствами структуры.
    private enum CodingKeys: String, CodingKey {
        
        // MARK: Cases
        
        case name
        case urlString = "url"
    }
    
    // MARK: Properties
    
    /// Идентификатор локации.
    let id: Int
    /// Название локации.
    let name: String
    
    // MARK: Initialization
    
    /// Создает новый экземпляр структуры.
    /// - Parameter decoder: декодер для извлечения данных.
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let urlString = try container.decode(String.self, forKey: .urlString)
        let idString = (urlString as NSString).lastPathComponent
        let name = try container.decode(String.self, forKey: .name)
        
        self.id = Int(idString) ?? 0
        self.name = name
    }
}
