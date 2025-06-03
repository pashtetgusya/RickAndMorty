import UIKit

// MARK: - Rick and Morty character info table header view

/// Хедер таблицы информации о персонаже из вселенной `"Rick and Morty"`.
final class RnMCharacterInfoTableHeaderView: UITableViewHeaderFooterView {
    
    // MARK: Sublayers
    
    /// Лейер градиентного затемнения нижней границы изображения.
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
        let view = UIActivityIndicatorView(style: .medium)
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
        
        imageLoadIndicatorView.stopAnimating()
        imageView.image = UIImage.charactersEmptySnapshot
    }
}

// MARK: - View configuration function

extension RnMCharacterInfoTableHeaderView {
    
    /// Настраивает ячейку на основе вью модели с персонажем.
    /// - Parameter viewModel: вью модель ячейки.
    func setup(with viewModel: RnMCharacterInfoTableHeaderViewModel?) {
        self.viewModel = viewModel
        
        guard let viewModel else { return }
        
        imageLoadIndicatorView.startAnimating()
        viewModel.loadCharacterImage { [weak self] image in
            self?.imageLoadIndicatorView.stopAnimating()
            
            guard let image else { return }
            
            self?.imageView.image = UIImage(data: image)
        }
    }
}

// MARK: - View setup functions

private extension RnMCharacterInfoTableHeaderView {
    
    /// Добавляет сабвью.
    func addSubviews() {
        addSubview(imageView)
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
        ])
    }
}
