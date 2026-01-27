import Foundation

// MARK: - Episodes info DTO

extension EpisodesDTO {
    
    /// Структура, описывающая `DTO` объект мета-информации о списке эпизодов.
    public struct Info: Decodable, Sendable {
        
        // MARK: Codings keys
        
        /// Перечень ключей для декодирования структуры из `JSON`-формата.
        ///
        /// Обеспечивает маппинг между именами полей `JSON`-представления и свойствами структуры.
        private enum CodingKeys: String, CodingKey {
            
            // MARK: Cases
            
            case totalEpisodesCount = "count"
            case totalEpisodesPages = "pages"
            case nextEpisodesPage = "next"
            case prevEpisodesPage = "prev"
        }
        
        // MARK: Properties
        
        /// Общее количество эпизодов.
        public let totalEpisodesCount: Int
        /// Общее количество страниц с эпизодами.
        ///
        /// На одной странице может быть не более 20 эпизодов.
        public let totalEpisodesPages: Int
        /// `URL` следующей страницы с эпизодами.
        ///
        /// `nil`, если текущая страница последняя.
        public let nextEpisodesPage: URL?
        /// `URL` предыдущей страницы с эпизодами.
        ///
        /// `nil`, если текущая страница первая.
        public let prevEpisodesPage: URL?
    }
}
