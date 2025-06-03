import Foundation
import Combine

// MARK: - Rick and Morty character list view model

/// Вью модель экрана списка персонажей из вселенной `"Rick and Morty"`.
@MainActor final class RnMCharacterListViewModel {
    
    // MARK: Services
    
    private let characterHTTPClient: RnMCharacterHTTPClient
    private let imageProvider: ImageProvider
    private let networkMonitor: NetworkMonitor
    
    private let coordinator: RnMCharacterListCoordinator
    
    // MARK: Properties
    
    /// Флаг ошибки загрузки страницы списка персонажей.
    @Published var isErrorLoading: Bool
    /// Флаг ошибки загрузки "следующей" страницы списка персонажей.
    private var isErrorNextPageLoading: Bool
    /// Флаг выполнения начальной / повторной загрузки списка персонажей.
    @Published var isLoading: Bool
    /// Флаг выполнения обновления списка персонажей.
    @Published var isRefreshing: Bool
    /// Флаг выполнения загрузки "следующей" страницы списка персонажей.
    @Published var isNextPageLoading: Bool
    /// Флаг загрузки последней страницы).
    private var isLastPageLoaded: Bool
    
    /// Страница с персонажами для загрузки.
    private var characterPage: Int
    /// Строка для фильтрации загруженного списка персонажей по имени.
    @Published private var filterCharacterName: String
    /// Строка для фильтрации загруженного списка персонажей по статусу.
    @Published private var filterCharacterStatus: String
    /// Строка для фильтрации загруженного списка персонажей по гендеру.
    @Published private var filterCharacterGender: String
    
    /// Список персонажей с учетом фильтрации.
    var characterList: AnyPublisher<[RnMCharacterListModel.Character], Never> {
        $fullCharacterList
            .combineLatest($filterCharacterName)
            .map { publishers in
                var characterList = publishers.0
                let name = publishers.1
                
                if !name.isEmpty { characterList = characterList.filter { $0.name.contains(name) } }
                
                return characterList
            }
            .eraseToAnyPublisher()
    }
    /// Полный список персонажей.
    @Published private var fullCharacterList: [RnMCharacterListModel.Character]
    
    private var cancellables: Set<AnyCancellable>
    
    /// Задача на загрузку следующей страницы списка персонажей.
    private var loadNextCharacterListPageTask: Task<(), Never>?
    /// Задача на повторную загрузку списка персонажей.
    private var retryLoadCharacterListTask: Task<(), Never>?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - diContainer: контейнер с зависимостями.
    ///   - coordinator: координатор для навигации.
    init(
        di diContainer: RnMCharacterListDIContainer,
        coordinator: RnMCharacterListCoordinator
    ) {
        self.characterHTTPClient = diContainer.characterHTTPClient
        self.imageProvider = diContainer.imageProvider
        self.networkMonitor = diContainer.networkMonitor
        self.coordinator = coordinator
        
        self.isErrorLoading = false
        self.isErrorNextPageLoading = false
        self.isLoading = false
        self.isRefreshing = false
        self.isNextPageLoading = false
        self.isLastPageLoaded = false
        
        self.characterPage = 1
        self.filterCharacterName = ""
        self.filterCharacterStatus = ""
        self.filterCharacterGender = ""
        
        self.fullCharacterList = []
        
        self.cancellables = []
        
        self.setupBindings()
    }
}

// MARK: - View model build functions

extension RnMCharacterListViewModel {
    
    /// Создает вью модель ячейки отображения персонажа.
    /// - Parameter character: отображаемый персонаж в ячейке.
    /// - Returns: вью модель ячейки.
    func getCharacterCellViewModel(
        for character: RnMCharacterListModel.Character
    ) -> RnMCharacterCellViewModel {
        RnMCharacterCellViewModel(character: character, imageProvider: imageProvider)
    }
    
    /// Создает вью модель для футера с индикатором загрузки.
    /// - Returns: вью модель футера.
    func getSpinerFoterViewModel() -> SpinerCollectionFooterViewModel {
        SpinerCollectionFooterViewModel(
            isLoadingPublisher: $isNextPageLoading.eraseToAnyPublisher(),
            networkMonitor: networkMonitor
        )
    }
}

// MARK: - View model filter functions

extension RnMCharacterListViewModel {
    
    /// Устанавливает фильтр персонажей по имени.
    /// - Parameter name: имя для фильтрации.
    func filterCharacterList(by name: String) {
        filterCharacterName = name
    }
}

// MARK: - View model load functions

extension RnMCharacterListViewModel {
    
    /// Загружает начальный список персонажей.
    func initialLoadCharacterList() {
        Task {
            defer { isLoading = false }
            isLoading = true
            
            do { fullCharacterList = try await loadCharacterList() }
            catch { isErrorLoading = true }
        }
    }
    
