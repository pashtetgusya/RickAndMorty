import Foundation

// MARK: - Episode short DTO

/// Структура, описывающая `DTO` объект краткого представления эпизода из вселенной `"Rick and Morty"`.
///
/// Используется в случаях, когда `API` возвращает только ссылку эпизод
/// (список эпизодов, в которых появляется персонаж).
public struct EpisodeShortDTO: Decodable, Sendable {
    
    // MARK: Properties
    
    /// Идентификатор эпизода.
    public let id: Int
    
    // MARK: Initialization
    
    /// Создает новый экземпляр структуры.
    /// - Parameter decoder: декодер для извлечения данных.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let urlString = try container.decode(String.self)
        let idString = (urlString as NSString).lastPathComponent
        
        self.id = Int(idString) ?? 0
    }
}
