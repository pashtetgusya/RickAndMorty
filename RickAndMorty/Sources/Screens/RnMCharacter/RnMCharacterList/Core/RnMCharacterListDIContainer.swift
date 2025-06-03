import Foundation

// MARK: - Rick and Morty character list view model DI container

/// Структура. описывающая контейнер с зависимостями для вью модели
/// списка персонажей из вселенной `"Rick and Morty"`.
struct RnMCharacterListDIContainer {
    
    // MARK: Properties
    
    let characterHTTPClient: RnMCharacterHTTPClient
    let imageProvider: ImageProvider
    let networkMonitor: NetworkMonitor
    
    // MARK: Initialization
    
    /// Создает новый экземпляр структуры.
    /// - Parameter diContainer: контейнер с зависимостями.
    init(di diContainer: AppDIContainer) {
        self.characterHTTPClient = diContainer.resolve(RnMCharacterHTTPClient.self)
        self.imageProvider = diContainer.resolve(ImageProvider.self)
        self.networkMonitor = diContainer.resolve(NetworkMonitor.self)
    }
}