    /// Перезагружает список персонажей
    /// (загружает первую страницу списка персонажей).
    func refreshCharacterList() {
        Task {
            defer { isRefreshing = false }
            isRefreshing = true
            isLastPageLoaded = false
            characterPage = 1
            
            do {
                isErrorLoading = false
                fullCharacterList = try await loadCharacterList()
            }
            catch {
                fullCharacterList = []
                isErrorLoading = true
            }
        }
    }
    
    /// Загружает следующую страницу списка персонажей.
    func loadNextCharacterListPage() {
        // Если уже есть задача на загрузку,
        // то ничего не делаем и дожидаемся ее выполнения.
        guard
            !isLastPageLoaded,
            loadNextCharacterListPageTask == nil
        else { return }
        
        loadNextCharacterListPageTask = Task {
            defer { loadNextCharacterListPageTask = nil }
            defer { isNextPageLoading = false }
            
            isNextPageLoading = true
            characterPage += 1
            
            try? await Task.sleep(nanoseconds: NSEC_PER_SEC * 3)
            do {
                isErrorNextPageLoading = false
                fullCharacterList += try await loadCharacterList()
            }
            catch HTTPRequestError.invalidStatusCode(404) { isLastPageLoaded = true }
            catch { isErrorNextPageLoading = true }
        }
    }
    
    /// Выполняет загрузку списка персонажей.
    /// - Returns: загруженный список персонажей.
    private func loadCharacterList() async throws -> [RnMCharacterListModel.Character] {
        let characterFilter = RnMCharacterHTTPRequestFilter(
            page: characterPage,
            status: .init(rawValue: filterCharacterStatus),
            gender: .init(rawValue: filterCharacterGender)
        )
        let characterDTOList = try await characterHTTPClient.getCharacters(with: characterFilter)
        let characterList = characterDTOList.map { RnMCharacterListModel.Character(dto: $0) }
        
        return characterList
    }
}

// MARK: - View model retry functions

extension RnMCharacterListViewModel {
    
    /// Выполняет повторную загрузку списка персонажей.
    func retryLoadCharacterList() {
        guard retryLoadCharacterListTask == nil else { return }
        
        retryLoadCharacterListTask = Task { [weak self] in
            defer { self?.retryLoadCharacterListTask = nil }
            self?.isLoading = true
            
            do {
                let characterList = try await self?.loadCharacterList()
                self?.isLoading = false
                self?.isErrorLoading = false
                self?.fullCharacterList += characterList?.filter({ character in
                    self?.fullCharacterList.contains(character) == false
                }) ?? []
            }
            catch {
                self?.isLoading = false
                self?.isErrorLoading = true
            }
        }
    }
    
    /// Выполняет повторную загрузку "следующей" страницы списка персонажей.
    func retryLoadNextCharacterListPage() {
        guard retryLoadCharacterListTask == nil else { return }
        
        retryLoadCharacterListTask = Task { [weak self] in
            defer { self?.retryLoadCharacterListTask = nil }
            self?.isNextPageLoading = true
            
            do {
                let characterList = try await self?.loadCharacterList()
                self?.isNextPageLoading = false
                self?.isErrorNextPageLoading = false
                self?.fullCharacterList += characterList?.filter({ character in
                    self?.fullCharacterList.contains(character) == false
                }) ?? []
            }
            catch {
                self?.isNextPageLoading = false
                self?.isErrorNextPageLoading = true
            }
        }
    }
}

// MARK: - View model navigation functions

extension RnMCharacterListViewModel {
    
    /// Отображает экран списка фильтров для персонажей.
    func presentCharacterFilterView() {
        let currentFilter = RnMCharacterFilterModel.CharacterFilter(
            gender: RnMCharacterFilterModel.CharacterGenderFilter(rawValue: filterCharacterGender) ?? .empty,
            status: RnMCharacterFilterModel.CharacterStatusFilter(rawValue: filterCharacterStatus) ?? .empty
        )
        coordinator.presentCharacterFilterView(with: currentFilter) { [weak self] filter in
            self?.filterCharacterGender = filter.gender.rawValue
            self?.filterCharacterStatus = filter.status.rawValue
            self?.refreshCharacterList()
        }
    }
    
    /// Отображает экран информации о пресонаже.
    /// - Parameters:
    ///   - characterId: идентификатор персонажа.
    ///   - characterName: имя персонажа.
    func presentCharacterInfoView(
        for characterId: Int,
        characterName: String
    ) {
        coordinator.presentCharacterInfoView(
            for: characterId,
            characterName: characterName
        )
    }
}

// MARK: - View model setup functions

private extension RnMCharacterListViewModel {
    
    /// Настраивает подписки.
    func setupBindings() {
        networkMonitor.start()
        networkMonitor
            .isReachablePublisher
            .sink { [weak self] isReachable in
                guard
                    isReachable == true,
                    self?.isErrorNextPageLoading == true
                else { return }
                
                self?.retryLoadNextCharacterListPage()
            }
            .store(in: &cancellables)
    }
}
