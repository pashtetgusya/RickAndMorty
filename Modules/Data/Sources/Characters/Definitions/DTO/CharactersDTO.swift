import Foundation

// MARK: - Characters DTO

/// Структура, описывающая `DTO` объект списока персонажей из вселенной `"Rick and Morty"`.
///
/// Содержит мета-информацию о полном колличестве персонажей и количестве страниц с персонажами,
/// а так-же список персонажей текущей страницы с полной информацией о них.
public struct CharactersDTO: Decodable, Sendable {
    
    // MARK: Codings keys
    
    /// Перечень ключей для декодирования структуры из `JSON`-формата.
    ///
    /// Обеспечивает маппинг между именами полей `JSON`-представления и свойствами структуры.
    private enum CodingKeys: String, CodingKey {
        
        // MARK: Cases
        
        case info
        case list = "results"
    }
    
    // MARK: Properties
    
    /// Мета-информация о списке персонажей.
    public let info: CharactersDTO.Info
    /// Список персонажей текущей страницы.
    ///
    /// Каждый элемент представляет полные данные о персонаже в формате `CharacterDTO`.
    /// Максимальная длина списка составляет 20 элементов.
    public let list: [CharacterDTO]
}
