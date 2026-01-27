import UIKit
import Combine
import Resources

// MARK: - Character list collection view cell

/// Ячейка отображения персонажа из вселенной `"Rick and Morty"`.
final class CharacterListCollectionViewCell: UICollectionViewCell {
    
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
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1.5
        imageView.layer.cornerRadius = 20
        
        return imageView
    }()
    /// Лейбл имени персонажа.
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFontFixed(forTextStyle: .headline)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.textMainColor
        
        return label
    }()
    /// Лейбл информации о персонаже.
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFontFixed(forTextStyle: .subheadline)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.textSubColor
        
        return label
    }()
    
    // MARK: Properties
    
    override var isHighlighted: Bool {
        didSet { isShrinked = isHighlighted }
    }
    override var isSelected: Bool {
        didSet { isShrinked = isSelected }
    }
    /// Флаг уменьшения ячейки.
    private var isShrinked: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.1) {
                switch self.isShrinked {
                case true: self.transform = CGAffineTransform(scaleX: self.shrinkScale, y: self.shrinkScale)
                case false: self.transform = .identity
                }
            }
        }
    }
    /// Коэффициент уменьшения ячейки.
    private let shrinkScale: CGFloat = 0.90
    
    private var viewModel: CharacterListCollectionViewCellViewModel?
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

// MARK: - Cell life cycle

extension CharacterListCollectionViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewModel?.cancelLoadCharacterImage()
        viewModel = nil
        
        cancellables = []
        
        imageLoadIndicatorView.stopAnimating()
        imageView.image = UIImage.charactersEmptySnapshot
        nameLabel.text = nil
        infoLabel.text = nil
    }
}

// MARK: - Cell configuration function

extension CharacterListCollectionViewCell {
    
    /// Выполняет настройку ячейки на основе вью модели с персонажем.
    /// - Parameter viewModel: вью модель ячейки.
    func setup(with viewModel: CharacterListCollectionViewCellViewModel) {
        self.viewModel = viewModel
        
        let info = viewModel.character.species + ", " +
                   viewModel.character.status.lowercased()
        nameLabel.text = viewModel.character.name
        infoLabel.text = info
        
        viewModel
            .$isLoading
            .sink { [weak self] isLoading in
                switch isLoading {
                case true: self?.imageLoadIndicatorView.startAnimating()
                case false: self?.imageLoadIndicatorView.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .$characterImageData
            .compactMap { $0 }
            .map { UIImage(data: $0) ?? UIImage.charactersEmptySnapshot }
            .assign(to: \.image, on: imageView)
            .store(in: &cancellables)
        
        viewModel.loadCharacterImage()
    }
}

// MARK: - Cell setup functions

private extension CharacterListCollectionViewCell {
    
    /// Выполняет добавление `view`-компонентов.
    func addSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(infoLabel)
        
        imageView.addSubview(imageLoadIndicatorView)
    }
    
    /// Выполняет настройку констрейнтов.
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -6),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            nameLabel.bottomAnchor.constraint(equalTo: infoLabel.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: 18),
            
            imageLoadIndicatorView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            imageLoadIndicatorView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
    }
}
