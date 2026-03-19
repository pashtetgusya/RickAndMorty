import UIKit
import Resources
import UIComponents

// MARK: - Character list view

/// Вью списка персонажей из вселенной `"Rick and Morty"`.
final class CharacterListView: BaseViewControllerView {
    
    // MARK: Subviews
    
    /// Кнопка отображения списка фильтров для персонажей.
    let showCharacterFilterItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Filter")
        item.tintColor = UIColor.applicationTintColor
        
        return item
    }()
    /// Коллекция отображения списка персонажей.
    let collectionView: UICollectionView = {
        let layout = CharacterListCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = UIRefreshControl()
        collectionView.registerCell(CharacterListCollectionViewCell.self)
        collectionView.registerFooter(SpinerCollectionFooterView.self)
        
        return collectionView
    }()
    
    // MARK: Properties
    
    /// Конфигурация отображения процесса загрузки контента.
    let loadingConfiguration = UIContentUnavailableConfiguration.loading(
        title: "Please wait...",
        subtitle: "Fetching character list."
    )
    /// Конфигурация отображения ошибки загрузки контента.
    private(set) lazy var errorLoadingConfiguration = UIContentUnavailableConfiguration.error(
        title: "Oops...",
        subtitle: "Failed to load character list.",
        icon: UIImage.charactersLoadError,
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

private extension CharacterListView {
    
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
