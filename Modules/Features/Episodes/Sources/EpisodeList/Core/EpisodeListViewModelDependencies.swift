import Foundation
import Data
import NetWork
import DependencyInjection

// MARK: - Episode list view model dependencies

/// Структура, описывающая зависимости для вью модели
/// экрана списка эпизодов из вселенной `"Rick and Morty"`.
struct EpisodeListViewModelDependencies {
    
    // MARK: Properties
    
    /// Репозиторий для получения эпизодов.
    let episodesRepository: EpisodesRepository
    /// Сервис для мониторинга статуса подключения к сети.
    let networkMonitor: NetworkMonitor
    /// Координатор экрана списка эпизодов.
    let coordinator: EpisodeListCoordinator
    
    // MARK: Initialization
    
    /// Создает новый экземпляр структуры.
    /// - Parameter diContainer: контейнер с зависимостями.
    init(di diContained: DIContainer) {
        self.episodesRepository = diContained.resolve(EpisodesRepository.self)
        self.networkMonitor = diContained.resolve(NetworkMonitor.self)
        self.coordinator = diContained.resolve(EpisodeListCoordinator.self)
    }
}
