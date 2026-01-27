import UIKit
import Resources
import UIComponents

// MARK: - Character info table view model

/// Модель данных таблицы экрана информации о персонаже из вселенной `"Rick and Morty"`.
enum CharacterInfoTableViewModel {
    
    // MARK: Character info section
    
    /// Структура, описывающая секцию таблицы информации о персонаже.
    struct Section: Equatable, Hashable {
        
        // MARK: Properties
        
        /// Тип секции.
        let type: CharacterInfoTableViewModel.Section.`Type`
        /// Перечень ячеек секции.
        let rows: [CharacterInfoTableViewModel.Section.Row]
    }
}

// MARK: - Character info table view model section type

extension CharacterInfoTableViewModel.Section {
    
    /// Энам, описывающий перечень возможных вариантов
    /// секций таблцы информации о персонаже.
    enum `Type`: Int, Equatable, Hashable {
        
        // MARK: Cases
        
        /// Детали о персонаже.
        case details
        /// Список эпизодов в которых встречался персонаж.
        case episodes
    }
}

// MARK: - Character info table view model section row

extension CharacterInfoTableViewModel.Section {
    
    /// Энам, описывающий перечень возможных ячеек с информацией о персонаже.
    enum Row: Parameter {
        
        // MARK: Cases
        
        /// Статус персонажа.
        case status(description: String)
        /// Пол персонажа.
        case gender(description: String)
        /// Локация происхождения персонажа.
        case originLocation(description: String)
        /// Последнее известное местоположение персонажа.
        case lastLocation(description: String)
        /// Эпизод в котором встречается персонаж.
        case episode(description: String)
        
        // MARK: Properties
        
        var icon: Data {
            switch self {
            case .status: UIImage.characterInfoStatusIcon.pngData() ?? Data()
            case .gender: UIImage.characterInfoGenderIcon.pngData() ?? Data()
            case .originLocation: UIImage.characterInfoOriginLocationIcon.pngData() ?? Data()
            case .lastLocation: UIImage.characterInfoLastLocationIcon.pngData() ?? Data()
            case .episode: UIImage.characterInfoEpisodeIcon.pngData() ?? Data()
            }
        }
        var name: String {
            switch self {
            case .status: "Status"
            case .gender: "Gender"
            case .originLocation: "Origin"
            case .lastLocation: "Location"
            case .episode: "Episode"
            }
        }
        var description: String {
            switch self {
            case .status(let description): description
            case .gender(let description): description
            case .originLocation(let description): description
            case .lastLocation(let description): description
            case .episode(let description): description
            }
        }
    }
}
