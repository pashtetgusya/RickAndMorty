import Foundation

// MARK: - Episodes HTTP requst filter

/// Структура, описывающая параметры фильтрации
/// для запроса списка персожаней из вселенной `"Rick and Morty"`.
public struct EpisodesHTTPRequestFilter: Sendable {
    
    // MARK: Properties
    
    /// Номер страницы списка эпизодов.
    let page: Int?
    
    /// Фильтр по названию эпизода.
    let name: String?
    /// Фильтр по коду эпизода.
    let code: String?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр структуры.
    /// - Parameters:
    ///   - page: номер страницы (по умолчанию `nil`).
    ///   - name: название эпизода (по умолчанию `nil`).
    ///   - code: код эпизода (по умолчанию `nil`).
    public init(
        page: Int? = nil,
        name: String? = nil,
        code: String? = nil
    ) {
        self.page = page
        self.name = name
        self.code = code
    }
}
