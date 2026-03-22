import Foundation
import DependencyInjection

// MARK: - Episode list assembly

/// Класс, отвечающий за регистрацию и сборку зависимостей
/// экрана списка эпизодов из вселенной `"Rick and Morty"`.
final class EpisodeListAssembly: DIAssembly {
    
    // MARK: DI assembly protocol implementation
    
    func assemble(in container: DIContainer) {
        container
            .register(EpisodeListViewModelDependencies.self) { container in
                EpisodeListViewModelDependencies(di: container)
            }
        
        container
            .register(EpisodeListViewModel.self) { @MainActor container in
                let dependencies = container.resolve(EpisodeListViewModelDependencies.self)
                let viewModel = EpisodeListViewModel(di: dependencies)
                
                return viewModel
            }
        
        container
            .register(EpisodeListViewController.self) { @MainActor container in
                let viewModel = container.resolve(EpisodeListViewModel.self)
                let viewController = EpisodeListViewController(viewModel: viewModel)
                
                return viewController
            }
    }
}
