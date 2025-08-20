import Foundation
import Combine

// MARK: - Rick and Morty character list view model

/// Вью модель экрана списка персонажей из вселенной `"Rick and Morty"`.
@MainActor final class RnMCharacterListViewModel: ListViewModel {
    
    // MARK: Services
    
    private let characterHTTPClient: RnMCharacterHTTPClient
    private let imageProvider: ImageProvider
    private let networkMonitor: NetworkMonitor
    private let coordinator: RnMCharacterListCoordinator
    
    // MARK: Properties
    
    /// Строка для фильтрации загруженного списка персонажей по имени.
    @Published private var filterCharacterName: String = ""
    /// Строка для фильтрации загруженного списка персонажей по статусу.
    @Published private var filterCharacterStatus: String = ""
    /// Строка для фильтрации загруженного списка персонажей по гендеру.
    @Published private var filterCharacterGender: String = ""
    
    /// Список персонажей с учетом фильтрации.
    var characterList: AnyPublisher<[RnMCharacterListModel.Character], Never> {
        $fullCharacterList
            .combineLatest($filterCharacterName)
            .map { publishers in
                var characterList = publishers.0
                let name = publishers.1
                
                if !name.isEmpty {
                    characterList = characterList.filter {
                        $0.name.contains(name)
                    }
                }
                
                return characterList
            }
            .eraseToAnyPublisher()
    }
    /// Полный список персонажей.
    @Published private var fullCharacterList: [RnMCharacterListModel.Character] = []
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter dependencies: контейнер с зависимостями.
    init(di dependencies: RnMCharacterListDependencies,) {
        self.characterHTTPClient = dependencies.characterHTTPClient
        self.imageProvider = dependencies.imageProvider
        self.networkMonitor = dependencies.networkMonitor
        self.coordinator = dependencies.coordinator
        
        super.init()
        
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
    
    /// Выполняет установку фильтра персонажей по имени.
    /// - Parameter name: имя для фильтрации.
    func filterCharacterList(by name: String) {
        filterCharacterName = name
    }
}

// MARK: - View model load functions

extension RnMCharacterListViewModel {
    
    /// Выполняет начальную загрузку списка персонажей.
    func initialLoadCharacterList() {
        Task { [weak self] in
            defer { self?.isLoading = false }
            self?.isLoading = true
            
            do { self?.fullCharacterList = try await self?.loadCharacterList() ?? [] }
            catch { self?.isErrorLoading = true }
        }
    }
    
    /// Выполняет перезагруску списка персонажей
    /// (загружает первую страницу списка персонажей).
    func refreshCharacterList() {
        Task { [weak self] in
            defer { self?.isRefreshing = false }
            self?.isRefreshing = true
            self?.isLastPageLoaded = false
            self?.currentListPage = 1
            
            do {
                self?.isErrorLoading = false
                self?.fullCharacterList = try await self?.loadCharacterList() ?? []
            }
            catch {
                self?.fullCharacterList = []
                self?.isErrorLoading = true
            }
        }
    }
    
    /// Выполняет загрузку следующей страницы списка персонажей.
    func loadNextCharacterListPage() {
        // Если уже есть задача на загрузку,
        // то ничего не делаем и дожидаемся ее выполнения.
        guard
            !isLastPageLoaded,
            loadNextListPageTask == nil
        else { return }
        
        loadNextListPageTask = Task { [weak self] in
            defer { self?.loadNextListPageTask = nil }
            defer { self?.isNextPageLoading = false }
            
            self?.isNextPageLoading = true
            self?.currentListPage += 1
            
            do {
                self?.isErrorNextPageLoading = false
                self?.fullCharacterList += try await self?.loadCharacterList() ?? []
            }
            catch HTTPRequestError.invalidStatusCode(404) { self?.isLastPageLoaded = true }
            catch { self?.isErrorNextPageLoading = true }
        }
    }
    
    /// Выполняет загркузку списка персонажей.
    /// - Returns: список персонажей.
    private func loadCharacterList() async throws -> [RnMCharacterListModel.Character] {
        let characterFilter = RnMCharacterHTTPRequestFilter(
            page: currentListPage,
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
        guard retryLoadListTask == nil else { return }
        
        retryLoadListTask = Task { [weak self] in
            defer { self?.retryLoadListTask = nil }
            defer { self?.isLoading = false }
            self?.isLoading = true
            
            do {
                let characterList = try await self?.loadCharacterList()
                self?.isErrorLoading = false
                self?.fullCharacterList = characterList?.filter({ character in
                    self?.fullCharacterList.contains(character) == false
                }) ?? []
            }
            catch { self?.isErrorLoading = true }
        }
    }
    
    /// Выполняет повторную загрузку "следующей" страницы списка персонажей.
    func retryLoadNextCharacterListPage() {
        guard retryLoadListTask == nil else { return }
        
        retryLoadListTask = Task { [weak self] in
            defer { self?.retryLoadListTask = nil }
            defer { self?.isNextPageLoading = false }
            self?.isNextPageLoading = true
            
            do {
                let characterList = try await self?.loadCharacterList()
                self?.isErrorNextPageLoading = false
                self?.fullCharacterList += characterList?.filter({ character in
                    self?.fullCharacterList.contains(character) == false
                }) ?? []
            }
            catch { self?.isErrorNextPageLoading = true }
        }
    }
}

// MARK: - View model navigation functions

extension RnMCharacterListViewModel {
    
    /// Выполняет отображение экрана списка фильтров для персонажей.
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
    
    /// Выполняет отображение экрана информации о пресонаже.
    /// - Parameter characterId: идентификатор персонажа.
    func presentCharacterInfoView(for characterId: Int) {
        coordinator.presentCharacterInfoView(for: characterId)
    }
}

// MARK: - View model setup functions

private extension RnMCharacterListViewModel {
    
    /// Выполняет настройку подписок на события сервисов.
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
