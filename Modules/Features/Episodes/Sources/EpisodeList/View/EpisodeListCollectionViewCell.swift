import UIKit
import Resources

// MARK: - Episode list collection view cell

/// Ячейка отображения эпизода из вселенной `"Rick and Morty"`.
final class EpisodeListCollectionViewCell: UICollectionViewListCell {
    
    // MARK: Subviews
    
    /// Лейбл названия эпизода.
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 1
        label.textColor = UIColor.textMainColor
        
        return label
    }()
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupAppearance()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }
}

// MARK: - Cell life cycle

extension EpisodeListCollectionViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
    }
}

// MARK: - Cell configuration function

extension EpisodeListCollectionViewCell {
    
    /// Выполняет настройку ячейки на основе модели.
    /// - Parameter episode: модель ячейки.
    func setup(with episode: EpisodeListCollectionViewModel.Section.Row) {
        nameLabel.text = "\(episode.number): \(episode.name)"
    }
}

// MARK: - Cell setup functions

private extension EpisodeListCollectionViewCell {
    
    /// Выполняет добавление `view`-компонентов.
    func addSubviews() {
        contentView.addSubview(nameLabel)
    }
    
    /// Выполняет настройку констрейнтов.
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    /// Выпоняет настройку `view`-компонентов.
    func setupAppearance() {
        accessories = [.disclosureIndicator()]
    }
}
