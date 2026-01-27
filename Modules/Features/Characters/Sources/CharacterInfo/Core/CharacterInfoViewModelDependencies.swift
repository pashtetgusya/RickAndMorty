import Foundation
import Data
import NetWork
import DependencyInjection

// MARK: - Character info view model dependencies

/// Структура, описывающая зависимости для вью модели
/// экрана информации о персонаже из вселенной `"Rick and Morty"`.
struct CharacterInfoViewModelDependencies {
    
    // MARK: Properties
    
    /// Репозиторий для получения персонажей.
    let charactersRepository: CharactersRepository
    /// Репозиторий для получения эпизодов.
    let episodesRepository: EpisodesRepository
    /// Репозиторий для получения изображений.
    let imageRepository: ImageRepository
    /// Сервис для мониторинга статуса подключения к сети.
    let networkMonitor: NetworkMonitor
    
    // MARK: Initialization
    
    /// Создает новый экземпляр структуры.
    /// - Parameter diContainer: контейнер с зависимостями.
    init(di diContainer: DIContainer) {
        self.charactersRepository = diContainer.resolve(CharactersRepository.self)
        self.episodesRepository = diContainer.resolve(EpisodesRepository.self)
        self.imageRepository = diContainer.resolve(ImageRepository.self)
        self.networkMonitor = diContainer.resolve(NetworkMonitor.self)
    }
}
