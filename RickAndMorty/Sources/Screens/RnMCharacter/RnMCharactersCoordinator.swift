import UIKit

// MARK: - Rick and Morty characters coordinator

/// Класс, реализующий координатор флоу персонажей из вселенной `"Rick and Morty"`.
final class RnMCharactersCoordinator: Coordinator {
    
    // MARK: Properties
    
    let diContainer: DIContainer
    var childCoordinators: [Coordinator]
    var navController: UINavigationController?
    
    var didFinish: ((Coordinator) -> Void)?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter diContainer: контейнер с зависимостями.
    init(di diContainer: DIContainer) {
        self.diContainer = diContainer
        self.childCoordinators = []
    }
    
    // MARK: Coordinator protocol implementation
    
    func start() -> UIViewController {
        let viewController = diContainer.resolve(RnMCharacterListViewController.self)
        let navController = BaseNavigationController(root: viewController)
        self.navController = navController
        
        return navController
    }
}

// MARK: - Rick and Morty character list coordinator protocol implementation

extension RnMCharactersCoordinator: RnMCharacterListCoordinator {
    
    func presentCharacterFilterView(
        with currentFilter: RnMCharacterFilterModel.CharacterFilter,
        completion: @MainActor @escaping (RnMCharacterFilterModel.CharacterFilter) -> Void
    ) {
        let viewController = diContainer.resolve(RnMCharacterFilterViewController.self, args: (currentFilter, completion))
        let navController = BaseNavigationController(root: viewController)
        navController.modalPresentationStyle = .pageSheet
        
        self.navController?.present(navController, animated: true)
    }
    
    func presentCharacterInfoView(for characterId: Int) {
        let viewController = diContainer.resolve(RnMCharacterInfoViewController.self, args: characterId)
        
        self.navController?.pushViewController(viewController, animated: true)
    }
}
