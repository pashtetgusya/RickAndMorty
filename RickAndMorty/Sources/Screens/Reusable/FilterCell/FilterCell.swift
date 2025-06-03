import UIKit

// MARK: - Filter cell

/// Ячейка отображения фильтра.
final class FilterCell: UITableViewCell {
    
    // MARK: Subviews
    
    /// Иконка отображения чек-бокса выбора фильтра.
    private let checkBoxIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.checkBoxDeselectedIcon
        
        return imageView
    }()
    /// Лейбл значения (описания) фильтра.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFontFixed(forTextStyle: .body)
        label.numberOfLines = 1
        label.textColor = UIColor.textMain
        
        return label
    }()
    
    // MARK: Properties
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Cell life cycle

extension FilterCell {
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        checkBoxIconImageView.image = selected
                                      ? UIImage.checkBoxSelectedIcon
                                               .withTintColor(UIColor.applicationTint)
                                      : UIImage.checkBoxDeselectedIcon
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        checkBoxIconImageView.image = UIImage.checkBoxDeselectedIcon
        titleLabel.text = nil
    }
}

// MARK: - Cell configuration function

extension FilterCell {
    
    /// Настраивает ячейку на основе фильтра.
    /// - Parameter filter: отображаемый фильтр.
    func setup(with filter: AnyFilter) {
        titleLabel.text = filter.rawValue
    }
}

// MARK: - Cell setup functions

private extension FilterCell {
    
    /// Добавляет сабвью.
    func addSubviews() {
        contentView.addSubview(checkBoxIconImageView)
        contentView.addSubview(titleLabel)
    }
    
    /// Настраивает констрейнты.
    func setupConstraints() {
        NSLayoutConstraint.activate([
            checkBoxIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkBoxIconImageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -8),
            checkBoxIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkBoxIconImageView.widthAnchor.constraint(equalToConstant: 24),
            checkBoxIconImageView.heightAnchor.constraint(equalTo: checkBoxIconImageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}
