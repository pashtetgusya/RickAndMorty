import UIKit
import Resources
import UIComponents

// MARK: - Tab bar controller

/// Класс, реализующий таб бар контроллер.
final class TabBarController: UITabBarController { }

// MARK: - Controller life cycle

extension TabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
}

// MARK: - Controller setup functions

extension TabBarController {
    
    /// Выполняет настройку таб бара.
    private func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.tabBarBackgroundColor
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.tabBarItemInactiveColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.tabBarItemInactiveColor,
            NSAttributedString.Key.font: UIFont.preferredFontFixed(forTextStyle: .caption2),
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.tabBarItemActiveColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.tabBarItemActiveColor,
            NSAttributedString.Key.font: UIFont.preferredFontFixed(forTextStyle: .caption1),
        ]
        
        tabBar.isTranslucent = if #available(iOS 26.0, *) { true } else { false }
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    /// Выполняет настройку таб бар айтема вью контроллера.
    /// - Parameters:
    ///   - viewController: вью контроллер у которого настраивается таб бар айтем.
    ///   - item: айтем на основе которого выполняется настройка.
    func setupViewControllerTabItem(
        for viewController: UIViewController,
        item: TabBarController.Item
    ) {
        viewController.tabBarItem.image = item.inactiveIcon
        viewController.tabBarItem.selectedImage = item.activeIcon
        viewController.tabBarItem.tag = item.tag
        viewController.tabBarItem.title = item.title
    }
}
