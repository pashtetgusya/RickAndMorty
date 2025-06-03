import UIKit

// MARK: - Rick and Morty character list view

/// Вью списка персонажей из вселенной `"Rick and Morty"`.
final class RnMCharacterListView: BaseViewControllerView {
    
    // MARK: Subviews
    
    /// Айтем отображения списка фильтров для персонажей.
    let showCharacterFilterItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Filter")
        item.tintColor = UIColor.applicationTint
        
        return item
    }()
    /// Вью индикатора отображеня загрузки.
    let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        
        return view
    }()
    /// Коллекция отображения списка персонажей.
    let collectionView: UICollectionView = {
        let layout = RnMCharacterListCollectionLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = UIRefreshControl()
        collectionView.registerCell(RnMCharacterCell.self)
        collectionView.registerFooter(SpinerCollectionFooterView.self)
        
        return collectionView
    }()
    
    // MARK: Properties
    
    let loadingConfiguration: UIContentUnavailableConfiguration = {
        var configuration = UIContentUnavailableConfiguration.loading()
        configuration.text = "Please wait..."
        configuration.secondaryText = "Fetching character list."
        
        return configuration
    }()
    var errorLoadingConfiguration: UIContentUnavailableConfiguration = {
        var buttonConfiguration = UIButton.Configuration.borderless()
        buttonConfiguration.title = "Retry"
        buttonConfiguration.image = UIImage(systemName: "arrow.clockwise")
        buttonConfiguration.baseForegroundColor = UIColor.applicationTint
        
        var configuration = UIContentUnavailableConfiguration.empty()
        configuration.image = UIImage.charactersLoadError
        configuration.text = "Oops..."
        configuration.secondaryText = "Failed to load character list."
        configuration.button = buttonConfiguration
        
        return configuration
    }()
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View setup functions

private extension RnMCharacterListView {
    
    /// Добавляет сабвью.
    func addSubviews() {
        addSubview(collectionView)
        addSubview(activityIndicatorView)
    }
    
    /// Настраивает констрейнты.
    func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
