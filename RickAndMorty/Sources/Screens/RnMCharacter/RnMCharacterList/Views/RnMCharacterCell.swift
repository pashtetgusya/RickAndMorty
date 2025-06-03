import UIKit

// MARK: - Rick and Morty character cell

/// Ячейка отображения персонажа из вселенной `"Rick and Morty"`.
final class RnMCharacterCell: UICollectionViewCell {
    
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
        label.textColor = UIColor.textMain
        
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
        label.textColor = UIColor.textSub
        
        return label
    }()
    
    // MARK: Properties
    
    private var viewModel: RnMCharacterCellViewModel?
    
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

extension RnMCharacterCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewModel?.cancelLoadCharacterImage()
        viewModel = nil
        
        imageLoadIndicatorView.stopAnimating()
        imageView.image = UIImage.charactersEmptySnapshot
        nameLabel.text = nil
        infoLabel.text = nil
    }
}

// MARK: - Cell configuration function

extension RnMCharacterCell {
    
    /// Настраивает ячейку на основе вью модели с персонажем.
    /// - Parameter viewModel: вью модель ячейки.
    func setup(with viewModel: RnMCharacterCellViewModel?) {
        self.viewModel = viewModel
        
        guard let viewModel else { return }
        
        imageLoadIndicatorView.startAnimating()
        viewModel.loadCharacterImage { [weak self] image in
            self?.imageLoadIndicatorView.stopAnimating()
            
            guard let image else { return }
            
            self?.imageView.image = UIImage(data: image)
        }
        
        let info = viewModel.character.species + ", " +
                   viewModel.character.status.lowercased()
        nameLabel.text = viewModel.character.name
        infoLabel.text = info
    }
}

// MARK: - Cell setup functions

private extension RnMCharacterCell {
    
    /// Добавляет сабвью.
    func addSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(infoLabel)
        
        imageView.addSubview(imageLoadIndicatorView)
    }
    
    /// Настраивает констрейнты.
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
