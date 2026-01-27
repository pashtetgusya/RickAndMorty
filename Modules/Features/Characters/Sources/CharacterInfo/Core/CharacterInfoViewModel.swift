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
    /// Список секций с параметрами информации о персонаже.
    @Published var characterInfoParameterList: [CharacterInfoTableViewModel.Section] = []
    
    /// Репозиторий для получения персонажей.
    private let charactersRepository: CharactersRepository
    /// Репозиторий для получения эпизодов.
    private let episodesRepository: EpisodesRepository
    /// Репозиторий для получения изображений.
    private let imageRepository: ImageRepository
    /// Сервис для мониторинга статуса подключения к сети,
    private let networkMonitor: NetworkMonitor
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
    
    /// Выполняет начальную загрузку информации о персонаже.
    func initialLoadCharacterInfo() {
        runLoadCharacterInfoTask()
    }
}

// MARK: - View model retry functions

extension CharacterInfoViewModel {
    
    /// Выполняет повторную загрузку информации о персонаже.
    func retryLoadCharacterInfo() {
        runLoadCharacterInfoTask()
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
                
                self?.retryLoadCharacterInfo()
            }
            .store(in: &cancellables)
    }
}

// MARK: - View model support functions

private extension CharacterInfoViewModel {
    
    /// Выполняет запуск задачи на загрузку информации о персонаже.
    func runLoadCharacterInfoTask() {
        Task { [weak self] in
            defer { self?.isLoading = false }
            self?.isLoading = true
            
            do {
                guard let characterInfo = try await self?.getCharacterInfo() else { return }
                
                self?.characterName = characterInfo.name
                self?.characterImageURL = characterInfo.imageURL
                self?.characterInfoParameterList = self?.getCharacterInfoSectionList(for: characterInfo) ?? []
                self?.isErrorLoading = false
            }
            catch { self?.isErrorLoading = true }
        }
    }
    
    /// Выполняет загрузку информации о персонаже.
    /// - Returns: структура с информацией о персонаже.
    func getCharacterInfo() async throws -> CharacterInfo {
        let characterInfoDTO = try await charactersRepository.getCharacter(with: characterId)
        let episodeIdList = characterInfoDTO.episodesInWhichAppeared.map { $0.id }
        let episodeDTOList = try await episodesRepository.getEpisodes(with: episodeIdList)
        let characterInfo = CharacterInfo(characterDTO: characterInfoDTO, episodeDTOList: episodeDTOList)
        
        return characterInfo
    }
    
    /// Выполняет загрузку списка секций с информацией о персонаже на основе переданной структуры.
    /// - Parameter characterInfo: структура с информацией о персонаже.
    /// - Returns: список секций с информацией о персонаже.
    func getCharacterInfoSectionList(
        for characterInfo: CharacterInfo
    ) -> [CharacterInfoTableViewModel.Section] {
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
            rows: characterInfo.episodeNamesInWhichAppeared.map { .episode(description: $0) }
        )
        let sectionList = [detailsSection, episodesSection]
        
        return sectionList
    }
}
