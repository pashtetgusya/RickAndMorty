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
    @Published var isLoading: Bool
    /// Флаг ошибки загрузки информации об персонаже.
    @Published var isErrorLoading: Bool
    
    /// Идентификатор персонажа.
    private let characterId: Int
    /// Имя персонажа.
    let characterName: String
    
    /// Информация о просматриваемом персонаже.
    @Published private var characterInfo: RnMCharacterInfoModel.CharacterInfo?
    @Published var characterInfoParameterList: [RnMCharacterInfoModel.Section] = []
    /// Паблишер списка секций с параметрами информации о персонаже.
    var characterInfoParameterListPublisher: AnyPublisher<[RnMCharacterInfoModel.Section], Never> {
        $characterInfo
            .compactMap { $0 }
            .map {
                [
                    RnMCharacterInfoModel.Section(type: .details, rows: [
                        RnMCharacterInfoModel.CharacterInfoParameter.status(description: $0.status).erased(),
                        RnMCharacterInfoModel.CharacterInfoParameter.gender(description: $0.gender).erased(),
                        RnMCharacterInfoModel.CharacterInfoParameter.originLocation(description: $0.originLocationName).erased(),
                        RnMCharacterInfoModel.CharacterInfoParameter.lastLocation(description: $0.lastLocationName).erased(),
                    ]),
                    RnMCharacterInfoModel.Section(type: .episodes, rows: $0.episodeNamesInWhichAppeared.map {
                        RnMCharacterInfoModel.CharacterInfoParameter.episode(description: $0).erased()
                    })
                ]
            }
            .eraseToAnyPublisher()
    }
    
    private var cancellables: Set<AnyCancellable>
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - characterId: идентификатор персонажа.
    ///   - characterName: имя персонажа.
    ///   - diContainer: контейнер с зависимостями.
    init(
        characterId: Int,
        characterName: String,
        di diContainer: RnMCharacterInfoDIContainer
    ) {
        self.characterId = characterId
        self.characterName = characterName
        
        self.characterHTTPClient = diContainer.characterHTTPClient
        self.episodeHTTPClient = diContainer.episodeHTTPClient
        self.imageProvider = diContainer.imageProvider
        self.networkMonitor = diContainer.networkMonitor
        
        self.isLoading = false
        self.isErrorLoading = false
        
        self.cancellables = []
        
        self.setupBindings()
    }
}

// MARK: - View model build functions

extension RnMCharacterInfoViewModel {
    
    /// Создает вью модель для хедера с информацией о персонаже.
    /// - Returns: вью модель хедера.
    func getCharacterInfoTableHeaderViewModel() -> RnMCharacterInfoTableHeaderViewModel? {
        guard let characterInfo else { return nil }
        
        let viewModel = RnMCharacterInfoTableHeaderViewModel(
            imageURL: characterInfo.imageURL,
            imageProvider: imageProvider
        )
        
        return viewModel
    }
}

// MARK: - View model load functions

extension RnMCharacterInfoViewModel {
    
    /// Загружает информацию о персонаже.
    func initialLoadCharacterInfo() {
        Task { [weak self] in
            defer { self?.isLoading = false }
            self?.isLoading = true
            
            let characterInfo = await self?.loadCharacterInfo()
            self?.characterInfo = characterInfo
            self?.characterInfoParameterList = characterInfo
                .map {
                    [
                        RnMCharacterInfoModel.Section(type: .details, rows: [
                            RnMCharacterInfoModel.CharacterInfoParameter.status(description: $0.status).erased(),
                            RnMCharacterInfoModel.CharacterInfoParameter.gender(description: $0.gender).erased(),
                            RnMCharacterInfoModel.CharacterInfoParameter.originLocation(description: $0.originLocationName).erased(),
                            RnMCharacterInfoModel.CharacterInfoParameter.lastLocation(description: $0.lastLocationName).erased(),
                        ]),
                        RnMCharacterInfoModel.Section(type: .episodes, rows: $0.episodeNamesInWhichAppeared.map {
                            RnMCharacterInfoModel.CharacterInfoParameter.episode(description: $0).erased()
                        })
                    ]
                } ?? []
        }
    }
    
    /// Загружает информацию о персонаже.
    private func loadCharacterInfo() async -> RnMCharacterInfoModel.CharacterInfo? {
        do {
            let characterInfoDTO = try await characterHTTPClient.getCharacter(with: characterId)
            let episodeIdList = characterInfoDTO.episodesInWhichAppeared.map { $0.id }
            let episodeDTOList = try await episodeHTTPClient.getEpisodes(with: episodeIdList)
            let characterInfo = RnMCharacterInfoModel.CharacterInfo(
                characterInfoDTO: characterInfoDTO,
                episodeDTOList: episodeDTOList
            )
            isErrorLoading = false
            
            return characterInfo
        }
        catch { isErrorLoading = true }
        
        return nil
    }
}

// MARK: - View model retry functions

extension RnMCharacterInfoViewModel {
    
    /// Выполняет повторную загрузку информации о персонаже.
    func retryLoadCharacterInfo() {
        initialLoadCharacterInfo()
    }
}

// MARK: - View model setup functions

private extension RnMCharacterInfoViewModel {
    
    /// Настраивает подписки.
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
