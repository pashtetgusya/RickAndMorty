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
    public var didFinish: ((Coordinator) -> Void)?
    public var navController: UINavigationController?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter diContainer: контейнер с зависимостями.
    public init(di diContainer: DIContainer) {
        self.diContainer = diContainer
        self.childCoordinators = []
    }
}

// MARK: - Coordinator protocol implementation

extension CharactersCoordinator: Coordinator {
    
    @discardableResult public func start() -> UIViewController {
        let viewController = diContainer.resolve(CharacterListViewController.self)
        let navController = BaseNavigationController(root: viewController)
        self.navController = navController
        
        return navController
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
        let navController = BaseNavigationController(root: viewController)
        navController.modalPresentationStyle = .pageSheet
        
        self.navController?.present(navController, animated: true)
    }
    
    func presentCharacterInfoView(for characterId: Int) {
        let viewController = diContainer.resolve(
            CharacterInfoViewController.self,
            args: characterId
        )
        
        self.navController?.pushViewController(viewController, animated: true)
    }
}
