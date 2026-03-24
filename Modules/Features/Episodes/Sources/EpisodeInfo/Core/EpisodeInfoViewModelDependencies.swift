import Foundation
import Data
import NetWork
import DependencyInjection

// MARK: - Episode info view model dependencies

/// Структура, описывающая зависимости для вью модели
/// экрана информации об эпизоде из вселенной `"Rick and Morty"`.
struct EpisodeInfoViewModelDependencies {
    
    // MARK: Properties
    
    /// Репозиторий для получения эпизодов.
    let episodesRepository: EpisodesRepository
    /// Репозиторий для получения персонажей.
    let charactersRepository: CharactersRepository
    /// Сервис для мониторинга статуса подключения к сети.
    let networkMonitor: NetworkMonitor
    /// Координатор экрана информации об эпизоде.
    let coordinator: EpisodeInfoCoordinator
    
    // MARK: Initialization
    
    /// Создает новый экземпляр структуры.
    /// - Parameter diContainer: контейнер с зависимостями.
    init(di diContainer: DIContainer) {
        self.episodesRepository = diContainer.resolve(EpisodesRepository.self)
        self.charactersRepository = diContainer.resolve(CharactersRepository.self)
        self.networkMonitor = diContainer.resolve(NetworkMonitor.self)
        self.coordinator = diContainer.resolve(EpisodeInfoCoordinator.self)
    }
}
