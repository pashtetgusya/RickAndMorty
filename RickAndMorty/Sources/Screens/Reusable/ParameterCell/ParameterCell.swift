import UIKit

// MARK: - Parameter cell

/// Ячейка отображения параметра.
final class ParameterCell: UITableViewCell {
    
    // MARK: Subviews
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [valueLabel, nameLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        
        return stackView
    }()
    
    /// Вью изображения параметра.
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    /// Лейбл названия параметра.
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFontFixed(forTextStyle: .footnote)
        label.numberOfLines = 1
        label.textColor = UIColor.textSub
        
        return label
    }()
    /// Лейбл значения параметра.
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFontFixed(forTextStyle: .body)
        label.numberOfLines = 0
        label.textColor = UIColor.textMain
        
        return label
    }()
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Cell life cycle

extension ParameterCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        nameLabel.text = nil
        valueLabel.text = nil
    }
}

// MARK: - Cell configuration function

extension ParameterCell {
    
    /// Настраивает ячейку на основе параметра.
    /// - Parameter parameter: отображаемый параметр.
    func setup(with parameter: AnyParameter) {
        iconImageView.image = UIImage(data: parameter.icon)?.withTintColor(UIColor.applicationTint)
        nameLabel.text = parameter.name
        valueLabel.text = parameter.description
    }
}

// MARK: - Cell setup functions

private extension ParameterCell {
    
    /// Добавляет сабвью.
    func addSubviews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(labelsStackView)
    }
    
    /// Настраивает констрейнты.
    func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            
            labelsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            labelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            labelsStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}
