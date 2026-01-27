import UIKit
import Resources

// MARK: - Base navigation controller

/// Класс, реализующий базовый навигационный контроллер.
open class BaseNavigationController: UINavigationController {
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter viewController: корневой вью контроллер.
    public init(root viewController: UIViewController) {
        super.init(rootViewController: viewController)
        
        setupNavigationBar()
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) { nil }
}

// MARK: - Controller setup functions

private extension BaseNavigationController {
    
    /// Выполняет настройку навигейшн бара.
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.textMainColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.textMainColor]
        if #unavailable(iOS 26.0) {
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.navigationBarBackgroundColor
        }
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        navigationBar.isTranslucent = if #available(iOS 26.0, *) { true } else { false }
        navigationBar.prefersLargeTitles = true
        navigationBar.tintAdjustmentMode = .normal
        navigationBar.tintColor = UIColor.applicationTintColor
    }
}
