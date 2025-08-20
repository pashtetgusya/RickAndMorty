import Foundation
import Combine

// MARK: - Rick and Morty character info view model

/// Вью модель экрана информации о персонаже из вселенной `"Rick and Morty"`.
@MainActor final class RnMCharacterInfoViewModel {
    
    // MARK: Services
    
    private let characterHTTPClient: RnMCharacterHTTPClient
    private let episodeHTTPClient: RnMEpisodeHTTPClient
    private let imageProvider: ImageProvider
    private let networkMonitor: NetworkMonitor
    
    // MARK: Properties
    
    /// Флаг выполнения загрузки информации о персонаже.
    @Published var isLoading: Bool = false
    /// Флаг ошибки загрузки информации о персонаже.
    @Published var isErrorLoading: Bool = false
    
    /// Идентификатор персонажа.
    private let characterId: Int
    /// Имя персонажа.
    @Published var characterName: String = ""
    /// Ссылка на изображение персонажа.
    private var characterImageURL: URL? = nil
    /// Список секций с параметрами информации о персонаже.
    @Published var characterInfoParameterList: [RnMCharacterInfoModel.Section] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - characterId: идентификатор персонажа.
    ///   - dependencies: контейнер с зависимостями.
    init(
        characterId: Int,
        di dependencies: RnMCharacterInfoDependencies
    ) {
        self.characterHTTPClient = dependencies.characterHTTPClient
        self.episodeHTTPClient = dependencies.episodeHTTPClient
        self.imageProvider = dependencies.imageProvider
        self.networkMonitor = dependencies.networkMonitor
        
        self.characterId = characterId
        
        self.setupBindings()
    }
}

// MARK: - View model build functions

extension RnMCharacterInfoViewModel {
    
    /// Создает вью модель для хедера с информацией о персонаже.
    /// - Returns: вью модель хедера.
    func getCharacterInfoTableHeaderViewModel() -> RnMCharacterInfoTableHeaderViewModel? {
        guard let characterImageURL else { return nil }
        
        let viewModel = RnMCharacterInfoTableHeaderViewModel(
            imageURL: characterImageURL,
            imageProvider: imageProvider
        )
        
        return viewModel
    }
}

// MARK: - View model load functions

extension RnMCharacterInfoViewModel {
    
    /// Выполняет начальную загрузку информации о персонаже.
    func initialLoadCharacterInfo() {
        Task { [weak self] in
            defer { self?.isLoading = false }
            self?.isLoading = true
            
            do {
                let characterInfo = try await self?.loadCharacterInfo()
                self?.characterName = characterInfo?.name ?? ""
                self?.characterImageURL = characterInfo?.imageURL
                self?.characterInfoParameterList = characterInfo?.toSectionList() ?? []
                self?.isErrorLoading = false
            }
            catch { self?.isErrorLoading = true }
        }
    }
    
    /// Выполняет загрузку информации о персонаже.
    private func loadCharacterInfo() async throws -> RnMCharacterInfoModel.CharacterInfo {
        let characterInfoDTO = try await characterHTTPClient.getCharacter(with: characterId)
        let episodeIdList = characterInfoDTO.episodesInWhichAppeared.map { $0.id }
        let episodeDTOList = try await episodeHTTPClient.getEpisodes(with: episodeIdList)
        let characterInfo = RnMCharacterInfoModel.CharacterInfo(
            characterInfoDTO: characterInfoDTO,
            episodeDTOList: episodeDTOList
        )
        
        return characterInfo
    }
}

// MARK: - View model retry functions

extension RnMCharacterInfoViewModel {
    
    /// Выполняет повторную загрузку информации о персонаже.
    func retryLoadCharacterInfo() {
        Task { [weak self] in
            defer { self?.isLoading = false }
            self?.isLoading = true
            
            do {
                let characterInfo = try await self?.loadCharacterInfo()
                self?.characterName = characterInfo?.name ?? ""
                self?.characterInfoParameterList = characterInfo?.toSectionList() ?? []
                self?.isErrorLoading = false
            }
            catch { self?.isErrorLoading = true }
        }
    }
}

// MARK: - View model setup functions

private extension RnMCharacterInfoViewModel {
    
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
