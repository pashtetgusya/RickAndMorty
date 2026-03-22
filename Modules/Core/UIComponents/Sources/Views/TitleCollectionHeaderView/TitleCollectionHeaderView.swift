import UIKit

// MARK: Title collection header view

/// Вью хедера коллекции с заголовком.
public final class TitleCollectionHeaderView: UICollectionReusableView {
    
    // MARK: Subviews
    
    /// Лейбл заголовка хедера.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFontFixed(forTextStyle: .headline)
        label.textColor = UIColor.textSubColor
        
        return label
    }()
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }
}

// MARK: - Header configuration function

public extension TitleCollectionHeaderView {
    
    /// Выполняет настройку на основе заголовка.
    /// - Parameter title: заголовок для настройки.
    func setup(with title: String) {
        titleLabel.text = title
    }
}

// MARK: - Header setup functions

private extension TitleCollectionHeaderView {
    
    /// Выполняет добавление `view`-компонентов.
    func addSubviews() {
        addSubview(titleLabel)
    }
    
    /// Выполняет настройку констрейнтов.
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
