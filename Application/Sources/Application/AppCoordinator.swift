import UIKit
import UIComponents
import Navigation
import DependencyInjection
import Characters

// MARK: - Application coodrinator

/// Класс, реализующий интерфейс координатора и
/// являющийся главным координатором приложения.
@MainActor final class AppCoordinator: Sendable {
    
    // MARK: Properties
    
    let diContainer: DIContainer
    var childCoordinators: [Coordinator] = []
    var navController: UINavigationController
    var didFinish: ((Coordinator) -> Void)?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter diContainer: контейнер с зависимостями.
    /// - Parameter navController: навигационный контроллер.
    init(
        di diContainer: DIContainer,
        navController: UINavigationController
    ) {
        self.diContainer = diContainer
        self.navController = navController
    }
}
 
// MARK: - Coordinator protocol implementation

extension AppCoordinator: Coordinator {
    
    func start() {
        let charactersNavController = BaseNavigationController()
        let charactersCoordinator = diContainer.resolve(
            CharactersCoordinator.self,
            args: charactersNavController
        )
        
        let tabBarController = diContainer.resolve(TabBarController.self)
        tabBarController.setupViewControllerTabItem(for: charactersNavController, item: .characters)
        tabBarController.viewControllers = [charactersNavController]
        
        navController.setNavigationBarHidden(true, animated: false)
        navController.viewControllers = [tabBarController]
        
        childCoordinators = [charactersCoordinator]
        childCoordinators.forEach { $0.start() }
    }
    
    func resetToRoot() -> Self {
        childCoordinators.forEach { $0.resetToRoot(animated: false) }
        (navController.viewControllers.first as? TabBarController)?.selectedIndex = 0
        
        return self
    }
}
