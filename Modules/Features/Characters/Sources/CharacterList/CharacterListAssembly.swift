import UIKit
import UIComponents
import DependencyInjection

// MARK: - Character list assembly

/// Класс, отвечающий за регистрацию и сборку зависимостей
/// экрана списка персонажей из вселенной `"Rick and Morty"`.
final class CharacterListAssembly: DIAssembly {
    
    // MARK: DI assembly protocol implementation
    
    func assemble(in container: DIContainer) {
        container
            .register(BaseSearchController.self) { _ in
                MainActor.assumeIsolated {
                    BaseSearchController()
                }
            }
        
        container
            .register(CharacterListViewModelDependencies.self) { container in
                CharacterListViewModelDependencies(di: container)
            }
        
        container
            .register(CharacterListViewModel.self) { container in
                MainActor.assumeIsolated {
                    let dependencies = container.resolve(CharacterListViewModelDependencies.self)
                    let viewModel = CharacterListViewModel(di: dependencies)
                    
                    return viewModel
                }
            }
        
        container
            .register(CharacterListViewController.self) { container in
                MainActor.assumeIsolated {
                    let searchController = container.resolve(BaseSearchController.self)
                    let viewModel = container.resolve(CharacterListViewModel.self)
                    let viewController = CharacterListViewController(
                        searchController: searchController,
                        viewModel: viewModel
                    )
                    
                    return viewController
                }
            }
    }
}
