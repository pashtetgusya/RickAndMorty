import Foundation
import Combine
import NetWork
import Data
import Domain

// MARK: - Episode info view model

/// Вью модель экрана информации об эпизоде из вселенной `"Rick and Morty"`.
@MainActor final class EpisodeInfoViewModel {
    
    // MARK: Properties
    
    /// Флаг выполнения загрузки информации об эпизоде.
    @Published var isLoading: Bool = false
    /// Флаг ошибки загрузки информации об эпизоде.
    @Published var isErrorLoading: Bool = false
    /// Название эпизода.
    @Published var episodeName: String = ""
    /// Список секций с информацией об эпизоде.
    @Published var episodeInfoSectionList: [EpisodeInfoCollectionViewModel.Section] = []
    /// Идентификатор эпизода.
    private let episodeId: Int
    /// Репозиторий для получения информации об эпизоде.
    private let episodesRepository: EpisodesRepository
    /// Репозиторий для получения информации о персонажах.
    private let charactersRepository: CharactersRepository
    /// Сервис для мониторинга статуса подключения к сети.
    private let networkMonitor: NetworkMonitor
    /// Координатор экрана информации об эпизоде.
    private weak let coordinator: EpisodeInfoCoordinator?
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - episodeId: идентификатор эпизода.
    ///   - dependencies: контейнер с зависимостями.
    init(
        episodeId: Int,
        di dependencies: EpisodeInfoViewModelDependencies
    ) {
        self.episodeId = episodeId
        self.episodesRepository = dependencies.episodesRepository
        self.charactersRepository = dependencies.charactersRepository
        self.networkMonitor = dependencies.networkMonitor
        self.coordinator = dependencies.coordinator
        
        self.setupBindings()
    }
}

// MARK: - View model load functions

extension EpisodeInfoViewModel {
    
    /// Выполняет загрузку информации об эпизоде.
    func loadEpisodeInfo() {
        Task { [weak self] in
            guard let self else { return }
            
            defer { isLoading = false }
            isLoading = true
            
            do {
                let episodeInfoDTO = try await episodesRepository.getEpisode(with: episodeId)
                let characterIdList = episodeInfoDTO.characters.map(\.id)
                let characterDTOList = try await charactersRepository.getCharacters(with: characterIdList)
                let episodeInfo = EpisodeInfo(episodeDTO: episodeInfoDTO, characterDTOList: characterDTOList)
                
                let detailsSection = EpisodeInfoCollectionViewModel.Section(
                    type: .details,
                    rows: [
                        .number(description: "\(episodeInfo.number)"),
                        .season(description: "\(episodeInfo.season)"),
                        .releaseDate(description: episodeInfo.releaseDate.formatted(date: .complete, time: .omitted))
                    ]
                )
                let charactersSection = EpisodeInfoCollectionViewModel.Section(
                    type: .characters,
                    rows: zip(characterIdList, episodeInfo.characterNamesThatAppeared).map { .character(id: $0.0, description: $0.1) }
                )
                episodeName = episodeInfo.name
                episodeInfoSectionList = [detailsSection, charactersSection]
                isErrorLoading = false
            }
            catch {
                isErrorLoading = true
            }
        }
    }
}

// MARK: - View model navigation functions

extension EpisodeInfoViewModel {
    
    /// Выполняет отображение экрана информации о персонаже.
    /// - Parameter characterId: идентификатор персонажа.
    func presentCharacterInfoView(for characterId: Int) {
        coordinator?.presentCharacterInfoView(for: characterId)
    }
}

// MARK: - View model setup functions

private extension EpisodeInfoViewModel {
    
    /// Выполняет настройку подписок на события сервисов.
    func setupBindings() {
        networkMonitor.start()
        networkMonitor
            .isReachablePublisher
            .sink { [weak self] isReachable in
                guard
                    isReachable == true,
                    self?.isErrorLoading == true
                else { return }
                
                self?.loadEpisodeInfo()
            }
            .store(in: &cancellables)
    }
}
