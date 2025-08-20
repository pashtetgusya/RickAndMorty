import UIKit

// MARK: - Rick and Morty tab bar controller

/// Класс, реализующий таб бар контроллер.
final class RnMTabBarController: UITabBarController { }

// MARK: - Controller life cycle

extension RnMTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
}

// MARK: - Controller setup functions

extension RnMTabBarController {
    
    /// Выполняет настройку таб бара.
    private func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.tabBarBackground
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.tabBarItemInactive
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.tabBarItemInactive,
            NSAttributedString.Key.font: UIFont.preferredFontFixed(forTextStyle: .caption2),
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.tabBarItemActive
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.tabBarItemActive,
            NSAttributedString.Key.font: UIFont.preferredFontFixed(forTextStyle: .caption1),
        ]
        
        tabBar.isTranslucent = false
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    /// Выполняет настройку таб бар айтема вью контроллера.
    /// - Parameters:
    ///   - viewController: вью контроллер у которого настраивается таб бар айтем.
    ///   - item: айтем на основе которого выполняется настройка.
    func setupViewControllerTabItem(
        for viewController: UIViewController,
        item: RnMTabBarController.Item
    ) {
        viewController.tabBarItem.image = item.inactiveIcon
        viewController.tabBarItem.selectedImage = item.activeIcon
        viewController.tabBarItem.tag = item.tag
        viewController.tabBarItem.title = item.title
    }
}
