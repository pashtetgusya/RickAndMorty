import UIKit
import Combine

// MARK: - Spiner collection footer view

/// Вью футера коллекции с индикатором загрузки.
final class SpinerCollectionFooterView: UICollectionReusableView {
    
    // MARK: Subviews
    
    /// Вью индикатора загрузки.
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        
        return view
    }()
    /// Лейбл сообщения об отсутствии подключения к сети.
    private let networkUnreachableLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFontFixed(forTextStyle: .footnote)
        label.isHidden = true
        label.numberOfLines = 2
        label.text = "No internet connection.\nWaiting for network..."
        label.textAlignment = .center
        label.textColor = UIColor.textSub
        
        return label
    }()
    
    // MARK: Properties
    
    private var viewModel: SpinerCollectionFooterViewModel?
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View life cycle

extension SpinerCollectionFooterView {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewModel = nil
        cancellables = []
        
        networkUnreachableLabel.isHidden = true
    }
}

// MARK: - View configuration functions

extension SpinerCollectionFooterView {
    
    /// Выполняет настройку на основе вью модели.
    /// - Parameter viewModel: вью модель для настройки.
    func setup(with viewModel: SpinerCollectionFooterViewModel?) {
        self.viewModel = viewModel
        
        guard let viewModel else { return }
        
        Publishers
            .CombineLatest(
                viewModel.$isLoading,
                viewModel.$isNetworkReachable
            )
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] isLoading, isNetworkReachable in
                switch isNetworkReachable {
                case true:
                    switch isLoading {
                    case true: self?.activityIndicatorView.startAnimating()
                    case false: self?.activityIndicatorView.stopAnimating()
                    }
                    
                    self?.networkUnreachableLabel.isHidden = true
                case false:
                    self?.activityIndicatorView.stopAnimating()
                    self?.networkUnreachableLabel.isHidden = false
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - View setup functions

private extension SpinerCollectionFooterView {
    
    /// Выполняет добавление `view`-компонентов.
    func addSubviews() {
        addSubview(activityIndicatorView)
        addSubview(networkUnreachableLabel)
    }
    
    /// Выполняет настройку констрейнтов.
    func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            networkUnreachableLabel.topAnchor.constraint(equalTo: topAnchor),
            networkUnreachableLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            networkUnreachableLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            networkUnreachableLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            networkUnreachableLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
