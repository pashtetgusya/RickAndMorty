import Foundation

// MARK: - Locations HTTP request filter

/// Структура, описывающая параметры фильтрации
/// для запроса списка локаций из вселенной `"Rick and Morty"`.
public struct LocationsHTTPRequestFilter: Sendable {
    
    // MARK: Properties
    
    /// Номер страницы списка локаций.
    let page: Int?
    /// Фильтр по названию локации.
    let name: String?
    /// Фильтр по типу локации.
    let type: String?
    /// Фильтр по измерению (галлактике) в котором находится локация.
    let dimension: String?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр структуры.
    /// - Parameters:
    ///   - page: номер страницы (по умолчанию `nil`).
    ///   - name: название локации (по умолчанию `nil`).
    ///   - type: тип локации (по умолчанию `nil`).
    ///   - dimension: измерение (галлактика) в котором находится локация (по умолчанию `nil`).
    public init(
        page: Int? = nil,
        name: String? = nil,
        type: String? = nil,
        dimension: String? = nil
    ) {
        self.page = page
        self.name = name
        self.type = type
        self.dimension = dimension
    }
}
