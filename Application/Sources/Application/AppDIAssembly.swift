import Foundation
import Data
import NetWork
import Storage
import DependencyInjection
import UIComponents
import Characters
import Episodes

// MARK: - Application dependency injection assembly

/// Класс, отвечающий за регистрацию и сборку зависимостей приложения.
final class AppDIAssembly: DIAssembly {
    
    // MARK: DI assemly protocol implementation
    
    func assemble(in container: DIContainer) {
        let assemblies: [DIAssembly] = [
            TabBarAssembly(),
            CharactersAssembly(),
            EpisodesAssembly()
        ]
        assemblies.forEach { $0.assemble(in: container) }
        
        container
            .register(AppCoordinator.self) { @MainActor (
                container,
                args: BaseNavigationController
            ) -> AppCoordinator in
                AppCoordinator(di: container, navController: args)
            }
            .lifecycle(.singleton)
        
        container
            .register(HTTPClient.self) { _ in
                URLSessionHTTPClient()
            }
            .lifecycle(.singleton)
        
        container
            .register(NetworkMonitor.self) { _ in
                NWPathNetworkMonitor()
            }
            .lifecycle(.singleton)
        
        container
            .register(CharactersRepository.self) {
                BaseCharactersRepository(httpClient: $0.resolve(HTTPClient.self))
            }
        
        container
            .register(EpisodesRepository.self) {
                BaseEpisodesRepository(httpClient: $0.resolve(HTTPClient.self))
            }
        
        container
            .register(LocationsRepository.self) {
                BaseLocationsRepository(httpClient: $0.resolve(HTTPClient.self))
            }
        
        container
            .register(ImageRepository.self) { contaiter in
                BaseImageRepository(
                    loader: URLSessionImageLoader(),
                    storage: NSCacheStorage()
                )
            }
            .lifecycle(.singleton)
    }
}
