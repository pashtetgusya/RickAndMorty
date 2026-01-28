import UIKit
import Navigation
import DependencyInjection

// MARK: - Application coodrinator

/// Класс, реализующий интерфейс координатора и
/// являющийся главным координатором приложения.
@MainActor final class AppCoordinator: Sendable {
    
    // MARK: Properties
    
    let diContainer: DIContainer
    var childCoordinators: [Coordinator] = []
    var rootViewController: TabBarController?
    var navController: UINavigationController? { nil }
    var didFinish: ((Coordinator) -> Void)?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter diContainer: контейнер с зависимостями.
    init(di diContainer: DIContainer) {
        self.diContainer = diContainer
    }
}
 
// MARK: - Coordinator protocol implementation

extension AppCoordinator: Coordinator {
    
    func start() -> UIViewController {
        let tabBarController = diContainer.resolve(TabBarController.self)
        rootViewController = tabBarController
        
        return tabBarController
    }
    
    func resetToRoot() -> Self {
        childCoordinators.forEach { $0.resetToRoot(animated: false) }
        rootViewController?.selectedIndex = 0
        
        return self
    }
}
