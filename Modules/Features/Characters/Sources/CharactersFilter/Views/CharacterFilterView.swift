import UIKit
import UIComponents

// MARK: - Character filter view

/// Вью списка фильтров для персонажей из вселенной `"Rick and Morty"`.
final class CharacterFilterView: BaseViewControllerView {
    
    // MARK: Subviews
    
    /// Кнопка приминения фильтра.
    let applyFilterItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Apply")
        item.tintColor = UIColor.applicationTintColor
        
        return item
    }()
    /// Кнопка отмены изменений.
    let cancelItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Cancel")
        item.tintColor = UIColor.applicationTintColor
        
        return item
    }()
    /// Таблица отображения списка фильтров для персонажей.
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = true
        tableView.backgroundColor = .clear
        tableView.registerCell(FilterTalbieViewCell.self)
        
        return tableView
    }()
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    override init() {
        super.init()
        
        addSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }
}

// MARK: - View setup functions

private extension CharacterFilterView {
    
    /// Выполняет добавление `view`-компонентов.
    func addSubviews() {
        addSubview(tableView)
    }
    
    /// Выполняет настройку констрейнтов.
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
