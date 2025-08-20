import Foundation

// MARK: - Rick and Morty character list view model dependencies

/// Структура, описывающая контейнер с зависимостями для вью модели
/// списка персонажей из вселенной `"Rick and Morty"`.
struct RnMCharacterListDependencies: Sendable {
    
    // MARK: Properties
    
    let characterHTTPClient: RnMCharacterHTTPClient
    let imageProvider: ImageProvider
    let networkMonitor: NetworkMonitor
    let coordinator: RnMCharacterListCoordinator
    
    // MARK: Initialization
    
    /// Создает новый экземпляр структуры.
    /// - Parameter diContainer: контейнер с зависимостями.
    init(di diContainer: DIContainer) {
        self.characterHTTPClient = diContainer.resolve(RnMCharacterHTTPClient.self)
        self.imageProvider = diContainer.resolve(ImageProvider.self)
        self.networkMonitor = diContainer.resolve(NetworkMonitor.self)
        self.coordinator = diContainer.resolve(RnMCharacterListCoordinator.self)
    }
}
