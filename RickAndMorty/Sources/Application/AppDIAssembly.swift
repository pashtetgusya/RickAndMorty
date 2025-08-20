import Foundation

// MARK: - Application dependency injection assembly

/// Класс, отвечающий за регистрацию и сборку зависимостей приложения.
final class AppDIAssembly: DIAssembly {
    
    // MARK: DI assemly protocol implementation
    
    func assemble(container: DIContainer) {
        let assemblies: [DIAssembly] = [
            RnMCharactersAssembly(),
        ]
        assemblies.forEach { $0.assemble(container: container) }
        
        container
            .register(NetworkMonitor.self) { _ in NWPathNetworkMonitor() }
            .lifecycle(.singleton)
        
        container
            .register(RnMCharacterHTTPClient.self) { _ in RnMCharacterURLSessionHTTPClient() }
        
        container
            .register(RnMLocationHTTPClient.self) { _ in RnMLocationURLSessionHTTPClient() }
        
        container
            .register(RnMEpisodeHTTPClient.self) { _ in RnMEpisodeURLSessionHTTPClient() }
        
        container
            .register(ImageCache.self) { _ in NSImageCache() }
            .lifecycle(.singleton)
        
        container
            .register(ImageLoader.self) { _ in URLSessionImageLoader() }
        
        container
            .register(ImageProvider.self) { contaiter in
                DefaultImageProvider(
                    imageLoader: contaiter.resolve(ImageLoader.self),
                    imageCache: contaiter.resolve(ImageCache.self)
                )
            }
    }
}
