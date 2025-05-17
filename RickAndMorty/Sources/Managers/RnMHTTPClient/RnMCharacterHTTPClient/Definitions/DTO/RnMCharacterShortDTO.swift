import Foundation

// MARK: - Rick and Morty character short DTO

/// Структура, описывающая краткое представление персонажа из вселенной `"Rick and Morty"`.
///
/// Используется в случаях, когда API возвращает только ссылку на персонажа
/// (список персонажей в локации или эпизоде).
struct RnMCharacterShortDTO: Decodable {
    
    // MARK: Properties
    
    /// Идентификатор персонажа.
    let id: Int
    
    // MARK: Initialization
    
    /// Создает новый экземпля структуры.
    /// - Parameter decoder: декодер для извлечения данных.
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let urlString = try container.decode(String.self)
        let idString = (urlString as NSString).lastPathComponent
        
        self.id = Int(idString) ?? 0
    }
}
