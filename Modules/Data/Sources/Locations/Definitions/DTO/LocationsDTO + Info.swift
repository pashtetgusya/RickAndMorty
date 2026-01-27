import Foundation

// MARK: - Locations info DTO

extension LocationsDTO {
    
    /// Структура, описывающая `DTO` объект мета-информации о списке локаций.
    public struct Info: Decodable, Sendable {
        
        // MARK: Codings keys
        
        /// Перечень ключей для декодирования структуры из `JSON`-формата.
        ///
        /// Обеспечивает маппинг между именами полей `JSON`-представления и свойствами структуры.
        private enum CodingKeys: String, CodingKey {
            
            // MARK: Cases
            
            case totalLocationsCount = "count"
            case totalLocationsPages = "pages"
            case nextLocationsPage = "next"
            case prevLocationsPage = "prev"
        }
        
        // MARK: Properties
        
        /// Общее количество локаций.
        public let totalLocationsCount: Int
        /// Общее количество страниц с локациями.
        ///
        /// На одной странице может быть не более 20 локаций.
        public let totalLocationsPages: Int
        /// `URL` следующей страницы с локациями.
        ///
        /// `nil`, если текущая страница последняя.
        public let nextLocationsPage: URL?
        /// `URL` предыдущей страницы с локациями.
        ///
        /// `nil`, если текущая страница первая.
        public let prevLocationsPage: URL?
    }
}
