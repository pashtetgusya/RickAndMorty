import UIKit
import UIComponents

// MARK: - Episode info view

/// Вью информации об эпизоде из вселенной `"Rick and Morty"`.
final class EpisodeInfoView: BaseViewControllerView {
    
    // MARK: Subviews
    
    /// Коллекция отображения информации об эпизоде.
    let collectionView: UICollectionView = {
        let layout = EpisodeInfoCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .clear
        collectionView.registerCell(ParameterCollectionViewCell.self)
        collectionView.registerHeader(TitleCollectionHeaderView.self)
        
        return collectionView
    }()
    
    // MARK: Properties
    
    /// Конфигурация отображения процесса загрузки контента.
    let loadingConfiguration = UIContentUnavailableConfiguration.loading(
        title: "Please wait...",
        subtitle: "Fetching episode info"
    )
    /// Конфигурация отображения ошибки загрузки контента.
    private(set) lazy var errorLoadingConfiguration = UIContentUnavailableConfiguration.error(
        title: "Oops...",
        subtitle: "Failed to load episode info.",
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

private extension EpisodeInfoView {
    
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

