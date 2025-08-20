import UIKit

// MARK: - Base navigation controller

/// Класс, реализующий базовый навигационный контроллер.
class BaseNavigationController: UINavigationController {
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter viewController: корневой вью контроллер.
    init(root viewController: UIViewController) {
        super.init(rootViewController: viewController)
        
        setupNavigationBar()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Controller setup functions

private extension BaseNavigationController {
    
    /// Выполняет настройку навигейшн бара.
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.navigationBarBackground
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        navigationBar.prefersLargeTitles = true
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.standardAppearance = appearance
        navigationBar.tintColor = UIColor.applicationTint
    }
}
