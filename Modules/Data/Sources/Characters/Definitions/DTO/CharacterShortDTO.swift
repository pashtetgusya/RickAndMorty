import Foundation

// MARK: - Character short DTO

/// Структура, описывающая `DTO` объект краткого представления персонажа из вселенной `"Rick and Morty"`.
///
/// Используется в случаях, когда `API` возвращает только ссылку на персонажа
/// (список персонажей в локации или эпизоде).
public struct CharacterShortDTO: Decodable, Sendable {
    
    // MARK: Properties
    
    /// Идентификатор персонажа.
    public let id: Int
    
    // MARK: Initialization
    
    /// Создает новый экземпля структуры.
    /// - Parameter decoder: декодер для извлечения данных.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let urlString = try container.decode(String.self)
        let idString = (urlString as NSString).lastPathComponent
        
        self.id = Int(idString) ?? 0
    }
}
