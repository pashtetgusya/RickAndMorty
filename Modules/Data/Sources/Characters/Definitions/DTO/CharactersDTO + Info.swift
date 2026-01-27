import Foundation

// MARK: - Characters info DTO

extension CharactersDTO {
    
    /// Структура, описывающая `DTO` объект мета-информации о списке персонажей.
    public struct Info: Decodable, Sendable {
        
        // MARK: Codings keys
        
        /// Перечень ключей для декодирования структуры из `JSON`-формата.
        ///
        /// Обеспечивает маппинг между именами полей `JSON`-представления и свойствами структуры.
        private enum CodingKeys: String, CodingKey {
            
            // MARK: Cases
            
            case totalCharactersCount = "count"
            case totalCharactersPages = "pages"
            case nextCharactersPage = "next"
            case prevCharactersPage = "prev"
        }
        
        // MARK: Properties
        
        /// Общее количество персонажей.
        public let totalCharactersCount: Int
        /// Общее количество страниц с персонажами.
        ///
        /// На одной странице может быть не более 20 персонажей.
        public let totalCharactersPages: Int
        /// `URL` следующей страницы с персонажами.
        ///
        /// `nil`, если текущая страница последняя.
        public let nextCharactersPage: URL?
        /// `URL` предыдущей страницы с персонажами.
        ///
        /// `nil`, если текущая страница первая.
        public let prevCharactersPage: URL?
    }
}
