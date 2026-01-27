import Foundation

// MARK: - HTTP request constants

/// Константы, используемые в `HTTP`-запросах.
public enum HTTPRequestConstants {
    
    // MARK: Properties
    
    /// Доменное имя для выполнения запросов к `API` `"Rick and Morty"`.
    public static let hostRnM: String = "rickandmortyapi.com"
    /// Тайм-аут выполнения запроса.
    public static let timeoutInterval: TimeInterval = 5
}
