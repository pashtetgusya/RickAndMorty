import Foundation

// MARK: - Locations DTO

/// Структура, описывающая `DTO` объект списока локаций из вселенной `"Rick and Morty"`.
///
/// Содержит мета-информацию о полном колличестве локаций и количесттве страниц с локациями,
/// а так-же список локаций текущей страницы с полной информацией о них.
public struct LocationsDTO: Decodable, Sendable {
    
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
    
    /// Мета-информация о списке локаций.
    public let info: LocationsDTO.Info
    /// Список локаций текущей страницы.
    ///
    /// Каждый элемент представляет полные данные о локации в формате `RnMLocationDTO`.
    /// Максимальная длина списка составляе 20 элементов.
    public let list: [LocationDTO]
}
