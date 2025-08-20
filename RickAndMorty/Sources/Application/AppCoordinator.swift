import UIKit

// MARK: - Application coodrinator

/// Класс, реалищующий интерфейс координатора и
/// являющийся главным координатором приложения.
final class AppCoordinator: Coordinator {
    
    // MARK: Properties
    
    let diContainer: DIContainer
    var childCoordinators: [Coordinator] = []
    var rootViewController: RnMTabBarController?
    var navController: UINavigationController? { nil }
    
    var didFinish: ((Coordinator) -> Void)?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter diContainer: контейнер с зависимостями.
    init(di diContainer: DIContainer) {
        self.diContainer = diContainer
    }
    
    // MARK: Coordinator protocol implementation
    
    func start() -> UIViewController {
        let tabBarController = RnMTabBarController()
        rootViewController = tabBarController
        tabBarController.viewControllers = [
            startCharactersCoordinator(),
            startLocationsCoordinator(),
            startEpisodesCoordinator(),
        ]
        
        return tabBarController
    }
    
    func resetToRoot() -> Self {
        childCoordinators.forEach { $0.resetToRoot(animated: false) }
        rootViewController?.selectedIndex = 0
        
        return self
    }
}

// MARK: - Coordinator support functions

private extension AppCoordinator {
    
    /// Выполняет запуск потока координатора персонажей.
    func startCharactersCoordinator() -> UIViewController {
        let coordinator = diContainer.resolve(RnMCharactersCoordinator.self)
        coordinator.didFinish = { [weak self] coordinator in
            self?.removeChild(coordinator)
        }
        addChild(coordinator)
        
        let viewController = coordinator.start()
        rootViewController?.setupViewControllerTabItem(for: viewController, item: .characters)
        
        return viewController
    }
    
    /// Выполняет запуск потока координатора локаций.
    func startLocationsCoordinator() -> UIViewController {
        // let coordinator: Coordinator = RnMLocationsCoodrinator(di: diContainer)
        // coordinator.didFinish = { [weak self] coordinator in
        //     self?.removeChild(coordinator)
        // }
        // addChild(coordinator)
        
        let viewController = UIViewController() // coordinator.start()
        rootViewController?.setupViewControllerTabItem(for: viewController, item: .locations)
        
        return viewController
    }
    
    /// Выполняет запуск потока координатора эпизодов.
    func startEpisodesCoordinator() -> UIViewController {
        // let coordinator: Coordinator = RnMEpisodesCoodrinator(di: diContainer)
        // coordinator.didFinish = { [weak self] coordinator in
        //     self?.removeChild(coordinator)
        // }
        // addChild(coordinator)
        
        let viewController = UIViewController() // coordinator.start()
        //
        rootViewController?.setupViewControllerTabItem(for: viewController, item: .episodes)
        
        return viewController
    }
}
