import UIKit

// MARK: - Rick and Morty character list assembly

/// Класс, отвечающий за регистрацию и сборку зависимостей
/// экрана списка персонажей из вселенной `"Rick and Morty"`.
final class RnMCharacterListAssembly: DIAssembly {
    
    // MARK: DI assembly protocol implementation
    
    func assemble(container: DIContainer) {
        container
            .register(RnMCharacterListDependencies.self) { container in
                RnMCharacterListDependencies(di: container)
            }
        
        container
            .register(RnMCharacterListViewModel.self) { container in
                MainActor.assumeIsolated {
                    let dependencies = container.resolve(RnMCharacterListDependencies.self)
                    let viewModel = RnMCharacterListViewModel(di: dependencies)
                    
                    return viewModel
                }
            }
        
        container
            .register(BaseSearchController.self) { _ in
                MainActor.assumeIsolated {
                    BaseSearchController()
                }
            }
        
        container
            .register(RnMCharacterListViewController.self) { container in
                MainActor.assumeIsolated {
                    let searchController = container.resolve(BaseSearchController.self)
                    let viewModel = container.resolve(RnMCharacterListViewModel.self)
                    let viewController = RnMCharacterListViewController(
                        searchController: searchController,
                        viewModel: viewModel
                    )
                    
                    return viewController
                }
            }
    }
}
