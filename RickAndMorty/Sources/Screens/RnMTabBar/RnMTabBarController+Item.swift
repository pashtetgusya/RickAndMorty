import UIKit

// MARK: - Rick and Morty tab bar controller item

extension RnMTabBarController {
    
    /// Перечень элементов таб бара.
    enum Item: CaseIterable {
        
        // MARK: Cases
        
        case characters
        case locations
        case episodes
        
        // MARK: Properties
        
        /// Иконка активного айтема таб бара.
        var activeIcon: UIImage {
            switch self {
            case .characters: UIImage.charactersTabBarItemActiveIcon
            case .locations: UIImage.locationsTabBarItemActiveIcon
            case .episodes: UIImage.episodesTabBarItemActiveIcon
            }
        }
        /// Иконка неактивного айтема таб бара.
        var inactiveIcon: UIImage {
            switch self {
            case .characters: UIImage.charactersTabBarItermInactiveIcon
            case .locations: UIImage.locationsTabBarItemInactiveIcon
            case .episodes: UIImage.episodesTabBarItermInactiveIcon
            }
        }
        /// Тэг айтема таб бара.
        var tag: Int {
            switch self {
            case .characters: 0
            case .locations: 1
            case .episodes: 2
            }
        }
        /// Заголовок айтема таб бара.
        var title: String {
            switch self {
            case .characters: "Characters"
            case .locations: "Locations"
            case .episodes: "Episodes"
            }
        }
    }
}
