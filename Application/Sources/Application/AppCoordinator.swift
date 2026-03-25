import UIKit
import UIComponents
import Navigation
import DependencyInjection
import Characters
import Episodes

// MARK: - Application coodrinator

/// Класс, реализующий интерфейс координатора и
/// являющийся главным координатором приложения.
@MainActor final class AppCoordinator: NSObject, Sendable {
    
    // MARK: Properties
    
    let diContainer: DIContainer
    var childCoordinators: [Coordinator] = []
    let navController: UINavigationController
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
        
        super.init()
        
        self.navController.delegate = self
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
        charactersCoordinator.didFinish = { [weak self] coordinator in
            self?.childCoordinators.removeAll { $0 === coordinator }
        }
        
        let episodesNavController = BaseNavigationController()
        let episodesCoordinator = diContainer.resolve(
            EpisodesCoordinator.self,
            args: episodesNavController
        )
        episodesCoordinator.didFinish = { [weak self] coordinator in
            self?.childCoordinators.removeAll { $0 === coordinator }
        }
        
        charactersCoordinator.presentEpisodeInfoView = { [weak episodesCoordinator] episodeId in
            episodesCoordinator?.presentEpisodeInfoSheetView(for: episodeId)
        }
        episodesCoordinator.presentCharacterInfoView = { [weak charactersCoordinator] characterId in
            charactersCoordinator?.presentCharacterInfoSheetView(for: characterId)
        }
        
        let tabBarController = diContainer.resolve(TabBarController.self)
        tabBarController.setupViewControllerTabItem(for: charactersNavController, item: .characters)
        tabBarController.setupViewControllerTabItem(for: episodesNavController, item: .episodes)
        tabBarController.viewControllers = [charactersNavController, episodesNavController]
        
        navController.setNavigationBarHidden(true, animated: false)
        navController.viewControllers = [tabBarController]
        
        childCoordinators = [charactersCoordinator, episodesCoordinator]
        childCoordinators.forEach { $0.start() }
    }
    
    func resetToRoot() -> Self {
        childCoordinators.forEach { $0.resetToRoot(animated: false) }
        (navController.viewControllers.first as? TabBarController)?.selectedIndex = 0
        
        return self
    }
}

// MARK: - UI navigation controller delegate protocol implementation

extension AppCoordinator: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        guard
            let transitionCoordinator = navigationController.transitionCoordinator,
            let fromViewController = transitionCoordinator.viewController(forKey: .from),
            !navigationController.viewControllers.contains(fromViewController)
        else { return }
        
        if fromViewController is TabBarController {
            childCoordinators.forEach { $0.didFinish?($0) }
        }
    }
}
