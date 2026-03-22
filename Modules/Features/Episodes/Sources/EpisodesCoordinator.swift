import UIKit
import UIComponents
import Navigation
import DependencyInjection

// MARK: - Episodes coordinator

/// Класс, реализующий координатор модуля эпизодов из вселенной `"Rick and Morty"`.
@MainActor public final class EpisodesCoordinator {
    
    // MARK: Properties
    
    public let diContainer: DIContainer
    public var childCoordinators: [Coordinator]
    public let navController: UINavigationController
    public var didFinish: ((Coordinator) -> Void)?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter diContainer: контейнер с зависимостями.
    /// - Parameter navController: навигационный контроллер.
    public init(
        di diContainer: DIContainer,
        navController: UINavigationController
    ) {
        self.diContainer = diContainer
        self.navController = navController
        self.childCoordinators = []
    }
}

// MARK: - Coordinator protocol implementation

extension EpisodesCoordinator: Coordinator {
    
    public func start() {
        let viewController = diContainer.resolve(EpisodeListViewController.self)
        navController.pushViewController(viewController, animated: true)
    }
}

// MARK: - Episode list coordinator protocol implementation

extension EpisodesCoordinator: EpisodeListCoordinator {
    
    func presentEpisodeInfoView(for episodeId: Int) { }
}
