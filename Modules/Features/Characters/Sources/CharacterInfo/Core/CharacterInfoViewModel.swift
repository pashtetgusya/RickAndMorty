import Foundation
import Combine
import NetWork
import Data
import Domain

// MARK: - Character info view model

/// Вью модель экрана информации о персонаже из вселенной `"Rick and Morty"`.
@MainActor final class CharacterInfoViewModel {
    
    // MARK: Properties
    
    /// Идентификатор персонажа.
    private let characterId: Int
    
    /// Флаг выполнения загрузки информации о персонаже.
    @Published var isLoading: Bool = false
    /// Флаг ошибки загрузки информации о персонаже.
    @Published var isErrorLoading: Bool = false
    /// Имя персонажа.
    @Published var characterName: String = ""
    /// Ссылка на изображение персонажа.
    private var characterImageURL: URL? = nil
    /// Список секций с информации о персонаже.
    @Published var characterInfoSectionList: [CharacterInfoTableViewModel.Section] = []
    
    /// Репозиторий для получения персонажей.
    private let charactersRepository: CharactersRepository
    /// Репозиторий для получения эпизодов.
    private let episodesRepository: EpisodesRepository
    /// Репозиторий для получения изображений.
    private let imageRepository: ImageRepository
    /// Сервис для мониторинга статуса подключения к сети.
    private let networkMonitor: NetworkMonitor
    /// Координатор экрана информации о персожане.
    private weak let coordinator: CharacterInfoCoordinator?
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - characterId: идентификатор персонажа.
    ///   - dependencies: контейнер с зависимостями.
    init(
        characterId: Int,
        di dependencies: CharacterInfoViewModelDependencies
    ) {
        self.characterId = characterId
        
        self.charactersRepository = dependencies.charactersRepository
        self.episodesRepository = dependencies.episodesRepository
        self.imageRepository = dependencies.imageRepository
        self.networkMonitor = dependencies.networkMonitor
        self.coordinator = dependencies.coordinator
        
        self.setupBindings()
    }
}

// MARK: - View model build functions

extension CharacterInfoViewModel {
    
    /// Создает вью модель для хедера с информацией о персонаже.
    /// - Returns: вью модель хедера.
    func getCharacterInfoTableViewHeaderViewModel() -> CharacterInfoTableViewHeaderViewModel {
        CharacterInfoTableViewHeaderViewModel(
            imageURL: characterImageURL,
            imageRepository: imageRepository
        )
    }
}

// MARK: - View model load functions

extension CharacterInfoViewModel {
    
    /// Выполняет загрузку информации о персонаже.
    func loadCharacterInfo() {
        Task { [weak self] in
            guard let self else { return }
            
            defer { isLoading = false }
            isLoading = true
            
            do {
                let characterInfoDTO = try await charactersRepository.getCharacter(with: characterId)
                let episodeIdList = characterInfoDTO.episodesInWhichAppeared.map { $0.id }
                let episodeDTOList = try await episodesRepository.getEpisodes(with: episodeIdList)
                let characterInfo = CharacterInfo(characterDTO: characterInfoDTO, episodeDTOList: episodeDTOList)
                
                let detailsSection = CharacterInfoTableViewModel.Section(
                    type: .details,
                    rows: [
                        .status(description: characterInfo.status),
                        .gender(description: characterInfo.gender),
                        .originLocation(description: characterInfo.originLocationName),
                        .lastLocation(description: characterInfo.lastLocationName),
                    ]
                )
                let episodesSection = CharacterInfoTableViewModel.Section(
                    type: .episodes,
                    rows: zip(episodeIdList, characterInfo.episodeNamesInWhichAppeared).map { .episode(id: $0.0, description: $0.1) }
                )
                characterName = characterInfo.name
                characterImageURL = characterInfo.imageURL
                characterInfoSectionList = [detailsSection, episodesSection]
                isErrorLoading = false
            }
            catch {
                isErrorLoading = true
            }
        }
    }
}

// MARK: - View model navigation functions

extension CharacterInfoViewModel {
    
    /// Выполняет отображение экрана информации об эпизоде.
    /// - Parameter episodeId: идентификатор эпизода.
    func presentEpisodeInfoView(for episodeId: Int) {
        coordinator?.presentEpisodeInfoView(for: episodeId)
    }
}

// MARK: - View model setup functions

private extension CharacterInfoViewModel {
    
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
                
                self?.loadCharacterInfo()
            }
            .store(in: &cancellables)
    }
}
