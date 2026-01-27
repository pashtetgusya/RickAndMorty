import UIKit
import Resources

// MARK: - Parameter table view cell

/// Ячейка отображения параметра.
public final class ParameterTableViewCell: UITableViewCell {
    
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
        label.textColor = UIColor.textSubColor
        
        return label
    }()
    /// Лейбл значения параметра.
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFontFixed(forTextStyle: .body)
        label.numberOfLines = 0
        label.textColor = UIColor.textMainColor
        
        return label
    }()
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    public override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }
}

// MARK: - Cell life cycle

public extension ParameterTableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        nameLabel.text = nil
        valueLabel.text = nil
    }
}

// MARK: - Cell configuration function

public extension ParameterTableViewCell {
    
    /// Выполняет настройку ячейки на основе параметра.
    /// - Parameter parameter: отображаемый параметр.
    func setup(with parameter: AnyParameter) {
        iconImageView.image = UIImage(data: parameter.icon)?.withTintColor(UIColor.applicationTintColor)
        nameLabel.text = parameter.name.capitalized
        valueLabel.text = parameter.description.capitalized
    }
}

// MARK: - Cell setup functions

private extension ParameterTableViewCell {
    
    /// Выполняет добавление `view`-компонентов.
    func addSubviews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(labelsStackView)
    }
    
    /// Выполняет настройку констрейнтов.
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
