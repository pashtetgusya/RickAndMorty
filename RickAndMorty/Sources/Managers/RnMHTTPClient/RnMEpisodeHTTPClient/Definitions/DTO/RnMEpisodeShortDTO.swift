import Foundation

// MARK: - Rick and Morty episode short DTO

/// Структура, описывающая краткое представление эпизода из вселенной `"Rick and Morty"`.
///
/// Используется в случаях, когда API возвращает только ссылку эпизод
/// (список эпизодов, в которых появляется персонаж).
struct RnMEpisodeShortDTO: Decodable {
    
    // MARK: Properties
    
    /// Идентификатор эпизода.
    let id: Int
    
    // MARK: Initialization
    
    /// Создает новый экземпляр структуры.
    /// - Parameter decoder: декодер для извлечения данных.
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let urlString = try container.decode(String.self)
        let idString = (urlString as NSString).lastPathComponent
        
        self.id = Int(idString) ?? 0
    }
}
