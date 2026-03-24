import UIKit
import Combine
import CombineCocoa
import UIComponents

// MARK: - Character list view controller

/// Вью контроллер списка персонажей из вселенной `"Rick and Morty"`.
final class CharacterListViewController: UIViewController {
    
    // MARK: Properties
    
    private let contentView: CharacterListView
    private let searchController: BaseSearchController
    private let dataSource: CharacterListCollectionViewDataSource
    private let viewModel: CharacterListViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init(
        searchController: BaseSearchController,
        viewModel: CharacterListViewModel
    ) {
        self.contentView = CharacterListView()
        self.searchController = searchController
        self.dataSource = CharacterListCollectionViewDataSource(
            for: contentView.collectionView,
            cellProvider: { [weak viewModel] collectionView, indexPath, itemIdentifier in
                let cell: CharacterListCollectionViewCell = collectionView.dequeue(for: indexPath)
                
                if let cellViewModel = viewModel?.getCharacterCellViewModel(for: itemIdentifier) {
                    cell.setup(with: cellViewModel)
                }
                
                return cell
            },
            supplementaryViewProvider: { [weak viewModel] collectionView, elementKind, indexPath in
                switch elementKind {
                case UICollectionView.elementKindSectionFooter:
                    let footerView: SpinerCollectionFooterView = collectionView.dequeueFooter(for: indexPath)
                    let footerViewModel = viewModel?.getSpinerFoterViewModel()
                    if let footerViewModel {
                        footerView.setup(with: footerViewModel)
                    }
                    
                    return footerView
                    
                default: return nil
                }
            }
        )
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }
}

// MARK: - Controller life cycle

extension CharacterListViewController {
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        setupViewBindings()
        setupViewModelBindings()
        viewModel.initialLoadCharacterList()
    }
}

// MARK: - UI search result updating protocol implementation

extension CharacterListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let name = searchController.searchBar.text ?? ""
        viewModel.filterCharacterList(by: name)
    }
}

// MARK: - UI collection view delegate protocol implementation

extension CharacterListViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let character = dataSource.itemIdentifier(for: indexPath) else { return }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.presentCharacterInfoView(for: character.id)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let collectionViewContentSizeHeight = contentView.collectionView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > (collectionViewContentSizeHeight - 100 - scrollViewHeight) {
            viewModel.loadNextCharacterListPage()
        }
    }
}

// MARK: - Controller setup functions

private extension CharacterListViewController {
    
    /// Выпоняет настройку `view`-компонентов.
    func setupAppearance() {
        searchController.searchResultsUpdater = self
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.preferredSearchBarPlacement = .stacked
        navigationItem.rightBarButtonItem = contentView.showCharacterFilterItem
        navigationItem.searchController = searchController
        navigationItem.title = "Characters"
    }
    
    /// Выполняет настройку подписок на события вью.
    func setupViewBindings() {
        contentView.collectionView.delegate = self
        
        contentView
            .showCharacterFilterItem
            .tapPublisher
            .sink { [weak self] in
                self?.viewModel.presentCharacterFilterView()
            }
            .store(in: &cancellables)
        
        contentView
            .collectionView
            .refreshControl?
            .beginRefreshingPublisher
            .sink { [weak self] in
                self?.viewModel.refreshCharacterList()
            }
            .store(in: &cancellables)
        
        contentView
            .errorLoadingRetryTapAction = { [weak self] in
                self?.viewModel.retryLoadCharacterList()
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
            .characterSectionList
            .dropFirst()
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] characterSectionList in
                self?.dataSource.update(with: characterSectionList)
            }
            .store(in: &cancellables)
    }
}
