import UIKit

// MARK: - Rick and Morty characters coordinator

/// Класс, реализующий координатор флоу персонажей.
final class RnMCharactersCoordinator: Coordinator {
    
    // MARK: Properties
    
    /// Контейнер с зависимостями.
    private let diContainer: AppDIContainer
    
    var childCoordinators: [Coordinator] = []
    var navController: UINavigationController?
    
    var didFinish: ((any Coordinator) -> Void)?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter diContainer: контейнер с зависимостями.
    init(di diContainer: AppDIContainer) {
        self.diContainer = diContainer
    }
    
    // MARK: Functions
    
    func start() -> UIViewController {
        let viewController = RnMCharacterListAssembly.build(di: diContainer, coordinator: self)
        let navController  = BaseNavigationController(root: viewController)
        self.navController = navController
        
        return navController
    }
}

// MARK: - Rick and Morty character list coordinator protocol implementation

extension RnMCharactersCoordinator: RnMCharacterListCoordinator {
    
    func presentCharacterFilterView(
        with currentFilter: RnMCharacterFilterModel.CharacterFilter,
        completion: @escaping (RnMCharacterFilterModel.CharacterFilter) -> Void
    ) {
        let viewController = RnMCharacterFilterAssembly.build(with: currentFilter, completion: completion)
        let navController = BaseNavigationController(root: viewController)
        navController.modalPresentationStyle = .pageSheet
        
        self.navController?.present(navController, animated: true)
    }
    
    func presentCharacterInfoView(
        for characterId: Int,
        characterName: String
    ) {
        let viewController = RnMCharacterInfoAssembly.build(
            characterId: characterId,
            characterName: characterName,
            di: diContainer,
            coordinator: self
        )
        
        self.navController?.pushViewController(viewController, animated: true)
    }
}
