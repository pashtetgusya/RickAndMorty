import UIKit

// MARK: - Application coodrinator

/// Класс, реалищующий интерфейс координатора `UITabBarController'а` и
/// являющийся главным координатором приложения.
final class AppCoordinator: TabBarCoordinator {
    
    // MARK: Properties
    
    /// Контейнер с зависимостями.
    ///
    /// Хранит в себе зависимости,
    /// используемыми для конфигурации экранов.
    private let diContainer: AppDIContainer
    
    var charactersCoordinator: Coordinator?
    var locationsCoordinator: Coordinator?
    var episodesCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: UITabBarController?
    var navController: UINavigationController? { nil }
    
    var didFinish: ((Coordinator) -> Void)?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter diContainer: контейнер с зависимостями.
    init(di diContainer: AppDIContainer) {
        self.diContainer = diContainer
    }
    
    // MARK: Functions
    
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
        charactersCoordinator?.resetToRoot(animated: false)
        locationsCoordinator?.resetToRoot(animated: true)
        episodesCoordinator?.resetToRoot(animated: false)
        rootViewController?.selectedIndex = 0
        
        return self
    }
}

// MARK: - Coordinator support functions

private extension AppCoordinator {
    
    /// Запускает поток координатора персонажей.
    func startCharactersCoordinator() -> UIViewController {
        // let coordinator: Coordinator = RnMCharactersCoordinator(di: diContainer)
        // coordinator.didFinish = { [weak self] coordinator in
        //     self?.removeChild(coordinator)
        // }
        // addChild(coordinator)
        
        let viewController = UIViewController() // coordinator.start()
        // charactersCoordinator = coordinator
        (rootViewController as? RnMTabBarController)?
            .setupViewControllerTabItem(for: viewController, item: .characters)
        
        return viewController
    }
    
    /// Запускает поток координатора локаций.
    func startLocationsCoordinator() -> UIViewController {
        // let coordinator: Coordinator = RnMLocationsCoodrinator(di: diContainer)
        // coordinator.didFinish = { [weak self] coordinator in
        //     self?.removeChild(coordinator)
        // }
        // addChild(coordinator)
        
        let viewController = UIViewController() // coordinator.start()
        // locationsCoordinator = coordinator
        (rootViewController as? RnMTabBarController)?
            .setupViewControllerTabItem(for: viewController, item: .locations)
        
        return viewController
    }
    
    /// Запускает поток координатора эпизодов.
    func startEpisodesCoordinator() -> UIViewController {
        // let coordinator: Coordinator = RnMEpisodesCoodrinator(di: diContainer)
        // coordinator.didFinish = { [weak self] coordinator in
        //     self?.removeChild(coordinator)
        // }
        // addChild(coordinator)
        
        let viewController = UIViewController() // coordinator.start()
        // locationsCoordinator = coordinator
        (rootViewController as? RnMTabBarController)?
            .setupViewControllerTabItem(for: viewController, item: .episodes)
        
        return viewController
    }
}
