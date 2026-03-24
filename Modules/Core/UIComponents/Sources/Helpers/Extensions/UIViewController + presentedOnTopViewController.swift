import UIKit

// MARK: - UI view controller presented on top view controller

public extension UIViewController {
    
    /// Верхний вью контроллер в иерархии представления.
    var presentedOnTopViewController: UIViewController? {
        guard let presentedViewController else { return self }
        
        switch presentedViewController {
        case let navController as UINavigationController:
            return navController.visibleViewController?.presentedOnTopViewController
        case let tabBarController as UITabBarController:
            return tabBarController.selectedViewController?.presentedOnTopViewController
        
        default: return nil
        }
    }
}
