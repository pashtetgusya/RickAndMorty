import Foundation

// MARK: - Rick and Morty character info view model DI container

/// Структура. описывающая контейнер с зависимостями для вью модели
/// информации о персонаже из вселенной `"Rick and Morty"`.
struct RnMCharacterInfoDIContainer {
    
    // MARK: Properties
    
    let characterHTTPClient: RnMCharacterHTTPClient
    let episodeHTTPClient: RnMEpisodeHTTPClient
    let imageProvider: ImageProvider
    let networkMonitor: NetworkMonitor
    
    // MARK: Initialization
    
    /// Создает новый экземпляр структуры.
    /// - Parameter diContainer: контейнер с зависимостями.
    init(di diContainer: AppDIContainer) {
        self.characterHTTPClient = diContainer.resolve(RnMCharacterHTTPClient.self)
        self.episodeHTTPClient = diContainer.resolve(RnMEpisodeHTTPClient.self)
        self.imageProvider = diContainer.resolve(ImageProvider.self)
        self.networkMonitor = diContainer.resolve(NetworkMonitor.self)
    }
}
