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
    /// Замыкание, которое будет вызвано при срабатывании триггера
    /// отображения экрана информации о персожане.
    public var presentCharacterInfoView: ((Int) -> Void)?
    
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
    
    public func presentEpisodeInfoSheetView(for episodeId: Int) {
        let viewController = diContainer.resolve(EpisodeInfoViewController.self, args: episodeId)
        viewController.navigationItem.leftBarButtonItem = .init(
            systemItem: .close,
            primaryAction: .init { [weak viewController] _ in
                viewController?.dismiss(animated: true)
            }
        )
        let episodeNavController = BaseNavigationController(root: viewController)
        episodeNavController.modalPresentationStyle = .pageSheet
        navController.presentedOnTopViewController?.present(episodeNavController, animated: true)
    }
}

// MARK: - Episode list coordinator protocol implementation

extension EpisodesCoordinator: EpisodeListCoordinator {
    
    func presentEpisodeInfoView(for episodeId: Int) {
        let viewController = diContainer.resolve(EpisodeInfoViewController.self, args: episodeId)
        navController.pushViewController(viewController, animated: true)
    }
}

// MARK: - Episode info coordinator protocol implementation

extension EpisodesCoordinator: EpisodeInfoCoordinator {
    
    func presentCharacterInfoView(for characterId: Int) {
        presentCharacterInfoView?(characterId)
    }
}
