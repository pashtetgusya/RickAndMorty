import Foundation

// MARK: - Rick and Morty locations DTO

/// Структура, описывающая список локаций из вселенной `"Rick and Morty"`.
///
/// Содержит мета-информацию о полном колличестве локаций и количесттве страниц с локациями,
/// а так-же список локаций текущей страницы с полной информацией о них.
struct RnMLocationsDTO: Decodable {
    
    // MARK: Codings keys
    
    /// Перечень ключей для декодирования структуры из JSON-формата.
    ///
    /// Обеспечивает маппинг между именами полей JSON-представления и свойствами структуры.
    private enum CodingKeys: String, CodingKey {
        
        // MARK: Cases
        
        case info
        case list = "results"
    }
    
    // MARK: Properties
    
    /// Мета-информация о списке локаций.
    let info: RnMLocationsDTO.Info
    /// Список локаций текущей страницы.
    ///
    /// Каждый элемент представляет полные данные о локации в формате `RnMLocationDTO`.
    /// Максимальная длина списка составляе 20 элементов.
    let list: [RnMLocationDTO]
}

// MARK: - Rick and Motry locations info DTO

extension RnMLocationsDTO {
    
    /// Структура, описывающая мета-информацию о списке локаций.
    struct Info: Decodable {
        
        // MARK: Codings keys
        
        /// Перечень ключей для декодирования структуры из JSON-формата.
        ///
        /// Обеспечивает маппинг между именами полей JSON-представления и свойствами структуры.
        private enum CodingKeys: String, CodingKey {
            
            // MARK: Cases
            
            case totalLocationsCount = "count"
            case totalLocationsPages = "pages"
            case nextLocationsPage = "next"
            case prevLocationsPage = "prev"
        }
        
        // MARK: Properties
        
        /// Общее количество локаций.
        let totalLocationsCount: Int
        /// Общее количество страниц с локациями.
        ///
        /// На одной странице может быть не более 20 локаций.
        let totalLocationsPages: Int
        /// URL следующей страницы с локациями.
        ///
        /// `nil`, если текущая страница последняя.
        let nextLocationsPage: URL?
        /// URL предыдущей страницы с локациями.
        ///
        /// `nil`, если текущая страница первая.
        let prevLocationsPage: URL?
    }
}
