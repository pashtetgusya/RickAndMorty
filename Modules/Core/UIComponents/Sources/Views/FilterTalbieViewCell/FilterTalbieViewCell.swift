import UIKit
import Resources

// MARK: - Filter table view cell

/// Ячейка отображения фильтра.
public final class FilterTalbieViewCell: UITableViewCell {
    
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
        
        selectionStyle = .none
        
        addSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }
}

// MARK: - Cell life cycle

public extension FilterTalbieViewCell {
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        checkBoxIconImageView.image = selected
                                      ? UIImage.checkBoxSelectedIcon.withTintColor(UIColor.applicationTintColor)
                                      : UIImage.checkBoxDeselectedIcon
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        checkBoxIconImageView.image = UIImage.checkBoxDeselectedIcon
        titleLabel.text = nil
    }
}

// MARK: - Cell configuration function

public extension FilterTalbieViewCell {
    
    /// Выполняет настройку ячейки на основе фильтра.
    /// - Parameter filter: отображаемый фильтр.
    func setup(with filter: AnyFilter) {
        titleLabel.text = filter.rawValue
    }
}

// MARK: - Cell setup functions

private extension FilterTalbieViewCell {
    
    /// Выполняет добавление `view`-компонентов.
    func addSubviews() {
        contentView.addSubview(checkBoxIconImageView)
        contentView.addSubview(titleLabel)
    }
    
    /// Выполняет настройку констрейнтов.
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
