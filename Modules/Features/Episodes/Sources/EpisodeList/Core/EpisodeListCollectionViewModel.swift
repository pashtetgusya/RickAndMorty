import Foundation
import Domain

// MARK: - Episode list collection view model

/// Модель данных коллекции экрана списка эпизодов из вселенной `"Rick and Morty"`.
enum EpisodeListCollectionViewModel {
    
    // MARK: Episode list section
    
    /// Структура, описывающая секцию коллекции списка эпизодов.
    struct Section: Equatable, Hashable {
        
        // MARK: Properties
        
        /// Тип секции.
        let type: EpisodeListCollectionViewModel.Section.`Type`
        /// Перечень ячеек секции.
        let rows: [EpisodeListCollectionViewModel.Section.Row]
    }
}

// MARK: - Episode list collection view model section type

extension EpisodeListCollectionViewModel.Section {
    
    /// Энам, описывающий перечень возможных вариантов
    /// секций коллекции списка эпизодов.
    enum `Type`: Equatable, Hashable {
        
        // MARK: Cases
        
        /// Список эпизодов сезона.
        case episodes(season: Int)
        
        // MARK: Properties
        
        /// Заголовок секции.
        var title: String {
            switch self {
            case .episodes(let season): "Season \(season)"
            }
        }
    }
}

// MARK: - Episode list collection view model section row

extension EpisodeListCollectionViewModel.Section {
    
    /// Структура, описывающая ячейку коллекции списка эпизодов.
    typealias Row = Episode
}
