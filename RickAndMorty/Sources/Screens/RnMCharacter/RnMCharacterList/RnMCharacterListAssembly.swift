import UIKit

// MARK: - Rick and Morty character list assembly

/// Класс, отвечающий за создание вью контроллер
/// списка персонажей из вселенной `"Rick and Morty"`.
@MainActor final class RnMCharacterListAssembly {
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    private init() { }
    
    // MARK: Build function
    
    /// Создает вью контроллер списка персонажей из вселенной `"Rick and Morty"`.
    /// - Parameters:
    ///   - diContainer: контейнер с зависимостями.
    ///   - coordinator: координатор для навигации.
    /// - Returns: вью контроллер.
    static func build(
        di diContainer: AppDIContainer,
        coordinator: RnMCharacterListCoordinator
    ) -> UIViewController {
        let diContainer = RnMCharacterListDIContainer(di: diContainer)
        let viewModel = RnMCharacterListViewModel(di: diContainer, coordinator: coordinator)
        let searchController = BaseSearchController()
        let viewController = RnMCharacterListViewController(
            searchController: searchController,
            viewModel: viewModel
        )
        
        return viewController
    }
}
