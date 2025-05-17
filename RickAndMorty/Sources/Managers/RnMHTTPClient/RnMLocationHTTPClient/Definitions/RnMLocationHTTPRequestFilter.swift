import Foundation

// MARK: - Rick and Morty location HTTP request filter

/// Структура, описывающая параметры фильтрации
/// для запроса списка локаций из вселенной `"Rick and Morty"`.
struct RnMLocationHTTPRequestFilter {
    
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
    init(
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
