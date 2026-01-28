import UIKit
import Resources

// MARK: - Tab bar controller item

extension TabBarController {
    
    /// Энам, описывающий перечень возможных элементов таб бара.
    enum Item: CaseIterable {
        
        // MARK: Cases
        
        /// Персонажи.
        case characters
        /// Локации.
        case locations
        /// Эпизоды.
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
            case .characters: UIImage.charactersTabBarItemInactiveIcon
            case .locations: UIImage.locationsTabBarItemInactiveIcon
            case .episodes: UIImage.episodesTabBarItemInactiveIcon
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
