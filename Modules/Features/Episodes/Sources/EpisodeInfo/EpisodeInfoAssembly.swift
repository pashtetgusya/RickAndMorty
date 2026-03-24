import Foundation
import DependencyInjection

// MARK: - Episode info assembly

/// Класс, отвечающий за регистрацию и сборку зависимостей
/// экрана информации об эпизоде из вселенной `"Rick and Morty"`.
final class EpisodeInfoAssembly: DIAssembly {
    
    // MARK: DI assembly protocol implementation
    
    func assemble(in container: DIContainer) {
        container
            .register(EpisodeInfoViewModelDependencies.self) { container in
                EpisodeInfoViewModelDependencies(di: container)
            }
        
        container
            .register(EpisodeInfoViewModel.self) { @MainActor (
                container: DIContainer,
                episodeId: Int
            ) -> EpisodeInfoViewModel in
                let dependencies = container.resolve(EpisodeInfoViewModelDependencies.self)
                let viewModel = EpisodeInfoViewModel(episodeId: episodeId, di: dependencies)
                
                return viewModel
            }
        
        container
            .register(EpisodeInfoViewController.self) { @MainActor (
                container: DIContainer,
                episodeId: Int
            ) -> EpisodeInfoViewController in
                let viewModel = container.resolve(EpisodeInfoViewModel.self, args: episodeId)
                let viewController = EpisodeInfoViewController(viewModel: viewModel)
                
                return viewController
            }
    }
}
