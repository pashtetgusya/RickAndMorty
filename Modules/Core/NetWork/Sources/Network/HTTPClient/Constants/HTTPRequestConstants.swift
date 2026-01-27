import Foundation

// MARK: - HTTP request constants

/// Константы, используемые в `HTTP`-запросах.
enum HTTPRequestConstants {
    
    // MARK: Properties
    
    /// Доменное имя для выполнения запросов к `API` `"Rick and Morty"`.
    static let hostRnM: String = "rickandmortyapi.com"
    /// Тайм-аут выполнения запроса.
    static let timeoutInterval: TimeInterval = 5
}
