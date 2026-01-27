import Foundation
import Data
import NetWork
import DependencyInjection

// MARK: - Character list view model dependencies

/// Структура, описывающая зависимости для вью модели
/// экрана списка персонажей из вселенной `"Rick and Morty"`.
struct CharacterListViewModelDependencies {
    
    // MARK: Properties
    
    /// Репозиторий для получения персонажей.
    let charactersRepository: CharactersRepository
    /// Репозиторий для получения изображений.
    let imageRepository: ImageRepository
    /// Сервис для мониторинга статуса подключения к сети.
    let networkMonitor: NetworkMonitor
    /// Координатор экрана списка персонажей.
    let coordinator: CharacterListCoordinator
    
    // MARK: Initialization
    
    /// Создает новый экземпляр структуры.
    /// - Parameter diContainer: контейнер с зависимостями.
    init(di diContainer: DIContainer) {
        self.charactersRepository = diContainer.resolve(CharactersRepository.self)
        self.imageRepository = diContainer.resolve(ImageRepository.self)
        self.networkMonitor = diContainer.resolve(NetworkMonitor.self)
        self.coordinator = diContainer.resolve(CharacterListCoordinator.self)
    }
}
