import UIKit
import UIComponents
import Navigation
import DependencyInjection

// MARK: - Characters coordinator

/// Класс, реализующий координатор модуля персонажей из вселенной `"Rick and Morty"`.
@MainActor public final class CharactersCoordinator {
    
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

extension CharactersCoordinator: Coordinator {
    
    public func start() {
        let viewController = diContainer.resolve(CharacterListViewController.self)
        navController.pushViewController(viewController, animated: true)
    }
    
    /// Выполняет отображение модального экрана с информацией о персонаже.
    /// - Parameter characterId: идентификатор персонажа
    public func presentCharacterInfoSheetView(for characterId: Int) {
        let viewController = diContainer.resolve(CharacterInfoViewController.self, args: characterId)
        viewController.navigationItem.leftBarButtonItem = .init(
            systemItem: .close,
            primaryAction: .init { [weak viewController] _ in
                viewController?.dismiss(animated: true)
            }
        )
        let characterNavController = BaseNavigationController(root: viewController)
        characterNavController.modalPresentationStyle = .pageSheet
        
        navController.present(characterNavController, animated: true)
    }
}

// MARK: - Character list coordinator protocol implementation

extension CharactersCoordinator: CharacterListCoordinator {
    
    func presentCharacterFilterView(
        with currentFilter: CharacterFilterTableViewModel.CharacterFilter,
        completion: @escaping @Sendable (CharacterFilterTableViewModel.CharacterFilter) -> Void
    ) {
        let viewController = diContainer.resolve(
            CharacterFilterViewController.self,
            args: (currentFilter, completion)
        )
        let filterNavController = BaseNavigationController(root: viewController)
        filterNavController.modalPresentationStyle = .pageSheet
        navController.present(filterNavController, animated: true)
    }
    
    func presentCharacterInfoView(for characterId: Int) {
        let viewController = diContainer.resolve(
            CharacterInfoViewController.self,
            args: characterId
        )
        navController.pushViewController(viewController, animated: true)
    }
}
