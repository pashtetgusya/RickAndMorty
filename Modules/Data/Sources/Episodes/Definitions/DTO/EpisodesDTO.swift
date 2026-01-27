import Foundation

// MARK: - Episodes DTO

/// Структура, описывающая `DTO` объект списока эпизодов из вселенной `"Rick and Morty"`.
///
/// Содержит мета-информацию о полном колличестве эпизодов и количесттве страниц с эпизодами,
/// а так-же список эпизодов текущей страницы с полной информацией о них.
public struct EpisodesDTO: Decodable, Sendable {
    
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
    
    /// Мета-информация о списке эпизодов.
    public let info: EpisodesDTO.Info
    /// Список эпизодов текущей страницы.
    ///
    /// Каждый элемент представляет полные данные об эпизоде в формате `EpisodeDTO`.
    /// Максимальная длина списка составляе 20 элементов.
    public let list: [EpisodeDTO]
}
