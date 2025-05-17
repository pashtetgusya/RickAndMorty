import Foundation

// MARK: - Rick and Morty episodes DTO

/// Структура, описывающая список эпизодов из вселенной `"Rick and Morty"`.
///
/// Содержит мета-информацию о полном колличестве эпизодов и количесттве страниц с эпизодами,
/// а так-же список эпизодов текущей страницы с полной информацией о них.
struct RnMEpisodesDTO: Decodable {
    
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
    
    /// Мета-информация о списке эпизодов.
    let info: RnMEpisodesDTO.Info
    /// Список эпизодов текущей страницы.
    ///
    /// Каждый элемент представляет полные данные об эпизоде в формате `RnMEpisodeDTO`.
    /// Максимальная длина списка составляе 20 элементов.
    let list: [RnMEpisodeDTO]
}

// MARK: - Rick and Motry episodes info DTO

extension RnMEpisodesDTO {
    
    /// Структура, описывающая мета-информацию о списке эпизодов.
    struct Info: Decodable {
        
        // MARK: Codings keys
        
        /// Перечень ключей для декодирования структуры из JSON-формата.
        ///
        /// Обеспечивает маппинг между именами полей JSON-представления и свойствами структуры.
        private enum CodingKeys: String, CodingKey {
            
            // MARK: Cases
            
            case totalEpisodesCount = "count"
            case totalEpisodesPages = "pages"
            case nextEpisodesPage = "next"
            case prevEpisodesPage = "prev"
        }
        
        // MARK: Properties
        
        /// Общее количество эпизодов.
        let totalEpisodesCount: Int
        /// Общее количество страниц с эпизодами.
        ///
        /// На одной странице может быть не более 20 эпизодов.
        let totalEpisodesPages: Int
        /// URL следующей страницы с эпизодами.
        ///
        /// `nil`, если текущая страница последняя.
        let nextEpisodesPage: URL?
        /// URL предыдущей страницы с эпизодами.
        ///
        /// `nil`, если текущая страница первая.
        let prevEpisodesPage: URL?
    }
}
