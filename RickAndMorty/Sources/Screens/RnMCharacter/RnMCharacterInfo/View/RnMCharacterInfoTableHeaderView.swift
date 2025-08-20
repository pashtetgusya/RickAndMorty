import UIKit
import Combine

// MARK: - Rick and Morty character info table header view

/// Хедер таблицы информации о персонаже из вселенной `"Rick and Morty"`.
final class RnMCharacterInfoTableHeaderView: UITableViewHeaderFooterView {
    
    // MARK: Sublayers
    
    /// Слой градиентного затемнения нижней границы изображения.
    private let tintLayer: CALayer = {
        let layer = CAGradientLayer()
        layer.name = "gradientLayer"
        layer.colors = [
            UIColor.viewDefaultBackground.withAlphaComponent(0).cgColor,
            UIColor.viewDefaultBackground.cgColor
        ]
        layer.locations = [0.0, 1.0]
        
        return layer
    }()
    
    // MARK: Subviews
    
    /// Вью индикации загрузки изображения персонажа.
    private let imageLoadIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        view.tintColor = .black
        
        return view
    }()
    /// Вью изображения персонажа.
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage.charactersEmptySnapshot
        
        return imageView
    }()
    
    // MARK: Properties
    
    private var viewModel: RnMCharacterInfoTableHeaderViewModel?
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View life cycle

extension RnMCharacterInfoTableHeaderView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tintLayer.frame = CGRect(
            x: 0,
            y: imageView.bounds.height - 60,
            width: imageView.bounds.width,
            height: 60
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewModel?.cancelLoadCharacterImage()
        viewModel = nil
        
        cancellables = []
        
        imageLoadIndicatorView.stopAnimating()
        imageView.image = UIImage.charactersEmptySnapshot
    }
}

// MARK: - View configuration function

extension RnMCharacterInfoTableHeaderView {
    
    /// Выполняет настройку ячейки на основе вью модели с персонажем.
    /// - Parameter viewModel: вью модель ячейки.
    func setup(with viewModel: RnMCharacterInfoTableHeaderViewModel?) {
        self.viewModel = viewModel
        
        guard let viewModel else { return }
        
        viewModel
            .$isLoading
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] isLoading in
                switch isLoading {
                case true: self?.imageLoadIndicatorView.startAnimating()
                case false: self?.imageLoadIndicatorView.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .$characterImageData
            .dropFirst()
            .compactMap { $0 }
            .map { UIImage(data: $0) ?? UIImage.charactersEmptySnapshot }
            .assign(to: \.image, on: imageView)
            .store(in: &cancellables)
        
        viewModel.loadCharacterImage()
    }
}

// MARK: - View setup functions

private extension RnMCharacterInfoTableHeaderView {
    
    /// Добавляет сабвью.
    func addSubviews() {
        addSubview(imageView)
        addSubview(imageLoadIndicatorView)
        imageView.layer.addSublayer(tintLayer)
    }
    
    /// Настраивает констрейнты.
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 260),
            
            imageLoadIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageLoadIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
