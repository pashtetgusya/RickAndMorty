import UIKit
import Resources
import UIComponents

// MARK: - Episode info collection view model

/// Модель данных коллекции экрана информации об эпизоде из вселенной `"Rick and Morty"`.
enum EpisodeInfoCollectionViewModel {
    
    // MARK: Episode info section
    
    /// Структура, описывающая секцию коллекции информации об эпизоде.
    struct Section: Equatable, Hashable {
        
        // MARK: Properties
        
        /// Тип секции.
        let type: EpisodeInfoCollectionViewModel.Section.`Type`
        /// Перечень ячеек секции.
        let rows: [EpisodeInfoCollectionViewModel.Section.Row]
    }
}

// MARK: - Episode info collection view model section type

extension EpisodeInfoCollectionViewModel.Section {
    
    /// Энам, описывающий перечень возможных вариантов
    /// секций коллекции информации об эпизоде.
    enum `Type`: Int, Equatable, Hashable {
        
        // MARK: Cases
        
        /// Детали об эпизоде.
        case details
        /// Список персонажей, которые встерчаются в эпизоде.
        case characters
        
        // MARK: Properties
        
        /// Описание секции.
        var description: String {
            switch self {
            case .details: "Details"
            case .characters: "Characters"
            }
        }
    }
}

// MARK: - Episode info collection view model section row

extension EpisodeInfoCollectionViewModel.Section {
    
    /// Энам, описывающий перечень возможных ячеек
    /// с информацией об эпизоде.
    enum Row: Parameter {
        
        // MARK: Cases
        
        /// Номер эпизода в сезоне.
        case number(description: String)
        /// Номер сезона.
        case season(description: String)
        /// Дата выхода эпизода.
        case releaseDate(description: String)
        /// Персонаж, который встречается в эпизоде.
        case character(id: Int, description: String)
        
        // MARK: Properties
        
        var icon: Data {
            switch self {
            case .number: UIImage.episodeInfoNumberIcon.pngData() ?? Data()
            case .season: UIImage.episodeInfoSeasionIcon.pngData() ?? Data()
            case .releaseDate: UIImage.episodeInfoReleaseDateIcon.pngData() ?? Data()
            case .character: UIImage.episodeInfoCharacterIcon.pngData() ?? Data()
            }
        }
        var name: String {
            switch self {
            case .number: "Number"
            case .season: "Season"
            case .releaseDate: "Release date"
            case .character: "Character"
            }
        }
        var description: String {
            switch self {
            case .number(let description): description
            case .season(let description): description
            case .releaseDate(let description): description
            case .character(_, let description): description
            }
        }
        var withDisclosureIndicator: Bool {
            switch self {
            case .number, .season, .releaseDate: false
            case .character: true
            }
        }
    }
}
