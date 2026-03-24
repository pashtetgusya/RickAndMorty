import UIKit
import Combine

// MARK: - Episode info view controller

/// Вью контроллер информации об эпизоде из вселенной `"Rick and Morty"`.
final class EpisodeInfoViewController: UIViewController {
    
    // MARK: Properties
    
    private let contentView: EpisodeInfoView
    private let dataSource: EpisodeInfoCollectionViewDataSource
    private let viewModel: EpisodeInfoViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    init(viewModel: EpisodeInfoViewModel) {
        self.contentView = EpisodeInfoView()
        self.dataSource = EpisodeInfoCollectionViewDataSource(for: self.contentView.collectionView)
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }
}

// MARK: - Controller life cycle

extension EpisodeInfoViewController {
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewBindings()
        setupViewModelBindings()
        viewModel.loadEpisodeInfo()
    }
}

// MARK: - UI collection view delegate protocol implementation

extension EpisodeInfoViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        dataSource.sectionIdentifier(for: indexPath.section) == .characters
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard case .character(let id, _) = dataSource.itemIdentifier(for: indexPath) else { return }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.presentCharacterInfoView(for: id)
    }
}

// MARK: - Controller setup functions

private extension EpisodeInfoViewController {
    
    /// Выполняет настройку подписок на события вью.
    func setupViewBindings() {
        contentView.collectionView.delegate = self
    }
    
    /// Выполняет настройку подписок на события вью модели.
    func setupViewModelBindings() {
        viewModel
            .$isLoading
            .dropFirst()
            .throttle(for: 0.3, scheduler: DispatchQueue.main, latest: true)
            .map { $0 ? self.contentView.loadingConfiguration : nil }
            .assign(to: \.contentUnavailableConfiguration, on: self)
            .store(in: &cancellables)
        
        viewModel
            .$episodeName
            .map { $0 }
            .assign(to: \.title, on: navigationItem)
            .store(in: &cancellables)
        
        viewModel
            .$episodeInfoSectionList
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] sectionList in
                self?.dataSource.update(with: sectionList)
            }
            .store(in: &cancellables)
    }
}
