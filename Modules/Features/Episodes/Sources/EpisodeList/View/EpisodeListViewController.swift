import UIKit
import Combine
import UIComponents

// MARK: - Episode list view controller

/// Вью контроллер списка эпизодов из вселенной `"Rick and Morty"`.
final class EpisodeListViewController: UIViewController {
    
    // MARK: Properties
    
    private let contentView: EpisodeListView
    private let dataSource: EpisodeListCollectionViewDataSource
    private let viewModel: EpisodeListViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init(viewModel: EpisodeListViewModel) {
        self.contentView = EpisodeListView()
        self.dataSource = EpisodeListCollectionViewDataSource(for: contentView.collectionView)
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }
}

// MARK: - Controller life cycle

extension EpisodeListViewController {
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        setupViewBindings()
        setupViewModelBindings()
        viewModel.initialLoadEpisodeList()
    }
}

// MARK: - UI collection view delegate protocol implementation

extension EpisodeListViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let episode = dataSource.itemIdentifier(for: indexPath) else { return }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.presentEpisodeInfoView(for: episode.id)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let collectionViewContentSizeHeight = contentView.collectionView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > (collectionViewContentSizeHeight - 100 - scrollViewHeight) {
            viewModel.loadNextEpisodeListPage()
        }
    }
}

// MARK: - Controller setup functions

private extension EpisodeListViewController {
    
    /// Выпоняет настройку `view`-компонентов.
    func setupAppearance() {
        navigationItem.title = "Episodes"
        
        dataSource.supplementaryViewProvider = { [
            weak viewModel, weak dataSource
        ] collectionView, elementKind, indexPath in
            switch elementKind {
            case UICollectionView.elementKindSectionFooter:
                let footerView: SpinerCollectionFooterView = collectionView.dequeueFooter(for: indexPath)
                if let footerViewModel = viewModel?.getSpinerFoterViewModel() {
                    footerView.setup(with: footerViewModel)
                }
                
                return footerView
            case UICollectionView.elementKindSectionHeader:
                let headerView: TitleCollectionHeaderView = collectionView.dequeueHeader(for: indexPath)
                if let sectionIdentifier = dataSource?.sectionIdentifier(for: indexPath.section) {
                    headerView.setup(with: sectionIdentifier.title)
                }
                
                return headerView
            
            default: return nil
            }
        }
    }
    
    /// Выполняет настройку подписок на события вью.
    func setupViewBindings() {
        contentView.collectionView.delegate = self
        
        contentView
            .collectionView
            .refreshControl?
            .beginRefreshingPublisher
            .sink { [weak self] in
                self?.viewModel.refreshEpisodeList()
            }
            .store(in: &cancellables)
        
        contentView
            .errorLoadingRetryTapAction = { [weak self] in
                self?.viewModel.retryLoadEpisodeList()
            }
    }
    
    /// Выполняет настройку подписок на события вью модели.
    func setupViewModelBindings() {
        viewModel
            .$isRefreshing
            .dropFirst()
            .throttle(for: 0.6, scheduler: DispatchQueue.main, latest: true)
            .assign(to: \.isRefreshing, on: contentView.collectionView)
            .store(in: &cancellables)
        
        viewModel
            .$isLoading
            .dropFirst()
            .throttle(for: 0.3, scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] isLoading in
                let configuration = isLoading ? self?.contentView.loadingConfiguration : nil
                self?.contentUnavailableConfiguration = configuration
            }
            .store(in: &cancellables)
        
        viewModel
            .$isErrorLoading
            .dropFirst()
            .throttle(for: 0.3, scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] isErrorLoading in
                let configuration = isErrorLoading ? self?.contentView.errorLoadingConfiguration : nil
                self?.contentUnavailableConfiguration = configuration
            }
            .store(in: &cancellables)
        
        viewModel
            .episodeSectionList
            .dropFirst()
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] episodeSectionList in
                self?.dataSource.update(with: episodeSectionList)
            }
            .store(in: &cancellables)
    }
}
