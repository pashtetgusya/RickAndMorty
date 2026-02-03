import Foundation
import Combine
import Data
import NetWork
import UIComponents

// MARK: - Character list view model

/// Вью модель экрана списка персонажей из вселенной `"Rick and Morty"`.
@MainActor final class CharacterListViewModel {
    
    // MARK: Properties
    
    /// Флаг ошибки загрузки страницы списка.
    @Published var isErrorLoading: Bool = false
    /// Флаг ошибки загрузки "следующей" страницы списка.
    var isErrorNextPageLoading: Bool = false
    /// Флаг выполнения начальной / повторной загрузки списка.
    @Published var isLoading: Bool = false
    /// Флаг выполнения обновления списка.
    @Published var isRefreshing: Bool = false
    /// Флаг выполнения загрузки "следующей" страницы списка.
    @Published var isNextPageLoading: Bool = false
    /// Флаг загрузки последней страницы.
    var isLastPageLoaded: Bool = false
    /// Текущая страница списка.
    var currentListPage: Int = 1
    
    /// Строка для фильтрации загруженного списка персонажей по имени.
    @Published private var filterCharacterName: String = ""
    /// Строка для фильтрации загруженного списка персонажей по статусу.
    @Published private var filterCharacterStatus: String = ""
    /// Строка для фильтрации загруженного списка персонажей по гендеру.
    @Published private var filterCharacterGender: String = ""
    
    /// Список персонажей с учетом фильтрации.
    var characterList: AnyPublisher<[CharacterListCollectionViewModel.Section], Never> {
        Publishers
            .CombineLatest($fullCharacterList, $filterCharacterName)
            .map { publishers in
                var characterList = publishers.0
                let name = publishers.1
                
                if !name.isEmpty {
                    characterList = characterList.filter {
                        $0.name.contains(name)
                    }
                }
                
                let sections = [CharacterListCollectionViewModel.Section(
                    type: .characters,
                    rows: characterList
                )]
                
                return sections
            }
            .eraseToAnyPublisher()
    }
    /// Полный список персонажей.
    @Published private var fullCharacterList: [CharacterListCollectionViewModel.Section.Row] = []
    
    /// Репозиторий для получения персонажей.
    private let charactersRepository: CharactersRepository
    /// Репозиторий для получения изображений.
    private let imageRepository: ImageRepository
    /// Сервис для мониторинга статуса подключения к сети.
    private let networkMonitor: NetworkMonitor
    /// Координатор экрана списка персонажей.
    private weak let coordinator: CharacterListCoordinator?
    /// Задача на загрузку следующей страницы списка.
    private var loadNextListPageTask: Task<(), Never>? = nil
    /// Задача на повторную загрузку списка.
    private var retryLoadListTask: Task<(), Never>? = nil
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter dependencies: контейнер с зависимостями.
    init(di dependencies: CharacterListViewModelDependencies) {
        self.charactersRepository = dependencies.charactersRepository
        self.imageRepository = dependencies.imageRepository
        self.networkMonitor = dependencies.networkMonitor
        self.coordinator = dependencies.coordinator
        
        self.setupBindings()
    }
}

// MARK: - View model build functions

extension CharacterListViewModel {
    
    /// Создает вью модель ячейки отображения персонажа.
    /// - Parameter character: отображаемый персонаж в ячейке.
    /// - Returns: вью модель ячейки.
    func getCharacterCellViewModel(
        for character: CharacterListCollectionViewModel.Section.Row
    ) -> CharacterListCollectionViewCellViewModel {
        CharacterListCollectionViewCellViewModel(character: character, imageRepository: imageRepository)
    }
    
    /// Создает вью модель для футера с индикатором загрузки.
    /// - Returns: вью модель футера.
    func getSpinerFoterViewModel() -> SpinerCollectionFooterViewModel {
        SpinerCollectionFooterViewModel(
            isLoadingPublisher: $isNextPageLoading.eraseToAnyPublisher(),
            isNetworkReachablePublisher: networkMonitor.isReachablePublisher
        )
    }
}

// MARK: - View model filter functions

extension CharacterListViewModel {
    
    /// Выполняет установку фильтра персонажей по имени.
    /// - Parameter name: имя для фильтрации.
    func filterCharacterList(by name: String) {
        filterCharacterName = name
    }
}

// MARK: - View model load functions

extension CharacterListViewModel {
    
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
    private func loadCharacterList() async throws -> [CharacterListCollectionViewModel.Section.Row] {
        let characterFilter = CharactersHTTPRequestFilter(
            page: currentListPage,
            status: .init(rawValue: filterCharacterStatus),
            gender: .init(rawValue: filterCharacterGender)
        )
        let characterDTOList = try await charactersRepository.getCharacters(with: characterFilter)
        let characterList = characterDTOList.map { CharacterListCollectionViewModel.Section.Row(dto: $0) }
        
        return characterList
    }
}

// MARK: - View model retry functions

extension CharacterListViewModel {
    
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

extension CharacterListViewModel {
    
    /// Выполняет отображение экрана списка фильтров для персонажей.
    func presentCharacterFilterView() {
        let currentFilter = CharacterFilterTableViewModel.CharacterFilter(
            gender: CharacterFilterTableViewModel.Section.Row.Gender(rawValue: filterCharacterGender) ?? .empty,
            status: CharacterFilterTableViewModel.Section.Row.Status(rawValue: filterCharacterStatus) ?? .empty
        )
        coordinator?.presentCharacterFilterView(with: currentFilter) { [weak self] filter in
            Task { @MainActor [weak self] in
                self?.filterCharacterGender = filter.gender.rawValue
                self?.filterCharacterStatus = filter.status.rawValue
                self?.refreshCharacterList()
            }
        }
    }
    
    /// Выполняет отображение экрана информации о пресонаже.
    /// - Parameter characterId: идентификатор персонажа.
    func presentCharacterInfoView(for characterId: Int) {
        coordinator?.presentCharacterInfoView(for: characterId)
    }
}

// MARK: - View model setup functions

private extension CharacterListViewModel {
    
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
