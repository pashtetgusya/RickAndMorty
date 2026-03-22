import UIKit
import UIComponents

// MARK: - Episode list view

/// Вью списка эпизодов из вселенной `"Rick and Morty"`.
final class EpisodeListView: BaseViewControllerView {
    
    // MARK: Subivews
    
    /// Коллекция отображения списка эпизодов.
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = EpisodeListCollectionViewLayout(collectionView: collectionView)
        collectionView.refreshControl = UIRefreshControl()
        collectionView.registerCell(EpisodeListCollectionViewCell.self)
        collectionView.registerHeader(TitleCollectionHeaderView.self)
        collectionView.registerFooter(SpinerCollectionFooterView.self)
        
        return collectionView
    }()
    
    // MARK: Properties
    
    /// Конфигурация отображения процесса загрузки контента.
    let loadingConfiguration = UIContentUnavailableConfiguration.loading(
        title: "Please wait...",
        subtitle: "Fetching episode list."
    )
    /// Конфигурация отображения ошибки загрузки контента.
    private(set) lazy var errorLoadingConfiguration = UIContentUnavailableConfiguration.error(
        title: "Oops...",
        subtitle: "Failed to load episode list.",
        retryAction: UIAction { [weak self] _ in
            self?.errorLoadingRetryTapAction?()
        }
    )
    /// Экшн нажатия кнопки "Повторить" для `errorLoadingConfiguration`.
    var errorLoadingRetryTapAction: (() -> Void)?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    override init() {
        super.init()
        
        addSubviews()
        setupConstraints()
    }
}

// MARK: - View setup functions

private extension EpisodeListView {
    
    /// Выполняет добавление `view`-компонентов.
    func addSubviews() {
        addSubview(collectionView)
    }
    
    /// Выполняет настройку констрейнтов.
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
