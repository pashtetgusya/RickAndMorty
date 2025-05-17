import Foundation

// MARK: - Rick and Morty characters DTO

/// Структура, описывающая список персонажей из вселенной `"Rick and Morty"`.
///
/// Содержит мета-информацию о полном колличестве персонажей и количестве страниц с персонажами,
/// а так-же список персонажей текущей страницы с полной информацией о них.
struct RnMCharactersDTO: Decodable {
    
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
    
    /// Мета-информация о списке персонажей.
    let info: RnMCharactersDTO.Info
    /// Список персонажей текущей страницы.
    ///
    /// Каждый элемент представляет полные данные о персонаже в формате `RnMCharacterDTO`.
    /// Максимальная длина списка составляет 20 элементов.
    let list: [RnMCharacterDTO]
}

// MARK: - Rick and Motry characters info DTO

extension RnMCharactersDTO {
    
    /// Структура, описывающая мета-информацию о списке персонажей.
    struct Info: Decodable {
        
        // MARK: Codings keys
        
        /// Перечень ключей для декодирования структуры из JSON-формата.
        ///
        /// Обеспечивает маппинг между именами полей JSON-представления и свойствами структуры.
        private enum CodingKeys: String, CodingKey {
            
            // MARK: Cases
            
            case totalCharactersCount = "count"
            case totalCharactersPages = "pages"
            case nextCharactersPage = "next"
            case prevCharactersPage = "prev"
        }
        
        // MARK: Properties
        
        /// Общее количество персонажей.
        let totalCharactersCount: Int
        /// Общее количество страниц с персонажами.
        ///
        /// На одной странице может быть не более 20 персонажей.
        let totalCharactersPages: Int
        /// URL следующей страницы с персонажами.
        ///
        /// `nil`, если текущая страница последняя.
        let nextCharactersPage: URL?
        /// URL предыдущей страницы с персонажами.
        ///
        /// `nil`, если текущая страница первая.
        let prevCharactersPage: URL?
    }
}
