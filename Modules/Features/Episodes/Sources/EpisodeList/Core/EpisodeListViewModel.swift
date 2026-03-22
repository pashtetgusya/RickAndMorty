import Foundation
import Combine
import Data
import NetWork
import UIComponents

// MARK: - Episode list view model

/// Вью модель экрана списка эпизодов из вселенной `"Rick and Morty"`.
@MainActor final class EpisodeListViewModel {
    
    // MARK: Properties
    
    /// Флаг ошибки загрузки страницы списка.
    @Published var isErrorLoading: Bool = false
    /// Флаг выполнения начальной / повторной загрузки списка.
    @Published var isLoading: Bool = false
    /// Флаг выполнения обновления списка.
    @Published var isRefreshing: Bool = false
    /// Флаг выполнения загрузки "следующей" страницы списка.
    @Published var isNextPageLoading: Bool = false
    /// Флаг ошибки загрузки "следующей" страницы списка.
    private var isErrorNextPageLoading: Bool = false
    /// Флаг загрузки последней страницы.
    private var isLastPageLoaded: Bool = false
    /// Текущая страница списка.
    private var currentListPage: Int = 1
    
    /// Список секций с эпизодами.
    var episodeSectionList: AnyPublisher<[EpisodeListCollectionViewModel.Section], Never> {
        $episodeList
            .map { episodeList in
                let episodeGroupedBySeason = Dictionary(grouping: episodeList, by: \.season)
                let episodeSectionList = episodeGroupedBySeason
                    .sorted { $0.key < $1.key }
                    .map {
                        EpisodeListCollectionViewModel.Section(
                            type: .episodes(season: $0.key),
                            rows: $0.value
                        )
                    }
                
                return episodeSectionList
            }
            .eraseToAnyPublisher()
    }
    /// Список эпизодов.
    @Published private var episodeList: [EpisodeListCollectionViewModel.Section.Row] = []
    
    /// Репозиторий для получения эпизодов.
    private let episodesRepository: EpisodesRepository
    /// Сервис для мониторинга статуса подключения к сети.
    private let networkMonitor: NetworkMonitor
    /// Координатор экрана списка эпизодов.
    private weak let coordinator: EpisodeListCoordinator?
    /// Задача на загрузку следующей страницы списка.
    private var loadNextListPageTask: Task<(), Never>? = nil
    /// Задача на повторную загрузку списка.
    private var retryLoadListTask: Task<(), Never>? = nil
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter dependencies: контейнер с зависимостями.
    init(di dependencies: EpisodeListViewModelDependencies) {
        self.episodesRepository = dependencies.episodesRepository
        self.networkMonitor = dependencies.networkMonitor
        self.coordinator = dependencies.coordinator
        
        self.setupBindings()
    }
}

// MARK: - View model build functions

extension EpisodeListViewModel {
    
    /// Создает вью модель для футера с индикатором загрузки.
    /// - Returns: вью модель футера.
    func getSpinerFoterViewModel() -> SpinerCollectionFooterViewModel {
        SpinerCollectionFooterViewModel(
            isLoadingPublisher: $isNextPageLoading.eraseToAnyPublisher(),
            isNetworkReachablePublisher: networkMonitor.isReachablePublisher
        )
    }
}

// MARK: - View model load functions

extension EpisodeListViewModel {
    
    /// Выполняет начальную загрузку списка эпизодов.
    func initialLoadEpisodeList() {
        Task { [weak self] in
            defer { self?.isLoading = false }
            self?.isLoading = true
            
            do { self?.episodeList = try await self?.loadEpisodeList() ?? [] }
            catch { self?.isErrorLoading = true }
        }
    }
    
    /// Выполняет перезагрузку списка эпизодов
    /// (загружает первую страницу списка эпизодов).
    func refreshEpisodeList() {
        Task { [weak self] in
            defer { self?.isRefreshing = false }
            self?.isRefreshing = true
            self?.isLastPageLoaded = false
            self?.currentListPage = 1
            
            do {
                self?.isErrorLoading = false
                self?.episodeList = try await self?.loadEpisodeList() ?? []
            }
            catch {
                self?.episodeList = []
                self?.isErrorLoading = true
            }
        }
    }
    
    /// Выполняет загрузку следующей страницы списка эпизодов.
    func loadNextEpisodeListPage() {
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
                self?.episodeList += try await self?.loadEpisodeList() ?? []
            }
            catch HTTPRequestError.invalidStatusCode(404) { self?.isLastPageLoaded = true }
            catch { self?.isErrorNextPageLoading = true }
        }
    }
    
    /// Выполняет загрузку списка эпизодов.
    /// - Returns: список эпизодов.
    private func loadEpisodeList() async throws -> [EpisodeListCollectionViewModel.Section.Row] {
        let episodesFilter = EpisodesHTTPRequestFilter(page: currentListPage)
        let episodeDTOList = try await episodesRepository.getEpisodes(with: episodesFilter)
        let episodeList = episodeDTOList.map { EpisodeListCollectionViewModel.Section.Row(dto: $0) }
        
        return episodeList
    }
}

// MARK: - View model retry functions

extension EpisodeListViewModel {
    
    /// Выполняет повторную загрузку списка эпизодов.
    func retryLoadEpisodeList() {
        guard retryLoadListTask == nil else { return }
        
        retryLoadListTask = Task { [weak self] in
            defer { self?.retryLoadListTask = nil }
            defer { self?.isLoading = false }
            self?.isLoading = true
            
            do {
                self?.isErrorLoading = false
                self?.episodeList = try await self?.loadEpisodeList().filter { episode in
                    self?.episodeList.contains(episode) == false
                } ?? []
            }
            catch { self?.isErrorLoading = true }
        }
    }
    
    /// Выполняте повторную загрузку "следующей" страницы списка эпизодов.
    func retryLoadNextEpisodeListPage() {
        guard retryLoadListTask == nil else { return }
        
        retryLoadListTask = Task { [weak self] in
            defer { self?.retryLoadListTask = nil }
            defer { self?.isNextPageLoading = false }
            self?.isNextPageLoading = true
            
            do {
                self?.isErrorNextPageLoading = false
                self?.episodeList += try await self?.loadEpisodeList().filter { episode in
                    self?.episodeList.contains(episode) == false
                } ?? []
            }
            catch { self?.isErrorNextPageLoading = true }
        }
    }
}

// MARK: - View model navigation functions

extension EpisodeListViewModel {
    
    /// Выполняет отображение экрана информации об эпизоде.
    /// - Parameter episodeId: идентификатор эпизода.
    func presentEpisodeInfoView(for episodeId: Int) {
        coordinator?.presentEpisodeInfoView(for: episodeId)
    }
}

// MARK: - View model setup functions

private extension EpisodeListViewModel {
    
    /// Выполняет настройку подписок на события сервисов.
    func setupBindings() {
        networkMonitor.start()
        networkMonitor
            .isReachablePublisher
            .sink { [weak self] isReachable in
                guard
                    isReachable,
                    self?.isErrorNextPageLoading == true
                else { return }
                
                self?.retryLoadNextEpisodeListPage()
            }
            .store(in: &cancellables)
    }
}
